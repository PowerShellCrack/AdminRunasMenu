Function Save-FailedComputers
{
    Param(
        $Path
        ,$FailedComputersInfo
        )
    Begin{
        Create-ReportFolder
    }
    Process{
        foreach($item in $FailedComputersInfo){
            $Dobject = New-Object PSObject
                $Dobject | Add-Member -MemberType NoteProperty -Name "Name" -Value $item.Location
                $Dobject | Add-Member -MemberType NoteProperty -Name "Error" -Value $item.JobStateInfo.Reason.Message
                Try{
                    $Dobject | Export-Csv -Path $Path -Append -UseCulture -NoTypeInformation -ErrorAction STOP
                }
                Catch{
                    Get-ErrorInformation -Component "Save-FailedComputers"
                }
        }
    }
}

#####################################################
#
# Export-Content function exports content to CSV file
#
#####################################################
Function Export-Content
{
    Param(
        $ContentObject,
        $ContentOutPutLocation = "$Global:PATH\Reports\",
        $ContentFileName
        )
        
        Begin{
                Write-Log -Message "Exporting Content to report: $ContentFileName" -severity 1 -component "Export-Content"
                Create-ReportFolder
        }
        Process{
            foreach($item in $ContentObject){
                Try{
                    Export-Csv -InputObject $item -Path "$ContentOutPutLocation$ContentFileName.csv" -NoTypeInformation -Force -ErrorAction STOP -Append -UseCulture
                }
                Catch{
                    Get-ErrorInformation -Component "Export-Content"
                }
            }
        }
        End{
        }
}
#####################################################
#
# Open-Report function opens the report after all jobs are finished
#
#####################################################
Function Open-Report
{
    Param($ReportName)
    $ReportLocation = "$Global:PATH\Reports\$ReportName.csv"
    
    Try{
        Start-Process -WorkingDirectory "$Global:PATH\Reports" -FilePath """$ReportName.csv""" -ErrorAction STOP
    }
    Catch{
        Get-ErrorInformation -Component "Open-Report"
    }
}

#####################################################
#
# Start-BackGroundJob function creates all the background jobs that runs on administrator PC
#
#####################################################
Function Start-BackGroundJob
{
    Param(
         $ScriptBlock,
         $WorkerCredentials
         )

        Try{
            $ComputerName = $Global:Queue.Dequeue()
            $J = Start-Job -ScriptBlock $ScriptBlock -ArgumentList $ComputerName -Name $ComputerName -ErrorAction STOP @WorkerCredentials
            [Void]$Global:Jobs.Add($J.Id)
            Write-Log -Message "Created JOB for $($J.Name)" -severity 1 -component "Start-BackGroundJob"
        }
        Catch{
            Get-ErrorInformation -Component "Start-BackGroundJob"
        }           
}

#####################################################
#
# Invoke-CMClientAction is the main function that handles all the jobs and reporting.
#
#####################################################
Function Invoke-CMClientAction
{
    [CMDLetBinding()]
    PARAM(
         [Parameter(Mandatory=$True,ParameterSetName='RemoteJob')]
            $Computers,
         [Parameter(Mandatory=$False,ParameterSetName='RemoteJob')]
            $TaskScriptBlockParameters,
         [Parameter(Mandatory=$True,ParameterSetName='RemoteJob')]
         [Parameter(Mandatory=$True,ParameterSetName='LocalJob')]
            $TaskName,
         [Parameter(Mandatory=$True,ParameterSetName='RemoteJob')]
         [Parameter(Mandatory=$True,ParameterSetName='LocalJob')]
            $ScriptBlock,
         [Parameter(Mandatory=$True,ParameterSetName='RemoteJob')]
         [Parameter(Mandatory=$True,ParameterSetName='LocalJob')]
            $Reporting,
         [Parameter(Mandatory=$True,ParameterSetName='RemoteJob')]
         [Parameter(Mandatory=$True,ParameterSetName='LocalJob')]
            $OpenReport,
         [Parameter(Mandatory=$True,ParameterSetName='LocalJob')]
            $JobType,
         [Parameter(Mandatory=$True,ParameterSetName='RemoteJob')]
         [Parameter(Mandatory=$True,ParameterSetName='LocalJob')]
            $WorkerCredentials
         )

    Begin{
        [int]$ErrorCount = 0 
        [int]$SuccessCount = 0
        [int]$ContentCount = 0
        $FailedComputers = @()
        $ReportName = "$TaskName" +"_" +(Get-Random)
        $StartTime = Get-Date
        
    }
    Process{
            if($JobType -eq "Local"){
                while($Global:Queue.count -gt 0){
                    if((Get-Job -State Running).Count -lt $Global:MaxConcurrentJobs){
                        Write-Log -Message "Total Running Jobs: $((Get-Job -State Running).Count)" -severity 1 -component "Start-BackGroundJob"
                        Start-BackGroundJob -ScriptBlock $ScriptBlock -WorkerCredentials $WorkerCredentials
                    }

                }
                while((Get-Job).State -eq "Running"){
                       Write-Log -Message "Waiting for local Jobs. Still Jobs in Queue list: $($Global:Queue.Count)" -severity 1 -component "Invoke-CMClientAction"
                       Start-Sleep 1
                }
            }
            Else{

                Try{
                    $MainJob = Invoke-Command -ScriptBlock $ScriptBlock -ComputerName $Computers -AsJob -ErrorAction STOP -ThrottleLimit 10 -ArgumentList $TaskScriptBlockParameters @WorkerCredentials
                    foreach ($job in $MainJob.ChildJobs){
                     $Global:Jobs.Add($Job.Id)
                     Write-Log -Message "Adding $($Job.Location) PSH JOB" -severity 1 -component "Invoke-CMClientAction"
                    }

                }
                Catch{
                    Write-Log -Message $_.Exception.Message -severity 3 -component "Invoke-CMClientAction"
                    Write-Log -Message "Error in line: $($_.InvocationInfo.ScriptLineNumber)" -component "Invoke-CMClientAction" -severity 3
                    
                }
        }
    }
    End{

        While($Global:Jobs.Count -ne 0){
            if($Global:Jobs.Count -ne $null){
                $RemoveJobID = @()
                foreach($JOB in $Global:Jobs){
                    $JobInfo = Get-Job -ID $JOB
                   
                    if($JobInfo.State -eq "Failed"){
                         Write-Log -Message "$TaskName failed on $($JobInfo.Location) with error $($JobInfo.JobStateInfo.Reason.Message.ToString())" -severity 3 -component "Invoke-CMClientAction"
                         Write-Log -Message "Removing JOB ID: $JOB from the array" -severity 2 -component "Invoke-CMClientAction"
                         $FailedComputers += $JobInfo
                         $RemoveJobID += ,$JOB
                         $ErrorCount++         
                    }
                    if($JobInfo.State -eq "Completed"){
                         If($JobType -eq "Local"){
                            Write-Log -Message "$TaskName Completed on $($JobInfo.Name)" -severity 1 -component "Invoke-CMClientAction"
                         }
                         Else{
                            Write-Log -Message "$TaskName Completed on $($JobInfo.Location)" -severity 1 -component "Invoke-CMClientAction"
                         }
                            Write-Log -Message "Removing JOB ID: $JOB from the array" -severity 2 -component "Invoke-CMClientAction"
                         
                             if($Reporting -eq "True"){
                                $JobData = Receive-Job -Id $JOB
                                If([System.String]::IsNullOrEmpty($JobData)){
                                    Write-Log -Message "**** --- No result from query --- ****" -severity 1 -component "Invoke-CMClientAction"
                                }
                                Else{
                                    $ContentCount++
                                    Export-Content -ContentObject $JobData -ContentFileName $ReportName
                                }
                                
                             }

                         $RemoveJobID += ,$JOB
                         $SuccessCount++
                    }
                
                }
                foreach ($Id in $RemoveJobID){
                    $Global:Jobs.Remove($ID)
                }

            }
  
            Start-sleep 1
        }

        Write-Log -Message "-------------------------------------------------------------------------------" -severity 1 -component "Invoke-CMClientAction"
        Write-Log -Message "TOTAL FAILED JOBS: $ErrorCount" -severity 1 -component "Invoke-CMClientAction"
        Write-Log -Message "TOTAL SUCCESS JOBS: $SuccessCount" -severity 1 -component "Invoke-CMClientAction"
        
        If($SuccessCount -ne 0 -and $ContentCount -gt 0){
            $ReportLocation = "$Global:PATH\Reports\$ReportName.csv"
            Write-Log -Message "Please check the following report: $ReportName" -severity 1 -component "Invoke-CMClientAction"
            Write-Log -Message "Report location: ""$ReportLocation""" -severity 1 -component "Open-Report"
        }
        If($ErrorCount -ne 0){
            Write-Log -Message "Please check the failed computers report: $Global:PATH\Reports\FailedComputers_$ReportName.CSV" -severity 1 -component "Invoke-CMClientAction"
            Save-FailedComputers -FailedComputersInfo $FailedComputers -Path "$Global:PATH\Reports\FailedComputers_$ReportName.CSV"
        }

        #Get the end time and calculate total run time
        $EndTime = (Get-Date) - $StartTime
        Write-Log -Message "TOTAL TIME: $($EndTime.TotalMinutes) minutes" -severity 1 -component "Invoke-CMClientAction"

        #Reset to default state Start Button and Worker running state
        $UserInterFace.Btn_START.Dispatcher.Invoke("Normal",[Action]{
            $UserInterFace.WorkerRunning = $False
            $UserInterFace.Btn_START.Content = "Start"
            $UserInterFace.Btn_START.IsEnabled = $True
        })

        #STOP All actions and clean up
        Remove-Job * -Force
        Start-Sleep -Seconds 1
        If($OpenReport -and $SuccessCount -gt 0 -and $ContentCount -gt 0){
            Open-Report -ReportName $ReportName
        }
    }
}

#####################################################
#
# Invoke-ClientSchedule function initiates most of the ConfigMgr Client schedules.
# This function returns PSObject. You can disable/enable reporting in XML file
#####################################################
Function Invoke-ClientSchedule
{
    Param($X)
    
    $DObject = New-Object PSObject
    $DObject | Add-Member -MemberType NoteProperty -Name "ComputerName" -Value $env:ComputerName       
        Try{
            $Command = Invoke-WmiMethod -Namespace root\CCM -Class SMS_Client -Name TriggerSchedule -ArgumentList "{$X}" -ErrorAction STOP
            $DObject | Add-Member -MemberType NoteProperty -Name "Status" -Value "Success"
        }
        Catch{
             $DObject | Add-Member -MemberType NoteProperty -Name "Status" -Value $_.Exception.Message
        }
    $DObject
}

#####################################################
#
# Get-CMClientManagementPoint function queries ConfigMgr Client Management Point.
# This function returns PSObject. You can disable/enable reporting in XML file
#####################################################
Function Get-CMClientManagementPoint
{
    $DObject = New-Object PSObject
    $DObject | Add-Member -MemberType NoteProperty -Name "ComputerName" -Value $env:ComputerName   
    Try{
        $MpQuery = Get-WmiObject -Namespace "Root\CCM" -Class SMS_Authority
        $DObject | Add-Member -MemberType NoteProperty -Name "ManagementPoint" -Value $MpQuery.CurrentManagementPoint
    }
    Catch{
        $DObject | Add-Member -MemberType NoteProperty -Name "ManagementPoint" -Value $_.Exception.Message
    }
    $DObject
}

#####################################################
#
# Restart-ConfigMgrClientService function restarts SMS Agent Host Service on client computer
# This function returns PSObject. You can disable/enable reporting in XML file
#####################################################
Function Restart-ConfigMgrClientService
{
    $DObject = New-Object PSObject
    $DObject | Add-Member -MemberType NoteProperty -Name "ComputerName" -Value $env:ComputerName  
    Try{
        $RestartService = Restart-Service -Name CcmExec -Force -ErrorAction STOP -WarningAction SilentlyContinue -PassThru
        $DObject | Add-Member -MemberType NoteProperty -Name "Status" -Value $RestartService.Status
    }
    Catch{
        $DObject | Add-Member -MemberType NoteProperty -Name "Status" -Value $_.Exception.Message
    }
    $DObject
}

#####################################################
#
# Get-SMSAgentHostServiceState function queries SMS Agent Host Service State.
# This function returns PSObject. You can disable/enable reporting in XML file
#####################################################
Function Get-SMSAgentHostServiceState
{
   $DObject = New-Object PSObject
   $DObject | Add-Member -MemberType NoteProperty -Name "ComputerName" -Value $env:ComputerName
    Try{
        $QUery = Get-Service -Name CcmExec -ErrorAction STOP
        $DObject | Add-Member -MemberType NoteProperty -Name "Status" -Value $QUery.Status
    }
    Catch{
        $DObject | Add-Member -MemberType NoteProperty -Name "Status" -Value $_.Exception.Message
    }
    $DObject
}

#####################################################
#
# Set-CMClientSiteCode function modifies ConfigMgr Client Site Code
# You can specify ConfigMgr Client Site Code in XML File. Default Site Code is PS1
#####################################################
Function Set-CMClientSiteCode
{
    Param(
        $SiteCode
    )
    $DObject = New-Object PSObject
    $DObject | Add-Member -MemberType NoteProperty -Name "ComputerName" -Value $env:ComputerName 
    Try{
        Invoke-WmiMethod -Namespace "ROOT\CCM" -Class SMS_Client -Name SetAssignedSite -ArgumentList $SiteCode -ErrorAction STOP
        $DObject | Add-Member -MemberType NoteProperty -Name "Status" -Value "OK"
    }
    Catch{
        $DObject | Add-Member -MemberType NoteProperty -Name "Status" -Value $_.Exception
    }
    $DObject
}

#####################################################
#
# Create-SMSCFGIniFile function creates a new SMSCFG.ini file
# This function returns PSObject. You can disable/enable reporting in XML file
#####################################################
Function Create-SMSCFGIniFile
{
    $DObject = New-Object PSObject
    $DObject | Add-Member -MemberType NoteProperty -Name "ComputerName" -Value $env:ComputerName 
        Try{
            Stop-Service -Name CcmExec -ErrorAction STOP -WarningAction SilentlyContinue
            if(Get-Item "$($env:windir)\SMSCFG.ini.old" -ErrorAction SilentlyContinue){
                Remove-Item -Path "$($env:windir)\SMSCFG.ini.old"
                Rename-Item -Path "$($env:windir)\SMSCFG.ini" -NewName "SMSCFG.ini.old"
            }
            Else{
                Rename-Item -Path "$($env:windir)s\SMSCFG.ini" -NewName "SMSCFG.ini.old"
            }
            Start-Service -Name CcmExec -WarningAction SilentlyContinue
           $DObject | Add-Member -MemberType NoteProperty -Name "Status" -Value "OK" 
        }
        Catch{
           $DObject | Add-Member -MemberType NoteProperty -Name "Status" -Value $_.Exception.Message
        }
    $DObject
}

#####################################################
#
# Reset-CMClientPolicy function resets ConfigMgr Client Policies
# This function does not return anything
#####################################################
Function Reset-CMClientPolicy
{
    Try{
        Invoke-WmiMethod -Namespace "Root\CCM" -Class SMS_Client -Name ResetPolicy -ArgumentList 1
    }
    Catch{
        $_.Exception.Message
    }
}

#####################################################
#
# Start-CMClientRepair function starts ConfigMgr Client repaire
# This function does not return anything
#####################################################
Function Start-CMClientRepair
{
    Try{
        Invoke-WmiMethod -Namespace "Root\CCM" -Class SMS_Client -Name RepairClient
    }
    Catch{
        $_.Exception.Message
    }
}

#####################################################
#
# Remove-CMClient function uninstalls ConfigMgr Client
# This function does not return anything
#####################################################
Function Remove-CMClient
{
    $CCMSetup = "$env:windir\ccmsetup\ccmsetup.exe /uninstall"
    $CurrentDate = (Get-Date).AddMinutes(2).ToString("HH:mm")
    $Command = "Schtasks /create /ru ""System"" /tn ""UnInstall-CMClient"" /tr ""$CCMSetup"" /sc once /st $CurrentDate /F /V1 /Z"

    Try{
        Invoke-Expression $Command -ErrorAction STOP
    }
    Catch{
        $_.Exception.Message
    }
}

#####################################################
#
# Install-CMClient function installs ConfigMgr Client
# This function does not return anything
#####################################################
Function Install-CMClient
{
    Param($X)

    $CurrentDate = (Get-Date).AddMinutes(2).ToString("HH:mm")
    $Command = "Schtasks /create /ru ""System"" /tn ""Install-CMClient"" /tr ""$X"" /sc once /st $CurrentDate /F /V1 /Z"

    Try{
        Invoke-Expression $Command -ErrorAction STOP
    }
    Catch{
        $_.Exception.Message
    }

}

#####################################################
#
# Get-CMClientInventoryActions function queries ConfigMgr Client last HW and SW inventory dates
# This function returns PSObject. You can disable/enable reporting in XML file 
#####################################################
Function Get-CMClientInventoryActions
{
    $DObject = New-Object PSObject
    $DObject | Add-Member -MemberType NoteProperty -Name "ComputerName" -Value $env:ComputerName 
    Try{
        #Hardware Inventory Date
        $HW = Get-WmiObject -NameSpace "ROOT\CCM\INVAGT" -Class InventoryActionStatus -Filter "InventoryActionID='{00000000-0000-0000-0000-000000000001}'" -ErrorAction STOP
        $DObject | Add-Member -MemberType NoteProperty -Name "Hardware Inventory Date" -Value $HW.ConvertToDateTime($HW.LastCycleStartedDate) 
    }
    Catch{
        $DObject | Add-Member -MemberType NoteProperty -Name "Hardware Inventory Date" -Value $_.Exception.Message
    }

    Try{
        #Software Inventory Date
        $SW = Get-WmiObject -NameSpace "ROOT\CCM\INVAGT" -Class InventoryActionStatus -Filter "InventoryActionID='{00000000-0000-0000-0000-000000000002}'" -ErrorAction STOP
        $DObject | Add-Member -MemberType NoteProperty -Name "Software Inventory Date" -Value $SW.ConvertToDateTime($SW.LastCycleStartedDate)
    }
    Catch{
        $DObject | Add-Member -MemberType NoteProperty -Name "Software Inventory Date" -Value $_.Exception.Message
    }
    $DObject
}

#####################################################
#
# Get-CMClientCacheInformation function queries ConfigMgr Client Cache information
# This function returns PSObject. You can disable/enable reporting in XML file
#####################################################
Function Get-CMClientCacheInformation
{
    $DObject = New-Object PSObject
    $DObject | Add-Member -MemberType NoteProperty -Name "ComputerName" -Value $env:ComputerName 
    Try{
        $CMObject = New-Object -ComObject "UIResource.UIResourceMgr" -ErrorAction STOP
        $CMCacheObject = $CMObject.GetCacheInfo()
        $DObject | Add-Member -MemberType NoteProperty -Name "Status" -Value "OK"
        $DObject | Add-Member -MemberType NoteProperty -Name "Location" -Value $CMCacheObject.Location
        $DObject | Add-Member -MemberType NoteProperty -Name "Size" -Value $CMCacheObject.TotalSize
        $DObject | Add-Member -MemberType NoteProperty -Name "FreeSpace" -Value $CMCacheObject.FreeSize
        [void][System.Runtime.Interopservices.Marshal]::ReleaseComObject($CMObject)
    }
    Catch{
        $DObject | Add-Member -MemberType NoteProperty -Name "Status" -Value $_.Exception.Message
        $DObject | Add-Member -MemberType NoteProperty -Name "Location" -Value "N/A"
        $DObject | Add-Member -MemberType NoteProperty -Name "Size" -Value "N/A"
        $DObject | Add-Member -MemberType NoteProperty -Name "FreeSpace" -Value "N/A"
    }
    $DObject
}

#####################################################
#
# Remove-CMClientCacheItems function removes ConfigMgr Client Cache items
# This function returns PSObject. You can disable/enable reporting in XML file
#####################################################
Function Remove-CMClientCacheItems
{
    $DObject = New-Object PSObject
    $DObject | Add-Member -MemberType NoteProperty -Name "ComputerName" -Value $env:ComputerName 

    Try{
        $CMObject = New-Object -ComObject "UIResource.UIResourceMgr" -ErrorAction STOP
        $CMCacheObject = $CMObject.GetCacheInfo()
        foreach($CItem in $CMCacheObject.GetCacheElements()){
            $CMCacheObject.DeleteCacheElement($CItem.CacheElementId)
        }
        [Void][System.Runtime.Interopservices.Marshal]::ReleaseComObject($CMObject)
        $DObject | Add-Member -MemberType NoteProperty -Name "Status" -Value "OK" 
    }
    Catch{
        $DObject | Add-Member -MemberType NoteProperty -Name "Status" -Value $_.Exception.Message 
    }
    $DObject
}

#####################################################
#
# Set-CMClientCacheSize function modifies ConfigMgr Client Cahce Size
# You can specify ConfigMgr Client Cache size in XML File. Default Size is 10000MB (10 GB)
#####################################################
Function Set-CMClientCacheSize
{
     Param(
         [int]$CacheSize
        )
    
    #Query Cache size
    Try{
        $CacheQuery = Get-WmiObject -Namespace ROOT\CCM\SoftMgmtAgent -Class CacheConfig -ErrorAction STOP
        $CacheQuery.Size = $CacheSize
        [Void]$CacheQuery.Put()
        Try{
            #Restart CcmExec service
            Restart-Service -Name CcmExec -ErrorAction STOP -Force -WarningAction SilentlyContinue
        }
        Catch{
            $_.Exception.Message
        }
    }
    Catch{
            $_.Exception.Message
    }
}

#####################################################
#
# Invoke-WMIStateCheck function register WMI dll files and resets WMI repository
# This function does not return anything
#####################################################
Function Invoke-WMIStateCheck
{
    #Stop Services
    Stop-Service -Name Winmgmt -Force -WarningAction SilentlyContinue
    Set-Location "$($env:windir)\System32\wbem"
    #Register DLL Files
    foreach($DLL in (Get-ChildItem -Filter *.dll)){
       regsvr32.exe -S $DLL.Name
    }
    #Check SysWOW64
    if((Test-Path "$($env:windir)\SysWOW64\wbem")){
       Set-Location "$($env:windir)\SysWOW64\wbem"
       #Register DLL Files
       foreach($DLL in (Get-ChildItem -Filter *.dll)){
          regsvr32.exe -S $DLL.Name
       }
    }
    #Reset WMI Repository
    Invoke-Expression "$($env:windir)\System32\Wbem\winmgmt.exe /resetrepository"
    #Start Services
    Start-Service -Name Winmgmt -WarningAction SilentlyContinue
    Start-Service -Name CcmExec -WarningAction SilentlyContinue
}

#####################################################
#
# Salvage-WMIRepository function salvages WMI repository if it is inconsistent
# This function returns PSObject. You can disable/enable reporting in XML file
#####################################################
Function Salvage-WMIRepository
{
    $DObject = New-Object PSObject
    $DObject | Add-Member -MemberType NoteProperty -Name "ComputerName" -Value $env:ComputerName 

    Try{
    #Salvage WMI Repository
    $Command = Invoke-Expression "$($env:windir)\System32\Wbem\winmgmt.exe /salvagerepository" -ErrorAction STOP
       $DObject | Add-Member -MemberType NoteProperty -Name "RepositoryState" -Value $Command
    }
    Catch{
       $DObject | Add-Member -MemberType NoteProperty -Name "RepositoryState" -Value $_.Exception.Message  
    }

    $DObject
}

#####################################################
#
# Get-WMIRepositoryState function queries WMI Repository State
# This function returns PSObject. You can disable/enable reporting in XML file
#####################################################
Function Get-WMIRepositoryState
{
    $DObject = New-Object PSObject
    $DObject | Add-Member -MemberType NoteProperty -Name "ComputerName" -Value $env:ComputerName 

    Try{
    #Verify WMI Repository
    $Command = Invoke-Expression "$($env:windir)\System32\Wbem\winmgmt.exe /verifyrepository" -ErrorAction STOP
       $DObject | Add-Member -MemberType NoteProperty -Name "RepositoryState" -Value $Command
    }
    Catch{
       $DObject | Add-Member -MemberType NoteProperty -Name "RepositoryState" -Value $_.Exception.Message  
    }

    $DObject
}

#####################################################
#
# Get-AdminShare function queries computer Admin$ share status
# This function returns PSObject. You can disable/enable reporting in XML file 
#####################################################
Function Get-AdminShare
{
    $DObject = New-Object PSObject
    $DObject | Add-Member -MemberType NoteProperty -Name "ComputerName" -Value $env:ComputerName

    Try{
        $AdminShareQuery = Get-WmiObject -Class Win32_Share -Filter "Name='ADMIN$'" -ErrorAction STOP
        If(($AdminShareQuery | Measure-Object | Select-Object -ExpandProperty Count) -eq 1){
            $DObject | Add-Member -MemberType NoteProperty -Name "AdminShare" -Value "OK"
        }
        Else{
            $DObject | Add-Member -MemberType NoteProperty -Name "AdminShare" -Value "NO Share"
        }
    }
    Catch{
            $DObject | Add-Member -MemberType NoteProperty -Name "AdminShare" -Value $_.Exception.Message
    }
    $DObject
}

#####################################################
#
# Get-CMClientWSUSContentLocation function queries ConfigMgr Client WSUS Content Location
# This function returns PSObject. You can disable/enable reporting in XML file
#####################################################
Function Get-CMClientWSUSContentLocation
{
    $DObject = New-Object PSObject
    $DObject | Add-Member -MemberType NoteProperty -Name "ComputerName" -Value $env:ComputerName  
        Try{
            $WUA = Get-WmiObject -Namespace "Root\CCM\SoftwareUpdates\WUAHandler" -Class CCM_UpdateSource -ErrorAction STOP
            $DObject | Add-Member -MemberType NoteProperty -Name "Status" -Value "OK"
            $DObject | Add-Member -MemberType NoteProperty -Name "ContentLocation" -Value $WUA.ContentLocation
            $DObject | Add-Member -MemberType NoteProperty -Name "ContentVersion" -Value $WUA.ContentVersion
        }
        Catch{
            Try{
                $WUA = Get-ItemProperty "HKLM:SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" -ErrorAction STOP
                if($WUA.WUServer.Length -eq 0){
                    $WuServer = "No Server"
                }
                Else{
                    $WuServer = $WUA.WUServer
                }
                $DObject | Add-Member -MemberType NoteProperty -Name "Status" -Value "OK"
                $DObject | Add-Member -MemberType NoteProperty -Name "ContentLocation" -Value $WuServer
                $DObject | Add-Member -MemberType NoteProperty -Name "ContentVersion" -Value "N/A"
            }
            Catch{
                    $DObject | Add-Member -MemberType NoteProperty -Name "Status" -Value $_.Exception.Message
                    $DObject | Add-Member -MemberType NoteProperty -Name "ContentLocation" -Value "N/A"
                    $DObject | Add-Member -MemberType NoteProperty -Name "ContentVersion" -Value "N/A"
            }
            $DObject | Add-Member -MemberType NoteProperty -Name "Status" -Value $_.Exception.Message
            $DObject | Add-Member -MemberType NoteProperty -Name "ContentLocation" -Value "N/A"
            $DObject | Add-Member -MemberType NoteProperty -Name "ContentVersion" -Value "N/A"
        }
    $DObject
}

#####################################################
#
# Get-CMClientWUAVersion function queries Windows Update Agent Version
# This function returns PSObject. You can disable/enable reporting in XML file
#####################################################
Function Get-CMClientWUAVersion
{
    $DObject = New-Object PSObject
    $DObject | Add-Member -MemberType NoteProperty -Name "ComputerName" -Value $env:ComputerName  
    Try{
        $WUAgent = Get-WmiObject -Namespace "Root\Cimv2\SMS" -Class Win32_WindowsUpdateAgentVersion -ErrorAction STOP
        $DObject | Add-Member -MemberType NoteProperty -Name "WUAVersion" -Value $WUAgent.Version
    }
    Catch{
        
        Try{
            $WUAgent = (Get-Item "$env:windir\System32\wuapi.dll" -ErrorAction STOP).VersionInfo.ProductVersion
            $DObject | Add-Member -MemberType NoteProperty -Name "WUAVersion" -Value $WUAgent
        }
        Catch{
            $DObject | Add-Member -MemberType NoteProperty -Name "WUAVersion" -Value $_.Exception.Message
        }
        $DObject | Add-Member -MemberType NoteProperty -Name "WUAVersion" -Value $_.Exception.Message
    }
    $DObject
}

#####################################################
#
# Get-CMClientMissingUpdates function queries ConfigMgr available updates
# This function returns PSObject. You can disable/enable reporting in XML file 
#####################################################
Function Get-CMClientMissingUpdates
{
    $MissingUpdates = @()
    Try{
        $MissingUpdatesQuery = Get-WmiObject -Query "SELECT * FROM CCM_SoftwareUpdate" -Namespace "ROOT\ccm\ClientSDK" -ErrorAction STOP
        If(($MissingUpdatesQuery | Measure-Object | Select-Object -ExpandProperty Count) -ne 0){
            foreach($item in $MissingUpdatesQuery){
                $DObject = New-Object PSObject                    $DObject | Add-Member -MemberType NoteProperty -Name "ComputerName" -Value $env:ComputerName 
                    $DObject | Add-Member -MemberType NoteProperty -Name "Name" -Value $item.Name
                    $DObject | Add-Member -MemberType NoteProperty -Name "ArticleID" -Value $item.ArticleID
                    $DObject | Add-Member -MemberType NoteProperty -Name "Status" -Value "OK"
                $MissingUpdates += $DObject
            }
        }
    }
    Catch{
                $DObject = New-Object PSObject                    $DObject | Add-Member -MemberType NoteProperty -Name "ComputerName" -Value $env:ComputerName 
                    $DObject | Add-Member -MemberType NoteProperty -Name "Name" -Value "N/A"
                    $DObject | Add-Member -MemberType NoteProperty -Name "ArticleID" -Value "N/A"
                    $DObject | Add-Member -MemberType NoteProperty -Name "Status" -Value $_.Exception.Message
                $MissingUpdates += $DObject        
    }
    $MissingUpdates
}

#####################################################
#
# Install-CMClientMissingUpdates function installs ConfigMgr available updates
# This function does not return anything
#####################################################
Function Install-CMClientMissingUpdates
{
    Try{
    $MissingUpdatesQuery = Get-WmiObject -Query "SELECT * FROM CCM_SoftwareUpdate" -Namespace "ROOT\ccm\ClientSDK" -ErrorAction STOP
        If(($MissingUpdatesQuery | Measure-Object | Select-Object -ExpandProperty Count) -ne 0){
            Try{
                foreach($item in $MissingUpdatesQuery){
                    Invoke-WmiMethod -Namespace "Root\CCM\ClientSDK" -Class CCM_SoftwareUpdatesManager -Name InstallUpdates -ArgumentList $item
                }
            }
            Catch{
                $_.Exception.Message
            }
        }
    }
    Catch{
        $_.Exception.Message
    }
}

#####################################################
#
# Get-WindowsUpdateStatus function queries specific KB Articles installation statuss
# This function returns PSObject. You can specify KB Articles through UI
#####################################################
Function Get-WindowsUpdateStatus
{
    Param([String[]]$KBArticles)

    $InstalledUpdates = @()
    $i=0
    $KBArticles = $KBArticles.Split(",") | ForEach-Object {$_}
    foreach($item in $KBArticles){

                $DObject = New-Object PSObject
                $DObject | Add-Member -MemberType NoteProperty -Name "ComputerName" -Value $env:ComputerName
        Try{
            $KBQuery = Get-WmiObject -Namespace "Root\Cimv2" -Class Win32_QuickFixEngineering -Filter "HotFixID like '%$item%'" -ErrorAction STOP
            IF(($KBQuery | Measure-Object | Select-Object -ExpandProperty Count) -ne 0){
                $DObject | Add-Member -MemberType NoteProperty -Name "Status" -Value "Installed"
                $DObject | Add-Member -MemberType NoteProperty -Name "HotFixID" -Value $KBQuery.HotFixID
                $DObject | Add-Member -MemberType NoteProperty -Name "InstalledOn" -Value $KBQuery.InstalledOn
                $DObject | Add-Member -MemberType NoteProperty -Name "InstalledBy" -Value $KBQuery.InstalledBy
            }
            Else{
                $DObject | Add-Member -MemberType NoteProperty -Name "Status" -Value "Not Installed"
                $DObject | Add-Member -MemberType NoteProperty -Name "HotFixID" -Value $item
                $DObject | Add-Member -MemberType NoteProperty -Name "InstalledOn" -Value "N/A"
                $DObject | Add-Member -MemberType NoteProperty -Name "InstalledBy" -Value "N/A"
            }
        }
        Catch{
                $DObject | Add-Member -MemberType NoteProperty -Name "Status" -Value $_.Exception.Message
                $DObject | Add-Member -MemberType NoteProperty -Name "HotFixID" -Value $item
                $DObject | Add-Member -MemberType NoteProperty -Name "InstalledOn" -Value "N/A"
                $DObject | Add-Member -MemberType NoteProperty -Name "InstalledBy" -Value "N/A"
        }
    $InstalledUpdates += $DObject
    }
    $InstalledUpdates
}

#####################################################
#
# Start-EPFullScan function starts Endpoint Protection Full Scan
# This function does not return anything
#####################################################
Function Start-EPFullScan
{
    $Location = "$Env:SystemDrive\Program Files\Microsoft Security Client\MpCmdRun.exe"
    Try{
        Invoke-Expression '& $Location -scan -scantype 2' -ErrorAction STOP
    }
    Catch{
        $_.Exception.Message
    }
}

#####################################################
#
# Get-EPAppliedPolicies function queries Endpoint Protection Client applied policies
# This function returns PSObject. You can disable/enable reporting in XML file 
#####################################################
Function Get-EPAppliedPolicies
{
    $AppliedPolicies = @()
    Try{

        $Policies = Get-WmiObject -Namespace "ROOT\ccm\Policy\Machine\ActualConfig" -Class CCM_AntiMalwarePolicyClientConfig  -ErrorAction STOP | Group-Object Name | Select-Object -Unique -ExpandProperty Name
        foreach($item in $Policies){
            $DObject = New-Object PSObject                $DObject | Add-Member -MemberType NoteProperty -Name "ComputerName" -Value $env:ComputerName 
                $DObject | Add-Member -MemberType NoteProperty -Name "Status" -Value "OK"
                $DObject | Add-Member -MemberType NoteProperty -Name "PolicyName" -Value $item
            $AppliedPolicies += $DObject
        }
    }
    Catch{
             $DObject = New-Object PSObject                $DObject | Add-Member -MemberType NoteProperty -Name "ComputerName" -Value $env:ComputerName 
                $DObject | Add-Member -MemberType NoteProperty -Name "Status" -Value $_.Exception.Message
                $DObject | Add-Member -MemberType NoteProperty -Name "PolicyName" -Value "N/A"
            $AppliedPolicies += $DObject       
    }
    $AppliedPolicies
}

#####################################################
#
# Get-EPlastScanTime function queries Endpoint Protection Client last scan date
# This function returns PSObject. You can disable/enable reporting in XML file 
#####################################################
Function Get-EPlastScanTime
{
    $DObject = New-Object PSObject
    $DObject | Add-Member -MemberType NoteProperty -Name "ComputerName" -Value $env:ComputerName
    Try{
        $MMA = Get-ItemProperty -Path "Microsoft.PowerShell.Core\Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Microsoft Antimalware\scan" -ErrorAction STOP
            $ScanTime = 0; $i = 0
            foreach($item in $MMA.LastScanRun){
                $ScanTime += $item * [math]::Pow(256,$i++)
            }
            $ScanTime = [DateTime]::FromFileTime($ScanTime)
        $DObject | Add-Member -MemberType NoteProperty -Name "Status" -Value "OK"
        $DObject | Add-Member -MemberType NoteProperty -Name "LastScanTime" -Value $ScanTime
    }
    Catch{
        $DObject | Add-Member -MemberType NoteProperty -Name "Status" -Value $_.Exception.Message
        $DObject | Add-Member -MemberType NoteProperty -Name "LastScanTime" -Value "N/A"
    }
    $DObject
}

#####################################################
#
# Get-APPvClientPackages function queries APP-V client packages
# This function returns PSObject. You can disable/enable reporting in XML file
#####################################################
Function Get-APPvClientPackages
{
    $APPVAppsCol = @()
    Try{
        $APPVApps = Get-WmiObject -Namespace "ROOT\Appv" -Class AppvClientPackage -ErrorAction STOP
        foreach($item in $APPVApps){
            $DObject = New-Object PSObject
                    $DObject | Add-Member -MemberType NoteProperty -Name "ComputerName" -Value $env:ComputerName
                    $DObject | Add-Member -MemberType NoteProperty -Name "Status" -Value "OK"
                    $DObject | Add-Member -MemberType NoteProperty -Name "Name" -Value $item.Name
                    $DObject | Add-Member -MemberType NoteProperty -Name "PackageId" -Value $item.PackageID
                    $DObject | Add-Member -MemberType NoteProperty -Name "VersionId" -Value $item.VersionID
                    $DObject | Add-Member -MemberType NoteProperty -Name "Path" -Value $item.Path
                    $DObject | Add-Member -MemberType NoteProperty -Name "IsPublishedGlobally" -Value $item.IsPublishedGlobally
                    $DObject | Add-Member -MemberType NoteProperty -Name "PercentLoaded" -Value $item.PercentLoaded
                    $APPVAppsCol += $DObject
        }
    }
    Catch{
        $DObject = New-Object PSObject
                    $DObject | Add-Member -MemberType NoteProperty -Name "ComputerName" -Value $env:ComputerName
                    $DObject | Add-Member -MemberType NoteProperty -Name "Status" -Value $_.Exception.Message
                    $DObject | Add-Member -MemberType NoteProperty -Name "Name" -Value "N/A"
                    $DObject | Add-Member -MemberType NoteProperty -Name "PackageId" -Value "N/A"
                    $DObject | Add-Member -MemberType NoteProperty -Name "VersionId" -Value "N/A"
                    $DObject | Add-Member -MemberType NoteProperty -Name "Path" -Value "N/A"
                    $DObject | Add-Member -MemberType NoteProperty -Name "IsPublishedGlobally" -Value "N/A"
                    $DObject | Add-Member -MemberType NoteProperty -Name "PercentLoaded" -Value "N/A"
                    $APPVAppsCol += $DObject
    }
    $APPVAppsCol
}

#####################################################
#
# Get-APPvClientConfiguration function queries APP-V client configuration
# This function returns PSObject. You can disable/enable reporting in XML file
#####################################################
Function Get-APPvClientConfiguration
{

     Try{
         $AppVSettings = Get-appvclientconfiguration -ErrorAction STOP
             $DObject = New-Object PSObject
             $DObject | Add-Member -MemberType NoteProperty -Name "ComputerName" -Value $env:COMPUTERNAME
             foreach($item in $AppVSettings){
                $DObject | Add-Member -MemberType NoteProperty -Name $item.name -Value $item.Value
             }
     }
     Catch{
     }
     $DObject
}

#####################################################
#
# Get-AppvClientVersion function queries APP-V client information
# This function returns PSObject. You can disable/enable reporting in XML file
#####################################################
Function Get-AppvClientVersion
{
   $DObject = New-Object PSObject
   $DObject | Add-Member -MemberType NoteProperty -Name "ComputerName" -Value $env:ComputerName
   Try{
       $APPVClient = Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\APPV\Client" -ErrorAction STOP
           $DObject | Add-Member -MemberType NoteProperty -Name "Status" -Value "OK"
           $DObject | Add-Member -MemberType NoteProperty -Name "Version" -Value $APPVClient.Version
           $DObject | Add-Member -MemberType NoteProperty -Name "InstallPath" -Value $APPVClient.InstallPath
   }
   Catch{
           $DObject | Add-Member -MemberType NoteProperty -Name "Status" -Value $_.Exception.Message
           $DObject | Add-Member -MemberType NoteProperty -Name "Version" -Value "N/A"
           $DObject | Add-Member -MemberType NoteProperty -Name "InstallPath" -Value "N/A"
   }
   $DObject
}

#####################################################
#
# Enable-AppVClientScripts function enables APP-V Client scripts
# This function does not return anything
#####################################################
Function Enable-AppVClientScripts
{
    Set-AppvClientConfiguration -EnablePackageScripts $True
}

#####################################################
#
# Get-ConfigMgrClientAvailableApps function queries Configuration Manager Client available applications
# This function returns PSObject. You can disable/enable reporting in XML file 
#####################################################
Function Get-ConfigMgrClientAvailableApps
{
    Param($X)

    $AppsAr = @()
    Try{
    $AvailableApps = Get-WmiObject -Namespace "ROOT\CCM\ClientSDK" -Class CCM_Application -ComputerName $X -ErrorAction STOP
        foreach($item in $AvailableApps){
           $DObject = New-Object PSObject
           $DObject | Add-Member -MemberType NoteProperty -Name "ComputerName" -Value $X
           $DObject | Add-Member -MemberType NoteProperty -Name "Status" -Value "OK"
           $DObject | Add-Member -MemberType NoteProperty -Name "FullName" -Value $item.FullName
           $DObject | Add-Member -MemberType NoteProperty -Name "Id" -Value $item.ID
           $DObject | Add-Member -MemberType NoteProperty -Name "ApplicabilityState" -Value $item.ApplicabilityState
           $DObject | Add-Member -MemberType NoteProperty -Name "InstallState" -Value $item.InstallState
           $DObject | Add-Member -MemberType NoteProperty -Name "Revision" -Value $item.Revision
           $DObject | Add-Member -MemberType NoteProperty -Name "IsMachineTarget" -Value $item.IsMachineTarget
           $DObject | Add-Member -MemberType NoteProperty -Name "EnforcePreference" -Value $item.EnforcePreference
           $AppsAr += $DObject
        }
    }
    Catch{
           $DObject = New-Object PSObject
           $DObject | Add-Member -MemberType NoteProperty -Name "ComputerName" -Value $X
           $DObject | Add-Member -MemberType NoteProperty -Name "Status" -Value $_.Exception.Message
           $DObject | Add-Member -MemberType NoteProperty -Name "FullName" -Value "N/A"
           $DObject | Add-Member -MemberType NoteProperty -Name "Id" -Value "N/A"
           $DObject | Add-Member -MemberType NoteProperty -Name "ApplicabilityState" -Value "N/A"
           $DObject | Add-Member -MemberType NoteProperty -Name "InstallState" -Value "N/A"
           $DObject | Add-Member -MemberType NoteProperty -Name "Revision" -Value "N/A"
           $DObject | Add-Member -MemberType NoteProperty -Name "IsMachineTarget" -Value "N/A"
           $DObject | Add-Member -MemberType NoteProperty -Name "EnforcePreference" -Value "N/A"
           $AppsAr += $DObject
    }
    $AppsAr
}

#####################################################
#
# Restart-CMClientComputer function restarts client computer
# 
#####################################################
Function Restart-CMClientComputer
{
    Param($ComputerName)
    Restart-Computer -Force -ComputerName $ComputerName -WarningAction SilentlyContinue
}

#####################################################
#
# Start-ComputerShutDown function shutdowns client computer
# 
#####################################################
Function Start-ComputerShutDown
{
    Param($ComputerName)
    Stop-Computer -Force -ComputerName $ComputerName -WarningAction SilentlyContinue
}


#####################################################
#
# Ping-Computer function pings remote computer
# This function returns PSObject. You can disable/enable reporting in XML file
#####################################################
Function Ping-Computer
{
    Param($X)
    $DObject = New-Object PSObject
    $DObject | Add-Member -MemberType NoteProperty -Name "ComputerName" -Value $X 
    Try{
        If(Test-Connection -Count 2 -ComputerName $X -Quiet -ErrorAction STOP){
            $DObject | Add-Member -MemberType NoteProperty -Name "Online" -Value "YES"
        }
        Else{
            $DObject | Add-Member -MemberType NoteProperty -Name "Online" -Value "NO"
        }
    }
    Catch{
        $DObject | Add-Member -MemberType NoteProperty -Name "Online" -Value "N/A"
    }
    $DObject
}

#####################################################
#
# Get-RebootPendingStatus function queries computer reboot pending state
# This function returns PSObject. You can disable/enable reporting in XML file
#####################################################
Function Get-RebootPendingStatus
{
    $DObject = New-Object PSObject
    $DObject | Add-Member -MemberType NoteProperty -Name "ComputerName" -Value $env:ComputerName    
    Try{
        $RebootStatus = Invoke-WmiMethod -NameSpace "ROOT\CCM\ClientSDK" -Name DetermineIfRebootPending -Class CCM_ClientUtilities -ErrorAction STOP
        $DObject | Add-Member -MemberType NoteProperty -Name "InGracePeriod" -Value $RebootStatus.InGracePeriod
        $DObject | Add-Member -MemberType NoteProperty -Name "IsHardRebootPending" -Value $RebootStatus.IsHardRebootPending
        $DObject | Add-Member -MemberType NoteProperty -Name "RebootPending" -Value $RebootStatus.RebootPending
    }
    Catch{
        Try{
            $RegQuery = Get-ItemProperty "HKLM:SYSTEM\CurrentControlSet\Control\Session Manager" -Name "PendingFileRenameOperations" -ErrorAction STOP
            $DObject | Add-Member -MemberType NoteProperty -Name "InGracePeriod" -Value "N/A"
            $DObject | Add-Member -MemberType NoteProperty -Name "IsHardRebootPending" -Value "N/A"
            $DObject | Add-Member -MemberType NoteProperty -Name "RebootPending" -Value "True"
        }
        Catch{
            $DObject | Add-Member -MemberType NoteProperty -Name "InGracePeriod" -Value "N/A"
            $DObject | Add-Member -MemberType NoteProperty -Name "IsHardRebootPending" -Value "N/A"
            $DObject | Add-Member -MemberType NoteProperty -Name "RebootPending" -Value "False"
        }
    }
    $DObject
}

#####################################################
#
# Invoke-UserLogOff function logs off logged on user
# This function does not return anything
#####################################################
Function Invoke-UserLogOff
{
    Try{
        Invoke-WmiMethod -Path "\\localhost\root\cimv2:Win32_OperatingSystem=@" -Name Win32Shutdown -ArgumentList 4
         
    }
    Catch{
        $_.Exception.Message
    }
}

#####################################################
#
# Get-LoggedOnUser function queries logged on user
# This function returns PSObject. You can disable/enable reporting in XML file 
#####################################################
Function Get-LoggedOnUser
{
    $DObject = New-Object PSObject
    $DObject | Add-Member -MemberType NoteProperty -Name "ComputerName" -Value $env:ComputerName 
    Try{
        $UserQuery = Get-WmiObject -Namespace "Root\Cimv2" -Class Win32_ComputerSystem
        $DObject | Add-Member -MemberType NoteProperty -Name "Status" -Value "OK"
        $DObject | Add-Member -MemberType NoteProperty -Name "UserName" -Value $UserQuery.UserName
    }
    Catch{
        $DObject | Add-Member -MemberType NoteProperty -Name "Status" -Value $_.Exception.Message
        $DObject | Add-Member -MemberType NoteProperty -Name "UserName" -Value "N/A"
    }
    $DObject
}

#####################################################
#
# Get-ComputerUpTime function queries computer uptime date/time
# This function returns PSObject. You can disable/enable reporting in XML file
#####################################################
Function Get-ComputerUpTime
{
    $DObject = New-Object PSObject
    $DObject | Add-Member -MemberType NoteProperty -Name "ComputerName" -Value $env:ComputerName 
    Try{
        $BootTime = Get-WmiObject -Class Win32_OperatingSystem -ErrorAction STOP
        $LastBootUpTime = $BootTime.ConvertToDateTime($BootTime.LastBootUpTime)
        $DObject | Add-Member -MemberType NoteProperty -Name "LastBootUpTime" -Value $LastBootUpTime
        $DObject | Add-Member -MemberType NoteProperty -Name "Days" -Value (((Get-Date) - (Get-Date $LastBootUpTime)).Days)
        $DObject | Add-Member -MemberType NoteProperty -Name "Hours" -Value (((Get-Date) - (Get-Date $LastBootUpTime)).Hours)
    }
    Catch{
        $DObject | Add-Member -MemberType NoteProperty -Name "LastBootUpTime" -Value "N/A"
        $DObject | Add-Member -MemberType NoteProperty -Name "Days" -Value "N/A"
        $DObject | Add-Member -MemberType NoteProperty -Name "Hours" -Value "N/A"
    }
    $DObject
}

#####################################################
#
# Get-ComputerAppliedPolicies function queries applied computer policies
# This function returns PSObject. You can disable/enable reporting in XML file
#####################################################
Function Get-ComputerAppliedPolicies
{
    $GPOPolicies = @()
    Try{
    $GPOQuery = Get-WmiObject -Namespace "ROOT\RSOP\Computer" -Class RSOP_GPLink -Filter "AppliedOrder <> 0" -ErrorAction STOP | ForEach-Object {$_.GPO.ToString().Replace("RSOP_GPO.","")}
        foreach($GP in $GPOQuery){
            $AppliedPolicy = Get-WmiObject -Namespace "ROOT\RSOP\Computer" -Class RSOP_GPO -Filter $GP
                $DObject = New-Object PSObject
                $DObject | Add-Member -MemberType NoteProperty -Name "ComputerName" -Value $env:ComputerName
                $DObject | Add-Member -MemberType NoteProperty -Name "Name" -Value $AppliedPolicy.Name
                $DObject | Add-Member -MemberType NoteProperty -Name "GuidName" -Value $AppliedPolicy.GuidName
                $DObject | Add-Member -MemberType NoteProperty -Name "ID" -Value $AppliedPolicy.ID
                $GPOPolicies += $DObject
        }
    }
    Catch{
        $DObject = New-Object PSObject
                $DObject | Add-Member -MemberType NoteProperty -Name "ComputerName" -Value $env:ComputerName
                $DObject | Add-Member -MemberType NoteProperty -Name "Name" -Value "N/A"
                $DObject | Add-Member -MemberType NoteProperty -Name "GuidName" -Value "N/A"
                $DObject | Add-Member -MemberType NoteProperty -Name "ID" -Value "N/A"
                $GPOPolicies += $DObject
    }
    $GPOPolicies
}

#####################################################
#
# Invoke-GPUpdate function invokes Group Policy update
# This function does not return anything
#####################################################
Function Invoke-GPUpdate
{
   Try{
        Invoke-Expression "Gpupdate /Force" -ErrorAction STOP
   }
   Catch{
        $_.Exception.Message
   }
}

#####################################################
#
# Get-FreeDiskSpace function queries computer freespace information
# This function returns PSObject. You can disable/enable reporting in XML file
#####################################################
Function Get-FreeDiskSpace
{
    Param($X)

    $DisksArray = @()
    Try{
        $DisksQuery = Get-WmiObject -Class Win32_Volume -ErrorAction STOP -Filter "DriveType=3" -ComputerName $X
        foreach($item in $DisksQuery){
            $DObject = New-Object PSObject
                $DObject | Add-Member -MemberType NoteProperty -Name "ComputerName" -Value $X
                $DObject | Add-Member -MemberType NoteProperty -Name "Status" -Value "OK"
                $DObject | Add-Member -MemberType NoteProperty -Name "DriveLetter" -Value $item.DriveLetter
                $DObject | Add-Member -MemberType NoteProperty -Name "Label" -Value $item.Label
                $DObject | Add-Member -MemberType NoteProperty -Name "FreeSpace" -Value ($item.FreeSpace /1GB)
            $DisksArray += $DObject
        }
    }
    Catch{
         $DObject = New-Object PSObject
            $DObject | Add-Member -MemberType NoteProperty -Name "ComputerName" -Value $X
            $DObject | Add-Member -MemberType NoteProperty -Name "Status" -Value $_.Exception.Message
            $DObject | Add-Member -MemberType NoteProperty -Name "DriveLetter" -Value "N/A"
            $DObject | Add-Member -MemberType NoteProperty -Name "Label" -Value "N/A"
            $DObject | Add-Member -MemberType NoteProperty -Name "FreeSpace" -Value "N/A"
        $DisksArray += $DObject
    }
    $DisksArray
}

#####################################################

    #
    # PLACE YOUR CUSTOM FUNCTION HERE
    #


#####################################################


#####################################################
#
# Start-CMToolAction function  is a Pre-Execution function that queries correct ScriptBlock
#  
#####################################################
Function Start-CMToolAction
{
     PARAM(
          $ScriptBlockName,
          $TaskName,
          $Computers,
          $Reporting,
          $TaskScriptBlockParameters,
          $OpenReport,
          $JobType,
          $WorkerCredentials
          )

    Remove-Job * -Force
    Write-Log -Message "Starting to run $TaskName" -severity 1 -component "Start-CMToolAction"
    $Global:Jobs = [system.collections.arraylist]::Synchronized((New-Object System.Collections.ArrayList))

    Try{
        $WorkerFunction = (Get-ChildItem "Function:$ScriptBlockName" -ErrorAction STOP) | Select-Object -ExpandProperty Definition
        $FunctionTOScriptBlock = [System.Management.Automation.ScriptBlock]::Create($WorkerFunction)   
        
           If($JobType -eq "Local"){
                Write-Log -Message "Job Type: Local Remote Jobs" -severity 1 -component "Start-CMToolAction"
                Write-Log -Message "Please wait - generating new Jobs" -severity 1 -component "Start-CMToolAction"
                $Global:MaxConcurrentJobs = 10
                $Global:Queue = [System.Collections.Queue]::Synchronized((New-Object System.Collections.Queue))
                $Computers | ForEach-Object {$Global:Queue.Enqueue($_)}
                If($Global:Queue.count -lt $MaxConcurrentJobs) {
                    $Global:MaxConcurrentJobs = $Global:Queue.count
                }
                for( $i = 0; $i -lt $Global:MaxConcurrentJobs; $i++ ){
                    Start-BackGroundJob -ScriptBlock $FunctionTOScriptBlock -WorkerCredentials $WorkerCredentials
                }
                Invoke-CMClientAction -TaskName $TaskName -Reporting $Reporting -OpenReport $OpenReport -JobType $JobType -ScriptBlock $FunctionTOScriptBlock -WorkerCredentials $WorkerCredentials
            }
            Else{
                Write-Log -Message "Job Type: Remote" -severity 1 -component "Start-CMToolAction"
                Write-Log -Message "Total computers: $($Computers.Count)" -severity 1 -component "Start-CMToolAction" -noScreen
                Invoke-CMClientAction -Computers $Computers -TaskName $TaskName -ScriptBlock $FunctionTOScriptBlock -Reporting $Reporting -TaskScriptBlockParameters $TaskScriptBlockParameters -OpenReport $OpenReport -WorkerCredentials $WorkerCredentials
            } 
    }
    Catch{
        Get-ErrorInformation -Component "Start-CMToolAction"
        #Reset to default state Start Button and Worker running state
        $UserInterFace.Btn_START.Dispatcher.Invoke("Normal",[Action]{
            $UserInterFace.WorkerRunning = $False
            $UserInterFace.Btn_START.Content = "Start"
            $UserInterFace.Btn_START.IsEnabled = $True
        })
    }
    
}