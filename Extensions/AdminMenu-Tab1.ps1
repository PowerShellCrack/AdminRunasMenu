##*=============================================
##* LOAD TAB 2 FROM CONFIG
##*=============================================
$ConfigTab1 = $XmlConfigFile.app.tabAndButtons.tab[0]

##*=============================================
##* FORM ADD CLICK FUNCTIONS
##*=============================================
<#
    Examples to use (place in function):

    SIMPLE:
        Start-Process -FilePath "$PSHOME\PowerShell.exe" -WindowStyle Normal

    SEND TO OUTPUT (PASSTHRU):
        Write-OutputBox -OutputBoxMessage "Opening Powershell window." -Type "START: " -Object Tab1
        $PasstoOutput = Start-Process -FilePath "$PSHOME\PowerShell.exe" -WindowStyle Normal -PassThru | Out-String
        If ($LogDebugMode){Write-OutputBox -OutputBoxMessage $PasstoOutput -Type "INFO: " -Object Tab1}

    OPEN EXTERNAL PS1
        . ($scriptRoot + "\Scripts\ClipboardHistoryViewer.ps1")

    USE INTGRATED FUNCTION (EASIEST)
     - to log to output box in tab, use -OutputTab switch
     - to identify process alias, use -Title switch, otherwise path will be used instead
     - to specify a custom run message use the -CustomRunMsg switch
     - to specify a custom error message use the -CustomErrMsg switch (this will only display if errors)
     - Auto use credentials feature if selected in menu, you can force it not to by adding -NeverRunAs switch

       EXAMPLE (EXE):
          Start-ButtonProcess -Title "$($WPFbtnTab1_01.Content)" -Path "$PSHOME\PowerShell.exe" -WorkingDirectory "$envWinDir\System32" -OutputTab tab1 -WindowStyle Normal
       
       EXAMPLE (EXE) with Parameters:
          Start-ButtonProcess -Title "$($WPFbtnTab1_11.Content)" -Path "$env:windir\system32\mstsc.exe" -Parameters ("/v:" + $WPFtxtBoxRemote.Text) -OutputTab tab1 -WindowStyle Normal

       EXAMPLE (PS1): 
          Start-ButtonProcess -ProcessCall ps1 -Title "$($WPFbtnTab6_02.Content)" -File "Start-PoshPAIG.ps1" -WorkingDirectory "$($scriptRoot + "\Scripts\PoshPAIG_2_1_5")" -CreateNoWindow

#>
# Set of 6 large buttons under left column
function btnTab1_01_Click {
    Start-ButtonProcess -Title "$($WPFbtnTab1_01.Content)" -Path "$PSHOME\PowerShell.exe" -WorkingDirectory "$envWinDir\System32" -OutputTab tab1 -WindowStyle Normal
}

function btnTab1_02_Click {
    Start-ButtonProcess -Title "$($WPFbtnTab1_02.Content)" -Path "$envComSpec" -WorkingDirectory "$envWinDir\System32" -OutputTab tab1 -WindowStyle Normal
}

function btnTab1_03_Click {
    $CMToolkitPath = "$envProgramFilesX86\ConfigMgr 2012 Toolkit R2\ClientTools"
    If (Test-Path $CMToolkitPath){
        Start-ButtonProcess -Title "$($WPFbtnTab1_03.Content)" -Path "$CMToolkitPath\cmtrace.exe" -OutputTab tab1 -WindowStyle Normal
    }
    Else{
        Start-ButtonProcess -Title "$($WPFbtnTab1_03.Content)" -Path "$envWinDir\system32\cmtrace.exe" -OutputTab tab1 -WindowStyle Normal
    }
}

function btnTab1_04_Click {
    Start-ButtonProcess -Title "$($WPFbtnTab1_04.Content)" -Path "$env:windir\system32\mmc.exe" -OutputTab tab1 -WindowStyle Normal
}

function btnTab1_05_Click {
    $DameWarePath = "$envProgramFilesX86\DameWare Development\DameWare NT Utilities"
    Start-ButtonProcess -Title "$($WPFbtnTab1_05.Content)" -Path $DameWarePath -OutputTab tab1 -WindowStyle Normal -CustomErrMsg "Unable to open [$($WPFbtnTab1_05.Content)], it may not be installed"

}

function btnTab1_06_Click {

}

# Set of 4 small buttons under left column
function btnTab1_07_Click {
    #clear Registries last used path
    Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Applets\Regedit" -Name "FindFlags" -Force -ErrorAction SilentlyContinue
    Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Applets\Regedit" -Name "LastKey" -Force -ErrorAction SilentlyContinue
    Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Applets\Regedit" -Name "View" -Force -ErrorAction SilentlyContinue
    Start-ButtonProcess -Title "$($WPFbtnTab1_07.Content)" -Path "$env:windir\system32\regedt32.exe" -OutputTab tab1 -WindowStyle Normal
}

function btnTab1_08_Click {

}


function btnTab1_09_Click {

}


function btnTab1_10_Click {

}


# Set of 4 large buttons under right column
function btnTab1_11_Click {
    If ($WPFtxtBoxRemote.Text -eq $env:COMPUTERNAME){
        Write-OutputBox -OutputBoxMessage "Unable to open [$($WPFbtnTab1_11.Content)] for local system, change remote system and try again" -Type "ERROR: " -Object Tab1
    }
    Else{
        Write-OutputBox -OutputBoxMessage "Opening Remote Desktop Connection for: $($WPFtxtBoxRemote.Text)" -Type "START: " -Object Tab1
        Start-ButtonProcess -Title "$($WPFbtnTab1_11.Content)" -Path "$env:windir\system32\mstsc.exe" -Parameters ("/v:" + $WPFtxtBoxRemote.Text) -OutputTab tab1 -NeverRunAs -WindowStyle Normal
    }
}

function btnTab1_12_Click {
    $DameWarePath = "$envProgramFilesX86\DameWare Development\DameWare NT Utilities"
    If ($WPFtxtBoxRemote.Text -eq $env:COMPUTERNAME){
        Start-ButtonProcess -Title "$($WPFbtnTab1_12.Content)" -Path "$DameWarePath\DWRCC.exe" -OutputTab tab1 -WindowStyle Normal 
    }
    Else{
        Start-ButtonProcess -Title "$($WPFbtnTab1_12.Content)" -Path "$DameWarePath\DWRCC.exe" -Parameters "-m:$($WPFtxtBoxRemote.Text) -u:$Global:runAsAccount  -p:$Global:runAsPassword -x:" -CustomRunMsg "Connecting to $($WPFtxtBoxRemote.Text) with [$($WPFbtnTab1_12.Content)]"  -OutputTab tab1 -WindowStyle Normal 
    }
    
}

function btnTab1_13_Click {
    If ($WPFtxtBoxRemote.Text -eq $env:COMPUTERNAME){
        Start-ButtonProcess -Title "$($WPFbtnTab1_13.Content)" -Path "$env:windir\system32\compmgmt.msc" -CustomRunMsg "Opening [$($WPFbtnTab1_13.Content)] for local system, change remote system and try again OR right click on local system in the Computer Managmeent window and select 'connect to another computer'." -OutputTab tab1 -WindowStyle Normal 
    }
    Else{
        If (Test-Connection -ComputerName $WPFtxtBoxRemote.Text -Quiet){
             Start-ButtonProcess -Path "$env:windir\system32\compmgmt.msc" -Parameters ("/computer:" + $WPFtxtBoxRemote.Text) -CustomRunMsg "Opening [$($WPFbtnTab1_13.Content)] for: $($WPFtxtBoxRemote.Text)" -Object Tab1 -WindowStyle Normal
        }
        Else {
            Write-OutputBox -OutputBoxMessage "Unable to remotely open [$($WPFbtnTab1_13.Content)] for: $($WPFtxtBoxRemote.Text), system may be offline." -Type "ERROR: " -Object Tab1
        }
    }
    
}

function btnTab1_14_Click {

}

# Set of 12 small buttons under right column
function btnTab1_15_Click {
    #Ping-System -Remote $WPFtxtBoxRemote.Text
    $Pingtest = Test-Connection -ComputerName $WPFtxtBoxRemote.Text -Count 4 | Select Address,IPv4Address,ResponseTime,BufferSize | out-string
    Write-OutputBox -OutputBoxMessage "$($WPFtxtBoxRemote.Text) $Pingtest" -Type "PING: " -Object Tab1 

}

function btnTab1_16_Click {
    If ($WPFtxtBoxRemote.Text -eq $env:COMPUTERNAME){
        Start-ButtonProcess -ProcessCall cmd -Title "$($WPFbtnTab1_16.Content)" -File "systeminfo.exe" -CustomRunMsg "Retrieving [$($WPFbtnTab1_17.Content)] for local system, change remote system and try again." -OutputTab tab1 -CreateNoWindow
    }
    Else{
        If (Test-Connection -ComputerName $WPFtxtBoxRemote.Text -Quiet){
            Start-ButtonProcess -ProcessCall cmd -File "systeminfo.exe" -Parameters ("/S " + $WPFtxtBoxRemote.Text) -CustomRunMsg "Retrieving [$($WPFbtnTab1_17.Content)] for: $($WPFtxtBoxRemote.Text)" -Object Tab1 -WindowStyle Normal
        }
        Else {
            Write-OutputBox -OutputBoxMessage "Unable to retrieve [$($WPFbtnTab1_17.Content)] for: $($WPFtxtBoxRemote.Text), system may be offline." -Type "ERROR: " -Object Tab1
        }
    }
}

function btnTab1_17_Click {
    #Start-ButtonProcess -ProcessCall ps1 -File "Get-SystemInfo.ps1" -WorkingDirectory "E:\Software\Scripts\AdminMenu\Scripts" -Parameters "-ComputerName PLEXSVR" -OutputTab tab1 -CreateNoWindow
    Retrieve-SystemInfo -ComputerName $WPFtxtBoxRemote.Text
}

function btnTab1_18_Click {
    If ($WPFtxtBoxRemote.Text -eq $env:COMPUTERNAME){
        Start-ButtonProcess -Title "$($WPFbtnTab1_18.Content)" -Path "$env:windir\system32\services.msc" -CustomRunMsg "Opening [$($WPFbtnTab1_18.Content)] for local system, change remote system and try again OR right click on local system in the window and select 'connect to another computer'." -OutputTab tab1 -WindowStyle Normal 
    }
    Else{
        If (Test-Connection -ComputerName $WPFtxtBoxRemote.Text -Quiet){
             Start-ButtonProcess -Path "$env:windir\system32\services.msc" -Parameters ("/computer:" + $WPFtxtBoxRemote.Text) -CustomRunMsg "Opening [$($WPFbtnTab1_18.Content)] for: $($WPFtxtBoxRemote.Text)" -Object Tab1 -WindowStyle Normal
        }
        Else {
            Write-OutputBox -OutputBoxMessage "Unable to remotely open [$($WPFbtnTab1_18.Content)] for: $($WPFtxtBoxRemote.Text), system may be offline." -Type "ERROR: " -Object Tab1
        }
    }
}

function btnTab1_19_Click {

}

function btnTab1_20_Click {

}

function btnTab1_21_Click {
    Get-LoggedIn -computername $WPFtxtBoxRemote.Text -Outbox Tab1
}

function btnTab1_22_Click {
    If ($WPFtxtBoxRemote.Text -eq $envComputerNameFQD){
        Start-ButtonProcess -Title "$($WPFbtnTab1_22.Content)" -Path "$env:windir\system32\eventvwr.msc" -CustomRunMsg "Opening [$($WPFbtnTab1_22.Content)] for local system, change remote system and try again OR right click on local system in the window and select 'connect to another computer'." -OutputTab tab1 -WindowStyle Normal 
    }
    Else{
        If (Test-Connection -ComputerName $WPFtxtBoxRemote.Text -Quiet){
            Start-ButtonProcess -Path "$env:windir\system32\seventvwr.msc" -Parameters ("/computer:" + $WPFtxtBoxRemote.Text) -CustomRunMsg "Opening [$($WPFbtnTab1_22.Content)] for: $($WPFtxtBoxRemote.Text)" -Object Tab1 -WindowStyle Normal
        }
        Else {
            Write-OutputBox -OutputBoxMessage "Unable to remotely open [$($WPFbtnTab1_22.Content)] for: $($WPFtxtBoxRemote.Text), system may be offline." -Type "ERROR: " -Object Tab1
        }
    }
    
}

function btnTab1_23_Click {

}

function btnTab1_24_Click {

}

function btnTab1_25_Click {

}

function btnTab1_26_Click {
    Start-ButtonProcess -ProcessCall ps1 -Title "$($WPFbtnTab1_26.Content)" -File "Remote-TaskMgr.ps1" -WorkingDirectory "$($scriptRoot + "\Scripts")" -Parameters ("-computer " + $WPFtxtBoxRemote.Text) -OutputTab tab1 -CreateNoWindow
    #. ($scriptRoot + "\Scripts\Remote-TaskMgr.ps1") $WPFtxtBoxRemote.Text
    #Build-TskMgrForm -Remote $WPFtxtBoxRemote.Text
}


##*=============================================
##* TAB 1 OTHER FUNCTIONS
##*=============================================

$WPFtxtBoxRemote.Text = $envComputerName


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
    If ($LogDebugMode){Write-Host "Tab1: Found button: $buttonID"}

    If ($buttonID -eq "01"){
        If ($LogDebugMode){write-Host "      Configuring  button: $buttonID"}
        $WPFbtnTab1_01.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab1_01.IsEnabled = $false} Else {$WPFbtnTab1_01.IsEnabled = $true}
        $WPFbtnTab1_01.Content = $button.Name
        $WPFbtnTab1_01.Background = $button.bgcolor
        $WPFbtnTab1_01.Foreground = $button.textcolor
        $WPFbtnTab1_01.Add_Click({btnTab1_01_Click})
    } 

    If ($buttonID -eq "02"){
        If ($LogDebugMode){write-Host "      Configuring  button: $buttonID"}
        $WPFbtnTab1_02.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab1_02.IsEnabled = $false} Else {$WPFbtnTab1_02.IsEnabled = $true}
        $WPFbtnTab1_02.Content = $button.Name
        $WPFbtnTab1_02.Background = $button.bgcolor
        $WPFbtnTab1_02.Foreground = $button.textcolor
        $WPFbtnTab1_02.Add_Click({btnTab1_02_Click})
    }

    If ($buttonID -eq "03"){
        If ($LogDebugMode){write-Host "      Configuring  button: $buttonID"}
        $WPFbtnTab1_03.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab1_03.IsEnabled = $false} Else {$WPFbtnTab1_03.IsEnabled = $true}
        $WPFbtnTab1_03.Content = $button.Name
        $WPFbtnTab1_03.Background = $button.bgcolor
        $WPFbtnTab1_03.Foreground = $button.textcolor
        $WPFbtnTab1_03.Add_Click({btnTab1_03_Click})
    }

    If ($buttonID -eq "04"){
        If ($LogDebugMode){write-Host "      Configuring  button: $buttonID"}
        $WPFbtnTab1_04.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab1_04.IsEnabled = $false} Else {$WPFbtnTab1_04.IsEnabled = $true}
        $WPFbtnTab1_04.Content = $button.Name
        $WPFbtnTab1_04.Background = $button.bgcolor
        $WPFbtnTab1_04.Foreground = $button.textcolor
        $WPFbtnTab1_04.Add_Click({btnTab1_04_Click})
    } 

    If ($buttonID -eq "05"){
        If ($LogDebugMode){write-Host "      Configuring  button: $buttonID"}
        $WPFbtnTab1_05.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab1_05.IsEnabled = $false} Else {$WPFbtnTab1_05.IsEnabled = $true}
        $WPFbtnTab1_05.Content = $button.Name
        $WPFbtnTab1_05.Background = $button.bgcolor
        $WPFbtnTab1_05.Foreground = $button.textcolor
        $WPFbtnTab1_05.Add_Click({btnTab1_05_Click})
    } 

    If ($buttonID -eq "06"){
        If ($LogDebugMode){write-Host "      Configuring  button: $buttonID"}
        $WPFbtnTab1_06.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab1_06.IsEnabled = $false} Else {$WPFbtnTab1_06.IsEnabled = $true}
        $WPFbtnTab1_06.Content = $button.Name
        $WPFbtnTab1_06.Background = $button.bgcolor
        $WPFbtnTab1_06.Foreground = $button.textcolor
        $WPFbtnTab1_06.Add_Click({btnTab1_06_Click})
    } 

    If ($buttonID -eq "07"){
        If ($LogDebugMode){write-Host "      Configuring  button: $buttonID"}
        $WPFbtnTab1_07.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab1_07.IsEnabled = $false} Else {$WPFbtnTab1_07.IsEnabled = $true}
        $WPFbtnTab1_07.Content = $button.Name
        $WPFbtnTab1_07.Background = $button.bgcolor
        $WPFbtnTab1_07.Foreground = $button.textcolor
        $WPFbtnTab1_07.Add_Click({btnTab1_07_Click})
    }

    If ($buttonID -eq "08"){
        If ($LogDebugMode){write-Host "      Configuring  button: $buttonID"}
        $WPFbtnTab1_08.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab1_08.IsEnabled = $false} Else {$WPFbtnTab1_08.IsEnabled = $true}
        $WPFbtnTab1_08.Content = $button.Name
        $WPFbtnTab1_08.Background = $button.bgcolor
        $WPFbtnTab1_08.Foreground = $button.textcolor
        $WPFbtnTab1_08.Add_Click({btnTab1_08_Click})
    } 

    If ($buttonID -eq "09"){
        If ($LogDebugMode){write-Host "      Configuring  button: $buttonID"}
        $WPFbtnTab1_09.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab1_09.IsEnabled = $false} Else {$WPFbtnTab1_09.IsEnabled = $true}
        $WPFbtnTab1_09.Content = $button.Name
        $WPFbtnTab1_09.Background = $button.bgcolor
        $WPFbtnTab1_09.Foreground = $button.textcolor
        $WPFbtnTab1_09.Add_Click({btnTab1_09_Click})
    }

    If ($buttonID -eq "10"){
        If ($LogDebugMode){write-Host "      Configuring  button: $buttonID"}
        $WPFbtnTab1_10.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab1_10.IsEnabled = $false} Else {$WPFbtnTab1_10.IsEnabled = $true}
        $WPFbtnTab1_10.Content = $button.Name
        $WPFbtnTab1_10.Background = $button.bgcolor
        $WPFbtnTab1_10.Foreground = $button.textcolor
        $WPFbtnTab1_10.Add_Click({btnTab1_10_Click})
    }

    If ($buttonID -eq "11"){
        If ($LogDebugMode){write-Host "      Configuring  button: $buttonID"}
        $WPFbtnTab1_11.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab1_11.IsEnabled = $false} Else {$WPFbtnTab1_11.IsEnabled = $true}
        $WPFbtnTab1_11.Content = $button.Name
        $WPFbtnTab1_11.Background = $button.bgcolor
        $WPFbtnTab1_11.Foreground = $button.textcolor
        $WPFbtnTab1_11.Add_Click({btnTab1_11_Click})
    }

    If ($buttonID -eq "12"){
        If ($LogDebugMode){write-Host "      Configuring  button: $buttonID"}
        $WPFbtnTab1_12.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab1_12.IsEnabled = $false} Else {$WPFbtnTab1_12.IsEnabled = $true}
        $WPFbtnTab1_12.Content = $button.Name
        $WPFbtnTab1_12.Background = $button.bgcolor
        $WPFbtnTab1_12.Foreground = $button.textcolor
        $WPFbtnTab1_12.Add_Click({btnTab1_12_Click})
    }

    If ($buttonID -eq "13"){
        If ($LogDebugMode){write-Host "      Configuring  button: $buttonID"}
        $WPFbtnTab1_13.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab1_13.IsEnabled = $false} Else {$WPFbtnTab1_13.IsEnabled = $true}
        $WPFbtnTab1_13.Content = $button.Name
        $WPFbtnTab1_13.Background = $button.bgcolor
        $WPFbtnTab1_13.Foreground = $button.textcolor
        $WPFbtnTab1_13.Add_Click({btnTab1_13_Click})
    }

    If ($buttonID -eq "14"){
        If ($LogDebugMode){write-Host "      Configuring  button: $buttonID"}
        $WPFbtnTab1_14.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab1_14.IsEnabled = $false} Else {$WPFbtnTab1_14.IsEnabled = $true}
        $WPFbtnTab1_14.Content = $button.Name
        $WPFbtnTab1_14.Background = $button.bgcolor
        $WPFbtnTab1_14.Foreground = $button.textcolor
        $WPFbtnTab1_14.Add_Click({btnTab1_14_Click})
    }

    If ($buttonID -eq "15"){
        If ($LogDebugMode){write-Host "      Configuring  button: $buttonID"}
        $WPFbtnTab1_15.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab1_15.IsEnabled = $false} Else {$WPFbtnTab1_15.IsEnabled = $true}
        $WPFbtnTab1_15.Content = $button.Name
        $WPFbtnTab1_15.Background = $button.bgcolor
        $WPFbtnTab1_15.Foreground = $button.textcolor
        $WPFbtnTab1_15.Add_Click({btnTab1_15_Click})
    }

    If ($buttonID -eq "16"){
        If ($LogDebugMode){write-Host "      Configuring  button: $buttonID"}
        $WPFbtnTab1_16.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab1_16.IsEnabled = $false} Else {$WPFbtnTab1_16.IsEnabled = $true}
        $WPFbtnTab1_16.Content = $button.Name
        $WPFbtnTab1_16.Background = $button.bgcolor
        $WPFbtnTab1_16.Foreground = $button.textcolor
        $WPFbtnTab1_16.Add_Click({btnTab1_16_Click})
    }

    If ($buttonID -eq "17"){
        If ($LogDebugMode){write-Host "      Configuring  button: $buttonID"}
        $WPFbtnTab1_17.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab1_17.IsEnabled = $false} Else {$WPFbtnTab1_17.IsEnabled = $true}
        $WPFbtnTab1_17.Content = $button.Name
        $WPFbtnTab1_17.Background = $button.bgcolor
        $WPFbtnTab1_17.Foreground = $button.textcolor
        $WPFbtnTab1_17.Add_Click({btnTab1_17_Click})
    }

    If ($buttonID -eq "18"){
        If ($LogDebugMode){write-Host "      Configuring  button: $buttonID"}
        $WPFbtnTab1_18.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab1_18.IsEnabled = $false} Else {$WPFbtnTab1_18.IsEnabled = $true}
        $WPFbtnTab1_18.Content = $button.Name
        $WPFbtnTab1_18.Background = $button.bgcolor
        $WPFbtnTab1_18.Foreground = $button.textcolor
        $WPFbtnTab1_18.Add_Click({btnTab1_18_Click})
    }

    If ($buttonID -eq "19"){
        If ($LogDebugMode){write-Host "      Configuring  button: $buttonID"}
        $WPFbtnTab1_19.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab1_19.IsEnabled = $false} Else {$WPFbtnTab1_19.IsEnabled = $true}
        $WPFbtnTab1_19.Content = $button.Name
        $WPFbtnTab1_19.Background = $button.bgcolor
        $WPFbtnTab1_19.Foreground = $button.textcolor
        $WPFbtnTab1_19.Add_Click({btnTab1_19_Click})
    }

    If ($buttonID -eq "20"){
        If ($LogDebugMode){write-Host "      Configuring  button: $buttonID"}
        $WPFbtnTab1_20.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab1_20.IsEnabled = $false} Else {$WPFbtnTab1_20.IsEnabled = $true}
        $WPFbtnTab1_20.Content = $button.Name
        $WPFbtnTab1_20.Background = $button.bgcolor
        $WPFbtnTab1_20.Foreground = $button.textcolor
        $WPFbtnTab1_20.Add_Click({btnTab1_20_Click})
    }

    If ($buttonID -eq "21"){
        If ($LogDebugMode){write-Host "      Configuring  button: $buttonID"}
        $WPFbtnTab1_21.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab1_21.IsEnabled = $false} Else {$WPFbtnTab1_21.IsEnabled = $true}
        $WPFbtnTab1_21.Content = $button.Name
        $WPFbtnTab1_21.Background = $button.bgcolor
        $WPFbtnTab1_21.Foreground = $button.textcolor
        $WPFbtnTab1_21.Add_Click({btnTab1_21_Click})
    }

    If ($buttonID -eq "22"){
        If ($LogDebugMode){write-Host "      Configuring  button: $buttonID"}
        $WPFbtnTab1_22.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab1_22.IsEnabled = $false} Else {$WPFbtnTab1_22.IsEnabled = $true}
        $WPFbtnTab1_22.Content = $button.Name
        $WPFbtnTab1_22.Background = $button.bgcolor
        $WPFbtnTab1_22.Foreground = $button.textcolor
        $WPFbtnTab1_22.Add_Click({btnTab1_22_Click})
    }

    If ($buttonID -eq "23"){
        If ($LogDebugMode){write-Host "      Configuring  button: $buttonID"}
        $WPFbtnTab1_23.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab1_23.IsEnabled = $false} Else {$WPFbtnTab1_23.IsEnabled = $true}
        $WPFbtnTab1_23.Content = $button.Name
        $WPFbtnTab1_23.Background = $button.bgcolor
        $WPFbtnTab1_23.Foreground = $button.textcolor
        $WPFbtnTab1_23.Add_Click({btnTab1_23_Click})
    }

    If ($buttonID -eq "24"){
        If ($LogDebugMode){write-Host "      Configuring  button: $buttonID"}
        $WPFbtnTab1_24.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab1_24.IsEnabled = $false} Else {$WPFbtnTab1_24.IsEnabled = $true}
        $WPFbtnTab1_24.Content = $button.Name
        $WPFbtnTab1_24.Background = $button.bgcolor
        $WPFbtnTab1_24.Foreground = $button.textcolor
        $WPFbtnTab1_24.Add_Click({btnTab1_24_Click})
    }

    If ($buttonID -eq "25"){
        If ($LogDebugMode){write-Host "      Configuring  button: $buttonID"}
        $WPFbtnTab1_25.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab1_25.IsEnabled = $false} Else {$WPFbtnTab1_25.IsEnabled = $true}
        $WPFbtnTab1_25.Content = $button.Name
        $WPFbtnTab1_25.Background = $button.bgcolor
        $WPFbtnTab1_25.Foreground = $button.textcolor
        $WPFbtnTab1_25.Add_Click({btnTab1_25_Click})
    }

    If ($buttonID -eq "26"){
        If ($LogDebugMode){write-Host "      Configuring  button: $buttonID"}
        $WPFbtnTab1_26.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab1_26.IsEnabled = $false} Else {$WPFbtnTab1_26.IsEnabled = $true}
        $WPFbtnTab1_26.Content = $button.Name
        $WPFbtnTab1_26.Background = $button.bgcolor
        $WPFbtnTab1_26.Foreground = $button.textcolor
        $WPFbtnTab1_26.Add_Click({btnTab1_26_Click})
    }

}