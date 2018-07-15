##*=============================================
##* LOAD TAB 2 FROM CONFIG
##*=============================================
$ConfigTab2 = $AppMenuTabandButtons.tab[1]
If ($HashNames.Keys -eq "Tab2"){
    Write-Host "Found Tab2 section in Names File" -ForegroundColor Gray
    $Tab2HashNames = $HashNames.Tab2
    [string]$Tab2HashList = $Tab2HashNames| out-string -stream
    write-Host "`nNames found in list: `n$Tab2HashList"
}
Else{
    Write-Host "No Tab2 section found in names file" -ForegroundColor Gray
}

If($IsMachinePartOfDomain){$WPFtxtTab2Name1.Text = $envMachineADDomain}Else{$WPFtxtTab2Name1.Text = $envComputerName}

$WPFbtnTab2Name2List.add_Click({Save-ComputerList -TitleDesc "List of Domain Controllers" -TabObject Tab2})
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
          Start-ButtonProcess -Alias "$ButtonClicked" -Path "$envWinDir\system32\mstsc.exe" -Parameters ("/v:" + $WPFtxtBoxRemote.Text) -OutputTab tab1 -WindowStyle Normal

       EXAMPLE (PS1): 
          Start-ButtonProcess -ProcessCall ps1 -File "Start-PoshPAIG.ps1" -WorkingDirectory "$($scriptRoot + "\Scripts\PoshPAIG_2_1_5")" -CreateNoWindow

#>
# Set of 6 large buttons under left column
function Call-btnTab2_01{
    $ADMSC = "$envWinDir\system32\dsa.msc"
    If (($AppOptionRSATCheck) -and ($WPFtxtRSAT.Text -eq 'Yes') -or (!$AppOptionRSATCheck)){
        If ($WPFtxtTab2Name2.Text){
            Start-ButtonProcess -Path "$ADMSC" -Parameters ("/server=" + $WPFtxtTab2Name2.Text) -CustomRunMsg "Opening [$ButtonClicked] on DC: $($WPFtxtTab2Name2.Text)" -OutputTab Tab2 -WindowStyle Normal
        }
        ElseIf($WPFtxtTab2Name1.Text){
            Start-ButtonProcess -Path "$ADMSC" -Parameters ("/domain=" + $WPFtxtTab2Name1.Text) -CustomRunMsg "Opening [$ButtonClicked] for Domain: $($WPFtxtTab2Name1.Text)" -OutputTab Tab2 -WindowStyle Normal
        }
        Else{
             Start-ButtonProcess -Path "$ADMSC" -CustomRunMsg "Opening [$ButtonClicked]" -OutputTab Tab2 -WindowStyle Normal
        }
    }
    Else{
        Write-OutputBox -OutputBoxMessage "Unable to open [$ButtonClicked], RSAT is not detected or may not be installed" -Type "ERROR: " -Object Tab2
    }
}

function Call-btnTab2_02{
    $ADMSC = "$envWinDir\system32\dssite.msc"
    If (($AppOptionRSATCheck) -and ($WPFtxtRSAT.Text -eq 'Yes') -or (!$AppOptionRSATCheck)){
        If ($WPFtxtTab2Name1.Text){
            Start-ButtonProcess -Path "$ADMSC" -Parameters ("/domain=" + $WPFtxtTab2Name1.Text) -CustomRunMsg "Opening [$ButtonClicked] for: $($WPFtxtTab2Name1.Text)" -OutputTab Tab2 -WindowStyle Normal
        }
        Else{
            Start-ButtonProcess -Path "$ADMSC" -CustomRunMsg "Opening [$ButtonClicked]" -OutputTab Tab2 -WindowStyle Normal
        }
    }
    Else{
        Write-OutputBox -OutputBoxMessage "Unable to open [$ButtonClicked], RSAT is not detected or may not be installed" -Type "ERROR: " -Object Tab2
    }
}

function Call-btnTab2_03{
    $ADMSC = "$envWinDir\system32\gpmc.msc"
    If (($AppOptionRSATCheck) -and ($WPFtxtRSAT.Text -eq 'Yes') -or (!$AppOptionRSATCheck)){
        If ($WPFtxtTab2Name2.Text){
            Start-ButtonProcess -Path "$ADMSC" -Parameters ("/server=" + $WPFtxtTab2Name2.Text) -CustomRunMsg "Opening [$ButtonClicked] on DC: $($WPFtxtTab2Name2.Text)" -OutputTab Tab2 -WindowStyle Normal
        }
        ElseIf ($WPFtxtTab2Name1.Text){
            Start-ButtonProcess -Path "$ADMSC" -Parameters ("/domain=" + $WPFtxtTab2Name1.Text) -CustomRunMsg "Opening [$ButtonClicked] for Domain: $($WPFtxtTab2Name1.Text)" -OutputTab Tab2 -WindowStyle Normal
        }
        Else{
            Start-ButtonProcess -Path "$ADMSC" -CustomRunMsg "Opening [$ButtonClicked]" -OutputTab Tab2 -WindowStyle Normal
        }
    }
    Else{
        Write-OutputBox -OutputBoxMessage "Unable to open [$ButtonClicked], RSAT is not detected or may not be installed" -Type "ERROR: " -Object Tab2
    }
}

function Call-btnTab2_04{

}

function Call-btnTab2_05{

}

function Call-btnTab2_06{

}

# Set of 4 small buttons under left column
function Call-btnTab2_07{
    
}

function Call-btnTab2_08{
    $ADMSC = "$envWinDir\system32\dnsmgmt.msc"
    If (($AppOptionRSATCheck) -and ($WPFtxtRSAT.Text -eq 'Yes') -or (!$AppOptionRSATCheck)){
        If ($WPFtxtTab2Name2.Text){
            Start-ButtonProcess -Path "$ADMSC" -Parameters ("/ComputerName " + $WPFtxtTab2Name2.Text) -CustomRunMsg "Opening [$ButtonClicked] on DNS Server: $($WPFtxtTab2Name2.Text)" -OutputTab Tab2 -WindowStyle Normal
        }
        ElseIf ($WPFtxtTab2Name1.Text){
            Start-ButtonProcess -Path "$ADMSC" -Parameters ("/ComputerName " + $WPFtxtTab2Name1.Text) -CustomRunMsg "Opening [$ButtonClicked] for Domain: $($WPFtxtTab2Name1.Text)" -OutputTab Tab2 -WindowStyle Normal
        }
        Else{
            Start-ButtonProcess -Path "$ADMSC" -CustomRunMsg "Opening [$ButtonClicked]" -OutputTab Tab2 -WindowStyle Normal
        }
    }
    Else{
        Write-OutputBox -OutputBoxMessage "Unable to open [$ButtonClicked], RSAT is not detected or may not be installed" -Type "ERROR: " -Object Tab2
    }
}


function Call-btnTab2_09{
    $ADMSC = "$envWinDir\system32\dhcpmgmt.msc"
    If (($AppOptionRSATCheck) -and ($WPFtxtRSAT.Text -eq 'Yes') -or (!$AppOptionRSATCheck)){
        If ($WPFtxtTab2Name2.Text){
            Start-ButtonProcess -Path "$ADMSC" -Parameters ("/ComputerName " + $WPFtxtTab2Name2.Text) -CustomRunMsg "Opening [$ButtonClicked] on DHCP Server: $($WPFtxtTab2Name2.Text)" -OutputTab Tab2 -WindowStyle Normal
        }
        Else{
            Start-ButtonProcess -Path "$ADMSC" -CustomRunMsg "Opening [$ButtonClicked]" -OutputTab Tab2 -WindowStyle Normal
        }
    }
    Else{
        Write-OutputBox -OutputBoxMessage "Unable to open [$ButtonClicked], RSAT is not detected or may not be installed" -Type "ERROR: " -Object Tab2
    }
}


function Call-btnTab2_10{

}


# Set of 4 large buttons under right columnl
function Call-btnTab2_11{
    Start-ButtonProcess -ProcessCall module -Path ActiveDirectory -OutputTab Tab2 -WindowStyle Normal
}

function Call-btnTab2_12{
}

function Call-btnTab2_13{

}

function Call-btnTab2_14{
    
}

# Set of 12 small buttons under right column
function Call-btnTab2_15{
    Start-ButtonProcess -Path "$envWinDir\system32\ServerManager.exe" -OutputTab Tab2 -WindowStyle Normal
}

function Call-btnTab2_16{

}

function Call-btnTab2_17{

}

function Call-btnTab2_18{
    If ($Global:SelectedRunAs){
         Start-ButtonProcess -ProcessCall ps1 -File "Connect-Mstsc.ps1" -Parameters "-ComputerName $($WPFtxtTab2Name2.Text)" -OutputTab tab2 -CreateNoWindow
    }
    Else{
        Start-ButtonProcess -Path "$envWinDir\system32\mstsc.exe" -Parameters ("/v:" + $WPFtxtTab2Name2.Text) -OutputTab tab2 -CustomRunMsg "Opening Remote Desktop Connection for: $($WPFtxtTab2Name2.Text)" -NeverRunAs -WindowStyle Normal
    }
}

function Call-btnTab2_19{
}

function Call-btnTab2_20{

}

function Call-btnTab2_21{

}

function Call-btnTab2_22{

}


function Call-btnTab2_23{

}

function Call-btnTab2_24{

}

function Call-btnTab2_25{

}

function Call-btnTab2_26{

}


##*=============================================
##* TAB 2 FUNCTIONS
##*=============================================




##*=============================================
##* BUILD TAB 2 BUTTONS IF CONFIGURED
##*=============================================
$ConfigTab2_Name = $ConfigTab2.Name

$WPFTab2.Header = $ConfigTab2_Name
$WPFlblTab2Section1.Content = $ConfigTab2.section1Label
$WPFlblTab2Section2.Content = $ConfigTab2.section2Label

$ConfigTab2_btns = $ConfigTab2.button


Foreach ($button in $ConfigTab2_btns){
    
    [string]$buttonID = $button.id
    If ($AppOptionDebugeMode){Write-Host "Tab2:  Parsing 'button $buttonID' configurations" -ForegroundColor Gray}

    If ($buttonID -eq "01"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab2_01.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab2_01.IsEnabled = $false} Else {$WPFbtnTab2_01.IsEnabled = $true}
        $WPFbtnTextTab2_01.Text = $button.Name
        $WPFbtnTab2_01.Background = $button.bgcolor
        $WPFbtnTab2_01.Foreground = $button.textcolor
        #$WPFbtnTab2_01.Add_Click({Call-btnTab2_01})
        $WPFbtnTab2_01.add_Click({
                $ButtonClicked = $WPFbtnTextTab2_01.Text
                Call-btnTab2_01
            })
    } 

    If ($buttonID -eq "02"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab2_02.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab2_02.IsEnabled = $false} Else {$WPFbtnTab2_02.IsEnabled = $true}
        $WPFbtnTextTab2_02.Text = $button.Name
        $WPFbtnTab2_02.Background = $button.bgcolor
        $WPFbtnTab2_02.Foreground = $button.textcolor
        $WPFbtnTab2_02.Add_Click({
                $ButtonClicked = $WPFbtnTextTab2_02.Text
                Call-btnTab2_02
            })
    }

    If ($buttonID -eq "03"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab2_03.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab2_03.IsEnabled = $false} Else {$WPFbtnTab2_03.IsEnabled = $true}
        $WPFbtnTextTab2_03.Text = $button.Name
        $WPFbtnTab2_03.Background = $button.bgcolor
        $WPFbtnTab2_03.Foreground = $button.textcolor
        $WPFbtnTab2_03.Add_Click({
                $ButtonClicked = $WPFbtnTextTab2_03.Text
                Call-btnTab2_03
            })
    }

    If ($buttonID -eq "04"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab2_04.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab2_04.IsEnabled = $false} Else {$WPFbtnTab2_04.IsEnabled = $true}
        $WPFbtnTextTab2_04.Text = $button.Name
        $WPFbtnTab2_04.Background = $button.bgcolor
        $WPFbtnTab2_04.Foreground = $button.textcolor
        $WPFbtnTab2_04.Add_Click({
                $ButtonClicked = $WPFbtnTextTab2_04.Text
                Call-btnTab2_04
            })
    } 

    If ($buttonID -eq "05"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab2_05.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab2_05.IsEnabled = $false} Else {$WPFbtnTab2_05.IsEnabled = $true}
        $WPFbtnTextTab2_05.Text = $button.Name
        $WPFbtnTab2_05.Background = $button.bgcolor
        $WPFbtnTab2_05.Foreground = $button.textcolor
        $WPFbtnTab2_05.Add_Click({
                $ButtonClicked = $WPFbtnTextTab2_05.Text
                Call-btnTab2_05
             })
    } 

    If ($buttonID -eq "06"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab2_06.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab2_06.IsEnabled = $false} Else {$WPFbtnTab2_06.IsEnabled = $true}
        $WPFbtnTextTab2_06.Text = $button.Name
        $WPFbtnTab2_06.Background = $button.bgcolor
        $WPFbtnTab2_06.Foreground = $button.textcolor
        $WPFbtnTab2_06.Add_Click({
                $ButtonClicked = $WPFbtnTextTab2_06.Text
                Call-btnTab2_06
            })
    } 

    If ($buttonID -eq "07"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab2_07.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab2_07.IsEnabled = $false} Else {$WPFbtnTab2_07.IsEnabled = $true}
        $WPFbtnTextTab2_07.Text = $button.Name
        $WPFbtnTab2_07.Background = $button.bgcolor
        $WPFbtnTab2_07.Foreground = $button.textcolor
        $WPFbtnTab2_07.Add_Click({
                $ButtonClicked = $WPFbtnTextTab2_07.Text
                Call-btnTab2_07
            })
    } 

    If ($buttonID -eq "08"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab2_08.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab2_08.IsEnabled = $false} Else {$WPFbtnTab2_08.IsEnabled = $true}
        $WPFbtnTextTab2_08.Text = $button.Name
        $WPFbtnTab2_08.Background = $button.bgcolor
        $WPFbtnTab2_08.Foreground = $button.textcolor
        $WPFbtnTab2_08.Add_Click({
                $ButtonClicked = $WPFbtnTextTab2_08.Text
                Call-btnTab2_08
            })
    } 

    If ($buttonID -eq "09"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab2_09.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab2_09.IsEnabled = $false} Else {$WPFbtnTab2_09.IsEnabled = $true}
        $WPFbtnTextTab2_09.Text = $button.Name
        $WPFbtnTab2_09.Background = $button.bgcolor
        $WPFbtnTab2_09.Foreground = $button.textcolor
        $WPFbtnTab2_09.Add_Click({
                $ButtonClicked = $WPFbtnTextTab2_09.Text
                Call-btnTab2_09
            })
    } 

    If ($buttonID -eq "10"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab2_10.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab2_10.IsEnabled = $false} Else {$WPFbtnTab2_10.IsEnabled = $true}
        $WPFbtnTextTab2_10.Text = $button.Name
        $WPFbtnTab2_10.Background = $button.bgcolor
        $WPFbtnTab2_10.Foreground = $button.textcolor
        $WPFbtnTab2_10.Add_Click({
                $ButtonClicked = $WPFbtnTextTab2_10.Text
                Call-btnTab2_10
            })
    } 

    If ($buttonID -eq "11"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab2_11.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab2_11.IsEnabled = $false} Else {$WPFbtnTab2_11.IsEnabled = $true}
        $WPFbtnTextTab2_11.Text = $button.Name
        $WPFbtnTab2_11.Background = $button.bgcolor
        $WPFbtnTab2_11.Foreground = $button.textcolor
        $WPFbtnTab2_11.Add_Click({
                $ButtonClicked = $WPFbtnTextTab2_11.Text
                Call-btnTab2_11
            })
    } 

    If ($buttonID -eq "12"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab2_12.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab2_12.IsEnabled = $false} Else {$WPFbtnTab2_12.IsEnabled = $true}
        $WPFbtnTextTab2_12.Text = $button.Name
        $WPFbtnTab2_12.Background = $button.bgcolor
        $WPFbtnTab2_12.Foreground = $button.textcolor
        $WPFbtnTab2_12.Add_Click({
                $ButtonClicked = $WPFbtnTextTab2_12.Text
                Call-btnTab2_12
            })
    } 

    If ($buttonID -eq "13"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab2_13.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab2_13.IsEnabled = $false} Else {$WPFbtnTab2_13.IsEnabled = $true}
        $WPFbtnTextTab2_13.Text = $button.Name
        $WPFbtnTab2_13.Background = $button.bgcolor
        $WPFbtnTab2_13.Foreground = $button.textcolor
        $WPFbtnTab2_13.Add_Click({
                $ButtonClicked = $WPFbtnTextTab2_13.Text
                Call-btnTab2_13
            })
    } 
    If ($buttonID -eq "14"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab2_14.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab2_14.IsEnabled = $false} Else {$WPFbtnTab2_14.IsEnabled = $true}
        $WPFbtnTextTab2_14.Text = $button.Name
        $WPFbtnTab2_14.Background = $button.bgcolor
        $WPFbtnTab2_14.Foreground = $button.textcolor
        $WPFbtnTab2_14.Add_Click({
                $ButtonClicked = $WPFbtnTextTab2_14.Text
                Call-btnTab2_14
            })
    } 

    If ($buttonID -eq "15"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab2_15.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab2_15.IsEnabled = $false} Else {$WPFbtnTab2_15.IsEnabled = $true}
        $WPFbtnTextTab2_15.Text = $button.Name
        $WPFbtnTab2_15.Background = $button.bgcolor
        $WPFbtnTab2_15.Foreground = $button.textcolor
        $WPFbtnTab2_15.Add_Click({
                $ButtonClicked = $WPFbtnTextTab2_15.Text
                Call-btnTab2_15
            })
    } 

    If ($buttonID -eq "16"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab2_16.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab2_16.IsEnabled = $false} Else {$WPFbtnTab2_16.IsEnabled = $true}
        $WPFbtnTextTab2_16.Text = $button.Name
        $WPFbtnTab2_16.Background = $button.bgcolor
        $WPFbtnTab2_16.Foreground = $button.textcolor
        $WPFbtnTab2_16.Add_Click({
                $ButtonClicked = $WPFbtnTextTab2_16.Text
                Call-btnTab2_16
            })
    } 

    If ($buttonID -eq "17"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab2_17.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab2_17.IsEnabled = $false} Else {$WPFbtnTab2_17.IsEnabled = $true}
        $WPFbtnTextTab2_17.Text = $button.Name
        $WPFbtnTab2_17.Background = $button.bgcolor
        $WPFbtnTab2_17.Foreground = $button.textcolor
        $WPFbtnTab2_17.Add_Click({
                $ButtonClicked = $WPFbtnTextTab2_17.Text
                Call-btnTab2_17
            })
    } 

    If ($buttonID -eq "18"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab2_18.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab2_18.IsEnabled = $false} Else {$WPFbtnTab2_18.IsEnabled = $true}
        $WPFbtnTextTab2_18.Text = $button.Name
        $WPFbtnTab2_18.Background = $button.bgcolor
        $WPFbtnTab2_18.Foreground = $button.textcolor
        $WPFbtnTab2_18.Add_Click({
                $ButtonClicked = $WPFbtnTextTab2_18.Text
                Call-btnTab2_18
            })
    } 

    If ($buttonID -eq "19"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab2_19.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab2_19.IsEnabled = $false} Else {$WPFbtnTab2_19.IsEnabled = $true}
        $WPFbtnTextTab2_19.Text = $button.Name
        $WPFbtnTab2_19.Background = $button.bgcolor
        $WPFbtnTab2_19.Foreground = $button.textcolor
        $WPFbtnTab2_19.Add_Click({
                $ButtonClicked = $WPFbtnTextTab2_19.Text
                Call-btnTab2_19
            })
    } 

    If ($buttonID -eq "20"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab2_20.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab2_20.IsEnabled = $false} Else {$WPFbtnTab2_20.IsEnabled = $true}
        $WPFbtnTextTab2_20.Text = $button.Name
        $WPFbtnTab2_20.Background = $button.bgcolor
        $WPFbtnTab2_20.Foreground = $button.textcolor
        $WPFbtnTab2_20.Add_Click({
                $ButtonClicked = $WPFbtnTextTab2_20.Text
                Call-btnTab2_20
            })
    } 

    If ($buttonID -eq "21"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab2_21.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab2_21.IsEnabled = $false} Else {$WPFbtnTab2_21.IsEnabled = $true}
        $WPFbtnTextTab2_21.Text = $button.Name
        $WPFbtnTab2_21.Background = $button.bgcolor
        $WPFbtnTab2_21.Foreground = $button.textcolor
        $WPFbtnTab2_21.Add_Click({
                $ButtonClicked = $WPFbtnTextTab2_21.Text
                Call-btnTab2_21
            })
    } 

    If ($buttonID -eq "22"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab2_22.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab2_22.IsEnabled = $false} Else {$WPFbtnTab2_22.IsEnabled = $true}
        $WPFbtnTextTab2_22.Text = $button.Name
        $WPFbtnTab2_22.Background = $button.bgcolor
        $WPFbtnTab2_22.Foreground = $button.textcolor
        $WPFbtnTab2_22.Add_Click({
                $ButtonClicked = $WPFbtnTextTab2_22.Text
                Call-btnTab2_22
            })
    } 

    If ($buttonID -eq "23"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab2_23.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab2_23.IsEnabled = $false} Else {$WPFbtnTab2_23.IsEnabled = $true}
        $WPFbtnTextTab2_23.Text = $button.Name
        $WPFbtnTab2_23.Background = $button.bgcolor
        $WPFbtnTab2_23.Foreground = $button.textcolor
        $WPFbtnTab2_23.Add_Click({
                $ButtonClicked = $WPFbtnTextTab2_23.Text
                Call-btnTab2_23
            })
    } 

    If ($buttonID -eq "24"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab2_24.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab2_24.IsEnabled = $false} Else {$WPFbtnTab2_24.IsEnabled = $true}
        $WPFbtnTextTab2_24.Text = $button.Name
        $WPFbtnTab2_24.Background = $button.bgcolor
        $WPFbtnTab2_24.Foreground = $button.textcolor
        $WPFbtnTab2_24.Add_Click({
                $ButtonClicked = $WPFbtnTextTab2_24.Text
                Call-btnTab2_24
            })
    } 

    If ($buttonID -eq "25"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab2_25.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab2_25.IsEnabled = $false} Else {$WPFbtnTab2_25.IsEnabled = $true}
        $WPFbtnTextTab2_25.Text = $button.Name
        $WPFbtnTab2_25.Background = $button.bgcolor
        $WPFbtnTab2_25.Foreground = $button.textcolor
        $WPFbtnTab2_25.Add_Click({
                $ButtonClicked = $WPFbtnTextTab2_25.Text
                Call-btnTab2_25
            })
    } 

    If ($buttonID -eq "26"){
        If ($AppOptionDebugeMode){write-Host "      Loading 'button $buttonID' --> $($button.Name)"}
        $WPFbtnTab2_26.Visibility = 'Visible'
        If ($button.enable -eq "false"){$WPFbtnTab2_26.IsEnabled = $false} Else {$WPFbtnTab2_26.IsEnabled = $true}
        $WPFbtnTextTab2_26.Text = $button.Name
        $WPFbtnTab2_26.Background = $button.bgcolor
        $WPFbtnTab2_26.Foreground = $button.textcolor
        $WPFbtnTab2_26.Add_Click({
                $ButtonClicked = $WPFbtnTextTab2_26.Text
                Call-btnTab2_26
            })
    } 

}
If ($ConfigTab2.enable -eq "false"){$WPFtab2.Visibility = 'Hidden'} Else {$WPFtab2.Visibility = 'Visible'}