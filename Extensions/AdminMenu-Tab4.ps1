##*=============================================
##* LOAD TAB 2 FROM CONFIG
##*=============================================
$ConfigTab4 = $XmlConfigFile.app.tabAndButtons.tab[3]

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
function btnTab4_01_Click {
    
}

function btnTab4_02_Click {
    
}

function btnTab4_03_Click {
    
}

function btnTab4_04_Click {

}

function btnTab4_05_Click {

}

function btnTab4_06_Click {

}

# Set of 4 small buttons under left column
function btnTab4_07_Click {

}

function btnTab4_08_Click {

}


function btnTab4_09_Click {

}


function btnTab4_10_Click {

}


# Set of 4 large buttons under right column
function btnTab4_11_Click {

}

function btnTab4_12_Click {

}

function btnTab4_13_Click {

}

function btnTab4_14_Click {

}

# Set of 12 small buttons under right column
function btnTab4_15_Click {

}

function btnTab4_16_Click {

}

function btnTab4_17_Click {

}

function btnTab4_18_Click {

}

function btnTab4_19_Click {

}

function btnTab4_20_Click {

}

function btnTab4_21_Click {

}

function btnTab4_22_Click {

}

function btnTab4_23_Click {

}

function btnTab4_24_Click {

}

function btnTab4_25_Click {

}

function btnTab4_26_Click {

}


##*=============================================
##* TAB 1 OTHER FUNCTIONS
##*=============================================

$WPFtxtBoxRemote.Text = $env:COMPUTERNAME


##*=============================================
##* BUILD TAB 1 BUTTONS IF CONFIGURED
##*=============================================
$ConfigTab4_Name = $ConfigTab4.Name

$WPFTab4.Header = $ConfigTab4_Name
$WPFlblTab4Section1.Content = $ConfigTab4.section1Label
$WPFlblTab4Section2.Content = $ConfigTab4.section2Label

$ConfigTab4_btns = $ConfigTab4.button


Foreach ($button in $ConfigTab4_btns){
    
    [string]$buttonID = $button.id
    If ($LogDebugMode){Write-Host "Tab4: Found button: $buttonID"}

    If ($buttonID -eq "01"){
        If ($LogDebugMode){write-Host "      Configuring  button: $buttonID"}
        $WPFbtnTab4_01.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab4_01.IsEnabled = $false} Else {$WPFbtnTab4_01.IsEnabled = $true}
        $WPFbtnTab4_01.Content = $button.Name
        $WPFbtnTab4_01.Background = $button.bgcolor
        $WPFbtnTab4_01.Foreground = $button.textcolor
        $WPFbtnTab4_01.Add_Click({btnTab4_01_Click})
    } 

    If ($buttonID -eq "02"){
        If ($LogDebugMode){write-Host "      Configuring  button: $buttonID"}
        $WPFbtnTab4_02.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab4_02.IsEnabled = $false} Else {$WPFbtnTab4_02.IsEnabled = $true}
        $WPFbtnTab4_02.Content = $button.Name
        $WPFbtnTab4_02.Background = $button.bgcolor
        $WPFbtnTab4_02.Foreground = $button.textcolor
        $WPFbtnTab4_02.Add_Click({btnTab4_02_Click})
    }

    If ($buttonID -eq "03"){
        If ($LogDebugMode){write-Host "      Configuring  button: $buttonID"}
        $WPFbtnTab4_03.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab4_03.IsEnabled = $false} Else {$WPFbtnTab4_03.IsEnabled = $true}
        $WPFbtnTab4_03.Content = $button.Name
        $WPFbtnTab4_03.Background = $button.bgcolor
        $WPFbtnTab4_03.Foreground = $button.textcolor
        $WPFbtnTab4_03.Add_Click({btnTab4_03_Click})
    }

    If ($buttonID -eq "04"){
        If ($LogDebugMode){write-Host "      Configuring  button: $buttonID"}
        $WPFbtnTab4_04.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab4_04.IsEnabled = $false} Else {$WPFbtnTab4_04.IsEnabled = $true}
        $WPFbtnTab4_04.Content = $button.Name
        $WPFbtnTab4_04.Background = $button.bgcolor
        $WPFbtnTab4_04.Foreground = $button.textcolor
        $WPFbtnTab4_04.Add_Click({btnTab4_04_Click})
    } 

    If ($buttonID -eq "05"){
        If ($LogDebugMode){write-Host "      Configuring  button: $buttonID"}
        $WPFbtnTab4_05.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab4_05.IsEnabled = $false} Else {$WPFbtnTab4_05.IsEnabled = $true}
        $WPFbtnTab4_05.Content = $button.Name
        $WPFbtnTab4_05.Background = $button.bgcolor
        $WPFbtnTab4_05.Foreground = $button.textcolor
        $WPFbtnTab4_05.Add_Click({btnTab4_05_Click})
    } 

    If ($buttonID -eq "06"){
        If ($LogDebugMode){write-Host "      Configuring  button: $buttonID"}
        $WPFbtnTab4_06.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab4_06.IsEnabled = $false} Else {$WPFbtnTab4_06.IsEnabled = $true}
        $WPFbtnTab4_06.Content = $button.Name
        $WPFbtnTab4_06.Background = $button.bgcolor
        $WPFbtnTab4_06.Foreground = $button.textcolor
        $WPFbtnTab4_06.Add_Click({btnTab4_06_Click})
    } 

    If ($buttonID -eq "07"){
        If ($LogDebugMode){write-Host "      Configuring  button: $buttonID"}
        $WPFbtnTab4_07.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab4_07.IsEnabled = $false} Else {$WPFbtnTab4_07.IsEnabled = $true}
        $WPFbtnTab4_07.Content = $button.Name
        $WPFbtnTab4_07.Background = $button.bgcolor
        $WPFbtnTab4_07.Foreground = $button.textcolor
        $WPFbtnTab4_07.Add_Click({btnTab4_07_Click})
    }

    If ($buttonID -eq "08"){
        If ($LogDebugMode){write-Host "      Configuring  button: $buttonID"}
        $WPFbtnTab4_08.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab4_08.IsEnabled = $false} Else {$WPFbtnTab4_08.IsEnabled = $true}
        $WPFbtnTab4_08.Content = $button.Name
        $WPFbtnTab4_08.Background = $button.bgcolor
        $WPFbtnTab4_08.Foreground = $button.textcolor
        $WPFbtnTab4_08.Add_Click({btnTab4_08_Click})
    } 

    If ($buttonID -eq "09"){
        If ($LogDebugMode){write-Host "      Configuring  button: $buttonID"}
        $WPFbtnTab4_09.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab4_09.IsEnabled = $false} Else {$WPFbtnTab4_09.IsEnabled = $true}
        $WPFbtnTab4_09.Content = $button.Name
        $WPFbtnTab4_09.Background = $button.bgcolor
        $WPFbtnTab4_09.Foreground = $button.textcolor
        $WPFbtnTab4_09.Add_Click({btnTab4_09_Click})
    }

    If ($buttonID -eq "10"){
        If ($LogDebugMode){write-Host "      Configuring  button: $buttonID"}
        $WPFbtnTab4_10.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab4_10.IsEnabled = $false} Else {$WPFbtnTab4_10.IsEnabled = $true}
        $WPFbtnTab4_10.Content = $button.Name
        $WPFbtnTab4_10.Background = $button.bgcolor
        $WPFbtnTab4_10.Foreground = $button.textcolor
        $WPFbtnTab4_10.Add_Click({btnTab4_10_Click})
    }

    If ($buttonID -eq "11"){
        If ($LogDebugMode){write-Host "      Configuring  button: $buttonID"}
        $WPFbtnTab4_11.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab4_11.IsEnabled = $false} Else {$WPFbtnTab4_11.IsEnabled = $true}
        $WPFbtnTab4_11.Content = $button.Name
        $WPFbtnTab4_11.Background = $button.bgcolor
        $WPFbtnTab4_11.Foreground = $button.textcolor
        $WPFbtnTab4_11.Add_Click({btnTab4_11_Click})
    }

    If ($buttonID -eq "12"){
        If ($LogDebugMode){write-Host "      Configuring  button: $buttonID"}
        $WPFbtnTab4_12.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab4_12.IsEnabled = $false} Else {$WPFbtnTab4_12.IsEnabled = $true}
        $WPFbtnTab4_12.Content = $button.Name
        $WPFbtnTab4_12.Background = $button.bgcolor
        $WPFbtnTab4_12.Foreground = $button.textcolor
        $WPFbtnTab4_12.Add_Click({btnTab4_12_Click})
    }

    If ($buttonID -eq "13"){
        If ($LogDebugMode){write-Host "      Configuring  button: $buttonID"}
        $WPFbtnTab4_13.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab4_13.IsEnabled = $false} Else {$WPFbtnTab4_13.IsEnabled = $true}
        $WPFbtnTab4_13.Content = $button.Name
        $WPFbtnTab4_13.Background = $button.bgcolor
        $WPFbtnTab4_13.Foreground = $button.textcolor
        $WPFbtnTab4_13.Add_Click({btnTab4_13_Click})
    }

    If ($buttonID -eq "14"){
        If ($LogDebugMode){write-Host "      Configuring  button: $buttonID"}
        $WPFbtnTab4_14.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab4_14.IsEnabled = $false} Else {$WPFbtnTab4_14.IsEnabled = $true}
        $WPFbtnTab4_14.Content = $button.Name
        $WPFbtnTab4_14.Background = $button.bgcolor
        $WPFbtnTab4_14.Foreground = $button.textcolor
        $WPFbtnTab4_14.Add_Click({btnTab4_14_Click})
    }

    If ($buttonID -eq "15"){
        If ($LogDebugMode){write-Host "      Configuring  button: $buttonID"}
        $WPFbtnTab4_15.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab4_15.IsEnabled = $false} Else {$WPFbtnTab4_15.IsEnabled = $true}
        $WPFbtnTab4_15.Content = $button.Name
        $WPFbtnTab4_15.Background = $button.bgcolor
        $WPFbtnTab4_15.Foreground = $button.textcolor
        $WPFbtnTab4_15.Add_Click({btnTab4_15_Click})
    }

    If ($buttonID -eq "16"){
        If ($LogDebugMode){write-Host "      Configuring  button: $buttonID"}
        $WPFbtnTab4_16.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab4_16.IsEnabled = $false} Else {$WPFbtnTab4_16.IsEnabled = $true}
        $WPFbtnTab4_16.Content = $button.Name
        $WPFbtnTab4_16.Background = $button.bgcolor
        $WPFbtnTab4_16.Foreground = $button.textcolor
        $WPFbtnTab4_16.Add_Click({btnTab4_16_Click})
    }

    If ($buttonID -eq "17"){
        If ($LogDebugMode){write-Host "      Configuring  button: $buttonID"}
        $WPFbtnTab4_17.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab4_17.IsEnabled = $false} Else {$WPFbtnTab4_17.IsEnabled = $true}
        $WPFbtnTab4_17.Content = $button.Name
        $WPFbtnTab4_17.Background = $button.bgcolor
        $WPFbtnTab4_17.Foreground = $button.textcolor
        $WPFbtnTab4_17.Add_Click({btnTab4_17_Click})
    }

    If ($buttonID -eq "18"){
        If ($LogDebugMode){write-Host "      Configuring  button: $buttonID"}
        $WPFbtnTab4_18.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab4_18.IsEnabled = $false} Else {$WPFbtnTab4_18.IsEnabled = $true}
        $WPFbtnTab4_18.Content = $button.Name
        $WPFbtnTab4_18.Background = $button.bgcolor
        $WPFbtnTab4_18.Foreground = $button.textcolor
        $WPFbtnTab4_18.Add_Click({btnTab4_18_Click})
    }

    If ($buttonID -eq "19"){
        If ($LogDebugMode){write-Host "      Configuring  button: $buttonID"}
        $WPFbtnTab4_19.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab4_19.IsEnabled = $false} Else {$WPFbtnTab4_19.IsEnabled = $true}
        $WPFbtnTab4_19.Content = $button.Name
        $WPFbtnTab4_19.Background = $button.bgcolor
        $WPFbtnTab4_19.Foreground = $button.textcolor
        $WPFbtnTab4_19.Add_Click({btnTab4_19_Click})
    }

    If ($buttonID -eq "20"){
        If ($LogDebugMode){write-Host "      Configuring  button: $buttonID"}
        $WPFbtnTab4_20.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab4_20.IsEnabled = $false} Else {$WPFbtnTab4_20.IsEnabled = $true}
        $WPFbtnTab4_20.Content = $button.Name
        $WPFbtnTab4_20.Background = $button.bgcolor
        $WPFbtnTab4_20.Foreground = $button.textcolor
        $WPFbtnTab4_20.Add_Click({btnTab4_20_Click})
    }

    If ($buttonID -eq "21"){
        If ($LogDebugMode){write-Host "      Configuring  button: $buttonID"}
        $WPFbtnTab4_21.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab4_21.IsEnabled = $false} Else {$WPFbtnTab4_21.IsEnabled = $true}
        $WPFbtnTab4_21.Content = $button.Name
        $WPFbtnTab4_21.Background = $button.bgcolor
        $WPFbtnTab4_21.Foreground = $button.textcolor
        $WPFbtnTab4_21.Add_Click({btnTab4_21_Click})
    }

    If ($buttonID -eq "22"){
        If ($LogDebugMode){write-Host "      Configuring  button: $buttonID"}
        $WPFbtnTab4_22.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab4_22.IsEnabled = $false} Else {$WPFbtnTab4_22.IsEnabled = $true}
        $WPFbtnTab4_22.Content = $button.Name
        $WPFbtnTab4_22.Background = $button.bgcolor
        $WPFbtnTab4_22.Foreground = $button.textcolor
        $WPFbtnTab4_22.Add_Click({btnTab4_22_Click})
    }

    If ($buttonID -eq "23"){
        If ($LogDebugMode){write-Host "      Configuring  button: $buttonID"}
        $WPFbtnTab4_23.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab4_23.IsEnabled = $false} Else {$WPFbtnTab4_23.IsEnabled = $true}
        $WPFbtnTab4_23.Content = $button.Name
        $WPFbtnTab4_23.Background = $button.bgcolor
        $WPFbtnTab4_23.Foreground = $button.textcolor
        $WPFbtnTab4_23.Add_Click({btnTab4_23_Click})
    }

    If ($buttonID -eq "24"){
        If ($LogDebugMode){write-Host "      Configuring  button: $buttonID"}
        $WPFbtnTab4_24.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab4_24.IsEnabled = $false} Else {$WPFbtnTab4_24.IsEnabled = $true}
        $WPFbtnTab4_24.Content = $button.Name
        $WPFbtnTab4_24.Background = $button.bgcolor
        $WPFbtnTab4_24.Foreground = $button.textcolor
        $WPFbtnTab4_24.Add_Click({btnTab4_24_Click})
    }

    If ($buttonID -eq "25"){
        If ($LogDebugMode){write-Host "      Configuring  button: $buttonID"}
        $WPFbtnTab4_25.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab4_25.IsEnabled = $false} Else {$WPFbtnTab4_25.IsEnabled = $true}
        $WPFbtnTab4_25.Content = $button.Name
        $WPFbtnTab4_25.Background = $button.bgcolor
        $WPFbtnTab4_25.Foreground = $button.textcolor
        $WPFbtnTab4_25.Add_Click({btnTab4_25_Click})
    }

    If ($buttonID -eq "26"){
        If ($LogDebugMode){write-Host "      Configuring  button: $buttonID"}
        $WPFbtnTab4_26.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab4_26.IsEnabled = $false} Else {$WPFbtnTab4_26.IsEnabled = $true}
        $WPFbtnTab4_26.Content = $button.Name
        $WPFbtnTab4_26.Background = $button.bgcolor
        $WPFbtnTab4_26.Foreground = $button.textcolor
        $WPFbtnTab4_26.Add_Click({btnTab4_26_Click})
    }

}
If ($ConfigTab4.enable -eq "false"){$WPFTab4.Visibility = 'Hidden'} Else {$WPFTab4.Visibility = 'Visible'}