##*=============================================
##* LOAD TAB 4 FROM CONFIG
##*=============================================
$ConfigTab4 = $AppMenuTabandButtons.tab[3]
If ($HashNames.Keys -eq "Tab4"){
    Write-Host "Found Tab4 section in Names File" -ForegroundColor Gray
    $Tab4HashNames = $HashNames.Tab4
    [string]$Tab4HashList = $Tab4HashNames| out-string -stream
    write-Host "`nNames found in list: `n$Tab4HashList"
}
Else{
    Write-Host "No Tab4 section found in names file" -ForegroundColor Gray
}
$WPFtxtTab4Name1.Text = ""

$WPFbtnTab4Name1List.add_Click({Save-ComputerList -TitleDesc "List of Exchange Servers" -TabObject Tab4})

$Global:PSExchServer = "http://$($WPFtxtTab4Name1.Text)/PowerShell/"
$Global:PSLync = "http://$($WPFtxtTab4Name1.Text)/ocspowershell"
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
# Set of 6 large buttons under left column
function Call-btnTab4_01{
    
}

function Call-btnTab4_02{
    
}

function Call-btnTab4_03{
    
}

function Call-btnTab4_04{

}

function Call-btnTab4_05{

}

function Call-btnTab4_06{

}

# Set of 4 small buttons under left column
function Call-btnTab4_07{

}

function Call-btnTab4_08{

}


function Call-btnTab4_09{

}


function Call-btnTab4_10{

}


# Set of 4 large buttons under right column
function Call-btnTab4_11{
    Start-ButtonProcess -ProcessCall module -Path "$envProgramFiles\Microsoft\Exchange Server\V14\bin\RemoteExchange.ps1'; Connect-ExchangeServer -auto;" -OutputTab Tab4 -WindowStyle Normal

}

function Call-btnTab4_12{

}

function Call-btnTab4_13{

}

function Call-btnTab4_14{

}

# Set of 12 small buttons under right column
function Call-btnTab4_15{

}

function Call-btnTab4_16{

}

function Call-btnTab4_17{
    Start-ButtonProcess -ProcessCall ps1 -File "ThumbnailPhotoManager.ps1" -OutputTab tab4 -CreateNoWindow
}

function Call-btnTab4_18{
    Start-ButtonProcess -Path "$envWinDir\system32\mstsc.exe" -Parameters ("/v:" + $WPFtxtTab4Name1.Text) -OutputTab Tab4 -CustomRunMsg "Opening Remote Desktop Connection for: $($WPFtxtTab4Name1.Text)" -NeverRunAs -WindowStyle Normal
}

function Call-btnTab4_19{
     Start-ButtonProcess -ProcessCall ps1 -File "Get-ExchangeEnvironmentReport.ps1" -Parameters "-HTMLReport $envUserProfile\Desktop\ExchangeReport.html" -OutputTab tab4 -CreateNoWindow
}

function Call-btnTab4_20{

}

function Call-btnTab4_21{

}

function Call-btnTab4_22{
    Start-ButtonProcess -ProcessCall ps1 -File "New-ExchangeMailboxAudit-GUI.ps1" -WorkingScriptDirectory "ExchangeMailboxAuditReport\Script" -OutputTab tab4 -CreateNoWindow
}

function Call-btnTab4_23{

}

function Call-btnTab4_24{

}

function Call-btnTab4_25{

}

function Call-btnTab4_26{

}


##*=============================================
##* TAB 4 FUNCTIONS
##*=============================================


##*=============================================
##* BUILD TAB 4 BUTTONS IF CONFIGURED
##*=============================================
$ConfigTab4_Name = $ConfigTab4.Name

$WPFTab4.Header = $ConfigTab4_Name
$WPFlblTab4Section1.Content = $ConfigTab4.section1Label
$WPFlblTab4Section2.Content = $ConfigTab4.section2Label

$ConfigTab4_btns = $ConfigTab4.button


Foreach ($button in $ConfigTab4_btns){
    
    [string]$buttonID = $button.id
    If ($AppOptionDebugeMode){Write-Host "Tab4:  Parsing 'button $buttonID' configurations" -ForegroundColor Gray}

    If ($buttonID -eq "01"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab4_01.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab4_01.IsEnabled = $false} Else {$WPFbtnTab4_01.IsEnabled = $true}
        $WPFbtnTextTab4_01.Text = $button.Name
        $WPFbtnTab4_01.Background = $button.bgcolor
        $WPFbtnTab4_01.Foreground = $button.textcolor
        #$WPFbtnTab4_01.Add_Click({Call-btnTab4_01})
        $WPFbtnTab4_01.add_Click({
                $ButtonClicked = $WPFbtnTextTab4_01.Text
                Call-btnTab4_01
            })
    } 

    If ($buttonID -eq "02"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab4_02.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab4_02.IsEnabled = $false} Else {$WPFbtnTab4_02.IsEnabled = $true}
        $WPFbtnTextTab4_02.Text = $button.Name
        $WPFbtnTab4_02.Background = $button.bgcolor
        $WPFbtnTab4_02.Foreground = $button.textcolor
        $WPFbtnTab4_02.Add_Click({
                $ButtonClicked = $WPFbtnTextTab4_02.Text
                Call-btnTab4_02
            })
    }

    If ($buttonID -eq "03"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab4_03.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab4_03.IsEnabled = $false} Else {$WPFbtnTab4_03.IsEnabled = $true}
        $WPFbtnTextTab4_03.Text = $button.Name
        $WPFbtnTab4_03.Background = $button.bgcolor
        $WPFbtnTab4_03.Foreground = $button.textcolor
        $WPFbtnTab4_03.Add_Click({
                $ButtonClicked = $WPFbtnTextTab4_03.Text
                Call-btnTab4_03
            })
    }

    If ($buttonID -eq "04"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab4_04.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab4_04.IsEnabled = $false} Else {$WPFbtnTab4_04.IsEnabled = $true}
        $WPFbtnTextTab4_04.Text = $button.Name
        $WPFbtnTab4_04.Background = $button.bgcolor
        $WPFbtnTab4_04.Foreground = $button.textcolor
        $WPFbtnTab4_04.Add_Click({
                $ButtonClicked = $WPFbtnTextTab4_04.Text
                Call-btnTab4_04
            })
    } 

    If ($buttonID -eq "05"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab4_05.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab4_05.IsEnabled = $false} Else {$WPFbtnTab4_05.IsEnabled = $true}
        $WPFbtnTextTab4_05.Text = $button.Name
        $WPFbtnTab4_05.Background = $button.bgcolor
        $WPFbtnTab4_05.Foreground = $button.textcolor
        $WPFbtnTab4_05.Add_Click({
                $ButtonClicked = $WPFbtnTextTab4_05.Text
                Call-btnTab4_05
             })
    } 

    If ($buttonID -eq "06"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab4_06.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab4_06.IsEnabled = $false} Else {$WPFbtnTab4_06.IsEnabled = $true}
        $WPFbtnTextTab4_06.Text = $button.Name
        $WPFbtnTab4_06.Background = $button.bgcolor
        $WPFbtnTab4_06.Foreground = $button.textcolor
        $WPFbtnTab4_06.Add_Click({
                $ButtonClicked = $WPFbtnTextTab4_06.Text
                Call-btnTab4_06
            })
    } 

    If ($buttonID -eq "07"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab4_07.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab4_07.IsEnabled = $false} Else {$WPFbtnTab4_07.IsEnabled = $true}
        $WPFbtnTextTab4_07.Text = $button.Name
        $WPFbtnTab4_07.Background = $button.bgcolor
        $WPFbtnTab4_07.Foreground = $button.textcolor
        $WPFbtnTab4_07.Add_Click({
                $ButtonClicked = $WPFbtnTextTab4_07.Text
                Call-btnTab4_07
            })
    } 

    If ($buttonID -eq "08"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab4_08.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab4_08.IsEnabled = $false} Else {$WPFbtnTab4_08.IsEnabled = $true}
        $WPFbtnTextTab4_08.Text = $button.Name
        $WPFbtnTab4_08.Background = $button.bgcolor
        $WPFbtnTab4_08.Foreground = $button.textcolor
        $WPFbtnTab4_08.Add_Click({
                $ButtonClicked = $WPFbtnTextTab4_08.Text
                Call-btnTab4_08
            })
    } 

    If ($buttonID -eq "09"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab4_09.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab4_09.IsEnabled = $false} Else {$WPFbtnTab4_09.IsEnabled = $true}
        $WPFbtnTextTab4_09.Text = $button.Name
        $WPFbtnTab4_09.Background = $button.bgcolor
        $WPFbtnTab4_09.Foreground = $button.textcolor
        $WPFbtnTab4_09.Add_Click({
                $ButtonClicked = $WPFbtnTextTab4_09.Text
                Call-btnTab4_09
            })
    } 

    If ($buttonID -eq "10"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab4_10.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab4_10.IsEnabled = $false} Else {$WPFbtnTab4_10.IsEnabled = $true}
        $WPFbtnTextTab4_10.Text = $button.Name
        $WPFbtnTab4_10.Background = $button.bgcolor
        $WPFbtnTab4_10.Foreground = $button.textcolor
        $WPFbtnTab4_10.Add_Click({
                $ButtonClicked = $WPFbtnTextTab4_10.Text
                Call-btnTab4_10
            })
    } 

    If ($buttonID -eq "11"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab4_11.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab4_11.IsEnabled = $false} Else {$WPFbtnTab4_11.IsEnabled = $true}
        $WPFbtnTextTab4_11.Text = $button.Name
        $WPFbtnTab4_11.Background = $button.bgcolor
        $WPFbtnTab4_11.Foreground = $button.textcolor
        $WPFbtnTab4_11.Add_Click({
                $ButtonClicked = $WPFbtnTextTab4_11.Text
                Call-btnTab4_11
            })
    } 

    If ($buttonID -eq "12"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab4_12.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab4_12.IsEnabled = $false} Else {$WPFbtnTab4_12.IsEnabled = $true}
        $WPFbtnTextTab4_12.Text = $button.Name
        $WPFbtnTab4_12.Background = $button.bgcolor
        $WPFbtnTab4_12.Foreground = $button.textcolor
        $WPFbtnTab4_12.Add_Click({
                $ButtonClicked = $WPFbtnTextTab4_12.Text
                Call-btnTab4_12
            })
    } 

    If ($buttonID -eq "13"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab4_13.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab4_13.IsEnabled = $false} Else {$WPFbtnTab4_13.IsEnabled = $true}
        $WPFbtnTextTab4_13.Text = $button.Name
        $WPFbtnTab4_13.Background = $button.bgcolor
        $WPFbtnTab4_13.Foreground = $button.textcolor
        $WPFbtnTab4_13.Add_Click({
                $ButtonClicked = $WPFbtnTextTab4_13.Text
                Call-btnTab4_13
            })
    } 
    If ($buttonID -eq "14"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab4_14.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab4_14.IsEnabled = $false} Else {$WPFbtnTab4_14.IsEnabled = $true}
        $WPFbtnTextTab4_14.Text = $button.Name
        $WPFbtnTab4_14.Background = $button.bgcolor
        $WPFbtnTab4_14.Foreground = $button.textcolor
        $WPFbtnTab4_14.Add_Click({
                $ButtonClicked = $WPFbtnTextTab4_14.Text
                Call-btnTab4_14
            })
    } 

    If ($buttonID -eq "15"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab4_15.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab4_15.IsEnabled = $false} Else {$WPFbtnTab4_15.IsEnabled = $true}
        $WPFbtnTextTab4_15.Text = $button.Name
        $WPFbtnTab4_15.Background = $button.bgcolor
        $WPFbtnTab4_15.Foreground = $button.textcolor
        $WPFbtnTab4_15.Add_Click({
                $ButtonClicked = $WPFbtnTextTab4_15.Text
                Call-btnTab4_15
            })
    } 

    If ($buttonID -eq "16"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab4_16.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab4_16.IsEnabled = $false} Else {$WPFbtnTab4_16.IsEnabled = $true}
        $WPFbtnTextTab4_16.Text = $button.Name
        $WPFbtnTab4_16.Background = $button.bgcolor
        $WPFbtnTab4_16.Foreground = $button.textcolor
        $WPFbtnTab4_16.Add_Click({
                $ButtonClicked = $WPFbtnTextTab4_16.Text
                Call-btnTab4_16
            })
    } 

    If ($buttonID -eq "17"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab4_17.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab4_17.IsEnabled = $false} Else {$WPFbtnTab4_17.IsEnabled = $true}
        $WPFbtnTextTab4_17.Text = $button.Name
        $WPFbtnTab4_17.Background = $button.bgcolor
        $WPFbtnTab4_17.Foreground = $button.textcolor
        $WPFbtnTab4_17.Add_Click({
                $ButtonClicked = $WPFbtnTextTab4_17.Text
                Call-btnTab4_17
            })
    } 

    If ($buttonID -eq "18"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab4_18.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab4_18.IsEnabled = $false} Else {$WPFbtnTab4_18.IsEnabled = $true}
        $WPFbtnTextTab4_18.Text = $button.Name
        $WPFbtnTab4_18.Background = $button.bgcolor
        $WPFbtnTab4_18.Foreground = $button.textcolor
        $WPFbtnTab4_18.Add_Click({
                $ButtonClicked = $WPFbtnTextTab4_18.Text
                Call-btnTab4_18
            })
    } 

    If ($buttonID -eq "19"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab4_19.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab4_19.IsEnabled = $false} Else {$WPFbtnTab4_19.IsEnabled = $true}
        $WPFbtnTextTab4_19.Text = $button.Name
        $WPFbtnTab4_19.Background = $button.bgcolor
        $WPFbtnTab4_19.Foreground = $button.textcolor
        $WPFbtnTab4_19.Add_Click({
                $ButtonClicked = $WPFbtnTextTab4_19.Text
                Call-btnTab4_19
            })
    } 

    If ($buttonID -eq "20"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab4_20.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab4_20.IsEnabled = $false} Else {$WPFbtnTab4_20.IsEnabled = $true}
        $WPFbtnTextTab4_20.Text = $button.Name
        $WPFbtnTab4_20.Background = $button.bgcolor
        $WPFbtnTab4_20.Foreground = $button.textcolor
        $WPFbtnTab4_20.Add_Click({
                $ButtonClicked = $WPFbtnTextTab4_20.Text
                Call-btnTab4_20
            })
    } 

    If ($buttonID -eq "21"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab4_21.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab4_21.IsEnabled = $false} Else {$WPFbtnTab4_21.IsEnabled = $true}
        $WPFbtnTextTab4_21.Text = $button.Name
        $WPFbtnTab4_21.Background = $button.bgcolor
        $WPFbtnTab4_21.Foreground = $button.textcolor
        $WPFbtnTab4_21.Add_Click({
                $ButtonClicked = $WPFbtnTextTab4_21.Text
                Call-btnTab4_21
            })
    } 

    If ($buttonID -eq "22"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab4_22.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab4_22.IsEnabled = $false} Else {$WPFbtnTab4_22.IsEnabled = $true}
        $WPFbtnTextTab4_22.Text = $button.Name
        $WPFbtnTab4_22.Background = $button.bgcolor
        $WPFbtnTab4_22.Foreground = $button.textcolor
        $WPFbtnTab4_22.Add_Click({
                $ButtonClicked = $WPFbtnTextTab4_22.Text
                Call-btnTab4_22
            })
    } 

    If ($buttonID -eq "23"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab4_23.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab4_23.IsEnabled = $false} Else {$WPFbtnTab4_23.IsEnabled = $true}
        $WPFbtnTextTab4_23.Text = $button.Name
        $WPFbtnTab4_23.Background = $button.bgcolor
        $WPFbtnTab4_23.Foreground = $button.textcolor
        $WPFbtnTab4_23.Add_Click({
                $ButtonClicked = $WPFbtnTextTab4_23.Text
                Call-btnTab4_23
            })
    } 

    If ($buttonID -eq "24"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab4_24.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab4_24.IsEnabled = $false} Else {$WPFbtnTab4_24.IsEnabled = $true}
        $WPFbtnTextTab4_24.Text = $button.Name
        $WPFbtnTab4_24.Background = $button.bgcolor
        $WPFbtnTab4_24.Foreground = $button.textcolor
        $WPFbtnTab4_24.Add_Click({
                $ButtonClicked = $WPFbtnTextTab4_24.Text
                Call-btnTab4_24
            })
    } 

    If ($buttonID -eq "25"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab4_25.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab4_25.IsEnabled = $false} Else {$WPFbtnTab4_25.IsEnabled = $true}
        $WPFbtnTextTab4_25.Text = $button.Name
        $WPFbtnTab4_25.Background = $button.bgcolor
        $WPFbtnTab4_25.Foreground = $button.textcolor
        $WPFbtnTab4_25.Add_Click({
                $ButtonClicked = $WPFbtnTextTab4_25.Text
                Call-btnTab4_25
            })
    } 

    If ($buttonID -eq "26"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab4_26.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab4_26.IsEnabled = $false} Else {$WPFbtnTab4_26.IsEnabled = $true}
        $WPFbtnTextTab4_26.Text = $button.Name
        $WPFbtnTab4_26.Background = $button.bgcolor
        $WPFbtnTab4_26.Foreground = $button.textcolor
        $WPFbtnTab4_26.Add_Click({
                $ButtonClicked = $WPFbtnTextTab4_26.Text
                Call-btnTab4_26
            })
    } 

}
If ($ConfigTab4.enable -eq "false"){$WPFTab4.Visibility = 'Hidden'} Else {$WPFTab4.Visibility = 'Visible'}