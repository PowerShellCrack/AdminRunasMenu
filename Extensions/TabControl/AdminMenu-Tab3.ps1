##*=============================================
##* LOAD TAB 3 FROM CONFIG
##*=============================================
$ConfigTab3 = $AppMenuTabandButtons.tab[2]
If ($HashNames.Keys -eq "Tab3"){
    Write-Host "Found Tab3 section in Names File" -ForegroundColor Gray
    $Tab3HashNames = $HashNames.Tab3
    [string]$Tab3HashList = $Tab3HashNames| out-string -stream
    write-Host "`nNames found in list: `n$Tab3HashList"
}
Else{
    Write-Host "No Tab3 section found in names file" -ForegroundColor Gray
}

Try{$SMSSiteCode = ($([WmiClass]"ROOT\ccm:SMS_Client").getassignedsite()).sSiteCode}Catch{$SMSSiteCode = "N/A"}

$WPFtxtTab3Name1.Text = $SMSSiteCode

$WPFbtnTab3Name2List.add_Click({Save-ComputerList -TitleDesc "List of Sytem Center Server" -TabObject Tab3})
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
function Call-btnTab3_01{
    $SCCM = "$($Env:SMS_ADMIN_UI_PATH.Substring(0,$Env:SMS_ADMIN_UI_PATH.Length-5) + '\Microsoft.ConfigurationManagement.exe')"
    Start-ButtonProcess -Path $SCCM -OutputTab Tab3 -WindowStyle Normal
}

function Call-btnTab3_02{
    $DPWB = "$envProgramFiles\Microsoft Deployment Toolkit\Bin\DeploymentWorkbench.msc"
    Start-ButtonProcess -Path "$DPWB" -OutputTab Tab3 -WindowStyle Normal
}

function Call-btnTab3_03{
    $SCSM = "$envProgramFiles\Microsoft System Center 2012 R2\Service Manager\Microsoft.EnterpriseManagement.ServiceManager.UI.Console.exe"
    Start-ButtonProcess -Path $SCSM -OutputTab Tab3 -WindowStyle Normal
}

function Call-btnTab3_04{
    
}

function Call-btnTab3_05{
    
}

function Call-btnTab3_06{

}

# Set of 4 small buttons under left column
function Call-btnTab3_07{
    Start-ButtonProcess -Path "$envProgramFiles\Microsoft DaRT\v10\DartRemoteViewer.exe" -OutputTab Tab3 -WindowStyle Normal
}

function Call-btnTab3_08{
    
}


function Call-btnTab3_09{
    
}


function Call-btnTab3_10{
    Start-ButtonProcess -Path "C:\Program Files\SCCM Tools\SCCM Client Center\SMSCliCtrV2.exe" -OutputTab Tab3 -WindowStyle Normal
}


# Set of 4 large buttons under right column
function Call-btnTab3_11{
}

function Call-btnTab3_12{
    
}

function Call-btnTab3_13{

}

function Call-btnTab3_14{

}

# Set of 12 small buttons under right column
function Call-btnTab3_15{
}

function Call-btnTab3_16{
    Start-ButtonProcess -Path "$envProgramFilesX86\ConfigMgr 2012 Toolkit R2\ClientTools\PolicySpy.exe" -OutputTab Tab3 -WindowStyle Normal
}

function Call-btnTab3_17{
    Start-ButtonProcess -ProcessCall ps1 -File "Start-PoshCAT.ps1" -WorkingScriptDirectory "PoshCAT_0.2" -OutputTab tab3 -WindowStyle Hidden
}

function Call-btnTab3_18{
Start-ButtonProcess -Path "$envWinDir\system32\mstsc.exe" -Parameters ("/v:" + $WPFtxtTab3Name2.Text) -OutputTab Tab3 -CustomRunMsg "Opening Remote Desktop Connection for: $($WPFtxtTab3Name2.Text)" -NeverRunAs -WindowStyle Normal
}

function Call-btnTab3_19{

}

function Call-btnTab3_20{

}

function Call-btnTab3_21{

}

function Call-btnTab3_22{

}

function Call-btnTab3_23{

}

function Call-btnTab3_24{

}


function Call-btnTab3_25{

}

function Call-btnTab3_26{
    Start-ButtonProcess -ProcessCall ps1 -File "Install-ConfigMgrPrereqsGUI_1.4.2.ps1" -OutputTab tab3 -CreateNoWindow
}



##*=============================================
##* TAB 3 FUNCTIONS
##*=============================================



##*=============================================
##* BUILD TAB 3 BUTTONS IF CONFIGURED
##*=============================================
$ConfigTab3_Name = $ConfigTab3.Name

$WPFTab3.Header = $ConfigTab3_Name
$WPFlblTab3Section1.Content = $ConfigTab3.section1Label
$WPFlblTab3Section2.Content = $ConfigTab3.section2Label

$ConfigTab3_btns = $ConfigTab3.button


Foreach ($button in $ConfigTab3_btns){
    
    [string]$buttonID = $button.id
    If ($AppOptionDebugeMode){Write-Host "Tab3:  Parsing 'button $buttonID' configurations" -ForegroundColor Gray}

    If ($buttonID -eq "01"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab3_01.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab3_01.IsEnabled = $false} Else {$WPFbtnTab3_01.IsEnabled = $true}
        $WPFbtnTextTab3_01.Text = $button.Name
        $WPFbtnTab3_01.Background = $button.bgcolor
        $WPFbtnTab3_01.Foreground = $button.textcolor
        #$WPFbtnTab3_01.Add_Click({Call-btnTab3_01})
        $WPFbtnTab3_01.add_Click({
                $ButtonClicked = $WPFbtnTextTab3_01.Text
                Call-btnTab3_01
            })
    } 

    If ($buttonID -eq "02"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab3_02.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab3_02.IsEnabled = $false} Else {$WPFbtnTab3_02.IsEnabled = $true}
        $WPFbtnTextTab3_02.Text = $button.Name
        $WPFbtnTab3_02.Background = $button.bgcolor
        $WPFbtnTab3_02.Foreground = $button.textcolor
        $WPFbtnTab3_02.Add_Click({
                $ButtonClicked = $WPFbtnTextTab3_02.Text
                Call-btnTab3_02
            })
    }

    If ($buttonID -eq "03"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab3_03.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab3_03.IsEnabled = $false} Else {$WPFbtnTab3_03.IsEnabled = $true}
        $WPFbtnTextTab3_03.Text = $button.Name
        $WPFbtnTab3_03.Background = $button.bgcolor
        $WPFbtnTab3_03.Foreground = $button.textcolor
        $WPFbtnTab3_03.Add_Click({
                $ButtonClicked = $WPFbtnTextTab3_03.Text
                Call-btnTab3_03
            })
    }

    If ($buttonID -eq "04"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab3_04.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab3_04.IsEnabled = $false} Else {$WPFbtnTab3_04.IsEnabled = $true}
        $WPFbtnTextTab3_04.Text = $button.Name
        $WPFbtnTab3_04.Background = $button.bgcolor
        $WPFbtnTab3_04.Foreground = $button.textcolor
        $WPFbtnTab3_04.Add_Click({
                $ButtonClicked = $WPFbtnTextTab3_04.Text
                Call-btnTab3_04
            })
    } 

    If ($buttonID -eq "05"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab3_05.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab3_05.IsEnabled = $false} Else {$WPFbtnTab3_05.IsEnabled = $true}
        $WPFbtnTextTab3_05.Text = $button.Name
        $WPFbtnTab3_05.Background = $button.bgcolor
        $WPFbtnTab3_05.Foreground = $button.textcolor
        $WPFbtnTab3_05.Add_Click({
                $ButtonClicked = $WPFbtnTextTab3_05.Text
                Call-btnTab3_05
             })
    } 

    If ($buttonID -eq "06"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab3_06.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab3_06.IsEnabled = $false} Else {$WPFbtnTab3_06.IsEnabled = $true}
        $WPFbtnTextTab3_06.Text = $button.Name
        $WPFbtnTab3_06.Background = $button.bgcolor
        $WPFbtnTab3_06.Foreground = $button.textcolor
        $WPFbtnTab3_06.Add_Click({
                $ButtonClicked = $WPFbtnTextTab3_06.Text
                Call-btnTab3_06
            })
    } 

    If ($buttonID -eq "07"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab3_07.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab3_07.IsEnabled = $false} Else {$WPFbtnTab3_07.IsEnabled = $true}
        $WPFbtnTextTab3_07.Text = $button.Name
        $WPFbtnTab3_07.Background = $button.bgcolor
        $WPFbtnTab3_07.Foreground = $button.textcolor
        $WPFbtnTab3_07.Add_Click({
                $ButtonClicked = $WPFbtnTextTab3_07.Text
                Call-btnTab3_07
            })
    } 

    If ($buttonID -eq "08"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab3_08.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab3_08.IsEnabled = $false} Else {$WPFbtnTab3_08.IsEnabled = $true}
        $WPFbtnTextTab3_08.Text = $button.Name
        $WPFbtnTab3_08.Background = $button.bgcolor
        $WPFbtnTab3_08.Foreground = $button.textcolor
        $WPFbtnTab3_08.Add_Click({
                $ButtonClicked = $WPFbtnTextTab3_08.Text
                Call-btnTab3_08
            })
    } 

    If ($buttonID -eq "09"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab3_09.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab3_09.IsEnabled = $false} Else {$WPFbtnTab3_09.IsEnabled = $true}
        $WPFbtnTextTab3_09.Text = $button.Name
        $WPFbtnTab3_09.Background = $button.bgcolor
        $WPFbtnTab3_09.Foreground = $button.textcolor
        $WPFbtnTab3_09.Add_Click({
                $ButtonClicked = $WPFbtnTextTab3_09.Text
                Call-btnTab3_09
            })
    } 

    If ($buttonID -eq "10"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab3_10.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab3_10.IsEnabled = $false} Else {$WPFbtnTab3_10.IsEnabled = $true}
        $WPFbtnTextTab3_10.Text = $button.Name
        $WPFbtnTab3_10.Background = $button.bgcolor
        $WPFbtnTab3_10.Foreground = $button.textcolor
        $WPFbtnTab3_10.Add_Click({
                $ButtonClicked = $WPFbtnTextTab3_10.Text
                Call-btnTab3_10
            })
    } 

    If ($buttonID -eq "11"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab3_11.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab3_11.IsEnabled = $false} Else {$WPFbtnTab3_11.IsEnabled = $true}
        $WPFbtnTextTab3_11.Text = $button.Name
        $WPFbtnTab3_11.Background = $button.bgcolor
        $WPFbtnTab3_11.Foreground = $button.textcolor
        $WPFbtnTab3_11.Add_Click({
                $ButtonClicked = $WPFbtnTextTab3_11.Text
                Call-btnTab3_11
            })
    } 

    If ($buttonID -eq "12"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab3_12.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab3_12.IsEnabled = $false} Else {$WPFbtnTab3_12.IsEnabled = $true}
        $WPFbtnTextTab3_12.Text = $button.Name
        $WPFbtnTab3_12.Background = $button.bgcolor
        $WPFbtnTab3_12.Foreground = $button.textcolor
        $WPFbtnTab3_12.Add_Click({
                $ButtonClicked = $WPFbtnTextTab3_12.Text
                Call-btnTab3_12
            })
    } 

    If ($buttonID -eq "13"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab3_13.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab3_13.IsEnabled = $false} Else {$WPFbtnTab3_13.IsEnabled = $true}
        $WPFbtnTextTab3_13.Text = $button.Name
        $WPFbtnTab3_13.Background = $button.bgcolor
        $WPFbtnTab3_13.Foreground = $button.textcolor
        $WPFbtnTab3_13.Add_Click({
                $ButtonClicked = $WPFbtnTextTab3_13.Text
                Call-btnTab3_13
            })
    } 
    If ($buttonID -eq "14"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab3_14.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab3_14.IsEnabled = $false} Else {$WPFbtnTab3_14.IsEnabled = $true}
        $WPFbtnTextTab3_14.Text = $button.Name
        $WPFbtnTab3_14.Background = $button.bgcolor
        $WPFbtnTab3_14.Foreground = $button.textcolor
        $WPFbtnTab3_14.Add_Click({
                $ButtonClicked = $WPFbtnTextTab3_14.Text
                Call-btnTab3_14
            })
    } 

    If ($buttonID -eq "15"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab3_15.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab3_15.IsEnabled = $false} Else {$WPFbtnTab3_15.IsEnabled = $true}
        $WPFbtnTextTab3_15.Text = $button.Name
        $WPFbtnTab3_15.Background = $button.bgcolor
        $WPFbtnTab3_15.Foreground = $button.textcolor
        $WPFbtnTab3_15.Add_Click({
                $ButtonClicked = $WPFbtnTextTab3_15.Text
                Call-btnTab3_15
            })
    } 

    If ($buttonID -eq "16"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab3_16.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab3_16.IsEnabled = $false} Else {$WPFbtnTab3_16.IsEnabled = $true}
        $WPFbtnTextTab3_16.Text = $button.Name
        $WPFbtnTab3_16.Background = $button.bgcolor
        $WPFbtnTab3_16.Foreground = $button.textcolor
        $WPFbtnTab3_16.Add_Click({
                $ButtonClicked = $WPFbtnTextTab3_16.Text
                Call-btnTab3_16
            })
    } 

    If ($buttonID -eq "17"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab3_17.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab3_17.IsEnabled = $false} Else {$WPFbtnTab3_17.IsEnabled = $true}
        $WPFbtnTextTab3_17.Text = $button.Name
        $WPFbtnTab3_17.Background = $button.bgcolor
        $WPFbtnTab3_17.Foreground = $button.textcolor
        $WPFbtnTab3_17.Add_Click({
                $ButtonClicked = $WPFbtnTextTab3_17.Text
                Call-btnTab3_17
            })
    } 

    If ($buttonID -eq "18"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab3_18.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab3_18.IsEnabled = $false} Else {$WPFbtnTab3_18.IsEnabled = $true}
        $WPFbtnTextTab3_18.Text = $button.Name
        $WPFbtnTab3_18.Background = $button.bgcolor
        $WPFbtnTab3_18.Foreground = $button.textcolor
        $WPFbtnTab3_18.Add_Click({
                $ButtonClicked = $WPFbtnTextTab3_18.Text
                Call-btnTab3_18
            })
    } 

    If ($buttonID -eq "19"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab3_19.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab3_19.IsEnabled = $false} Else {$WPFbtnTab3_19.IsEnabled = $true}
        $WPFbtnTextTab3_19.Text = $button.Name
        $WPFbtnTab3_19.Background = $button.bgcolor
        $WPFbtnTab3_19.Foreground = $button.textcolor
        $WPFbtnTab3_19.Add_Click({
                $ButtonClicked = $WPFbtnTextTab3_19.Text
                Call-btnTab3_19
            })
    } 

    If ($buttonID -eq "20"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab3_20.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab3_20.IsEnabled = $false} Else {$WPFbtnTab3_20.IsEnabled = $true}
        $WPFbtnTextTab3_20.Text = $button.Name
        $WPFbtnTab3_20.Background = $button.bgcolor
        $WPFbtnTab3_20.Foreground = $button.textcolor
        $WPFbtnTab3_20.Add_Click({
                $ButtonClicked = $WPFbtnTextTab3_20.Text
                Call-btnTab3_20
            })
    } 

    If ($buttonID -eq "21"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab3_21.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab3_21.IsEnabled = $false} Else {$WPFbtnTab3_21.IsEnabled = $true}
        $WPFbtnTextTab3_21.Text = $button.Name
        $WPFbtnTab3_21.Background = $button.bgcolor
        $WPFbtnTab3_21.Foreground = $button.textcolor
        $WPFbtnTab3_21.Add_Click({
                $ButtonClicked = $WPFbtnTextTab3_21.Text
                Call-btnTab3_21
            })
    } 

    If ($buttonID -eq "22"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab3_22.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab3_22.IsEnabled = $false} Else {$WPFbtnTab3_22.IsEnabled = $true}
        $WPFbtnTextTab3_22.Text = $button.Name
        $WPFbtnTab3_22.Background = $button.bgcolor
        $WPFbtnTab3_22.Foreground = $button.textcolor
        $WPFbtnTab3_22.Add_Click({
                $ButtonClicked = $WPFbtnTextTab3_22.Text
                Call-btnTab3_22
            })
    } 

    If ($buttonID -eq "23"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab3_23.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab3_23.IsEnabled = $false} Else {$WPFbtnTab3_23.IsEnabled = $true}
        $WPFbtnTextTab3_23.Text = $button.Name
        $WPFbtnTab3_23.Background = $button.bgcolor
        $WPFbtnTab3_23.Foreground = $button.textcolor
        $WPFbtnTab3_23.Add_Click({
                $ButtonClicked = $WPFbtnTextTab3_23.Text
                Call-btnTab3_23
            })
    } 

    If ($buttonID -eq "24"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab3_24.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab3_24.IsEnabled = $false} Else {$WPFbtnTab3_24.IsEnabled = $true}
        $WPFbtnTextTab3_24.Text = $button.Name
        $WPFbtnTab3_24.Background = $button.bgcolor
        $WPFbtnTab3_24.Foreground = $button.textcolor
        $WPFbtnTab3_24.Add_Click({
                $ButtonClicked = $WPFbtnTextTab3_24.Text
                Call-btnTab3_24
            })
    } 

    If ($buttonID -eq "25"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab3_25.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab3_25.IsEnabled = $false} Else {$WPFbtnTab3_25.IsEnabled = $true}
        $WPFbtnTextTab3_25.Text = $button.Name
        $WPFbtnTab3_25.Background = $button.bgcolor
        $WPFbtnTab3_25.Foreground = $button.textcolor
        $WPFbtnTab3_25.Add_Click({
                $ButtonClicked = $WPFbtnTextTab3_25.Text
                Call-btnTab3_25
            })
    } 

    If ($buttonID -eq "26"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab3_26.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab3_26.IsEnabled = $false} Else {$WPFbtnTab3_26.IsEnabled = $true}
        $WPFbtnTextTab3_26.Text = $button.Name
        $WPFbtnTab3_26.Background = $button.bgcolor
        $WPFbtnTab3_26.Foreground = $button.textcolor
        $WPFbtnTab3_26.Add_Click({
                $ButtonClicked = $WPFbtnTextTab3_26.Text
                Call-btnTab3_26
            })
    } 

}
If ($ConfigTab3.enable -eq "false"){$WPFTab3.Visibility = 'Hidden'} Else {$WPFTab3.Visibility = 'Visible'}