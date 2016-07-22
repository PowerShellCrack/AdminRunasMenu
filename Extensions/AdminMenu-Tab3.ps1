##*=============================================
##* LOAD TAB 2 FROM CONFIG
##*=============================================
$ConfigTab3 = $XmlConfigFile.app.tabAndButtons.tab[2]

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
function btnTab3_01_Click {
    
}

function btnTab3_02_Click {
    
}

function btnTab3_03_Click {
    
}

function btnTab3_04_Click {

}

function btnTab3_05_Click {

}

function btnTab3_06_Click {

}

# Set of 4 small buttons under left column
function btnTab3_07_Click {

}

function btnTab3_08_Click {

}


function btnTab3_09_Click {

}


function btnTab3_10_Click {

}


# Set of 4 large buttons under right column
function btnTab3_11_Click {

}

function btnTab3_12_Click {

}

function btnTab3_13_Click {

}

function btnTab3_14_Click {

}

# Set of 12 small buttons under right column
function btnTab3_15_Click {

}

function btnTab3_16_Click {

}

function btnTab3_17_Click {

}

function btnTab3_18_Click {

}

function btnTab3_19_Click {

}

function btnTab3_20_Click {

}

function btnTab3_21_Click {

}

function btnTab3_22_Click {

}

function btnTab3_23_Click {

}

function btnTab3_24_Click {

}

function btnTab3_25_Click {

}

function btnTab3_26_Click {

}


##*=============================================
##* TAB 1 OTHER FUNCTIONS
##*=============================================

$WPFtxtBoxRemote.Text = $env:COMPUTERNAME


##*=============================================
##* BUILD TAB 1 BUTTONS IF CONFIGURED
##*=============================================
$ConfigTab3_Name = $ConfigTab3.Name

$WPFTab3.Header = $ConfigTab3_Name
$WPFlblTab3Section1.Content = $ConfigTab3.section1Label
$WPFlblTab3Section2.Content = $ConfigTab3.section2Label

$ConfigTab3_btns = $ConfigTab3.button


Foreach ($button in $ConfigTab3_btns){
    
    [string]$buttonID = $button.id
    If ($LogDebugMode){Write-Host "Tab3: Found button: $buttonID"}

    If ($buttonID -eq "01"){
        If ($LogDebugMode){write-Host "      Configuring  button: $buttonID"}
        $WPFbtnTab3_01.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab3_01.IsEnabled = $false} Else {$WPFbtnTab3_01.IsEnabled = $true}
        $WPFbtnTab3_01.Content = $button.Name
        $WPFbtnTab3_01.Background = $button.bgcolor
        $WPFbtnTab3_01.Foreground = $button.textcolor
        $WPFbtnTab3_01.Add_Click({btnTab3_01_Click})
    } 

    If ($buttonID -eq "02"){
        If ($LogDebugMode){write-Host "      Configuring  button: $buttonID"}
        $WPFbtnTab3_02.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab3_02.IsEnabled = $false} Else {$WPFbtnTab3_02.IsEnabled = $true}
        $WPFbtnTab3_02.Content = $button.Name
        $WPFbtnTab3_02.Background = $button.bgcolor
        $WPFbtnTab3_02.Foreground = $button.textcolor
        $WPFbtnTab3_02.Add_Click({btnTab3_02_Click})
    }

    If ($buttonID -eq "03"){
        If ($LogDebugMode){write-Host "      Configuring  button: $buttonID"}
        $WPFbtnTab3_03.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab3_03.IsEnabled = $false} Else {$WPFbtnTab3_03.IsEnabled = $true}
        $WPFbtnTab3_03.Content = $button.Name
        $WPFbtnTab3_03.Background = $button.bgcolor
        $WPFbtnTab3_03.Foreground = $button.textcolor
        $WPFbtnTab3_03.Add_Click({btnTab3_03_Click})
    }

    If ($buttonID -eq "04"){
        If ($LogDebugMode){write-Host "      Configuring  button: $buttonID"}
        $WPFbtnTab3_04.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab3_04.IsEnabled = $false} Else {$WPFbtnTab3_04.IsEnabled = $true}
        $WPFbtnTab3_04.Content = $button.Name
        $WPFbtnTab3_04.Background = $button.bgcolor
        $WPFbtnTab3_04.Foreground = $button.textcolor
        $WPFbtnTab3_04.Add_Click({btnTab3_04_Click})
    } 

    If ($buttonID -eq "05"){
        If ($LogDebugMode){write-Host "      Configuring  button: $buttonID"}
        $WPFbtnTab3_05.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab3_05.IsEnabled = $false} Else {$WPFbtnTab3_05.IsEnabled = $true}
        $WPFbtnTab3_05.Content = $button.Name
        $WPFbtnTab3_05.Background = $button.bgcolor
        $WPFbtnTab3_05.Foreground = $button.textcolor
        $WPFbtnTab3_05.Add_Click({btnTab3_05_Click})
    } 

    If ($buttonID -eq "06"){
        If ($LogDebugMode){write-Host "      Configuring  button: $buttonID"}
        $WPFbtnTab3_06.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab3_06.IsEnabled = $false} Else {$WPFbtnTab3_06.IsEnabled = $true}
        $WPFbtnTab3_06.Content = $button.Name
        $WPFbtnTab3_06.Background = $button.bgcolor
        $WPFbtnTab3_06.Foreground = $button.textcolor
        $WPFbtnTab3_06.Add_Click({btnTab3_06_Click})
    } 

    If ($buttonID -eq "07"){
        If ($LogDebugMode){write-Host "      Configuring  button: $buttonID"}
        $WPFbtnTab3_07.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab3_07.IsEnabled = $false} Else {$WPFbtnTab3_07.IsEnabled = $true}
        $WPFbtnTab3_07.Content = $button.Name
        $WPFbtnTab3_07.Background = $button.bgcolor
        $WPFbtnTab3_07.Foreground = $button.textcolor
        $WPFbtnTab3_07.Add_Click({btnTab3_07_Click})
    }

    If ($buttonID -eq "08"){
        If ($LogDebugMode){write-Host "      Configuring  button: $buttonID"}
        $WPFbtnTab3_08.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab3_08.IsEnabled = $false} Else {$WPFbtnTab3_08.IsEnabled = $true}
        $WPFbtnTab3_08.Content = $button.Name
        $WPFbtnTab3_08.Background = $button.bgcolor
        $WPFbtnTab3_08.Foreground = $button.textcolor
        $WPFbtnTab3_08.Add_Click({btnTab3_08_Click})
    } 

    If ($buttonID -eq "09"){
        If ($LogDebugMode){write-Host "      Configuring  button: $buttonID"}
        $WPFbtnTab3_09.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab3_09.IsEnabled = $false} Else {$WPFbtnTab3_09.IsEnabled = $true}
        $WPFbtnTab3_09.Content = $button.Name
        $WPFbtnTab3_09.Background = $button.bgcolor
        $WPFbtnTab3_09.Foreground = $button.textcolor
        $WPFbtnTab3_09.Add_Click({btnTab3_09_Click})
    }

    If ($buttonID -eq "10"){
        If ($LogDebugMode){write-Host "      Configuring  button: $buttonID"}
        $WPFbtnTab3_10.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab3_10.IsEnabled = $false} Else {$WPFbtnTab3_10.IsEnabled = $true}
        $WPFbtnTab3_10.Content = $button.Name
        $WPFbtnTab3_10.Background = $button.bgcolor
        $WPFbtnTab3_10.Foreground = $button.textcolor
        $WPFbtnTab3_10.Add_Click({btnTab3_10_Click})
    }

    If ($buttonID -eq "11"){
        If ($LogDebugMode){write-Host "      Configuring  button: $buttonID"}
        $WPFbtnTab3_11.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab3_11.IsEnabled = $false} Else {$WPFbtnTab3_11.IsEnabled = $true}
        $WPFbtnTab3_11.Content = $button.Name
        $WPFbtnTab3_11.Background = $button.bgcolor
        $WPFbtnTab3_11.Foreground = $button.textcolor
        $WPFbtnTab3_11.Add_Click({btnTab3_11_Click})
    }

    If ($buttonID -eq "12"){
        If ($LogDebugMode){write-Host "      Configuring  button: $buttonID"}
        $WPFbtnTab3_12.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab3_12.IsEnabled = $false} Else {$WPFbtnTab3_12.IsEnabled = $true}
        $WPFbtnTab3_12.Content = $button.Name
        $WPFbtnTab3_12.Background = $button.bgcolor
        $WPFbtnTab3_12.Foreground = $button.textcolor
        $WPFbtnTab3_12.Add_Click({btnTab3_12_Click})
    }

    If ($buttonID -eq "13"){
        If ($LogDebugMode){write-Host "      Configuring  button: $buttonID"}
        $WPFbtnTab3_13.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab3_13.IsEnabled = $false} Else {$WPFbtnTab3_13.IsEnabled = $true}
        $WPFbtnTab3_13.Content = $button.Name
        $WPFbtnTab3_13.Background = $button.bgcolor
        $WPFbtnTab3_13.Foreground = $button.textcolor
        $WPFbtnTab3_13.Add_Click({btnTab3_13_Click})
    }

    If ($buttonID -eq "14"){
        If ($LogDebugMode){write-Host "      Configuring  button: $buttonID"}
        $WPFbtnTab3_14.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab3_14.IsEnabled = $false} Else {$WPFbtnTab3_14.IsEnabled = $true}
        $WPFbtnTab3_14.Content = $button.Name
        $WPFbtnTab3_14.Background = $button.bgcolor
        $WPFbtnTab3_14.Foreground = $button.textcolor
        $WPFbtnTab3_14.Add_Click({btnTab3_14_Click})
    }

    If ($buttonID -eq "15"){
        If ($LogDebugMode){write-Host "      Configuring  button: $buttonID"}
        $WPFbtnTab3_15.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab3_15.IsEnabled = $false} Else {$WPFbtnTab3_15.IsEnabled = $true}
        $WPFbtnTab3_15.Content = $button.Name
        $WPFbtnTab3_15.Background = $button.bgcolor
        $WPFbtnTab3_15.Foreground = $button.textcolor
        $WPFbtnTab3_15.Add_Click({btnTab3_15_Click})
    }

    If ($buttonID -eq "16"){
        If ($LogDebugMode){write-Host "      Configuring  button: $buttonID"}
        $WPFbtnTab3_16.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab3_16.IsEnabled = $false} Else {$WPFbtnTab3_16.IsEnabled = $true}
        $WPFbtnTab3_16.Content = $button.Name
        $WPFbtnTab3_16.Background = $button.bgcolor
        $WPFbtnTab3_16.Foreground = $button.textcolor
        $WPFbtnTab3_16.Add_Click({btnTab3_16_Click})
    }

    If ($buttonID -eq "17"){
        If ($LogDebugMode){write-Host "      Configuring  button: $buttonID"}
        $WPFbtnTab3_17.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab3_17.IsEnabled = $false} Else {$WPFbtnTab3_17.IsEnabled = $true}
        $WPFbtnTab3_17.Content = $button.Name
        $WPFbtnTab3_17.Background = $button.bgcolor
        $WPFbtnTab3_17.Foreground = $button.textcolor
        $WPFbtnTab3_17.Add_Click({btnTab3_17_Click})
    }

    If ($buttonID -eq "18"){
        If ($LogDebugMode){write-Host "      Configuring  button: $buttonID"}
        $WPFbtnTab3_18.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab3_18.IsEnabled = $false} Else {$WPFbtnTab3_18.IsEnabled = $true}
        $WPFbtnTab3_18.Content = $button.Name
        $WPFbtnTab3_18.Background = $button.bgcolor
        $WPFbtnTab3_18.Foreground = $button.textcolor
        $WPFbtnTab3_18.Add_Click({btnTab3_18_Click})
    }

    If ($buttonID -eq "19"){
        If ($LogDebugMode){write-Host "      Configuring  button: $buttonID"}
        $WPFbtnTab3_19.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab3_19.IsEnabled = $false} Else {$WPFbtnTab3_19.IsEnabled = $true}
        $WPFbtnTab3_19.Content = $button.Name
        $WPFbtnTab3_19.Background = $button.bgcolor
        $WPFbtnTab3_19.Foreground = $button.textcolor
        $WPFbtnTab3_19.Add_Click({btnTab3_19_Click})
    }

    If ($buttonID -eq "20"){
        If ($LogDebugMode){write-Host "      Configuring  button: $buttonID"}
        $WPFbtnTab3_20.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab3_20.IsEnabled = $false} Else {$WPFbtnTab3_20.IsEnabled = $true}
        $WPFbtnTab3_20.Content = $button.Name
        $WPFbtnTab3_20.Background = $button.bgcolor
        $WPFbtnTab3_20.Foreground = $button.textcolor
        $WPFbtnTab3_20.Add_Click({btnTab3_20_Click})
    }

    If ($buttonID -eq "21"){
        If ($LogDebugMode){write-Host "      Configuring  button: $buttonID"}
        $WPFbtnTab3_21.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab3_21.IsEnabled = $false} Else {$WPFbtnTab3_21.IsEnabled = $true}
        $WPFbtnTab3_21.Content = $button.Name
        $WPFbtnTab3_21.Background = $button.bgcolor
        $WPFbtnTab3_21.Foreground = $button.textcolor
        $WPFbtnTab3_21.Add_Click({btnTab3_21_Click})
    }

    If ($buttonID -eq "22"){
        If ($LogDebugMode){write-Host "      Configuring  button: $buttonID"}
        $WPFbtnTab3_22.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab3_22.IsEnabled = $false} Else {$WPFbtnTab3_22.IsEnabled = $true}
        $WPFbtnTab3_22.Content = $button.Name
        $WPFbtnTab3_22.Background = $button.bgcolor
        $WPFbtnTab3_22.Foreground = $button.textcolor
        $WPFbtnTab3_22.Add_Click({btnTab3_22_Click})
    }

    If ($buttonID -eq "23"){
        If ($LogDebugMode){write-Host "      Configuring  button: $buttonID"}
        $WPFbtnTab3_23.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab3_23.IsEnabled = $false} Else {$WPFbtnTab3_23.IsEnabled = $true}
        $WPFbtnTab3_23.Content = $button.Name
        $WPFbtnTab3_23.Background = $button.bgcolor
        $WPFbtnTab3_23.Foreground = $button.textcolor
        $WPFbtnTab3_23.Add_Click({btnTab3_23_Click})
    }

    If ($buttonID -eq "24"){
        If ($LogDebugMode){write-Host "      Configuring  button: $buttonID"}
        $WPFbtnTab3_24.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab3_24.IsEnabled = $false} Else {$WPFbtnTab3_24.IsEnabled = $true}
        $WPFbtnTab3_24.Content = $button.Name
        $WPFbtnTab3_24.Background = $button.bgcolor
        $WPFbtnTab3_24.Foreground = $button.textcolor
        $WPFbtnTab3_24.Add_Click({btnTab3_24_Click})
    }

    If ($buttonID -eq "25"){
        If ($LogDebugMode){write-Host "      Configuring  button: $buttonID"}
        $WPFbtnTab3_25.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab3_25.IsEnabled = $false} Else {$WPFbtnTab3_25.IsEnabled = $true}
        $WPFbtnTab3_25.Content = $button.Name
        $WPFbtnTab3_25.Background = $button.bgcolor
        $WPFbtnTab3_25.Foreground = $button.textcolor
        $WPFbtnTab3_25.Add_Click({btnTab3_25_Click})
    }

    If ($buttonID -eq "26"){
        If ($LogDebugMode){write-Host "      Configuring  button: $buttonID"}
        $WPFbtnTab3_26.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab3_26.IsEnabled = $false} Else {$WPFbtnTab3_26.IsEnabled = $true}
        $WPFbtnTab3_26.Content = $button.Name
        $WPFbtnTab3_26.Background = $button.bgcolor
        $WPFbtnTab3_26.Foreground = $button.textcolor
        $WPFbtnTab3_26.Add_Click({btnTab3_26_Click})
    }

}
If ($ConfigTab3.enable -eq "false"){$WPFTab3.Visibility = 'Hidden'} Else {$WPFTab3.Visibility = 'Visible'}