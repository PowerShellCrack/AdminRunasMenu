##*=============================================
##* LOAD TAB 2 FROM CONFIG
##*=============================================
$ConfigTab5 = $AppMenuTabandButtons.tab[4]
If ($HashNames.Keys -eq "Tab5"){
    Write-Host "Found Tab5 section in Names File" -ForegroundColor Gray
    $Tab5HashNames = $HashNames.Tab5
    [string]$Tab5HashList = $Tab5HashNames| out-string -stream
    write-Host "`nNames found in list: `n$Tab5HashList"
}
Else{
    Write-Host "No Tab5 section found in names file" -ForegroundColor Gray
}

$WPFbtnTab5Name1List.add_Click({Save-ComputerList -TitleDesc "List of Hosts" -TabObject Tab5})
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
function Call-btnTab5_01{
    $VPX = "$envProgramFilesX86\VMware\Infrastructure\Virtual Infrastructure Client\Launcher\VpxClient.exe"
    Start-ButtonProcess -Path $VPX -OutputTab Tab5 -WindowStyle Normal
}

function Call-btnTab5_02{
    $VMM = "$envProgramFiles\Microsoft System Center 2012 Virtual Machine Manager\bin\VmmAdminUI.exe"
    Start-ButtonProcess -Path $VMM -OutputTab Tab5 -WindowStyle Normal
}

function Call-btnTab5_03{
    $NetAppSysMgr = "$envProgramFiles\NetApp\OnCommand System Manager\SystemManager.exe"
    Start-ButtonProcess -Path $NetAppSysMgr -OutputTab Tab5 -WindowStyle Normal
}

function Call-btnTab5_04{

}

function Call-btnTab5_05{

}

function Call-btnTab5_06{

}

# Set of 4 small buttons under left column
function Call-btnTab5_07{
    Start-ButtonProcess -Path "%windir%\System32\virtmgmt.msc" -OutputTab Tab5 -WindowStyle Normal
}

function Call-btnTab5_08{
    
}


function Call-btnTab5_09{

}


function Call-btnTab5_10{

}


# Set of 4 large buttons under right column
function Call-btnTab5_11{

}

function Call-btnTab5_12{

}

function Call-btnTab5_13{

}

function Call-btnTab5_14{

}

# Set of 12 small buttons under right column
function Call-btnTab5_15{
    Start-ButtonProcess -Path "$envProgramFilesX86\VMware\VMware Horizon View Client\vmware-view.exe" -OutputTab Tab5 -WindowStyle Normal
}

function Call-btnTab5_16{

}

function Call-btnTab5_17{

}

function Call-btnTab5_18{
    Start-ButtonProcess -Path "$envWinDir\system32\mstsc.exe" -Parameters ("/v:" + $WPFtxtTab5Name1.Text) -OutputTab Tab4 -CustomRunMsg "Opening Remote Desktop Connection for: $($WPFtxtTab5Name1.Text)" -NeverRunAs -WindowStyle Normal
}

function Call-btnTab5_19{

}

function Call-btnTab5_20{

}

function Call-btnTab5_21{

}

function Call-btnTab5_22{
    If (Test-Path "$envWinDir\system32\putty.exe"){
        $PuttyPath = "$envWinDir\system32\putty.exe"
    }
    If (Test-Path $PuttyPath){
        $PuttyPath = "$UtilPath\putty.exe"
    }
    Else{
        $PuttyPath = "$UtilPath\putty.exe"
    }

    If (!$WPFtxtTab5Name1.Text){
        Start-ButtonProcess -ProcessCall exe -FilePath $PuttyPath -CustomRunMsg "Opening [$ButtonClicked], change host and try again to connnect $ButtonClicked to a host'." -OutputTab tab5 -WindowStyle Normal 
    }
    Else{
        If (Test-Connection -ComputerName $WPFtxtTab1Name1.Text -Quiet){
             Start-ButtonProcess -ProcessCall exe -FilePath $PuttyPath -Parameters $WPFtxtTab5Name1.Text -CustomRunMsg "connecting [$ButtonClicked] to: $($WPFtxtTab5Name1.Text)" -OutputTab Tab5 -WindowStyle Normal
        }
        Else {
            Write-OutputBox -OutputBoxMessage "Unable to ping host: $($WPFtxtTab5Name1.Text), host may be offline." -Type "ERROR: " -Object Tab5
        }
    }
}

function Call-btnTab5_23{

}

function Call-btnTab5_24{

}

function Call-btnTab5_25{

}

function Call-btnTab5_26{

}


##*=============================================
##* TAB 1 OTHER FUNCTIONS
##*=============================================

$WPFtxtTab5Name1.Text = ""


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
    If ($AppOptionDebugeMode){Write-Host "Tab5:  Parsing 'button $buttonID' configurations" -ForegroundColor Gray}

    If ($buttonID -eq "01"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab5_01.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab5_01.IsEnabled = $false} Else {$WPFbtnTab5_01.IsEnabled = $true}
        $WPFbtnTextTab5_01.Text = $button.Name
        $WPFbtnTab5_01.Background = $button.bgcolor
        $WPFbtnTab5_01.Foreground = $button.textcolor
        #$WPFbtnTab5_01.Add_Click({Call-btnTab5_01})
        $WPFbtnTab5_01.add_Click({
                $ButtonClicked = $WPFbtnTextTab5_01.Text
                Call-btnTab5_01
            })
    } 

    If ($buttonID -eq "02"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab5_02.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab5_02.IsEnabled = $false} Else {$WPFbtnTab5_02.IsEnabled = $true}
        $WPFbtnTextTab5_02.Text = $button.Name
        $WPFbtnTab5_02.Background = $button.bgcolor
        $WPFbtnTab5_02.Foreground = $button.textcolor
        $WPFbtnTab5_02.Add_Click({
                $ButtonClicked = $WPFbtnTextTab5_02.Text
                Call-btnTab5_02
            })
    }

    If ($buttonID -eq "03"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab5_03.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab5_03.IsEnabled = $false} Else {$WPFbtnTab5_03.IsEnabled = $true}
        $WPFbtnTextTab5_03.Text = $button.Name
        $WPFbtnTab5_03.Background = $button.bgcolor
        $WPFbtnTab5_03.Foreground = $button.textcolor
        $WPFbtnTab5_03.Add_Click({
                $ButtonClicked = $WPFbtnTextTab5_03.Text
                Call-btnTab5_03
            })
    }

    If ($buttonID -eq "04"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab5_04.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab5_04.IsEnabled = $false} Else {$WPFbtnTab5_04.IsEnabled = $true}
        $WPFbtnTextTab5_04.Text = $button.Name
        $WPFbtnTab5_04.Background = $button.bgcolor
        $WPFbtnTab5_04.Foreground = $button.textcolor
        $WPFbtnTab5_04.Add_Click({
                $ButtonClicked = $WPFbtnTextTab5_04.Text
                Call-btnTab5_04
            })
    } 

    If ($buttonID -eq "05"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab5_05.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab5_05.IsEnabled = $false} Else {$WPFbtnTab5_05.IsEnabled = $true}
        $WPFbtnTextTab5_05.Text = $button.Name
        $WPFbtnTab5_05.Background = $button.bgcolor
        $WPFbtnTab5_05.Foreground = $button.textcolor
        $WPFbtnTab5_05.Add_Click({
                $ButtonClicked = $WPFbtnTextTab5_05.Text
                Call-btnTab5_05
             })
    } 

    If ($buttonID -eq "06"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab5_06.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab5_06.IsEnabled = $false} Else {$WPFbtnTab5_06.IsEnabled = $true}
        $WPFbtnTextTab5_06.Text = $button.Name
        $WPFbtnTab5_06.Background = $button.bgcolor
        $WPFbtnTab5_06.Foreground = $button.textcolor
        $WPFbtnTab5_06.Add_Click({
                $ButtonClicked = $WPFbtnTextTab5_06.Text
                Call-btnTab5_06
            })
    } 

    If ($buttonID -eq "07"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab5_07.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab5_07.IsEnabled = $false} Else {$WPFbtnTab5_07.IsEnabled = $true}
        $WPFbtnTextTab5_07.Text = $button.Name
        $WPFbtnTab5_07.Background = $button.bgcolor
        $WPFbtnTab5_07.Foreground = $button.textcolor
        $WPFbtnTab5_07.Add_Click({
                $ButtonClicked = $WPFbtnTextTab5_07.Text
                Call-btnTab5_07
            })
    } 

    If ($buttonID -eq "08"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab5_08.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab5_08.IsEnabled = $false} Else {$WPFbtnTab5_08.IsEnabled = $true}
        $WPFbtnTextTab5_08.Text = $button.Name
        $WPFbtnTab5_08.Background = $button.bgcolor
        $WPFbtnTab5_08.Foreground = $button.textcolor
        $WPFbtnTab5_08.Add_Click({
                $ButtonClicked = $WPFbtnTextTab5_08.Text
                Call-btnTab5_08
            })
    } 

    If ($buttonID -eq "09"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab5_09.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab5_09.IsEnabled = $false} Else {$WPFbtnTab5_09.IsEnabled = $true}
        $WPFbtnTextTab5_09.Text = $button.Name
        $WPFbtnTab5_09.Background = $button.bgcolor
        $WPFbtnTab5_09.Foreground = $button.textcolor
        $WPFbtnTab5_09.Add_Click({
                $ButtonClicked = $WPFbtnTextTab5_09.Text
                Call-btnTab5_09
            })
    } 

    If ($buttonID -eq "10"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab5_10.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab5_10.IsEnabled = $false} Else {$WPFbtnTab5_10.IsEnabled = $true}
        $WPFbtnTextTab5_10.Text = $button.Name
        $WPFbtnTab5_10.Background = $button.bgcolor
        $WPFbtnTab5_10.Foreground = $button.textcolor
        $WPFbtnTab5_10.Add_Click({
                $ButtonClicked = $WPFbtnTextTab5_10.Text
                Call-btnTab5_10
            })
    } 

    If ($buttonID -eq "11"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab5_11.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab5_11.IsEnabled = $false} Else {$WPFbtnTab5_11.IsEnabled = $true}
        $WPFbtnTextTab5_11.Text = $button.Name
        $WPFbtnTab5_11.Background = $button.bgcolor
        $WPFbtnTab5_11.Foreground = $button.textcolor
        $WPFbtnTab5_11.Add_Click({
                $ButtonClicked = $WPFbtnTextTab5_11.Text
                Call-btnTab5_11
            })
    } 

    If ($buttonID -eq "12"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab5_12.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab5_12.IsEnabled = $false} Else {$WPFbtnTab5_12.IsEnabled = $true}
        $WPFbtnTextTab5_12.Text = $button.Name
        $WPFbtnTab5_12.Background = $button.bgcolor
        $WPFbtnTab5_12.Foreground = $button.textcolor
        $WPFbtnTab5_12.Add_Click({
                $ButtonClicked = $WPFbtnTextTab5_12.Text
                Call-btnTab5_12
            })
    } 

    If ($buttonID -eq "13"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab5_13.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab5_13.IsEnabled = $false} Else {$WPFbtnTab5_13.IsEnabled = $true}
        $WPFbtnTextTab5_13.Text = $button.Name
        $WPFbtnTab5_13.Background = $button.bgcolor
        $WPFbtnTab5_13.Foreground = $button.textcolor
        $WPFbtnTab5_13.Add_Click({
                $ButtonClicked = $WPFbtnTextTab5_13.Text
                Call-btnTab5_13
            })
    } 
    If ($buttonID -eq "14"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab5_14.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab5_14.IsEnabled = $false} Else {$WPFbtnTab5_14.IsEnabled = $true}
        $WPFbtnTextTab5_14.Text = $button.Name
        $WPFbtnTab5_14.Background = $button.bgcolor
        $WPFbtnTab5_14.Foreground = $button.textcolor
        $WPFbtnTab5_14.Add_Click({
                $ButtonClicked = $WPFbtnTextTab5_14.Text
                Call-btnTab5_14
            })
    } 

    If ($buttonID -eq "15"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab5_15.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab5_15.IsEnabled = $false} Else {$WPFbtnTab5_15.IsEnabled = $true}
        $WPFbtnTextTab5_15.Text = $button.Name
        $WPFbtnTab5_15.Background = $button.bgcolor
        $WPFbtnTab5_15.Foreground = $button.textcolor
        $WPFbtnTab5_15.Add_Click({
                $ButtonClicked = $WPFbtnTextTab5_15.Text
                Call-btnTab5_15
            })
    } 

    If ($buttonID -eq "16"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab5_16.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab5_16.IsEnabled = $false} Else {$WPFbtnTab5_16.IsEnabled = $true}
        $WPFbtnTextTab5_16.Text = $button.Name
        $WPFbtnTab5_16.Background = $button.bgcolor
        $WPFbtnTab5_16.Foreground = $button.textcolor
        $WPFbtnTab5_16.Add_Click({
                $ButtonClicked = $WPFbtnTextTab5_16.Text
                Call-btnTab5_16
            })
    } 

    If ($buttonID -eq "17"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab5_17.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab5_17.IsEnabled = $false} Else {$WPFbtnTab5_17.IsEnabled = $true}
        $WPFbtnTextTab5_17.Text = $button.Name
        $WPFbtnTab5_17.Background = $button.bgcolor
        $WPFbtnTab5_17.Foreground = $button.textcolor
        $WPFbtnTab5_17.Add_Click({
                $ButtonClicked = $WPFbtnTextTab5_17.Text
                Call-btnTab5_17
            })
    } 

    If ($buttonID -eq "18"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab5_18.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab5_18.IsEnabled = $false} Else {$WPFbtnTab5_18.IsEnabled = $true}
        $WPFbtnTextTab5_18.Text = $button.Name
        $WPFbtnTab5_18.Background = $button.bgcolor
        $WPFbtnTab5_18.Foreground = $button.textcolor
        $WPFbtnTab5_18.Add_Click({
                $ButtonClicked = $WPFbtnTextTab5_18.Text
                Call-btnTab5_18
            })
    } 

    If ($buttonID -eq "19"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab5_19.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab5_19.IsEnabled = $false} Else {$WPFbtnTab5_19.IsEnabled = $true}
        $WPFbtnTextTab5_19.Text = $button.Name
        $WPFbtnTab5_19.Background = $button.bgcolor
        $WPFbtnTab5_19.Foreground = $button.textcolor
        $WPFbtnTab5_19.Add_Click({
                $ButtonClicked = $WPFbtnTextTab5_19.Text
                Call-btnTab5_19
            })
    } 

    If ($buttonID -eq "20"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab5_20.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab5_20.IsEnabled = $false} Else {$WPFbtnTab5_20.IsEnabled = $true}
        $WPFbtnTextTab5_20.Text = $button.Name
        $WPFbtnTab5_20.Background = $button.bgcolor
        $WPFbtnTab5_20.Foreground = $button.textcolor
        $WPFbtnTab5_20.Add_Click({
                $ButtonClicked = $WPFbtnTextTab5_20.Text
                Call-btnTab5_20
            })
    } 

    If ($buttonID -eq "21"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab5_21.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab5_21.IsEnabled = $false} Else {$WPFbtnTab5_21.IsEnabled = $true}
        $WPFbtnTextTab5_21.Text = $button.Name
        $WPFbtnTab5_21.Background = $button.bgcolor
        $WPFbtnTab5_21.Foreground = $button.textcolor
        $WPFbtnTab5_21.Add_Click({
                $ButtonClicked = $WPFbtnTextTab5_21.Text
                Call-btnTab5_21
            })
    } 

    If ($buttonID -eq "22"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab5_22.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab5_22.IsEnabled = $false} Else {$WPFbtnTab5_22.IsEnabled = $true}
        $WPFbtnTextTab5_22.Text = $button.Name
        $WPFbtnTab5_22.Background = $button.bgcolor
        $WPFbtnTab5_22.Foreground = $button.textcolor
        $WPFbtnTab5_22.Add_Click({
                $ButtonClicked = $WPFbtnTextTab5_22.Text
                Call-btnTab5_22
            })
    } 

    If ($buttonID -eq "23"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab5_23.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab5_23.IsEnabled = $false} Else {$WPFbtnTab5_23.IsEnabled = $true}
        $WPFbtnTextTab5_23.Text = $button.Name
        $WPFbtnTab5_23.Background = $button.bgcolor
        $WPFbtnTab5_23.Foreground = $button.textcolor
        $WPFbtnTab5_23.Add_Click({
                $ButtonClicked = $WPFbtnTextTab5_23.Text
                Call-btnTab5_23
            })
    } 

    If ($buttonID -eq "24"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab5_24.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab5_24.IsEnabled = $false} Else {$WPFbtnTab5_24.IsEnabled = $true}
        $WPFbtnTextTab5_24.Text = $button.Name
        $WPFbtnTab5_24.Background = $button.bgcolor
        $WPFbtnTab5_24.Foreground = $button.textcolor
        $WPFbtnTab5_24.Add_Click({
                $ButtonClicked = $WPFbtnTextTab5_24.Text
                Call-btnTab5_24
            })
    } 

    If ($buttonID -eq "25"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab5_25.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab5_25.IsEnabled = $false} Else {$WPFbtnTab5_25.IsEnabled = $true}
        $WPFbtnTextTab5_25.Text = $button.Name
        $WPFbtnTab5_25.Background = $button.bgcolor
        $WPFbtnTab5_25.Foreground = $button.textcolor
        $WPFbtnTab5_25.Add_Click({
                $ButtonClicked = $WPFbtnTextTab5_25.Text
                Call-btnTab5_25
            })
    } 

    If ($buttonID -eq "26"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab5_26.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab5_26.IsEnabled = $false} Else {$WPFbtnTab5_26.IsEnabled = $true}
        $WPFbtnTextTab5_26.Text = $button.Name
        $WPFbtnTab5_26.Background = $button.bgcolor
        $WPFbtnTab5_26.Foreground = $button.textcolor
        $WPFbtnTab5_26.Add_Click({
                $ButtonClicked = $WPFbtnTextTab5_26.Text
                Call-btnTab5_26
            })
    } 

}
If ($ConfigTab5.enable -eq "false"){$WPFTab5.Visibility = 'Hidden'} Else {$WPFTab5.Visibility = 'Visible'}