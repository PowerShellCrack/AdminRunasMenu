##*=============================================
##* LOAD TAB 2 FROM CONFIG
##*=============================================
$ConfigTab6 = $AppMenuTabandButtons.tab[5]

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
     - to identify process alias, use -Alias switch, otherwise path will be used instead
     - to specify a custom run message use the -CustomRunMsg switch
     - to specify a custom error message use the -CustomErrMsg switch (this will only display if errors)
     - Auto use credentials feature if selected in menu, you can force it not to by adding -NeverRunAs switch

       EXAMPLE (EXE):
          Start-ButtonProcess -Alias "$ButtonClicked" -Path "$PSHOME\PowerShell.exe" -WorkingDirectory "$envWinDir\System32" -OutputTab tab1 -WindowStyle Normal
       
       EXAMPLE (EXE) with Parameters:
          Start-ButtonProcess -Alias "$ButtonClicked" -Path "$env:windir\system32\mstsc.exe" -Parameters ("/v:" + $WPFtxtBoxRemote.Text) -OutputTab tab1 -WindowStyle Normal

       EXAMPLE (PS1): 
          Start-ButtonProcess -ProcessCall ps1 -File "Start-PoshPAIG.ps1" -WorkingDirectory "$($scriptRoot + "\Scripts\PoshPAIG_2_1_5")" -CreateNoWindow

#>
function Call-btnTab6_01{
    Start-ButtonProcess -ProcessCall ps1 -File "ClipboardHistoryViewer.ps1" -OutputTab tab1
}

function Call-btnTab6_02{
}

function Call-btnTab6_03{
    Start-ButtonProcess -ProcessCall ps1 -File "PowerCopy.ps1" -OutputTab tab1 -CreateNoWindow
}

function Call-btnTab6_04{

}

function Call-btnTab6_05{

}

function Call-btnTab6_06{
    Start-ButtonProcess -ProcessCall invoke -File "GetDiskSpaceMultipleComputers.ps1" -OutputTab tab1 -CreateNoWindow
}

function Call-btnTab6_07{
    Start-ButtonProcess -ProcessCall ps1 -File "Convert-Image.ps1" -OutputTab tab1 -CreateNoWindow
}

function Call-btnTab6_08{
    Start-ButtonProcess -ProcessCall ps1 -File "Generate-Password.ps1" -OutputTab tab1 -CreateNoWindow
}


function Call-btnTab6_09{
    Start-ButtonProcess -ProcessCall ps1 -File "NetworkPing.ps1" -OutputTab tab1 -CreateNoWindow
}


function Call-btnTab6_10{
    Start-ButtonProcess -Path "$UtilPath\NetCalc.exe" -OutputTab tab1 -WindowStyle Normal 
}

function Call-btnTab6_11{

}

function Call-btnTab6_12{

}

function Call-btnTab6_13{

}

function Call-btnTab6_14{

}

function Call-btnTab6_15{

}

function Call-btnTab6_16{

}

function Call-btnTab6_17{

}

function Call-btnTab6_18{

}

function Call-btnTab6_19{

}

function Call-btnTab6_20{

}

function Call-btnTab6_21{

}

function Call-btnTab6_22{

}

function Call-btnTab6_23{

}

function Call-btnTab6_24{
   Start-ButtonProcess -ProcessCall ps1 -File "Show-PSHelpTree.ps1" -OutputTab tab1 -CreateNoWindow
}


##*=============================================
##* TAB 1 OTHER FUNCTIONS
##*=============================================




##*=============================================
##* BUILD TAB 1 BUTTONS IF CONFIGURED
##*=============================================
$ConfigTab6_Name = $ConfigTab6.Name

$WPFTab6.Header = $ConfigTab6_Name
$WPFlblTab6Section1.Content = $ConfigTab6.section1Label

$ConfigTab6_btns = $ConfigTab6.button


Foreach ($button in $ConfigTab6_btns){
    
    [string]$buttonID = $button.id
    If ($AppOptionDebugeMode){Write-Host "Tab6:  Parsing 'button $buttonID' configurations" -ForegroundColor Gray}

    If ($buttonID -eq "01"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab6_01.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab6_01.IsEnabled = $false} Else {$WPFbtnTab6_01.IsEnabled = $true}
        $WPFbtnTextTab6_01.Text = $button.Name
        $WPFbtnTab6_01.Background = $button.bgcolor
        $WPFbtnTab6_01.Foreground = $button.textcolor
        #$WPFbtnTab6_01.Add_Click({Call-btnTab6_01})
        $WPFbtnTab6_01.add_Click({
                $ButtonClicked = $WPFbtnTextTab6_01.Text
                Call-btnTab6_01
            })
    } 

    If ($buttonID -eq "02"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab6_02.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab6_02.IsEnabled = $false} Else {$WPFbtnTab6_02.IsEnabled = $true}
        $WPFbtnTextTab6_02.Text = $button.Name
        $WPFbtnTab6_02.Background = $button.bgcolor
        $WPFbtnTab6_02.Foreground = $button.textcolor
        $WPFbtnTab6_02.Add_Click({
                $ButtonClicked = $WPFbtnTextTab6_02.Text
                Call-btnTab6_02
            })
    }

    If ($buttonID -eq "03"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab6_03.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab6_03.IsEnabled = $false} Else {$WPFbtnTab6_03.IsEnabled = $true}
        $WPFbtnTextTab6_03.Text = $button.Name
        $WPFbtnTab6_03.Background = $button.bgcolor
        $WPFbtnTab6_03.Foreground = $button.textcolor
        $WPFbtnTab6_03.Add_Click({
                $ButtonClicked = $WPFbtnTextTab6_03.Text
                Call-btnTab6_03
            })
    }

    If ($buttonID -eq "04"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab6_04.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab6_04.IsEnabled = $false} Else {$WPFbtnTab6_04.IsEnabled = $true}
        $WPFbtnTextTab6_04.Text = $button.Name
        $WPFbtnTab6_04.Background = $button.bgcolor
        $WPFbtnTab6_04.Foreground = $button.textcolor
        $WPFbtnTab6_04.Add_Click({
                $ButtonClicked = $WPFbtnTextTab6_04.Text
                Call-btnTab6_04
            })
    } 

    If ($buttonID -eq "05"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab6_05.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab6_05.IsEnabled = $false} Else {$WPFbtnTab6_05.IsEnabled = $true}
        $WPFbtnTextTab6_05.Text = $button.Name
        $WPFbtnTab6_05.Background = $button.bgcolor
        $WPFbtnTab6_05.Foreground = $button.textcolor
        $WPFbtnTab6_05.Add_Click({
                $ButtonClicked = $WPFbtnTextTab6_05.Text
                Call-btnTab6_05
             })
    } 

    If ($buttonID -eq "06"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab6_06.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab6_06.IsEnabled = $false} Else {$WPFbtnTab6_06.IsEnabled = $true}
        $WPFbtnTextTab6_06.Text = $button.Name
        $WPFbtnTab6_06.Background = $button.bgcolor
        $WPFbtnTab6_06.Foreground = $button.textcolor
        $WPFbtnTab6_06.Add_Click({
                $ButtonClicked = $WPFbtnTextTab6_06.Text
                Call-btnTab6_06
            })
    } 

    If ($buttonID -eq "07"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab6_07.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab6_07.IsEnabled = $false} Else {$WPFbtnTab6_07.IsEnabled = $true}
        $WPFbtnTextTab6_07.Text = $button.Name
        $WPFbtnTab6_07.Background = $button.bgcolor
        $WPFbtnTab6_07.Foreground = $button.textcolor
        $WPFbtnTab6_07.Add_Click({
                $ButtonClicked = $WPFbtnTextTab6_07.Text
                Call-btnTab6_07
            })
    } 

    If ($buttonID -eq "08"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab6_08.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab6_08.IsEnabled = $false} Else {$WPFbtnTab6_08.IsEnabled = $true}
        $WPFbtnTextTab6_08.Text = $button.Name
        $WPFbtnTab6_08.Background = $button.bgcolor
        $WPFbtnTab6_08.Foreground = $button.textcolor
        $WPFbtnTab6_08.Add_Click({
                $ButtonClicked = $WPFbtnTextTab6_08.Text
                Call-btnTab6_08
            })
    } 

    If ($buttonID -eq "09"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab6_09.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab6_09.IsEnabled = $false} Else {$WPFbtnTab6_09.IsEnabled = $true}
        $WPFbtnTextTab6_09.Text = $button.Name
        $WPFbtnTab6_09.Background = $button.bgcolor
        $WPFbtnTab6_09.Foreground = $button.textcolor
        $WPFbtnTab6_09.Add_Click({
                $ButtonClicked = $WPFbtnTextTab6_09.Text
                Call-btnTab6_09
            })
    } 

    If ($buttonID -eq "10"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab6_10.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab6_10.IsEnabled = $false} Else {$WPFbtnTab6_10.IsEnabled = $true}
        $WPFbtnTextTab6_10.Text = $button.Name
        $WPFbtnTab6_10.Background = $button.bgcolor
        $WPFbtnTab6_10.Foreground = $button.textcolor
        $WPFbtnTab6_10.Add_Click({
                $ButtonClicked = $WPFbtnTextTab6_10.Text
                Call-btnTab6_10
            })
    } 

    If ($buttonID -eq "11"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab6_11.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab6_11.IsEnabled = $false} Else {$WPFbtnTab6_11.IsEnabled = $true}
        $WPFbtnTextTab6_11.Text = $button.Name
        $WPFbtnTab6_11.Background = $button.bgcolor
        $WPFbtnTab6_11.Foreground = $button.textcolor
        $WPFbtnTab6_11.Add_Click({
                $ButtonClicked = $WPFbtnTextTab6_11.Text
                Call-btnTab6_11
            })
    } 

    If ($buttonID -eq "12"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab6_12.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab6_12.IsEnabled = $false} Else {$WPFbtnTab6_12.IsEnabled = $true}
        $WPFbtnTextTab6_12.Text = $button.Name
        $WPFbtnTab6_12.Background = $button.bgcolor
        $WPFbtnTab6_12.Foreground = $button.textcolor
        $WPFbtnTab6_12.Add_Click({
                $ButtonClicked = $WPFbtnTextTab6_12.Text
                Call-btnTab6_12
            })
    } 

    If ($buttonID -eq "13"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab6_13.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab6_13.IsEnabled = $false} Else {$WPFbtnTab6_13.IsEnabled = $true}
        $WPFbtnTextTab6_13.Text = $button.Name
        $WPFbtnTab6_13.Background = $button.bgcolor
        $WPFbtnTab6_13.Foreground = $button.textcolor
        $WPFbtnTab6_13.Add_Click({
                $ButtonClicked = $WPFbtnTextTab6_13.Text
                Call-btnTab6_13
            })
    } 
    If ($buttonID -eq "14"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab6_14.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab6_14.IsEnabled = $false} Else {$WPFbtnTab6_14.IsEnabled = $true}
        $WPFbtnTextTab6_14.Text = $button.Name
        $WPFbtnTab6_14.Background = $button.bgcolor
        $WPFbtnTab6_14.Foreground = $button.textcolor
        $WPFbtnTab6_14.Add_Click({
                $ButtonClicked = $WPFbtnTextTab6_14.Text
                Call-btnTab6_14
            })
    } 

    If ($buttonID -eq "15"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab6_15.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab6_15.IsEnabled = $false} Else {$WPFbtnTab6_15.IsEnabled = $true}
        $WPFbtnTextTab6_15.Text = $button.Name
        $WPFbtnTab6_15.Background = $button.bgcolor
        $WPFbtnTab6_15.Foreground = $button.textcolor
        $WPFbtnTab6_15.Add_Click({
                $ButtonClicked = $WPFbtnTextTab6_15.Text
                Call-btnTab6_15
            })
    } 

    If ($buttonID -eq "16"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab6_16.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab6_16.IsEnabled = $false} Else {$WPFbtnTab6_16.IsEnabled = $true}
        $WPFbtnTextTab6_16.Text = $button.Name
        $WPFbtnTab6_16.Background = $button.bgcolor
        $WPFbtnTab6_16.Foreground = $button.textcolor
        $WPFbtnTab6_16.Add_Click({
                $ButtonClicked = $WPFbtnTextTab6_16.Text
                Call-btnTab6_16
            })
    } 

    If ($buttonID -eq "17"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab6_17.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab6_17.IsEnabled = $false} Else {$WPFbtnTab6_17.IsEnabled = $true}
        $WPFbtnTextTab6_17.Text = $button.Name
        $WPFbtnTab6_17.Background = $button.bgcolor
        $WPFbtnTab6_17.Foreground = $button.textcolor
        $WPFbtnTab6_17.Add_Click({
                $ButtonClicked = $WPFbtnTextTab6_17.Text
                Call-btnTab6_17
            })
    } 

    If ($buttonID -eq "18"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab6_18.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab6_18.IsEnabled = $false} Else {$WPFbtnTab6_18.IsEnabled = $true}
        $WPFbtnTextTab6_18.Text = $button.Name
        $WPFbtnTab6_18.Background = $button.bgcolor
        $WPFbtnTab6_18.Foreground = $button.textcolor
        $WPFbtnTab6_18.Add_Click({
                $ButtonClicked = $WPFbtnTextTab6_18.Text
                Call-btnTab6_18
            })
    } 

    If ($buttonID -eq "19"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab6_19.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab6_19.IsEnabled = $false} Else {$WPFbtnTab6_19.IsEnabled = $true}
        $WPFbtnTextTab6_19.Text = $button.Name
        $WPFbtnTab6_19.Background = $button.bgcolor
        $WPFbtnTab6_19.Foreground = $button.textcolor
        $WPFbtnTab6_19.Add_Click({
                $ButtonClicked = $WPFbtnTextTab6_19.Text
                Call-btnTab6_19
            })
    } 

    If ($buttonID -eq "20"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab6_20.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab6_20.IsEnabled = $false} Else {$WPFbtnTab6_20.IsEnabled = $true}
        $WPFbtnTextTab6_20.Text = $button.Name
        $WPFbtnTab6_20.Background = $button.bgcolor
        $WPFbtnTab6_20.Foreground = $button.textcolor
        $WPFbtnTab6_20.Add_Click({
                $ButtonClicked = $WPFbtnTextTab6_20.Text
                Call-btnTab6_20
            })
    } 

    If ($buttonID -eq "21"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab6_21.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab6_21.IsEnabled = $false} Else {$WPFbtnTab6_21.IsEnabled = $true}
        $WPFbtnTextTab6_21.Text = $button.Name
        $WPFbtnTab6_21.Background = $button.bgcolor
        $WPFbtnTab6_21.Foreground = $button.textcolor
        $WPFbtnTab6_21.Add_Click({
                $ButtonClicked = $WPFbtnTextTab6_21.Text
                Call-btnTab6_21
            })
    } 

    If ($buttonID -eq "22"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab6_22.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab6_22.IsEnabled = $false} Else {$WPFbtnTab6_22.IsEnabled = $true}
        $WPFbtnTextTab6_22.Text = $button.Name
        $WPFbtnTab6_22.Background = $button.bgcolor
        $WPFbtnTab6_22.Foreground = $button.textcolor
        $WPFbtnTab6_22.Add_Click({
                $ButtonClicked = $WPFbtnTextTab6_22.Text
                Call-btnTab6_22
            })
    } 

    If ($buttonID -eq "23"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab6_23.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab6_23.IsEnabled = $false} Else {$WPFbtnTab6_23.IsEnabled = $true}
        $WPFbtnTextTab6_23.Text = $button.Name
        $WPFbtnTab6_23.Background = $button.bgcolor
        $WPFbtnTab6_23.Foreground = $button.textcolor
        $WPFbtnTab6_23.Add_Click({
                $ButtonClicked = $WPFbtnTextTab6_23.Text
                Call-btnTab6_23
            })
    } 

    If ($buttonID -eq "24"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab6_24.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab6_24.IsEnabled = $false} Else {$WPFbtnTab6_24.IsEnabled = $true}
        $WPFbtnTextTab6_24.Text = $button.Name
        $WPFbtnTab6_24.Background = $button.bgcolor
        $WPFbtnTab6_24.Foreground = $button.textcolor
        $WPFbtnTab6_24.Add_Click({
                $ButtonClicked = $WPFbtnTextTab6_24.Text
                Call-btnTab6_24
            })
    } 

    If ($buttonID -eq "25"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab6_25.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab6_25.IsEnabled = $false} Else {$WPFbtnTab6_25.IsEnabled = $true}
        $WPFbtnTextTab6_25.Text = $button.Name
        $WPFbtnTab6_25.Background = $button.bgcolor
        $WPFbtnTab6_25.Foreground = $button.textcolor
        $WPFbtnTab6_25.Add_Click({
                $ButtonClicked = $WPFbtnTextTab6_25.Text
                Call-btnTab6_25
            })
    } 

    If ($buttonID -eq "26"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab6_26.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab6_26.IsEnabled = $false} Else {$WPFbtnTab6_26.IsEnabled = $true}
        $WPFbtnTextTab6_26.Text = $button.Name
        $WPFbtnTab6_26.Background = $button.bgcolor
        $WPFbtnTab6_26.Foreground = $button.textcolor
        $WPFbtnTab6_26.Add_Click({
                $ButtonClicked = $WPFbtnTextTab6_26.Text
                Call-btnTab6_26
            })
    } 

}
If ($ConfigTab6.enable -eq "false"){$WPFTab6.Visibility = 'Hidden'} Else {$WPFTab6.Visibility = 'Visible'}