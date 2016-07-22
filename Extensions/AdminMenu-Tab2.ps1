##*=============================================
##* LOAD TAB 2 FROM CONFIG
##*=============================================
$ConfigTab2 = $XmlConfigFile.app.tabAndButtons.tab[1]

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
function btnTab2_01_Click {
    $ADMSC = "$env:windir\system32\dsa.msc"
    If (($XmlConfigFile.app.configs.checkRSAT -eq 'true') -and ($WPFlblRSATCheck.Content -eq 'Yes')){
        If ($WPFtxtDomain.Text){
            Start-ButtonProcess -Path "$ADMSC" -Parameters ("/domain:" + $WPFtxtBoxRemote.Text) -CustomRunMsg "Opening [$($WPFbtnTab2_01.Content)] for: $($WPFtxtDomain.Text)" -OutputTab Tab2 -WindowStyle Normal
        }
        Else{
            Start-ButtonProcess -Path "$ADMSC" -CustomRunMsg "Opening [$($WPFbtnTab2_01.Content)]" -OutputTab Tab2 -WindowStyle Normal
        }
    }
    Else{
        Write-OutputBox -OutputBoxMessage "Unable to open [$($WPFbtnTab2_01.Content)], RSAT is not installed" -Type "ERROR: " -Object Tab2
    }
}

function btnTab2_02_Click {
    $ADMSC = "$env:windir\system32\dssite.msc"
    If (($XmlConfigFile.app.configs.checkRSAT -eq 'true') -and ($WPFlblRSATCheck.Content -eq 'Yes')){
        If ($WPFtxtDomain.Text){
            Start-ButtonProcess -Path "$ADMSC" -Parameters ("/domain:" + $WPFtxtBoxRemote.Text) -CustomRunMsg "Opening [$($WPFbtnTab2_02.Content)] for: $($WPFtxtDomain.Text)" -OutputTab Tab2 -WindowStyle Normal
        }
        Else{
            Start-ButtonProcess -Path "$ADMSC" -CustomRunMsg "Opening [$($WPFbtnTab2_02.Content)]" -OutputTab Tab2 -WindowStyle Normal
        }
    }
    Else{
        Write-OutputBox -OutputBoxMessage "Unable to open [$($WPFbtnTab2_02.Content)], RSAT is not installed" -Type "ERROR: " -Object Tab2
    }
}

function btnTab2_03_Click {
    $ADMSC = "$env:windir\system32\gpmc.msc"
    If (($XmlConfigFile.app.configs.checkRSAT -eq 'true') -and ($WPFlblRSATCheck.Content -eq 'Yes')){
        If ($WPFtxtDomain.Text){
            Start-ButtonProcess -Path "$ADMSC" -Parameters ("/domain:" + $WPFtxtBoxRemote.Text) -CustomRunMsg "Opening [$($WPFbtnTab2_03.Content)] for: $($WPFtxtDomain.Text)" -OutputTab Tab2 -WindowStyle Normal
        }
        Else{
            Start-ButtonProcess -Path "$ADMSC" -CustomRunMsg "Opening [$($WPFbtnTab2_03.Content)]" -OutputTab Tab2 -WindowStyle Normal
        }
    }
    Else{
        Write-OutputBox -OutputBoxMessage "Unable to open [$($WPFbtnTab2_03.Content)], RSAT is not installed" -Type "ERROR: " -Object Tab2
    }
}

function btnTab2_04_Click {

}

function btnTab2_05_Click {

}

function btnTab2_06_Click {

}

# Set of 4 small buttons under left column
function btnTab2_07_Click {
    $ADMSC = "$env:windir\system32\dsac.exe"
    If (($XmlConfigFile.app.configs.checkRSAT -eq 'true') -and ($WPFlblRSATCheck.Content -eq 'Yes')){
        Start-ButtonProcess -Path "$ADMSC" -CustomRunMsg "Opening [$($WPFbtnTab2_07.Content)]" -OutputTab Tab2 -WindowStyle Normal
    }
    Else{
        Write-OutputBox -OutputBoxMessage "Unable to open [$($WPFbtnTab2_07.Content)], RSAT is not installed" -Type "ERROR: " -Object Tab2
    }
}

function btnTab2_08_Click {
    $ADMSC = "$env:windir\system32\dnsmgmt.msc"
    If (($XmlConfigFile.app.configs.checkRSAT -eq 'true') -and ($WPFlblRSATCheck.Content -eq 'Yes')){
        Start-ButtonProcess -Path "$ADMSC" -CustomRunMsg "Opening [$($WPFbtnTab2_08.Content)]" -OutputTab Tab2 -WindowStyle Normal
    }
    Else{
        Write-OutputBox -OutputBoxMessage "Unable to open [$($WPFbtnTab2_08.Content)], RSAT is not installed" -Type "ERROR: " -Object Tab2
    }
}


function btnTab2_09_Click {
    $ADMSC = "$env:windir\system32\dhcpmgmt.msc"
    If (($XmlConfigFile.app.configs.checkRSAT -eq 'true') -and ($WPFlblRSATCheck.Content -eq 'Yes')){
        Start-ButtonProcess -Path "$ADMSC" -CustomRunMsg "Opening [$($WPFbtnTab2_09.Content)]" -OutputTab Tab2 -WindowStyle Normal
    }
    Else{
        Write-OutputBox -OutputBoxMessage "Unable to open [$($WPFbtnTab2_09.Content)], RSAT is not installed" -Type "ERROR: " -Object Tab2
    }
}


function btnTab2_10_Click {

}


# Set of 4 large buttons under right columnl
function btnTab2_11_Click {

}

function btnTab2_12_Click {

}

function btnTab2_13_Click {

}

function btnTab2_14_Click {

}

# Set of 12 small buttons under right column
function btnTab2_15_Click {

}

function btnTab2_16_Click {

}

function btnTab2_17_Click {

}

function btnTab2_18_Click {

}

function btnTab2_19_Click {

}

function btnTab2_20_Click {

}

function btnTab2_21_Click {

}

function btnTab2_22_Click {

}

function btnTab2_23_Click {

}

function btnTab2_24_Click {

}

function btnTab2_25_Click {

}

function btnTab2_26_Click {

}


##*=============================================
##* TAB 1 OTHER FUNCTIONS
##*=============================================

If($IsMachinePartOfDomain){$WPFtxtDomain.Text = $envMachineADDomain}


##*=============================================
##* BUILD TAB 1 BUTTONS IF CONFIGURED
##*=============================================
$ConfigTab2_Name = $ConfigTab2.Name

$WPFTab2.Header = $ConfigTab2_Name
$WPFlblTab2Section1.Content = $ConfigTab2.section1Label
$WPFlblTab2Section2.Content = $ConfigTab2.section2Label

$ConfigTab2_btns = $ConfigTab2.button


Foreach ($button in $ConfigTab2_btns){
    
    [string]$buttonID = $button.id
    If ($LogDebugMode){Write-Host "Tab2: Found button: $buttonID"}

    If ($buttonID -eq "01"){
        If ($LogDebugMode){write-Host "      Configuring  button: $buttonID"}
        $WPFbtnTab2_01.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab2_01.IsEnabled = $false} Else {$WPFbtnTab2_01.IsEnabled = $true}
        $WPFbtnTab2_01.Content = $button.Name
        $WPFbtnTab2_01.Background = $button.bgcolor
        $WPFbtnTab2_01.Foreground = $button.textcolor
        $WPFbtnTab2_01.Add_Click({btnTab2_01_Click})
    } 

    If ($buttonID -eq "02"){
        If ($LogDebugMode){write-Host "      Configuring  button: $buttonID"}
        $WPFbtnTab2_02.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab2_02.IsEnabled = $false} Else {$WPFbtnTab2_02.IsEnabled = $true}
        $WPFbtnTab2_02.Content = $button.Name
        $WPFbtnTab2_02.Background = $button.bgcolor
        $WPFbtnTab2_02.Foreground = $button.textcolor
        $WPFbtnTab2_02.Add_Click({btnTab2_02_Click})
    }

    If ($buttonID -eq "03"){
        If ($LogDebugMode){write-Host "      Configuring  button: $buttonID"}
        $WPFbtnTab2_03.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab2_03.IsEnabled = $false} Else {$WPFbtnTab2_03.IsEnabled = $true}
        $WPFbtnTab2_03.Content = $button.Name
        $WPFbtnTab2_03.Background = $button.bgcolor
        $WPFbtnTab2_03.Foreground = $button.textcolor
        $WPFbtnTab2_03.Add_Click({btnTab2_03_Click})
    }

    If ($buttonID -eq "04"){
        If ($LogDebugMode){write-Host "      Configuring  button: $buttonID"}
        $WPFbtnTab2_04.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab2_04.IsEnabled = $false} Else {$WPFbtnTab2_04.IsEnabled = $true}
        $WPFbtnTab2_04.Content = $button.Name
        $WPFbtnTab2_04.Background = $button.bgcolor
        $WPFbtnTab2_04.Foreground = $button.textcolor
        $WPFbtnTab2_04.Add_Click({btnTab2_04_Click})
    } 

    If ($buttonID -eq "05"){
        If ($LogDebugMode){write-Host "      Configuring  button: $buttonID"}
        $WPFbtnTab2_05.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab2_05.IsEnabled = $false} Else {$WPFbtnTab2_05.IsEnabled = $true}
        $WPFbtnTab2_05.Content = $button.Name
        $WPFbtnTab2_05.Background = $button.bgcolor
        $WPFbtnTab2_05.Foreground = $button.textcolor
        $WPFbtnTab2_05.Add_Click({btnTab2_05_Click})
    } 

    If ($buttonID -eq "06"){
        If ($LogDebugMode){write-Host "      Configuring  button: $buttonID"}
        $WPFbtnTab2_06.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab2_06.IsEnabled = $false} Else {$WPFbtnTab2_06.IsEnabled = $true}
        $WPFbtnTab2_06.Content = $button.Name
        $WPFbtnTab2_06.Background = $button.bgcolor
        $WPFbtnTab2_06.Foreground = $button.textcolor
        $WPFbtnTab2_06.Add_Click({btnTab2_06_Click})
    } 

    If ($buttonID -eq "07"){
        If ($LogDebugMode){write-Host "      Configuring  button: $buttonID"}
        $WPFbtnTab2_07.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab2_07.IsEnabled = $false} Else {$WPFbtnTab2_07.IsEnabled = $true}
        $WPFbtnTab2_07.Content = $button.Name
        $WPFbtnTab2_07.Background = $button.bgcolor
        $WPFbtnTab2_07.Foreground = $button.textcolor
        $WPFbtnTab2_07.Add_Click({btnTab2_07_Click})
    }

    If ($buttonID -eq "08"){
        If ($LogDebugMode){write-Host "      Configuring  button: $buttonID"}
        $WPFbtnTab2_08.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab2_08.IsEnabled = $false} Else {$WPFbtnTab2_08.IsEnabled = $true}
        $WPFbtnTab2_08.Content = $button.Name
        $WPFbtnTab2_08.Background = $button.bgcolor
        $WPFbtnTab2_08.Foreground = $button.textcolor
        $WPFbtnTab2_08.Add_Click({btnTab2_08_Click})
    } 

    If ($buttonID -eq "09"){
        If ($LogDebugMode){write-Host "      Configuring  button: $buttonID"}
        $WPFbtnTab2_09.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab2_09.IsEnabled = $false} Else {$WPFbtnTab2_09.IsEnabled = $true}
        $WPFbtnTab2_09.Content = $button.Name
        $WPFbtnTab2_09.Background = $button.bgcolor
        $WPFbtnTab2_09.Foreground = $button.textcolor
        $WPFbtnTab2_09.Add_Click({btnTab2_09_Click})
    }

    If ($buttonID -eq "10"){
        If ($LogDebugMode){write-Host "      Configuring  button: $buttonID"}
        $WPFbtnTab2_10.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab2_10.IsEnabled = $false} Else {$WPFbtnTab2_10.IsEnabled = $true}
        $WPFbtnTab2_10.Content = $button.Name
        $WPFbtnTab2_10.Background = $button.bgcolor
        $WPFbtnTab2_10.Foreground = $button.textcolor
        $WPFbtnTab2_10.Add_Click({btnTab2_10_Click})
    }

    If ($buttonID -eq "11"){
        If ($LogDebugMode){write-Host "      Configuring  button: $buttonID"}
        $WPFbtnTab2_11.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab2_11.IsEnabled = $false} Else {$WPFbtnTab2_11.IsEnabled = $true}
        $WPFbtnTab2_11.Content = $button.Name
        $WPFbtnTab2_11.Background = $button.bgcolor
        $WPFbtnTab2_11.Foreground = $button.textcolor
        $WPFbtnTab2_11.Add_Click({btnTab2_11_Click})
    }

    If ($buttonID -eq "12"){
        If ($LogDebugMode){write-Host "      Configuring  button: $buttonID"}
        $WPFbtnTab2_12.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab2_12.IsEnabled = $false} Else {$WPFbtnTab2_12.IsEnabled = $true}
        $WPFbtnTab2_12.Content = $button.Name
        $WPFbtnTab2_12.Background = $button.bgcolor
        $WPFbtnTab2_12.Foreground = $button.textcolor
        $WPFbtnTab2_12.Add_Click({btnTab2_12_Click})
    }

    If ($buttonID -eq "13"){
        If ($LogDebugMode){write-Host "      Configuring  button: $buttonID"}
        $WPFbtnTab2_13.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab2_13.IsEnabled = $false} Else {$WPFbtnTab2_13.IsEnabled = $true}
        $WPFbtnTab2_13.Content = $button.Name
        $WPFbtnTab2_13.Background = $button.bgcolor
        $WPFbtnTab2_13.Foreground = $button.textcolor
        $WPFbtnTab2_13.Add_Click({btnTab2_13_Click})
    }

    If ($buttonID -eq "14"){
        If ($LogDebugMode){write-Host "      Configuring  button: $buttonID"}
        $WPFbtnTab2_14.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab2_14.IsEnabled = $false} Else {$WPFbtnTab2_14.IsEnabled = $true}
        $WPFbtnTab2_14.Content = $button.Name
        $WPFbtnTab2_14.Background = $button.bgcolor
        $WPFbtnTab2_14.Foreground = $button.textcolor
        $WPFbtnTab2_14.Add_Click({btnTab2_14_Click})
    }

    If ($buttonID -eq "15"){
        If ($LogDebugMode){write-Host "      Configuring  button: $buttonID"}
        $WPFbtnTab2_15.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab2_15.IsEnabled = $false} Else {$WPFbtnTab2_15.IsEnabled = $true}
        $WPFbtnTab2_15.Content = $button.Name
        $WPFbtnTab2_15.Background = $button.bgcolor
        $WPFbtnTab2_15.Foreground = $button.textcolor
        $WPFbtnTab2_15.Add_Click({btnTab2_15_Click})
    }

    If ($buttonID -eq "16"){
        If ($LogDebugMode){write-Host "      Configuring  button: $buttonID"}
        $WPFbtnTab2_16.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab2_16.IsEnabled = $false} Else {$WPFbtnTab2_16.IsEnabled = $true}
        $WPFbtnTab2_16.Content = $button.Name
        $WPFbtnTab2_16.Background = $button.bgcolor
        $WPFbtnTab2_16.Foreground = $button.textcolor
        $WPFbtnTab2_16.Add_Click({btnTab2_16_Click})
    }

    If ($buttonID -eq "17"){
        If ($LogDebugMode){write-Host "      Configuring  button: $buttonID"}
        $WPFbtnTab2_17.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab2_17.IsEnabled = $false} Else {$WPFbtnTab2_17.IsEnabled = $true}
        $WPFbtnTab2_17.Content = $button.Name
        $WPFbtnTab2_17.Background = $button.bgcolor
        $WPFbtnTab2_17.Foreground = $button.textcolor
        $WPFbtnTab2_17.Add_Click({btnTab2_17_Click})
    }

    If ($buttonID -eq "18"){
        If ($LogDebugMode){write-Host "      Configuring  button: $buttonID"}
        $WPFbtnTab2_18.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab2_18.IsEnabled = $false} Else {$WPFbtnTab2_18.IsEnabled = $true}
        $WPFbtnTab2_18.Content = $button.Name
        $WPFbtnTab2_18.Background = $button.bgcolor
        $WPFbtnTab2_18.Foreground = $button.textcolor
        $WPFbtnTab2_18.Add_Click({btnTab2_18_Click})
    }

    If ($buttonID -eq "19"){
        If ($LogDebugMode){write-Host "      Configuring  button: $buttonID"}
        $WPFbtnTab2_19.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab2_19.IsEnabled = $false} Else {$WPFbtnTab2_19.IsEnabled = $true}
        $WPFbtnTab2_19.Content = $button.Name
        $WPFbtnTab2_19.Background = $button.bgcolor
        $WPFbtnTab2_19.Foreground = $button.textcolor
        $WPFbtnTab2_19.Add_Click({btnTab2_19_Click})
    }

    If ($buttonID -eq "20"){
        If ($LogDebugMode){write-Host "      Configuring  button: $buttonID"}
        $WPFbtnTab2_20.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab2_20.IsEnabled = $false} Else {$WPFbtnTab2_20.IsEnabled = $true}
        $WPFbtnTab2_20.Content = $button.Name
        $WPFbtnTab2_20.Background = $button.bgcolor
        $WPFbtnTab2_20.Foreground = $button.textcolor
        $WPFbtnTab2_20.Add_Click({btnTab2_20_Click})
    }

    If ($buttonID -eq "21"){
        If ($LogDebugMode){write-Host "      Configuring  button: $buttonID"}
        $WPFbtnTab2_21.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab2_21.IsEnabled = $false} Else {$WPFbtnTab2_21.IsEnabled = $true}
        $WPFbtnTab2_21.Content = $button.Name
        $WPFbtnTab2_21.Background = $button.bgcolor
        $WPFbtnTab2_21.Foreground = $button.textcolor
        $WPFbtnTab2_21.Add_Click({btnTab2_21_Click})
    }

    If ($buttonID -eq "22"){
        If ($LogDebugMode){write-Host "      Configuring  button: $buttonID"}
        $WPFbtnTab2_22.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab2_22.IsEnabled = $false} Else {$WPFbtnTab2_22.IsEnabled = $true}
        $WPFbtnTab2_22.Content = $button.Name
        $WPFbtnTab2_22.Background = $button.bgcolor
        $WPFbtnTab2_22.Foreground = $button.textcolor
        $WPFbtnTab2_22.Add_Click({btnTab2_22_Click})
    }

    If ($buttonID -eq "23"){
        If ($LogDebugMode){write-Host "      Configuring  button: $buttonID"}
        $WPFbtnTab2_23.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab2_23.IsEnabled = $false} Else {$WPFbtnTab2_23.IsEnabled = $true}
        $WPFbtnTab2_23.Content = $button.Name
        $WPFbtnTab2_23.Background = $button.bgcolor
        $WPFbtnTab2_23.Foreground = $button.textcolor
        $WPFbtnTab2_23.Add_Click({btnTab2_23_Click})
    }

    If ($buttonID -eq "24"){
        If ($LogDebugMode){write-Host "      Configuring  button: $buttonID"}
        $WPFbtnTab2_24.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab2_24.IsEnabled = $false} Else {$WPFbtnTab2_24.IsEnabled = $true}
        $WPFbtnTab2_24.Content = $button.Name
        $WPFbtnTab2_24.Background = $button.bgcolor
        $WPFbtnTab2_24.Foreground = $button.textcolor
        $WPFbtnTab2_24.Add_Click({btnTab2_24_Click})
    }

    If ($buttonID -eq "25"){
        If ($LogDebugMode){write-Host "      Configuring  button: $buttonID"}
        $WPFbtnTab2_25.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab2_25.IsEnabled = $false} Else {$WPFbtnTab2_25.IsEnabled = $true}
        $WPFbtnTab2_25.Content = $button.Name
        $WPFbtnTab2_25.Background = $button.bgcolor
        $WPFbtnTab2_25.Foreground = $button.textcolor
        $WPFbtnTab2_25.Add_Click({btnTab2_25_Click})
    }

    If ($buttonID -eq "26"){
        If ($LogDebugMode){write-Host "      Configuring  button: $buttonID"}
        $WPFbtnTab2_26.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab2_26.IsEnabled = $false} Else {$WPFbtnTab2_26.IsEnabled = $true}
        $WPFbtnTab2_26.Content = $button.Name
        $WPFbtnTab2_26.Background = $button.bgcolor
        $WPFbtnTab2_26.Foreground = $button.textcolor
        $WPFbtnTab2_26.Add_Click({btnTab2_26_Click})
    }

}
If ($ConfigTab2.enable -eq "false"){$WPFtab2.Visibility = 'Hidden'} Else {$WPFtab2.Visibility = 'Visible'}