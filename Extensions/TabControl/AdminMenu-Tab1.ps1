##*=============================================
##* LOAD TAB 2 FROM CONFIG
##*=============================================
$ConfigTab1 = $AppMenuTabandButtons.tab[0]
If ($HashNames.Keys -eq "Tab1"){
    Write-Host "Found Tab2 section in names file" -ForegroundColor Gray
    $Tab1HashNames = $HashNames.Tab1
    [string]$Tab1HashList = $Tab1HashNames| out-string -stream
    write-Host "`nNames found in list: `n$Tab1HashList"
}
Else{
    Write-Host "No Tab1 section found in names file" -ForegroundColor Gray
}

$WPFtxtTab1Name1.Text = $envComputerName

$WPFbtnTab1Name1List.add_Click({Save-ComputerList -TitleDesc "List of Workstations" -TabObject Tab1} )
##*=============================================
##* FORM ADD CLICK FUNCTIONS
##*=============================================
<#
    Examples to use (place in function):

    SIMPLE:
        Start-Process -File "$PSHOME\PowerShell.exe" -WindowStyle Normal

    SEND TO OUTPUT (PASSTHRU):
        Write-OutputBox -OutputBoxMessage "Opening Powershell window." -Type "START: " -Object Tab1
        $PasstoOutput = Start-Process -File "$PSHOME\PowerShell.exe" -WindowStyle Normal -PassThru | Out-String
        If ($AppOptionDebugeMode){Write-OutputBox -OutputBoxMessage $PasstoOutput -Type "INFO: " -Object Tab1}

    OPEN EXTERNAL PS1
        . ($scriptRoot + "\Scripts\ClipboardHistoryViewer.ps1")

    USE INTGRATED FUNCTION (EASIEST)
     - to log to output box in tab, use -OutputTab switch
     - to identify process alias, use -Alias switch, otherwise the button name will be used
     - to specify a custom run message use the -CustomRunMsg switch
     - to specify a custom error message use the -CustomErrMsg switch (this will only display if errors)
     - Auto use credentials feature if selected in menu, you can force it not to by adding -NeverRunAs switch

       EXAMPLE (EXE):
          Start-ButtonProcess -Alias "$ButtonClicked" -Path "$PSHOME\PowerShell.exe" -WorkingDirectory "$envWinDir\System32" -OutputTab tab1 -WindowStyle Normal
       
       EXAMPLE (EXE) with Parameters:
          Start-ButtonProcess -Alias "$ButtonClicked" -Path "$envWinDir\system32\mstsc.exe" -Parameters ("/v:" + $WPFtxtTab1Name1.Text) -OutputTab tab1 -WindowStyle Normal

       EXAMPLE (PS1): 
          Start-ButtonProcess -ProcessCall ps1 -File "Start-PoshPAIG.ps1" -WorkingDirectory "$($scriptRoot + "\Scripts\PoshPAIG_2_1_5")" -CreateNoWindow

#>
# Set of 6 large buttons under left column
function Call-btnTab1_01{
    Start-ButtonProcess -Path "$PSHOME\PowerShell.exe" -WorkingDirectory "$envWinDir\System32" -OutputTab tab1 -WindowStyle Normal
}

function Call-btnTab1_02{
    Start-ButtonProcess -Path "$envComSpec" -WorkingDirectory "$envWinDir\System32" -OutputTab tab1 -WindowStyle Normal
}

function Call-btnTab1_03{
    If ($WPFtxtTab1Name1.Text -eq $envComputerName){
        Start-ButtonProcess -Path "$envWinDir\system32\compmgmt.msc" -CustomRunMsg "Opening [$ButtonClicked] for local system, change remote system and try again OR right click on local system in the Computer Managmeent window and select 'connect to another computer'." -OutputTab tab1 -WindowStyle Normal 
    }
    Else{
        If (Test-Connection -ComputerName $WPFtxtTab1Name1.Text -Quiet){
             Start-ButtonProcess -Path "$envWinDir\system32\compmgmt.msc" -Parameters ("/computer:" + $WPFtxtTab1Name1.Text) -CustomRunMsg "Opening [$ButtonClicked] for: $($WPFtxtTab1Name1.Text)" -Object Tab1 -WindowStyle Normal
        }
        Else {
            Write-OutputBox -OutputBoxMessage "Unable to remotely open [$ButtonClicked] for: $($WPFtxtTab1Name1.Text), system may be offline." -Type "ERROR: " -Object Tab1
        }
    }
}

function Call-btnTab1_04{
    Start-ButtonProcess -Path "$envWinDir\system32\mmc.exe" -OutputTab tab1 -WindowStyle Normal
}

function Call-btnTab1_05{
    If ($WPFtxtTab1Name1.Text -eq $envComputerName){
        Write-OutputBox -OutputBoxMessage "Unable to open [$ButtonClicked] for local system, change remote system and try again" -Type "ERROR: " -Object Tab1
    }
    ElseIf ($Global:SelectedRunAs){
         Start-ButtonProcess -ProcessCall ps1 -File "Connect-Mstsc.ps1" -Parameters "-ComputerName $($WPFtxtTab1Name1.Text)" -OutputTab tab1 -CreateNoWindow
    }
    Else{
        Start-ButtonProcess -Path "$envWinDir\system32\mstsc.exe" -Parameters ("/v:" + $WPFtxtTab1Name1.Text) -OutputTab tab1 -CustomRunMsg "Opening Remote Desktop Connection for: $($WPFtxtTab1Name1.Text)" -NeverRunAs -WindowStyle Normal
    }
}

function Call-btnTab1_06{

}

# Set of 4 small buttons under left column
function Call-btnTab1_07{
    #clear Registries last used path
    Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Applets\Regedit" -Name "FindFlags" -Force -ErrorAction SilentlyContinue
    Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Applets\Regedit" -Name "LastKey" -Force -ErrorAction SilentlyContinue
    Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Applets\Regedit" -Name "View" -Force -ErrorAction SilentlyContinue
    Start-ButtonProcess -Path "$envWinDir\system32\regedt32.exe" -OutputTab tab1 -WindowStyle Normal
}

function Call-btnTab1_08{
    $CMToolkitPath = "$envProgramFilesX86\ConfigMgr 2012 Toolkit R2\ClientTools"
    $ClassRootValue = (Get-ItemProperty "Registry::HKEY_CLASSES_ROOT\Log.File\shell\open\command" "(Default)" | Select-Object -ExpandProperty "(Default)" -ErrorAction SilentlyContinue).split("%1")[0].Replace('"','').Trim()
    If (Test-Path $CMToolkitPath){
        Start-ButtonProcess -Path "$CMToolkitPath\cmtrace.exe" -OutputTab tab1 -WindowStyle Normal
    }
    ElseIf (Test-Path "$envWinDir\system32\cmtrace.exe"){
        Start-ButtonProcess -Path "$envWinDir\system32\cmtrace.exe" -OutputTab tab1 -WindowStyle Normal
    }
    ElseIf (Test-Path $ClassRootValue){
        Start-ButtonProcess -Path "$ClassRootValue" -OutputTab tab1 -WindowStyle Normal
    }
    Else{
        Start-ButtonProcess -Path "$UtilPath\cmtrace.exe" -OutputTab tab1 -WindowStyle Normal
    }
}


function Call-btnTab1_09{
    If ($WPFtxtTab1Name1.Text -eq $envComputerName){
        Start-ButtonProcess -ProcessCall vbs -Path "BypassCAC.vbs" -OutputTab tab1 -WindowStyle Normal
    }
    Else{
        Start-ButtonProcess -ProcessCall vbs -Path "BypassCAC.vbs" -Parameters $WPFtxtTab1Name1.Text -WindowStyle Normal
    }
}


function Call-btnTab1_10{

}


# Set of 4 large buttons under right column
function Call-btnTab1_11{
    $DameWarePath = "$envProgramFilesX86\DameWare Development\DameWare NT Utilities"
    Start-ButtonProcess -Path "$DameWarePath\DNTU.exe" -OutputTab tab1 -WindowStyle Normal -CustomErrMsg "Unable to open [$ButtonClicked], it may not be installed"
}

function Call-btnTab1_12{
    $DameWarePath = "$envProgramFilesX86\DameWare Development\DameWare NT Utilities"
    If ($WPFtxtTab1Name1.Text -eq $envComputerName){
        Start-ButtonProcess -Path "$DameWarePath\DWRCC.exe" -OutputTab tab1 -WindowStyle Normal 
    }
    Else{
        Start-ButtonProcess -Path "$DameWarePath\DWRCC.exe" -Parameters "-m:$($WPFtxtTab1Name1.Text) -u:$Global:runAsAccount  -p:$Global:runAsPassword -x:" -CustomRunMsg "Connecting to $($WPFtxtTab1Name1.Text) with [$ButtonClicked]"  -OutputTab tab1 -WindowStyle Normal 
    }
    
}

function Call-btnTab1_13{
    
}

function Call-btnTab1_14{

}

# Set of 12 small buttons under right column
function Call-btnTab1_15{
    $Pingtest = Test-Connection -ComputerName $WPFtxtTab1Name1.Text -Count 4 | Select Address,IPv4Address,ResponseTime,BufferSize | out-string 
    Write-OutputBox -OutputBoxMessage "$($WPFtxtTab1Name1.Text) $Pingtest" -Type "PING: " -Object Tab1 

}

function Call-btnTab1_16{
    If ($WPFtxtTab1Name1.Text -eq $envComputerName){
        Start-ButtonProcess -ProcessCall cmd -File "systeminfo.exe" -CustomRunMsg "Retrieving [$ButtonClicked] for local system, change remote system and try again." -OutputTab tab1 -CreateNoWindow
    }
    Else{
        If (Test-Connection -ComputerName $WPFtxtTab1Name1.Text -Quiet){
            Start-ButtonProcess -ProcessCall cmd -File "systeminfo.exe" -Parameters ("/S " + $WPFtxtTab1Name1.Text) -CustomRunMsg "Retrieving [$ButtonClicked] for: $($WPFtxtTab1Name1.Text)" -Object Tab1 -WindowStyle Normal
        }
        Else {
            Write-OutputBox -OutputBoxMessage "Unable to retrieve [$ButtonClicked] for: $($WPFtxtTab1Name1.Text), system may be offline." -Type "ERROR: " -Object Tab1
        }
    }
}

function Call-btnTab1_17{
    #Start-ButtonProcess -ProcessCall ps1 -File "Get-SystemInfo.ps1" -WorkingDirectory "E:\Software\Scripts\AdminMenu\Scripts" -Parameters "-ComputerName PLEXSVR" -OutputTab tab1 -CreateNoWindow
    Retrieve-SystemInfo -ComputerName $WPFtxtTab1Name1.Text
}

function Call-btnTab1_18{
    If ($WPFtxtTab1Name1.Text -eq $envComputerName){
        Start-ButtonProcess -Path "$envWinDir\system32\services.msc" -CustomRunMsg "Opening [$ButtonClicked] for local system, change remote system and try again OR right click on local system in the window and select 'connect to another computer'." -OutputTab tab1 -WindowStyle Normal 
    }
    Else{
        If (Test-Connection -ComputerName $WPFtxtTab1Name1.Text -Quiet){
             Start-ButtonProcess -Path "$envWinDir\system32\services.msc" -Parameters ("/computer:" + $WPFtxtTab1Name1.Text) -CustomRunMsg "Opening [$ButtonClicked] for: $($WPFtxtTab1Name1.Text)" -Object Tab1 -WindowStyle Normal
        }
        Else {
            Write-OutputBox -OutputBoxMessage "Unable to remotely open [$ButtonClicked] for: $($WPFtxtTab1Name1.Text), system may be offline." -Type "ERROR: " -Object Tab1
        }
    }
}

function Call-btnTab1_19{

}

function Call-btnTab1_20{

}

function Call-btnTab1_21{
    Get-LoggedIn -computername $WPFtxtTab1Name1.Text -Outbox Tab1
}

function Call-btnTab1_22{
    If ($WPFtxtTab1Name1.Text -eq $envComputerName){
        Start-ButtonProcess -Path "$envWinDir\system32\eventvwr.msc" -CustomRunMsg "Opening [$ButtonClicked] for local system, change remote system and try again OR right click on local system in the window and select 'connect to another computer'." -OutputTab tab1 -WindowStyle Normal 
    }
    Else{
        If (Test-Connection -ComputerName $WPFtxtTab1Name1.Text -Quiet){
            Start-ButtonProcess -Path "$envWinDir\system32\seventvwr.msc" -Parameters ("/computer:" + $WPFtxtTab1Name1.Text) -CustomRunMsg "Opening [$ButtonClicked] for: $($WPFtxtTab1Name1.Text)" -Object Tab1 -WindowStyle Normal
        }
        Else {
            Write-OutputBox -OutputBoxMessage "Unable to remotely open [$ButtonClicked] for: $($WPFtxtTab1Name1.Text), system may be offline." -Type "ERROR: " -Object Tab1
        }
    }
    
}

function Call-btnTab1_23{
	Run-RemoteCMD -ComputerName $WPFtxtTab1Name1.Text -Command $RemoteCommand	
	Write-OutputBox -OutputBoxMessage "$($WPFtxtTab1Name1.Text) >> sent Remote Command: '$RemoteCommand'" -Type "INFO: " -Object Tab1
}

function Call-btnTab1_24{
    Start-ButtonProcess -ProcessCall ps1 -File "Get-DiskSpaceChart.ps1" -Parameters "-ComputerName $($WPFtxtTab1Name1.Text)" -OutputTab tab1 -CreateNoWindow
    <#If ($WPFtxtTab1Name1.Text -eq $envComputerName){
        Write-OutputBox -OutputBoxMessage "Retrieving [$ButtonClicked] for local system" -Type "INFO: " -Object Tab1
         Get-WmiObject -Class Win32_LogicalDisk | Out-GridView -Title "Disk Info"
    }
    Else{
        If (Test-Connection -ComputerName $WPFtxtTab1Name1.Text -Quiet){
            Write-OutputBox -OutputBoxMessage "Retrieving [$ButtonClicked] for [$($WPFtxtTab1Name1.Text)]" -Type "INFO: " -Object Tab1
            Get-WmiObject -Class Win32_LogicalDisk -ComputerName $WPFtxtTab1Name1.Text | Out-GridView -Title "Disk Info"
        }
        Else {
            Write-OutputBox -OutputBoxMessage "Unable to retrieve [$ButtonClicked] for: $($WPFtxtTab1Name1.Text), system may be offline." -Type "ERROR: " -Object Tab1
        }
    }
   #Get-DiskSpace -computername $WPFtxtTab1Name1.Text #>
}

function Call-btnTab1_25{
    Get-InstalledSoftware -computername $WPFtxtTab1Name1.Text -Property InstallLocation,UninstallString,QuietUninstallString
    #$Script = {Get-InstalledSoftware}
    #$Params = @{computername= $WPFtxtTab1Name1.Text; Property = Uninstallstring}
    #Start-ButtonProcess -ProcessCall ps1 -File "Invoke-Runspace.ps1" -Parameters "-AddFunction Get-InstalledSoftware -ParamStatic $Params" -WindowStyle Normal
    #Invoke-Runspace -ScriptBlock $Script -ParamStatic $Params
}

function Call-btnTab1_26{
    Start-ButtonProcess -ProcessCall ps1 -File "Remote-TaskMgr.ps1" -Parameters "-ComputerName $($WPFtxtTab1Name1.Text)" -OutputTab tab1 -CreateNoWindow
    #. ($scriptRoot + "\Scripts\Remote-TaskMgr.ps1") $WPFtxtTab1Name1.Text
    #Build-TskMgrForm -Remote $WPFtxtTab1Name1.Text
}


##*=============================================
##* TAB 1 OTHER FUNCTIONS
##*=============================================




##*=============================================
##* BUILD TAB 1 BUTTONS IF CONFIGURED
##*=============================================
$ConfigTab1_Name = $ConfigTab1.Name

$WPFTab1.Header = $ConfigTab1_Name 
$WPFlblTab1Section1.Content = $ConfigTab1.section1Label
$WPFlblTab1Section2.Content = $ConfigTab1.section2Label


$ConfigTab1_btns = $ConfigTab1.button

Foreach ($button in $ConfigTab1_btns){
    
    [string]$buttonID = $button.id
    If ($AppOptionDebugeMode){Write-Host "Tab1: Parsing 'button $buttonID' configurations" -ForegroundColor Gray}

    If ($buttonID -eq "01"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab1_01.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab1_01.IsEnabled = $false} Else {$WPFbtnTab1_01.IsEnabled = $true}
        $WPFbtnTextTab1_01.Text = $button.Name
        $WPFbtnTab1_01.Background = $button.bgcolor
        $WPFbtnTab1_01.Foreground = $button.textcolor
        #$WPFbtnTab1_01.Add_Click({Call-btnTab1_01})
        $WPFbtnTab1_01.add_Click({
                $ButtonClicked = $WPFbtnTextTab1_01.Text
                Call-btnTab1_01
            })
    } 

    If ($buttonID -eq "02"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab1_02.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab1_02.IsEnabled = $false} Else {$WPFbtnTab1_02.IsEnabled = $true}
        $WPFbtnTextTab1_02.Text = $button.Name
        $WPFbtnTab1_02.Background = $button.bgcolor
        $WPFbtnTab1_02.Foreground = $button.textcolor
        $WPFbtnTab1_02.Add_Click({
                $ButtonClicked = $WPFbtnTextTab1_02.Text
                Call-btnTab1_02
            })
    }

    If ($buttonID -eq "03"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab1_03.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab1_03.IsEnabled = $false} Else {$WPFbtnTab1_03.IsEnabled = $true}
        $WPFbtnTextTab1_03.Text = $button.Name
        $WPFbtnTab1_03.Background = $button.bgcolor
        $WPFbtnTab1_03.Foreground = $button.textcolor
        $WPFbtnTab1_03.Add_Click({
                $ButtonClicked = $WPFbtnTextTab1_03.Text
                Call-btnTab1_03
            })
    }

    If ($buttonID -eq "04"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab1_04.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab1_04.IsEnabled = $false} Else {$WPFbtnTab1_04.IsEnabled = $true}
        $WPFbtnTextTab1_04.Text = $button.Name
        $WPFbtnTab1_04.Background = $button.bgcolor
        $WPFbtnTab1_04.Foreground = $button.textcolor
        $WPFbtnTab1_04.Add_Click({
                $ButtonClicked = $WPFbtnTextTab1_04.Text
                Call-btnTab1_04
            })
    } 

    If ($buttonID -eq "05"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab1_05.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab1_05.IsEnabled = $false} Else {$WPFbtnTab1_05.IsEnabled = $true}
        $WPFbtnTextTab1_05.Text = $button.Name
        $WPFbtnTab1_05.Background = $button.bgcolor
        $WPFbtnTab1_05.Foreground = $button.textcolor
        $WPFbtnTab1_05.Add_Click({
                $ButtonClicked = $WPFbtnTextTab1_05.Text
                Call-btnTab1_05
             })
    } 

    If ($buttonID -eq "06"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab1_06.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab1_06.IsEnabled = $false} Else {$WPFbtnTab1_06.IsEnabled = $true}
        $WPFbtnTextTab1_06.Text = $button.Name
        $WPFbtnTab1_06.Background = $button.bgcolor
        $WPFbtnTab1_06.Foreground = $button.textcolor
        $WPFbtnTab1_06.Add_Click({
                $ButtonClicked = $WPFbtnTextTab1_06.Text
                Call-btnTab1_06
            })
    } 

    If ($buttonID -eq "07"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab1_07.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab1_07.IsEnabled = $false} Else {$WPFbtnTab1_07.IsEnabled = $true}
        $WPFbtnTextTab1_07.Text = $button.Name
        $WPFbtnTab1_07.Background = $button.bgcolor
        $WPFbtnTab1_07.Foreground = $button.textcolor
        $WPFbtnTab1_07.Add_Click({
                $ButtonClicked = $WPFbtnTextTab1_07.Text
                Call-btnTab1_07
            })
    } 

    If ($buttonID -eq "08"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab1_08.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab1_08.IsEnabled = $false} Else {$WPFbtnTab1_08.IsEnabled = $true}
        $WPFbtnTextTab1_08.Text = $button.Name
        $WPFbtnTab1_08.Background = $button.bgcolor
        $WPFbtnTab1_08.Foreground = $button.textcolor
        $WPFbtnTab1_08.Add_Click({
                $ButtonClicked = $WPFbtnTextTab1_08.Text
                Call-btnTab1_08
            })
    } 

    If ($buttonID -eq "09"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab1_09.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab1_09.IsEnabled = $false} Else {$WPFbtnTab1_09.IsEnabled = $true}
        $WPFbtnTextTab1_09.Text = $button.Name
        $WPFbtnTab1_09.Background = $button.bgcolor
        $WPFbtnTab1_09.Foreground = $button.textcolor
        $WPFbtnTab1_09.Add_Click({
                $ButtonClicked = $WPFbtnTextTab1_09.Text
                Call-btnTab1_09
            })
    } 

    If ($buttonID -eq "10"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab1_10.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab1_10.IsEnabled = $false} Else {$WPFbtnTab1_10.IsEnabled = $true}
        $WPFbtnTextTab1_10.Text = $button.Name
        $WPFbtnTab1_10.Background = $button.bgcolor
        $WPFbtnTab1_10.Foreground = $button.textcolor
        $WPFbtnTab1_10.Add_Click({
                $ButtonClicked = $WPFbtnTextTab1_10.Text
                Call-btnTab1_10
            })
    } 

    If ($buttonID -eq "11"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab1_11.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab1_11.IsEnabled = $false} Else {$WPFbtnTab1_11.IsEnabled = $true}
        $WPFbtnTextTab1_11.Text = $button.Name
        $WPFbtnTab1_11.Background = $button.bgcolor
        $WPFbtnTab1_11.Foreground = $button.textcolor
        $WPFbtnTab1_11.Add_Click({
                $ButtonClicked = $WPFbtnTextTab1_11.Text
                Call-btnTab1_11
            })
    } 

    If ($buttonID -eq "12"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab1_12.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab1_12.IsEnabled = $false} Else {$WPFbtnTab1_12.IsEnabled = $true}
        $WPFbtnTextTab1_12.Text = $button.Name
        $WPFbtnTab1_12.Background = $button.bgcolor
        $WPFbtnTab1_12.Foreground = $button.textcolor
        $WPFbtnTab1_12.Add_Click({
                $ButtonClicked = $WPFbtnTextTab1_12.Text
                Call-btnTab1_12
            })
    } 

    If ($buttonID -eq "13"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab1_13.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab1_13.IsEnabled = $false} Else {$WPFbtnTab1_13.IsEnabled = $true}
        $WPFbtnTextTab1_13.Text = $button.Name
        $WPFbtnTab1_13.Background = $button.bgcolor
        $WPFbtnTab1_13.Foreground = $button.textcolor
        $WPFbtnTab1_13.Add_Click({
                $ButtonClicked = $WPFbtnTextTab1_13.Text
                Call-btnTab1_13
            })
    } 
    If ($buttonID -eq "14"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab1_14.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab1_14.IsEnabled = $false} Else {$WPFbtnTab1_14.IsEnabled = $true}
        $WPFbtnTextTab1_14.Text = $button.Name
        $WPFbtnTab1_14.Background = $button.bgcolor
        $WPFbtnTab1_14.Foreground = $button.textcolor
        $WPFbtnTab1_14.Add_Click({
                $ButtonClicked = $WPFbtnTextTab1_14.Text
                Call-btnTab1_14
            })
    } 

    If ($buttonID -eq "15"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab1_15.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab1_15.IsEnabled = $false} Else {$WPFbtnTab1_15.IsEnabled = $true}
        $WPFbtnTextTab1_15.Text = $button.Name
        $WPFbtnTab1_15.Background = $button.bgcolor
        $WPFbtnTab1_15.Foreground = $button.textcolor
        $WPFbtnTab1_15.Add_Click({
                $ButtonClicked = $WPFbtnTextTab1_15.Text
                Call-btnTab1_15
            })
    } 

    If ($buttonID -eq "16"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab1_16.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab1_16.IsEnabled = $false} Else {$WPFbtnTab1_16.IsEnabled = $true}
        $WPFbtnTextTab1_16.Text = $button.Name
        $WPFbtnTab1_16.Background = $button.bgcolor
        $WPFbtnTab1_16.Foreground = $button.textcolor
        $WPFbtnTab1_16.Add_Click({
                $ButtonClicked = $WPFbtnTextTab1_16.Text
                Call-btnTab1_16
            })
    } 

    If ($buttonID -eq "17"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab1_17.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab1_17.IsEnabled = $false} Else {$WPFbtnTab1_17.IsEnabled = $true}
        $WPFbtnTextTab1_17.Text = $button.Name
        $WPFbtnTab1_17.Background = $button.bgcolor
        $WPFbtnTab1_17.Foreground = $button.textcolor
        $WPFbtnTab1_17.Add_Click({
                $ButtonClicked = $WPFbtnTextTab1_17.Text
                Call-btnTab1_17
            })
    } 

    If ($buttonID -eq "18"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab1_18.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab1_18.IsEnabled = $false} Else {$WPFbtnTab1_18.IsEnabled = $true}
        $WPFbtnTextTab1_18.Text = $button.Name
        $WPFbtnTab1_18.Background = $button.bgcolor
        $WPFbtnTab1_18.Foreground = $button.textcolor
        $WPFbtnTab1_18.Add_Click({
                $ButtonClicked = $WPFbtnTextTab1_18.Text
                Call-btnTab1_18
            })
    } 

    If ($buttonID -eq "19"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab1_19.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab1_19.IsEnabled = $false} Else {$WPFbtnTab1_19.IsEnabled = $true}
        $WPFbtnTextTab1_19.Text = $button.Name
        $WPFbtnTab1_19.Background = $button.bgcolor
        $WPFbtnTab1_19.Foreground = $button.textcolor
        $WPFbtnTab1_19.Add_Click({
                $ButtonClicked = $WPFbtnTextTab1_19.Text
                Call-btnTab1_19
            })
    } 

    If ($buttonID -eq "20"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab1_20.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab1_20.IsEnabled = $false} Else {$WPFbtnTab1_20.IsEnabled = $true}
        $WPFbtnTextTab1_20.Text = $button.Name
        $WPFbtnTab1_20.Background = $button.bgcolor
        $WPFbtnTab1_20.Foreground = $button.textcolor
        $WPFbtnTab1_20.Add_Click({
                $ButtonClicked = $WPFbtnTextTab1_20.Text
                Call-btnTab1_20
            })
    } 

    If ($buttonID -eq "21"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab1_21.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab1_21.IsEnabled = $false} Else {$WPFbtnTab1_21.IsEnabled = $true}
        $WPFbtnTextTab1_21.Text = $button.Name
        $WPFbtnTab1_21.Background = $button.bgcolor
        $WPFbtnTab1_21.Foreground = $button.textcolor
        $WPFbtnTab1_21.Add_Click({
                $ButtonClicked = $WPFbtnTextTab1_21.Text
                Call-btnTab1_21
            })
    } 

    If ($buttonID -eq "22"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab1_22.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab1_22.IsEnabled = $false} Else {$WPFbtnTab1_22.IsEnabled = $true}
        $WPFbtnTextTab1_22.Text = $button.Name
        $WPFbtnTab1_22.Background = $button.bgcolor
        $WPFbtnTab1_22.Foreground = $button.textcolor
        $WPFbtnTab1_22.Add_Click({
                $ButtonClicked = $WPFbtnTextTab1_22.Text
                Call-btnTab1_22
            })
    } 

    If ($buttonID -eq "23"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab1_23.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab1_23.IsEnabled = $false} Else {$WPFbtnTab1_23.IsEnabled = $true}
        $WPFbtnTextTab1_23.Text = $button.Name
        $WPFbtnTab1_23.Background = $button.bgcolor
        $WPFbtnTab1_23.Foreground = $button.textcolor
        $WPFbtnTab1_23.Add_Click({
                $ButtonClicked = $WPFbtnTextTab1_23.Text
                Call-btnTab1_23
            })
    } 

    If ($buttonID -eq "24"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab1_24.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab1_24.IsEnabled = $false} Else {$WPFbtnTab1_24.IsEnabled = $true}
        $WPFbtnTextTab1_24.Text = $button.Name
        $WPFbtnTab1_24.Background = $button.bgcolor
        $WPFbtnTab1_24.Foreground = $button.textcolor
        $WPFbtnTab1_24.Add_Click({
                $ButtonClicked = $WPFbtnTextTab1_24.Text
                Call-btnTab1_24
            })
    } 

    If ($buttonID -eq "25"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab1_25.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab1_25.IsEnabled = $false} Else {$WPFbtnTab1_25.IsEnabled = $true}
        $WPFbtnTextTab1_25.Text = $button.Name
        $WPFbtnTab1_25.Background = $button.bgcolor
        $WPFbtnTab1_25.Foreground = $button.textcolor
        $WPFbtnTab1_25.Add_Click({
                $ButtonClicked = $WPFbtnTextTab1_25.Text
                Call-btnTab1_25
            })
    } 

    If ($buttonID -eq "26"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab1_26.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab1_26.IsEnabled = $false} Else {$WPFbtnTab1_26.IsEnabled = $true}
        $WPFbtnTextTab1_26.Text = $button.Name
        $WPFbtnTab1_26.Background = $button.bgcolor
        $WPFbtnTab1_26.Foreground = $button.textcolor
        $WPFbtnTab1_26.Add_Click({
                $ButtonClicked = $WPFbtnTextTab1_26.Text
                Call-btnTab1_26
            })
    } 
}
