##*=============================================
##* LOAD TAB 2 FROM CONFIG
##*=============================================
$ConfigTab5 = $XmlConfigFile.app.tabAndButtons.tab[4]

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
function btnTab5_01_Click {
    
}

function btnTab5_02_Click {
    
}

function btnTab5_03_Click {
    
}

function btnTab5_04_Click {

}

function btnTab5_05_Click {

}

function btnTab5_06_Click {

}

# Set of 4 small buttons under left column
function btnTab5_07_Click {

}

function btnTab5_08_Click {

}


function btnTab5_09_Click {

}


function btnTab5_10_Click {

}


# Set of 4 large buttons under right column
function btnTab5_11_Click {

}

function btnTab5_12_Click {

}

function btnTab5_13_Click {

}

function btnTab5_14_Click {

}

# Set of 12 small buttons under right column
function btnTab5_15_Click {

}

function btnTab5_16_Click {

}

function btnTab5_17_Click {

}

function btnTab5_18_Click {

}

function btnTab5_19_Click {

}

function btnTab5_20_Click {

}

function btnTab5_21_Click {

}

function btnTab5_22_Click {

}

function btnTab5_23_Click {

}

function btnTab5_24_Click {

}

function btnTab5_25_Click {

}

function btnTab5_26_Click {

}


##*=============================================
##* TAB 1 OTHER FUNCTIONS
##*=============================================

$WPFtxtBoxRemote.Text = $env:COMPUTERNAME


##*=============================================
##* BUILD TAB 1 BUTTONS IF CONFIGURED
##*=============================================
$ConfigTab5_Name = $ConfigTab5.Name

$WPFTab5.Header = $ConfigTab5_Name
$WPFlblTab5Section1.Content = $ConfigTab5.section1Label
$WPFlblTab5Section2.Content = $ConfigTab5.section2Label

$ConfigTab5_btns = $ConfigTab5.button


Foreach ($button in $ConfigTab5_btns){
    
    [string]$buttonID = $button.id
    If ($LogDebugMode){Write-Host "Tab5: Found button: $buttonID"}

    If ($buttonID -eq "01"){
        If ($LogDebugMode){write-Host "      Configuring  button: $buttonID"}
        $WPFbtnTab5_01.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab5_01.IsEnabled = $false} Else {$WPFbtnTab5_01.IsEnabled = $true}
        $WPFbtnTab5_01.Content = $button.Name
        $WPFbtnTab5_01.Background = $button.bgcolor
        $WPFbtnTab5_01.Foreground = $button.textcolor
        $WPFbtnTab5_01.Add_Click({btnTab5_01_Click})
    } 

    If ($buttonID -eq "02"){
        If ($LogDebugMode){write-Host "      Configuring  button: $buttonID"}
        $WPFbtnTab5_02.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab5_02.IsEnabled = $false} Else {$WPFbtnTab5_02.IsEnabled = $true}
        $WPFbtnTab5_02.Content = $button.Name
        $WPFbtnTab5_02.Background = $button.bgcolor
        $WPFbtnTab5_02.Foreground = $button.textcolor
        $WPFbtnTab5_02.Add_Click({btnTab5_02_Click})
    }

    If ($buttonID -eq "03"){
        If ($LogDebugMode){write-Host "      Configuring  button: $buttonID"}
        $WPFbtnTab5_03.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab5_03.IsEnabled = $false} Else {$WPFbtnTab5_03.IsEnabled = $true}
        $WPFbtnTab5_03.Content = $button.Name
        $WPFbtnTab5_03.Background = $button.bgcolor
        $WPFbtnTab5_03.Foreground = $button.textcolor
        $WPFbtnTab5_03.Add_Click({btnTab5_03_Click})
    }

    If ($buttonID -eq "04"){
        If ($LogDebugMode){write-Host "      Configuring  button: $buttonID"}
        $WPFbtnTab5_04.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab5_04.IsEnabled = $false} Else {$WPFbtnTab5_04.IsEnabled = $true}
        $WPFbtnTab5_04.Content = $button.Name
        $WPFbtnTab5_04.Background = $button.bgcolor
        $WPFbtnTab5_04.Foreground = $button.textcolor
        $WPFbtnTab5_04.Add_Click({btnTab5_04_Click})
    } 

    If ($buttonID -eq "05"){
        If ($LogDebugMode){write-Host "      Configuring  button: $buttonID"}
        $WPFbtnTab5_05.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab5_05.IsEnabled = $false} Else {$WPFbtnTab5_05.IsEnabled = $true}
        $WPFbtnTab5_05.Content = $button.Name
        $WPFbtnTab5_05.Background = $button.bgcolor
        $WPFbtnTab5_05.Foreground = $button.textcolor
        $WPFbtnTab5_05.Add_Click({btnTab5_05_Click})
    } 

    If ($buttonID -eq "06"){
        If ($LogDebugMode){write-Host "      Configuring  button: $buttonID"}
        $WPFbtnTab5_06.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab5_06.IsEnabled = $false} Else {$WPFbtnTab5_06.IsEnabled = $true}
        $WPFbtnTab5_06.Content = $button.Name
        $WPFbtnTab5_06.Background = $button.bgcolor
        $WPFbtnTab5_06.Foreground = $button.textcolor
        $WPFbtnTab5_06.Add_Click({btnTab5_06_Click})
    } 

    If ($buttonID -eq "07"){
        If ($LogDebugMode){write-Host "      Configuring  button: $buttonID"}
        $WPFbtnTab5_07.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab5_07.IsEnabled = $false} Else {$WPFbtnTab5_07.IsEnabled = $true}
        $WPFbtnTab5_07.Content = $button.Name
        $WPFbtnTab5_07.Background = $button.bgcolor
        $WPFbtnTab5_07.Foreground = $button.textcolor
        $WPFbtnTab5_07.Add_Click({btnTab5_07_Click})
    }

    If ($buttonID -eq "08"){
        If ($LogDebugMode){write-Host "      Configuring  button: $buttonID"}
        $WPFbtnTab5_08.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab5_08.IsEnabled = $false} Else {$WPFbtnTab5_08.IsEnabled = $true}
        $WPFbtnTab5_08.Content = $button.Name
        $WPFbtnTab5_08.Background = $button.bgcolor
        $WPFbtnTab5_08.Foreground = $button.textcolor
        $WPFbtnTab5_08.Add_Click({btnTab5_08_Click})
    } 

    If ($buttonID -eq "09"){
        If ($LogDebugMode){write-Host "      Configuring  button: $buttonID"}
        $WPFbtnTab5_09.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab5_09.IsEnabled = $false} Else {$WPFbtnTab5_09.IsEnabled = $true}
        $WPFbtnTab5_09.Content = $button.Name
        $WPFbtnTab5_09.Background = $button.bgcolor
        $WPFbtnTab5_09.Foreground = $button.textcolor
        $WPFbtnTab5_09.Add_Click({btnTab5_09_Click})
    }

    If ($buttonID -eq "10"){
        If ($LogDebugMode){write-Host "      Configuring  button: $buttonID"}
        $WPFbtnTab5_10.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab5_10.IsEnabled = $false} Else {$WPFbtnTab5_10.IsEnabled = $true}
        $WPFbtnTab5_10.Content = $button.Name
        $WPFbtnTab5_10.Background = $button.bgcolor
        $WPFbtnTab5_10.Foreground = $button.textcolor
        $WPFbtnTab5_10.Add_Click({btnTab5_10_Click})
    }

    If ($buttonID -eq "11"){
        If ($LogDebugMode){write-Host "      Configuring  button: $buttonID"}
        $WPFbtnTab5_11.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab5_11.IsEnabled = $false} Else {$WPFbtnTab5_11.IsEnabled = $true}
        $WPFbtnTab5_11.Content = $button.Name
        $WPFbtnTab5_11.Background = $button.bgcolor
        $WPFbtnTab5_11.Foreground = $button.textcolor
        $WPFbtnTab5_11.Add_Click({btnTab5_11_Click})
    }

    If ($buttonID -eq "12"){
        If ($LogDebugMode){write-Host "      Configuring  button: $buttonID"}
        $WPFbtnTab5_12.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab5_12.IsEnabled = $false} Else {$WPFbtnTab5_12.IsEnabled = $true}
        $WPFbtnTab5_12.Content = $button.Name
        $WPFbtnTab5_12.Background = $button.bgcolor
        $WPFbtnTab5_12.Foreground = $button.textcolor
        $WPFbtnTab5_12.Add_Click({btnTab5_12_Click})
    }

    If ($buttonID -eq "13"){
        If ($LogDebugMode){write-Host "      Configuring  button: $buttonID"}
        $WPFbtnTab5_13.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab5_13.IsEnabled = $false} Else {$WPFbtnTab5_13.IsEnabled = $true}
        $WPFbtnTab5_13.Content = $button.Name
        $WPFbtnTab5_13.Background = $button.bgcolor
        $WPFbtnTab5_13.Foreground = $button.textcolor
        $WPFbtnTab5_13.Add_Click({btnTab5_13_Click})
    }

    If ($buttonID -eq "14"){
        If ($LogDebugMode){write-Host "      Configuring  button: $buttonID"}
        $WPFbtnTab5_14.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab5_14.IsEnabled = $false} Else {$WPFbtnTab5_14.IsEnabled = $true}
        $WPFbtnTab5_14.Content = $button.Name
        $WPFbtnTab5_14.Background = $button.bgcolor
        $WPFbtnTab5_14.Foreground = $button.textcolor
        $WPFbtnTab5_14.Add_Click({btnTab5_14_Click})
    }

    If ($buttonID -eq "15"){
        If ($LogDebugMode){write-Host "      Configuring  button: $buttonID"}
        $WPFbtnTab5_15.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab5_15.IsEnabled = $false} Else {$WPFbtnTab5_15.IsEnabled = $true}
        $WPFbtnTab5_15.Content = $button.Name
        $WPFbtnTab5_15.Background = $button.bgcolor
        $WPFbtnTab5_15.Foreground = $button.textcolor
        $WPFbtnTab5_15.Add_Click({btnTab5_15_Click})
    }

    If ($buttonID -eq "16"){
        If ($LogDebugMode){write-Host "      Configuring  button: $buttonID"}
        $WPFbtnTab5_16.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab5_16.IsEnabled = $false} Else {$WPFbtnTab5_16.IsEnabled = $true}
        $WPFbtnTab5_16.Content = $button.Name
        $WPFbtnTab5_16.Background = $button.bgcolor
        $WPFbtnTab5_16.Foreground = $button.textcolor
        $WPFbtnTab5_16.Add_Click({btnTab5_16_Click})
    }

    If ($buttonID -eq "17"){
        If ($LogDebugMode){write-Host "      Configuring  button: $buttonID"}
        $WPFbtnTab5_17.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab5_17.IsEnabled = $false} Else {$WPFbtnTab5_17.IsEnabled = $true}
        $WPFbtnTab5_17.Content = $button.Name
        $WPFbtnTab5_17.Background = $button.bgcolor
        $WPFbtnTab5_17.Foreground = $button.textcolor
        $WPFbtnTab5_17.Add_Click({btnTab5_17_Click})
    }

    If ($buttonID -eq "18"){
        If ($LogDebugMode){write-Host "      Configuring  button: $buttonID"}
        $WPFbtnTab5_18.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab5_18.IsEnabled = $false} Else {$WPFbtnTab5_18.IsEnabled = $true}
        $WPFbtnTab5_18.Content = $button.Name
        $WPFbtnTab5_18.Background = $button.bgcolor
        $WPFbtnTab5_18.Foreground = $button.textcolor
        $WPFbtnTab5_18.Add_Click({btnTab5_18_Click})
    }

    If ($buttonID -eq "19"){
        If ($LogDebugMode){write-Host "      Configuring  button: $buttonID"}
        $WPFbtnTab5_19.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab5_19.IsEnabled = $false} Else {$WPFbtnTab5_19.IsEnabled = $true}
        $WPFbtnTab5_19.Content = $button.Name
        $WPFbtnTab5_19.Background = $button.bgcolor
        $WPFbtnTab5_19.Foreground = $button.textcolor
        $WPFbtnTab5_19.Add_Click({btnTab5_19_Click})
    }

    If ($buttonID -eq "20"){
        If ($LogDebugMode){write-Host "      Configuring  button: $buttonID"}
        $WPFbtnTab5_20.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab5_20.IsEnabled = $false} Else {$WPFbtnTab5_20.IsEnabled = $true}
        $WPFbtnTab5_20.Content = $button.Name
        $WPFbtnTab5_20.Background = $button.bgcolor
        $WPFbtnTab5_20.Foreground = $button.textcolor
        $WPFbtnTab5_20.Add_Click({btnTab5_20_Click})
    }

    If ($buttonID -eq "21"){
        If ($LogDebugMode){write-Host "      Configuring  button: $buttonID"}
        $WPFbtnTab5_21.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab5_21.IsEnabled = $false} Else {$WPFbtnTab5_21.IsEnabled = $true}
        $WPFbtnTab5_21.Content = $button.Name
        $WPFbtnTab5_21.Background = $button.bgcolor
        $WPFbtnTab5_21.Foreground = $button.textcolor
        $WPFbtnTab5_21.Add_Click({btnTab5_21_Click})
    }

    If ($buttonID -eq "22"){
        If ($LogDebugMode){write-Host "      Configuring  button: $buttonID"}
        $WPFbtnTab5_22.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab5_22.IsEnabled = $false} Else {$WPFbtnTab5_22.IsEnabled = $true}
        $WPFbtnTab5_22.Content = $button.Name
        $WPFbtnTab5_22.Background = $button.bgcolor
        $WPFbtnTab5_22.Foreground = $button.textcolor
        $WPFbtnTab5_22.Add_Click({btnTab5_22_Click})
    }

    If ($buttonID -eq "23"){
        If ($LogDebugMode){write-Host "      Configuring  button: $buttonID"}
        $WPFbtnTab5_23.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab5_23.IsEnabled = $false} Else {$WPFbtnTab5_23.IsEnabled = $true}
        $WPFbtnTab5_23.Content = $button.Name
        $WPFbtnTab5_23.Background = $button.bgcolor
        $WPFbtnTab5_23.Foreground = $button.textcolor
        $WPFbtnTab5_23.Add_Click({btnTab5_23_Click})
    }

    If ($buttonID -eq "24"){
        If ($LogDebugMode){write-Host "      Configuring  button: $buttonID"}
        $WPFbtnTab5_24.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab5_24.IsEnabled = $false} Else {$WPFbtnTab5_24.IsEnabled = $true}
        $WPFbtnTab5_24.Content = $button.Name
        $WPFbtnTab5_24.Background = $button.bgcolor
        $WPFbtnTab5_24.Foreground = $button.textcolor
        $WPFbtnTab5_24.Add_Click({btnTab5_24_Click})
    }

    If ($buttonID -eq "25"){
        If ($LogDebugMode){write-Host "      Configuring  button: $buttonID"}
        $WPFbtnTab5_25.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab5_25.IsEnabled = $false} Else {$WPFbtnTab5_25.IsEnabled = $true}
        $WPFbtnTab5_25.Content = $button.Name
        $WPFbtnTab5_25.Background = $button.bgcolor
        $WPFbtnTab5_25.Foreground = $button.textcolor
        $WPFbtnTab5_25.Add_Click({btnTab5_25_Click})
    }

    If ($buttonID -eq "26"){
        If ($LogDebugMode){write-Host "      Configuring  button: $buttonID"}
        $WPFbtnTab5_26.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab5_26.IsEnabled = $false} Else {$WPFbtnTab5_26.IsEnabled = $true}
        $WPFbtnTab5_26.Content = $button.Name
        $WPFbtnTab5_26.Background = $button.bgcolor
        $WPFbtnTab5_26.Foreground = $button.textcolor
        $WPFbtnTab5_26.Add_Click({btnTab5_26_Click})
    }

}
If ($ConfigTab5.enable -eq "false"){$WPFTab5.Visibility = 'Hidden'} Else {$WPFTab5.Visibility = 'Visible'}