##*=============================================
##* LOAD TAB 2 FROM CONFIG
##*=============================================
$ConfigTab6 = $XmlConfigFile.app.tabAndButtons.tab[5]

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
function btnTab6_01_Click {
    . ($scriptRoot + "\Scripts\ClipboardHistoryViewer.ps1")
}

function btnTab6_02_Click {
    Start-ButtonProcess -ProcessCall ps1 -Title "$($WPFbtnTab6_02.Content)" -File "Start-PoshPAIG.ps1" -WorkingDirectory "$($scriptRoot + "\Scripts\PoshPAIG_2_1_5")" -OutputTab tab1 -CreateNoWindow
}

function btnTab6_03_Click {
    
}

function btnTab6_04_Click {

}

function btnTab6_05_Click {

}

function btnTab6_06_Click {

}

function btnTab6_07_Click {

}

function btnTab6_08_Click {

}


function btnTab6_09_Click {

}


function btnTab6_10_Click {

}

function btnTab6_11_Click {

}

function btnTab6_12_Click {

}

function btnTab6_13_Click {

}

function btnTab6_14_Click {

}

function btnTab6_15_Click {

}

function btnTab6_16_Click {

}

function btnTab6_17_Click {

}

function btnTab6_18_Click {

}

function btnTab6_19_Click {

}

function btnTab6_20_Click {

}

function btnTab6_21_Click {

}

function btnTab6_22_Click {

}

function btnTab6_23_Click {

}

function btnTab6_24_Click {

}


##*=============================================
##* TAB 1 OTHER FUNCTIONS
##*=============================================

$WPFtxtBoxRemote.Text = $env:COMPUTERNAME


##*=============================================
##* BUILD TAB 1 BUTTONS IF CONFIGURED
##*=============================================
$ConfigTab6_Name = $ConfigTab6.Name

$WPFTab6.Header = $ConfigTab6_Name
$WPFlblTab6Section1.Content = $ConfigTab6.section1Label

$ConfigTab6_btns = $ConfigTab6.button


Foreach ($button in $ConfigTab6_btns){
    
    [string]$buttonID = $button.id
    If ($LogDebugMode){Write-Host "Tab6: Found button: $buttonID"}

    If ($buttonID -eq "01"){
        If ($LogDebugMode){write-Host "      Configuring button: $buttonID"}
        $WPFbtnTab6_01.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab6_01.IsEnabled = $false} Else {$WPFbtnTab6_01.IsEnabled = $true}
        $WPFbtnTab6_01.Content = $button.Name
        $WPFbtnTab6_01.Background = $button.bgcolor
        $WPFbtnTab6_01.Foreground = $button.textcolor
        $WPFbtnTab6_01.Add_Click({btnTab6_01_Click})
    } 

    If ($buttonID -eq "02"){
        If ($LogDebugMode){write-Host "      Configuring button: $buttonID"}
        $WPFbtnTab6_02.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab6_02.IsEnabled = $false} Else {$WPFbtnTab6_02.IsEnabled = $true}
        $WPFbtnTab6_02.Content = $button.Name
        $WPFbtnTab6_02.Background = $button.bgcolor
        $WPFbtnTab6_02.Foreground = $button.textcolor
        $WPFbtnTab6_02.Add_Click({btnTab6_02_Click})
    }

    If ($buttonID -eq "03"){
        If ($LogDebugMode){write-Host "      Configuring button: $buttonID"}
        $WPFbtnTab6_03.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab6_03.IsEnabled = $false} Else {$WPFbtnTab6_03.IsEnabled = $true}
        $WPFbtnTab6_03.Content = $button.Name
        $WPFbtnTab6_03.Background = $button.bgcolor
        $WPFbtnTab6_03.Foreground = $button.textcolor
        $WPFbtnTab6_03.Add_Click({btnTab6_03_Click})
    }

    If ($buttonID -eq "04"){
        If ($LogDebugMode){write-Host "      Configuring button: $buttonID"}
        $WPFbtnTab6_04.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab6_04.IsEnabled = $false} Else {$WPFbtnTab6_04.IsEnabled = $true}
        $WPFbtnTab6_04.Content = $button.Name
        $WPFbtnTab6_04.Background = $button.bgcolor
        $WPFbtnTab6_04.Foreground = $button.textcolor
        $WPFbtnTab6_04.Add_Click({btnTab6_04_Click})
    } 

    If ($buttonID -eq "05"){
        If ($LogDebugMode){write-Host "      Configuring button: $buttonID"}
        $WPFbtnTab6_05.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab6_05.IsEnabled = $false} Else {$WPFbtnTab6_05.IsEnabled = $true}
        $WPFbtnTab6_05.Content = $button.Name
        $WPFbtnTab6_05.Background = $button.bgcolor
        $WPFbtnTab6_05.Foreground = $button.textcolor
        $WPFbtnTab6_05.Add_Click({btnTab6_05_Click})
    } 

    If ($buttonID -eq "06"){
        If ($LogDebugMode){write-Host "      Configuring button: $buttonID"}
        $WPFbtnTab6_06.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab6_06.IsEnabled = $false} Else {$WPFbtnTab6_06.IsEnabled = $true}
        $WPFbtnTab6_06.Content = $button.Name
        $WPFbtnTab6_06.Background = $button.bgcolor
        $WPFbtnTab6_06.Foreground = $button.textcolor
        $WPFbtnTab6_06.Add_Click({btnTab6_06_Click})
    } 

    If ($buttonID -eq "07"){
        If ($LogDebugMode){write-Host "      Configuring button: $buttonID"}
        $WPFbtnTab6_07.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab6_07.IsEnabled = $false} Else {$WPFbtnTab6_07.IsEnabled = $true}
        $WPFbtnTab6_07.Content = $button.Name
        $WPFbtnTab6_07.Background = $button.bgcolor
        $WPFbtnTab6_07.Foreground = $button.textcolor
        $WPFbtnTab6_07.Add_Click({btnTab6_07_Click})
    }

    If ($buttonID -eq "08"){
        If ($LogDebugMode){write-Host "      Configuring button: $buttonID"}
        $WPFbtnTab6_08.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab6_08.IsEnabled = $false} Else {$WPFbtnTab6_08.IsEnabled = $true}
        $WPFbtnTab6_08.Content = $button.Name
        $WPFbtnTab6_08.Background = $button.bgcolor
        $WPFbtnTab6_08.Foreground = $button.textcolor
        $WPFbtnTab6_08.Add_Click({btnTab6_08_Click})
    } 

    If ($buttonID -eq "09"){
        If ($LogDebugMode){write-Host "      Configuring button: $buttonID"}
        $WPFbtnTab6_09.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab6_09.IsEnabled = $false} Else {$WPFbtnTab6_09.IsEnabled = $true}
        $WPFbtnTab6_09.Content = $button.Name
        $WPFbtnTab6_09.Background = $button.bgcolor
        $WPFbtnTab6_09.Foreground = $button.textcolor
        $WPFbtnTab6_09.Add_Click({btnTab6_09_Click})
    }

    If ($buttonID -eq "10"){
        If ($LogDebugMode){write-Host "      Configuring button: $buttonID"}
        $WPFbtnTab6_10.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab6_10.IsEnabled = $false} Else {$WPFbtnTab6_10.IsEnabled = $true}
        $WPFbtnTab6_10.Content = $button.Name
        $WPFbtnTab6_10.Background = $button.bgcolor
        $WPFbtnTab6_10.Foreground = $button.textcolor
        $WPFbtnTab6_10.Add_Click({btnTab6_10_Click})
    }

    If ($buttonID -eq "11"){
        If ($LogDebugMode){write-Host "      Configuring button: $buttonID"}
        $WPFbtnTab6_11.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab6_11.IsEnabled = $false} Else {$WPFbtnTab6_11.IsEnabled = $true}
        $WPFbtnTab6_11.Content = $button.Name
        $WPFbtnTab6_11.Background = $button.bgcolor
        $WPFbtnTab6_11.Foreground = $button.textcolor
        $WPFbtnTab6_11.Add_Click({btnTab6_11_Click})
    }

    If ($buttonID -eq "12"){
        If ($LogDebugMode){write-Host "      Configuring button: $buttonID"}
        $WPFbtnTab6_12.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab6_12.IsEnabled = $false} Else {$WPFbtnTab6_12.IsEnabled = $true}
        $WPFbtnTab6_12.Content = $button.Name
        $WPFbtnTab6_12.Background = $button.bgcolor
        $WPFbtnTab6_12.Foreground = $button.textcolor
        $WPFbtnTab6_12.Add_Click({btnTab6_12_Click})
    }

    If ($buttonID -eq "13"){
        If ($LogDebugMode){write-Host "      Configuring button: $buttonID"}
        $WPFbtnTab6_13.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab6_13.IsEnabled = $false} Else {$WPFbtnTab6_13.IsEnabled = $true}
        $WPFbtnTab6_13.Content = $button.Name
        $WPFbtnTab6_13.Background = $button.bgcolor
        $WPFbtnTab6_13.Foreground = $button.textcolor
        $WPFbtnTab6_13.Add_Click({btnTab6_13_Click})
    }

    If ($buttonID -eq "14"){
        If ($LogDebugMode){write-Host "      Configuring button: $buttonID"}
        $WPFbtnTab6_14.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab6_14.IsEnabled = $false} Else {$WPFbtnTab6_14.IsEnabled = $true}
        $WPFbtnTab6_14.Content = $button.Name
        $WPFbtnTab6_14.Background = $button.bgcolor
        $WPFbtnTab6_14.Foreground = $button.textcolor
        $WPFbtnTab6_14.Add_Click({btnTab6_14_Click})
    }

    If ($buttonID -eq "15"){
        If ($LogDebugMode){write-Host "      Configuring button: $buttonID"}
        $WPFbtnTab6_15.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab6_15.IsEnabled = $false} Else {$WPFbtnTab6_15.IsEnabled = $true}
        $WPFbtnTab6_15.Content = $button.Name
        $WPFbtnTab6_15.Background = $button.bgcolor
        $WPFbtnTab6_15.Foreground = $button.textcolor
        $WPFbtnTab6_15.Add_Click({btnTab6_15_Click})
    }

    If ($buttonID -eq "16"){
        If ($LogDebugMode){write-Host "      Configuring button: $buttonID"}
        $WPFbtnTab6_16.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab6_16.IsEnabled = $false} Else {$WPFbtnTab6_16.IsEnabled = $true}
        $WPFbtnTab6_16.Content = $button.Name
        $WPFbtnTab6_16.Background = $button.bgcolor
        $WPFbtnTab6_16.Foreground = $button.textcolor
        $WPFbtnTab6_16.Add_Click({btnTab6_16_Click})
    }

    If ($buttonID -eq "17"){
        If ($LogDebugMode){write-Host "      Configuring button: $buttonID"}
        $WPFbtnTab6_17.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab6_17.IsEnabled = $false} Else {$WPFbtnTab6_17.IsEnabled = $true}
        $WPFbtnTab6_17.Content = $button.Name
        $WPFbtnTab6_17.Background = $button.bgcolor
        $WPFbtnTab6_17.Foreground = $button.textcolor
        $WPFbtnTab6_17.Add_Click({btnTab6_17_Click})
    }

    If ($buttonID -eq "18"){
        If ($LogDebugMode){write-Host "      Configuring button: $buttonID"}
        $WPFbtnTab6_18.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab6_18.IsEnabled = $false} Else {$WPFbtnTab6_18.IsEnabled = $true}
        $WPFbtnTab6_18.Content = $button.Name
        $WPFbtnTab6_18.Background = $button.bgcolor
        $WPFbtnTab6_18.Foreground = $button.textcolor
        $WPFbtnTab6_18.Add_Click({btnTab6_18_Click})
    }

    If ($buttonID -eq "19"){
        If ($LogDebugMode){write-Host "      Configuring button: $buttonID"}
        $WPFbtnTab6_19.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab6_19.IsEnabled = $false} Else {$WPFbtnTab6_19.IsEnabled = $true}
        $WPFbtnTab6_19.Content = $button.Name
        $WPFbtnTab6_19.Background = $button.bgcolor
        $WPFbtnTab6_19.Foreground = $button.textcolor
        $WPFbtnTab6_19.Add_Click({btnTab6_19_Click})
    }

    If ($buttonID -eq "20"){
        If ($LogDebugMode){write-Host "      Configuring button: $buttonID"}
        $WPFbtnTab6_20.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab6_20.IsEnabled = $false} Else {$WPFbtnTab6_20.IsEnabled = $true}
        $WPFbtnTab6_20.Content = $button.Name
        $WPFbtnTab6_20.Background = $button.bgcolor
        $WPFbtnTab6_20.Foreground = $button.textcolor
        $WPFbtnTab6_20.Add_Click({btnTab6_20_Click})
    }

    If ($buttonID -eq "21"){
        If ($LogDebugMode){write-Host "      Configuring button: $buttonID"}
        $WPFbtnTab6_21.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab6_21.IsEnabled = $false} Else {$WPFbtnTab6_21.IsEnabled = $true}
        $WPFbtnTab6_21.Content = $button.Name
        $WPFbtnTab6_21.Background = $button.bgcolor
        $WPFbtnTab6_21.Foreground = $button.textcolor
        $WPFbtnTab6_21.Add_Click({btnTab6_21_Click})
    }

    If ($buttonID -eq "22"){
        If ($LogDebugMode){write-Host "      Configuring button: $buttonID"}
        $WPFbtnTab6_22.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab6_22.IsEnabled = $false} Else {$WPFbtnTab6_22.IsEnabled = $true}
        $WPFbtnTab6_22.Content = $button.Name
        $WPFbtnTab6_22.Background = $button.bgcolor
        $WPFbtnTab6_22.Foreground = $button.textcolor
        $WPFbtnTab6_22.Add_Click({btnTab6_22_Click})
    }

    If ($buttonID -eq "23"){
        If ($LogDebugMode){write-Host "      Configuring button: $buttonID"}
        $WPFbtnTab6_23.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab6_23.IsEnabled = $false} Else {$WPFbtnTab6_23.IsEnabled = $true}
        $WPFbtnTab6_23.Content = $button.Name
        $WPFbtnTab6_23.Background = $button.bgcolor
        $WPFbtnTab6_23.Foreground = $button.textcolor
        $WPFbtnTab6_23.Add_Click({btnTab6_23_Click})
    }

    If ($buttonID -eq "24"){
        If ($LogDebugMode){write-Host "      Configuring button: $buttonID"}
        $WPFbtnTab6_24.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab6_24.IsEnabled = $false} Else {$WPFbtnTab6_24.IsEnabled = $true}
        $WPFbtnTab6_24.Content = $button.Name
        $WPFbtnTab6_24.Background = $button.bgcolor
        $WPFbtnTab6_24.Foreground = $button.textcolor
        $WPFbtnTab6_24.Add_Click({btnTab6_24_Click})
    }

}
If ($ConfigTab6.enable -eq "false"){$WPFTab6.Visibility = 'Hidden'} Else {$WPFTab6.Visibility = 'Visible'}
