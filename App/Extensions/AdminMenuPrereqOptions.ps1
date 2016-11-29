# ==========================================
# Functions
# ==========================================
function Load-ComboBox {
	<#
		.SYNOPSIS
			This functions helps you load items into a ComboBox.
	
		.DESCRIPTION
			Use this function to dynamically load items into the ComboBox control.
	
		.PARAMETER  ComboBox
			The ComboBox control you want to add items to.
	
		.PARAMETER  Items
			The object or objects you wish to load into the ComboBox's Items collection.
	
		.PARAMETER  DisplayMember
			Indicates the property to display for the items in this control.
		
		.PARAMETER  Append
			Adds the item(s) to the ComboBox without clearing the Items collection.
		
		.EXAMPLE
			Load-ComboBox $combobox1 "Red", "White", "Blue"
		
		.EXAMPLE
			Load-ComboBox $combobox1 "Red" -Append
			Load-ComboBox $combobox1 "White" -Append
			Load-ComboBox $combobox1 "Blue" -Append
		
		.EXAMPLE
			Load-ComboBox $combobox1 (Get-Process) "ProcessName"
	#>
	Param (
		[ValidateNotNull()]
		[Parameter(Mandatory=$true)]
		[System.Windows.Forms.ComboBox]$ComboBox,
		[ValidateNotNull()]
		[Parameter(Mandatory=$true)]
		$Items,
		[Parameter(Mandatory=$false)]
		[string]$DisplayMember,
		[switch]$Append
	)
		
	if(-not $Append)
	{
		$ComboBox.Items.Clear()	
	}
		
	if($Items -is [Object[]])
	{
		$ComboBox.Items.AddRange($Items)
	}
	elseif ($Items -is [Array])
	{
		$ComboBox.BeginUpdate()
		foreach($obj in $Items)
		{
			$ComboBox.Items.Add($obj)	
		}
		$ComboBox.EndUpdate()
	}
	else
	{
		$ComboBox.Items.Add($Items)	
	}
	
	$ComboBox.DisplayMember = $DisplayMember	
}

# ==========================================	
# Load Option Config
# ==========================================
$global:Confpath = Join-Path -Path $ExtensionPath -ChildPath 'AdminMenuPrereqOptions.ps1.config'




# ==========================================
# Prereq Section
# ==========================================
$InstallPaths = $HashPrereq.InstalledPath
$PrereqPaths = @()
$InstallPaths.Keys | % {
    $key = $_
    $InstallPath = $InstallPaths.$key
    $obj = New-Object PSobject
    $obj | Add-Member Noteproperty Name $key
    $obj | Add-Member Noteproperty Path $InstallPath
    $PrereqPaths += $obj
}

		

function Show-UserOptions{
#region File Recovery Data (DO NOT MODIFY)
<#RecoveryData:
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
ALQDQPv7ALTk9WlBr0p/9CqA9jLQ+F0BWuSPzQv61rSg16SifGjyIhHFt71VGndXJHp7S56mZ793
+XtnjwGv/uzWv7ojLp6ix1lEr0np+7r8MZeZ030W0Sztn5rz/gH93bIfZomT/ZLsh+eGXpP9kI2q
PLa7hZ84fu+r2L7dyg0/3nDpNo6q8FLXn9h1HaVbLrWd+Kpcil8nBb4m59qXQV9jRRB48TfXr82K
qNtx418xk3+AN3+DRzjrk3yFN78qzff/13SGv9A1v0UP16YHvmvwt8rsJWbv6pZ/8SL6wfdJf5iH
8hW5nS/jFPyH5aF8ix56NVyd0vAaJfz8PJSTLPH/4EV0dWTzVWLdVyRzvSaueOXHBv68RfQWPfRq
uDrF5FXB3U/PC9oXBlH8ruvoF+qOeFsUcdUXO+4a/K2S26t5abvhJcl4r08Q+ktpcP/YTlbW12UI
pVI3PKNRdNZfIfl4o0Tb8Dlk79sHRDvOtopf9T3uH5Ht1PWfzbX5ouXA4Hndo5fkC30M692N8eKs
pDj6gvF8x/k++6WXZy2HcpzS700nvUDi2tz4L4OAd1PwHBL4xD6fHvzYVPks9vySLvsSv7xT70+3
2+C2TeeuTe+2zf5GAlza5VXup3zvd39Rb3sNpWc3/9DRh1n/Gvfoq9yZ7FcC32j5Gcn6DBIwqv4/
rF37kZ/+73//5VbtV5JPVUtVlZ/0A/Crh8vel3Sf7ydkYaf21k96Q/mLavplfrsE/50Y+NKJgUEn
gAkUsz0YQ3y4f2D+0tLXLSeVm5Vx5LzD9H+nlZ+k8B+3yJb2IUq3r2lrDAdogAcg6KFjG7Z/2Nav
GY9d27+kITOJf82Aot4z11nZnbN/R67/KrO4VlV/MVnp/5Lh3Y+q9wr90H7C2L4cPniVT1J/x+qd
SPnQo/v82o/ud3cVzp7vUfz0bOl94dTN0m+rPi3tXVcU+FXNlP6t1zo/G31T9qU201S9e3s4/+ja
L52QYrsOeq/x+X/O3vnh4MtppUnVNXV+FLj/9a9gdvBLNfTj+H7qbx+6vyl8uC8/na1Pqu82ZdT7
feCh5KlAX3C+izwUgnda/QQ8LnwcaHiNW39T+avyr+t/rajnSlm/cssofzrJwLOlTJbkdvo4dP6m
hMnyrjzHl08qfVM2Pb+QTu34qw4+X7zqhaO+9OGm+zh0f/FU37Pk6fvTpyWfgMeT9sUyz7bfW4Lv
Zq1fdmeX+fn/Ad+YIv5KygAA#>
#endregion
	#----------------------------------------------
	#region Import the Assemblies
	#----------------------------------------------
	[void][reflection.assembly]::Load("mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089")
	[void][reflection.assembly]::Load("System.Windows.Forms, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089")
	[void][reflection.assembly]::Load("System.Drawing, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a")
	[void][reflection.assembly]::Load("System, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089")
	[void][reflection.assembly]::Load("System.Data, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089")
	[void][reflection.assembly]::Load("System.Xml, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089")
	[void][reflection.assembly]::Load("System.DirectoryServices, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a")
	[void][reflection.assembly]::Load("System.Core, Version=3.5.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089")
	[void][reflection.assembly]::Load("System.ServiceProcess, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a")
	#endregion Import Assemblies

	#----------------------------------------------
	#region Generated Form Objects
	#----------------------------------------------
	[System.Windows.Forms.Application]::EnableVisualStyles()
	$Options = New-Object 'System.Windows.Forms.Form'
	$groupbox3 = New-Object 'System.Windows.Forms.GroupBox'
	$button2 = New-Object 'System.Windows.Forms.Button'
	$button1 = New-Object 'System.Windows.Forms.Button'
	$textbox8 = New-Object 'System.Windows.Forms.TextBox'
	$textbox9 = New-Object 'System.Windows.Forms.TextBox'
	$label10 = New-Object 'System.Windows.Forms.Label'
	$label12 = New-Object 'System.Windows.Forms.Label'
	$button_OK = New-Object 'System.Windows.Forms.Button'
	$button_Export = New-Object 'System.Windows.Forms.Button'
	$button_import = New-Object 'System.Windows.Forms.Button'
	$button_save = New-Object 'System.Windows.Forms.Button'
	$groupbox2 = New-Object 'System.Windows.Forms.GroupBox'
	$button3 = New-Object 'System.Windows.Forms.Button'
	$textbox10 = New-Object 'System.Windows.Forms.TextBox'
	$label14 = New-Object 'System.Windows.Forms.Label'
	$textbox6 = New-Object 'System.Windows.Forms.TextBox'
	$label7 = New-Object 'System.Windows.Forms.Label'
	$checkbox1 = New-Object 'System.Windows.Forms.CheckBox'
	$textbox4 = New-Object 'System.Windows.Forms.TextBox'
	$textbox5 = New-Object 'System.Windows.Forms.TextBox'
	$label5 = New-Object 'System.Windows.Forms.Label'
	$label6 = New-Object 'System.Windows.Forms.Label'
	$label4 = New-Object 'System.Windows.Forms.Label'
	$groupbox1 = New-Object 'System.Windows.Forms.GroupBox'
	$button6 = New-Object 'System.Windows.Forms.Button'
	$button5 = New-Object 'System.Windows.Forms.Button'
	$button4 = New-Object 'System.Windows.Forms.Button'
	$textbox0 = New-Object 'System.Windows.Forms.TextBox'
	$label13 = New-Object 'System.Windows.Forms.Label'
	$combobox1 = New-Object 'System.Windows.Forms.ComboBox'
	$textbox3 = New-Object 'System.Windows.Forms.TextBox'
	$label3 = New-Object 'System.Windows.Forms.Label'
	$textbox2 = New-Object 'System.Windows.Forms.TextBox'
	$label2 = New-Object 'System.Windows.Forms.Label'
	$textbox1 = New-Object 'System.Windows.Forms.TextBox'
	$label1 = New-Object 'System.Windows.Forms.Label'
	$label8 = New-Object 'System.Windows.Forms.Label'
	$button_abort = New-Object 'System.Windows.Forms.Button'
	$folderbrowserdialog1 = New-Object 'System.Windows.Forms.FolderBrowserDialog'
	$openfiledialog1 = New-Object 'System.Windows.Forms.OpenFileDialog'
	$InitialFormWindowState = New-Object 'System.Windows.Forms.FormWindowState'
	#endregion Generated Form Objects

	#----------------------------------------------
	# User Generated Script
	#----------------------------------------------
	
	$FormEvent_Load={
        if (Test-Path $global:Confpath){
	        $load = Import-Csv -Path $global:Confpath
	        foreach ($Line in $Load) {
		        $global:Language=$($Line."global:Language")
		        $global:Profilefolder=$($Line."global:Profilefolder")
		        $global:Homefolder=$($Line."global:Homefolder")
		        $global:Outfile=$($Line."global:Outfile")
		        $global:SiteName=$($Line."global:SiteName")
		        $global:SCCMServer=$($Line."global:SCCMServer")
		        $global:SCCMNameSpace=$($Line."global:SCCMNameSpace")
		        $global:SCCMEnabled=[bool]$($Line."global:SCCMEnabled")
		        $global:Nirlauncher=$($Line."global:Nirlauncher")
		        $global:Sysinternals=$($Line."global:Sysinternals")
		        $global:CmRCViewer=$($Line."global:CmRCViewer")
		        if ($global:Language -eq "English"){
			        Write-Host "Loaded configuration from $global:Confpath"
		        }
	        }
        }
        else {
	        if ($global:Language -eq "English"){
		        Write-Host "No Configfile found. Loading default Configuration."
	        }
        }

		$Options.Text = "Options"
		$label8.Text = "Language:"	
		
		#Load Variables into textboxes
		$textbox0.Text = $global:Confpath
		$textbox1.Text = $global:Profilefolder
		$textbox2.Text = $global:Homefolder
		$textbox3.Text = $global:Outfile
		if ($global:SCCMEnabled -eq $true) {
			$checkbox1.Checked = $global:SCCMEnabled
			$textbox4.Text = $global:SiteName
			$textbox5.Text = $global:SCCMServer
			$textbox6.Text = $global:SCCMNameSpace
			$textbox10.Text = $global:CmRCViewer
		}
		else {
			$checkbox1.Checked = $global:SCCMEnabled
			$textbox4.enabled = $false
			$textbox5.enabled = $false
			$textbox6.enabled = $false
			$textbox10.enabled = $false
		}
		$textbox8.Text = $global:Nirlauncher
		$textbox9.Text = $global:Sysinternals
		Load-ComboBox $combobox1 "English"
		$combobox1.SelectedItem = $global:Language
	}
	############################################################################################
	$checkbox1_CheckedChanged={
	if ($checkbox1.Checked -eq $true) {
			$textbox4.Text = $global:SiteName
			$textbox5.Text = $global:SCCMServer
			$textbox6.Text = $global:SCCMNameSpace
			$textbox10.Text = $global:CmRCViewer
		}
		else {
			$textbox4.enabled = $false
			$textbox5.enabled = $false
			$textbox6.enabled = $false
			$textbox10.enabled = $false
		}	
	}
	############################################################################################
	$button_save_Click={
		$global:Profilefolder =  $textbox1.Text
		$global:Homefolder = $textbox2.Text
		$global:Outfile = $textbox3.Text
		$global:SiteName = $textbox4.Text
		$global:SCCMServer = $textbox5.Text
		$global:SCCMNameSpace = $textbox6.Text
		$global:SCCMEnabled = [bool]$checkbox1.Checked
		$global:Language = $combobox1.Text
		$global:Nirlauncher = $textbox8.Text
		$global:Sysinternals = $textbox9.Text
		$global:CmRCViewer = $textbox10.Text
		$Exportpath = $Confpath
		New-Object -TypeName PSCustomObject -Property @{
			"global:Language" = $Language
			"global:Profilefolder" = $Profilefolder
			"global:Homefolder" = $Homefolder
			"global:Outfile" = $Outfile
			"global:SiteName" = $SiteName
			"global:SCCMServer" = $SCCMServer
			"global:SCCMNameSpace" = $SCCMNameSpace
			"global:SCCMEnabled" = $SCCMEnabled
			"global:Nirlauncher" = $Nirlauncher
			"global:Sysinternals" = $Sysinternals
			"global:CmRCViewer" = $CmRCViewer
		} | Export-Csv -Path $Exportpath -NoTypeInformation
	}
	############################################################################################
	$button_OK_Click={
		$global:Language = $combobox1.SelectedItem
		$global:Profilefolder =  $textbox1.Text
		$global:Homefolder = $textbox2.Text
		$global:Outfile = $textbox3.Text
		$global:SiteName = $textbox4.Text
		$global:SCCMServer = $textbox5.Text
		$global:SCCMNameSpace = $textbox6.Text
		$global:SCCMEnabled = [bool]$checkbox1.Checked
		$global:Language = $combobox1.Text
		$global:Nirlauncher = $textbox8.Text
		$global:Sysinternals = $textbox9.Text
		$global:CmRCViewer = $textbox10.Text
		$Exportpath = $Confpath
		New-Object -TypeName PSCustomObject -Property @{
			"global:Language" = $Language
			"global:Profilefolder" = $Profilefolder
			"global:Homefolder" = $Homefolder
			"global:Outfile" = $Outfile
			"global:SiteName" = $SiteName
			"global:SCCMServer" = $SCCMServer
			"global:SCCMNameSpace" = $SCCMNameSpace
			"global:SCCMEnabled" = $SCCMEnabled
			"global:Nirlauncher" = $Nirlauncher
			"global:Sysinternals" = $Sysinternals
			"global:CmRCViewer" = $CmRCViewer
		} | Export-Csv -Path $Exportpath -NoTypeInformation
	}
	
	$button_Export_Click={
		$folderbrowserdialog1.ShowDialog()
		$save = $folderbrowserdialog1.SelectedPath += '/AdminMenuPrereqOptions.ps1.config'
		New-Object -TypeName PSCustomObject -Property @{
			"global:Language" = $Language
			"global:Profilefolder" = $Profilefolder
			"global:Homefolder" = $Homefolder
			"global:Outfile" = $Outfile
			"global:SiteName" = $SiteName
			"global:SCCMServer" = $SCCMServer
			"global:SCCMNameSpace" = $SCCMNameSpace
			"global:SCCMEnabled"= [bool]$SCCMEnabled
			"global:Nirlauncher" = $Nirlauncher
			"global:Sysinternals" = $Sysinternals
			"global:CmRCViewer" = $CmRCViewer
		} | Export-Csv -Path $save -NoTypeInformation -Force
	}
	############################################################################################
	$button_abort_Click={$Options.Close()}
	############################################################################################
	$button_import_Click={
		$openfiledialog1.ShowDialog()
		$load = $openfiledialog1.FileNames
		$Import = Import-Csv -Path $load
		Write-Host $Import
		foreach ($Line in $Import) {
			$global:Language=$($Line."global:Language")
			$global:Profilefolder=$($Line."global:Profilefolder")
			$global:Homefolder=$($Line."global:Homefolder")
			$global:Outfile=$($Line."global:Outfile")
			$global:SiteName=$($Line."global:SiteName")
			$global:SCCMServer=$($Line."global:SCCMServer")
			$global:SCCMNameSpace=$($Line."global:SCCMNameSpace")
			$global:SCCMEnabled=[bool]$($Line."global:SCCMEnabled")
			$global:Nirlauncher=$($Line."global:Nirlauncher")
			$global:Sysinternals=$($Line."global:Sysinternals")
			$global:CmRCViewer=$($Line."global:CmRCViewer")
		}
		# Saving the imported Config
		$Exportpath = $Confpath
		New-Object -TypeName PSCustomObject -Property @{
			"global:Language" = $Language
			"global:Profilefolder" = $Profilefolder
			"global:Homefolder" = $Homefolder
			"global:Outfile" = $Outfile
			"global:SiteName" = $SiteName
			"global:SCCMServer" = $SCCMServer
			"global:SCCMNameSpace" = $SCCMNameSpace
			"global:SCCMEnabled" = [bool]$SCCMEnabled
			"global:Nirlauncher" = $Nirlauncher
			"global:Sysinternals" = $Sysinternals
			"global:CmRCViewer" = $CmRCViewer
		} | Export-Csv -Path $Exportpath -NoTypeInformation
	}
	############################################################################################
	
	$button1_Click={
		$folderbrowserdialog1.ShowDialog()
		$textbox8.Text = $folderbrowserdialog1.SelectedPath
		$global:Nirlauncher = $textbox8.Text
	}
	
	$button2_Click={
		$folderbrowserdialog1.ShowDialog()
		$textbox9.Text = $folderbrowserdialog1.SelectedPath
		$global:Sysinternals = $textbox9.Text
	}
	
	$button3_Click={
		$folderbrowserdialog1.ShowDialog()
		$textbox10.Text = $folderbrowserdialog1.SelectedPath
		$global:CmRCViewer = $textbox9.Text
	}
	
	$button4_Click={
		$folderbrowserdialog1.ShowDialog()
		$textbox3.Text = $folderbrowserdialog1.SelectedPath
		$global:logpath = $textbox3.Text
	}
	
	$button5_Click={
		$folderbrowserdialog1.ShowDialog()
		$textbox1.Text = $folderbrowserdialog1.SelectedPath
		$global:profilepath = $textbox1.Text	
	}
	
	$button6_Click={
		$folderbrowserdialog1.ShowDialog()
		$textbox2.Text = $folderbrowserdialog1.SelectedPath
		$global:outfile = $textbox2.Text	
	}
	
	$Options_FormClosed=[System.Windows.Forms.FormClosedEventHandler]{
	$Options.Close()
	}
		# --End User Generated Script--
	#----------------------------------------------
	#region Generated Events
	#----------------------------------------------
	
	$Form_StateCorrection_Load=
	{
		#Correct the initial state of the form to prevent the .Net maximized form issue
		$Options.WindowState = $InitialFormWindowState
	}
	
	$Form_StoreValues_Closing=
	{
		#Store the control values
		$script:Options_textbox8 = $textbox8.Text
		$script:Options_textbox9 = $textbox9.Text
		$script:Options_textbox10 = $textbox10.Text
		$script:Options_textbox6 = $textbox6.Text
		$script:Options_checkbox1 = $checkbox1.Checked
		$script:Options_textbox4 = $textbox4.Text
		$script:Options_textbox5 = $textbox5.Text
		$script:Options_textbox0 = $textbox0.Text
		$script:Options_combobox1 = $combobox1.Text
		$script:Options_textbox3 = $textbox3.Text
		$script:Options_textbox2 = $textbox2.Text
		$script:Options_textbox1 = $textbox1.Text
	}

	
	$Form_Cleanup_FormClosed=
	{
		#Remove all event handlers from the controls
		try
		{
			$button2.remove_Click($button2_Click)
			$button1.remove_Click($button1_Click)
			$button_OK.remove_Click($button_OK_Click)
			$button_Export.remove_Click($button_Export_Click)
			$button_import.remove_Click($button_import_Click)
			$button_save.remove_Click($button_save_Click)
			$button3.remove_Click($button3_Click)
			$checkbox1.remove_CheckedChanged($checkbox1_CheckedChanged)
			$button6.remove_Click($button6_Click)
			$button5.remove_Click($button5_Click)
			$button4.remove_Click($button4_Click)
			$button_abort.remove_Click($button_abort_Click)
			$Options.remove_FormClosed($Options_FormClosed)
			$Options.remove_Load($FormEvent_Load)
			$Options.remove_Load($Form_StateCorrection_Load)
			$Options.remove_Closing($Form_StoreValues_Closing)
			$Options.remove_FormClosed($Form_Cleanup_FormClosed)
		}
		catch [Exception]
		{ }
	}
	#endregion Generated Events

	#----------------------------------------------
	#region Generated Form Code
	#----------------------------------------------
	#
	# form1
	#
	$Options.Controls.Add($groupbox3)
	$Options.Controls.Add($button_OK)
	$Options.Controls.Add($button_Export)
	$Options.Controls.Add($button_import)
	$Options.Controls.Add($button_save)
	$Options.Controls.Add($groupbox2)
	$Options.Controls.Add($groupbox1)
	$Options.Controls.Add($button_abort)
	$Options.AcceptButton = $button_OK
	$Options.CancelButton = $button_abort
	$Options.ClientSize = '484, 489'
	$Options.FormBorderStyle = 'FixedDialog'
	$Options.MaximizeBox = $False
	$Options.MinimizeBox = $False
	$Options.Name = "form1"
	$Options.StartPosition = 'CenterScreen'
	$Options.Text = "Options"
	$Options.add_FormClosed($Options_FormClosed)
	$Options.add_Load($FormEvent_Load)
	#
	# groupbox3
	#
	$groupbox3.Controls.Add($button2)
	$groupbox3.Controls.Add($button1)
	$groupbox3.Controls.Add($textbox8)
	$groupbox3.Controls.Add($textbox9)
	$groupbox3.Controls.Add($label10)
	$groupbox3.Controls.Add($label12)
	$groupbox3.Location = '12, 357'
	$groupbox3.Name = "groupbox3"
	$groupbox3.Size = '461, 87'
	$groupbox3.TabIndex = 9
	$groupbox3.TabStop = $False
	$groupbox3.Text = "External Tools"
	#
	# button2
	#
	$button2.BackColor = 'Transparent'
	#region Binary Data
	$button2.BackgroundImage = [System.Convert]::FromBase64String($baseBrowseFolder)
	#endregion
	$button2.BackgroundImageLayout = 'Center'
	$button2.FlatStyle = 'Flat'
	$button2.ForeColor = 'Control'
	$button2.Location = '419, 42'
	$button2.Name = "button2"
	$button2.Size = '30, 26'
	$button2.TabIndex = 7
	$button2.UseVisualStyleBackColor = $False
	$button2.add_Click($button2_Click)
	#
	# button1
	#
	$button1.BackColor = 'Transparent'
	#region Binary Data
	$button1.BackgroundImage = [System.Convert]::FromBase64String($baseBrowseFolder)
	#endregion
	$button1.BackgroundImageLayout = 'Center'
	$button1.FlatStyle = 'Flat'
	$button1.ForeColor = 'Control'
	$button1.Location = '419, 15'
	$button1.Name = "button1"
	$button1.Size = '30, 26'
	$button1.TabIndex = 6
	$button1.UseVisualStyleBackColor = $False
	$button1.add_Click($button1_Click)
	#
	# textbox8
	#
	$textbox8.Location = '76, 19'
	$textbox8.Name = "textbox8"
	$textbox8.Size = '337, 20'
	$textbox8.TabIndex = 5
	#
	# textbox9
	#
	$textbox9.Location = '76, 46'
	$textbox9.Name = "textbox9"
	$textbox9.Size = '337, 20'
	$textbox9.TabIndex = 3
	#
	# label10
	#
	$label10.Location = '7, 21'
	$label10.Name = "label10"
	$label10.Size = '100, 23'
	$label10.TabIndex = 2
	$label10.Text = "Nirlauncher:"
	#
	# label12
	#
	$label12.Location = '7, 48'
	$label12.Name = "label12"
	$label12.Size = '100, 23'
	$label12.TabIndex = 4
	$label12.Text = "Sysinternals:"
	#
	# button_OK
	#
	$button_OK.Anchor = 'Bottom, Right'
	$button_OK.DialogResult = 'OK'
	$button_OK.Location = '398, 454'
	$button_OK.Name = "button_OK"
	$button_OK.Size = '75, 23'
	$button_OK.TabIndex = 0
	$button_OK.Text = "OK"
	$button_OK.UseVisualStyleBackColor = $True
	$button_OK.add_Click($button_OK_Click)
	#
	# button_Export
	#
	$button_Export.Anchor = 'Bottom, Right'
	$button_Export.Location = '74, 454'
	$button_Export.Name = "button_Export"
	$button_Export.Size = '75, 23'
	$button_Export.TabIndex = 9
	$button_Export.Text = "Export"
	$button_Export.UseVisualStyleBackColor = $True
	$button_Export.add_Click($button_Export_Click)
	#
	# button_import
	#
	$button_import.Anchor = 'Bottom, Right'
	$button_import.DialogResult = 'OK'
	$button_import.Location = '155, 454'
	$button_import.Name = "button_import"
	$button_import.Size = '75, 23'
	$button_import.TabIndex = 8
	$button_import.Text = "Import"
	$button_import.UseVisualStyleBackColor = $True
	$button_import.add_Click($button_import_Click)
	#
	# button_save
	#
	$button_save.Anchor = 'Bottom, Right'
	$button_save.Location = '236, 454'
	$button_save.Name = "button_save"
	$button_save.Size = '75, 23'
	$button_save.TabIndex = 7
	$button_save.Text = "Save"
	$button_save.UseVisualStyleBackColor = $True
	$button_save.add_Click($button_save_Click)
	#
	# groupbox2
	#
	$groupbox2.Controls.Add($button3)
	$groupbox2.Controls.Add($textbox10)
	$groupbox2.Controls.Add($label14)
	$groupbox2.Controls.Add($textbox6)
	$groupbox2.Controls.Add($label7)
	$groupbox2.Controls.Add($checkbox1)
	$groupbox2.Controls.Add($textbox4)
	$groupbox2.Controls.Add($textbox5)
	$groupbox2.Controls.Add($label5)
	$groupbox2.Controls.Add($label6)
	$groupbox2.Controls.Add($label4)
	$groupbox2.Location = '13, 183'
	$groupbox2.Name = "groupbox2"
	$groupbox2.Size = '460, 168'
	$groupbox2.TabIndex = 6
	$groupbox2.TabStop = $False
	$groupbox2.Text = "SCCM"
	#
	# button3
	#
	$button3.BackColor = 'Transparent'
	#region Binary Data
	$button3.BackgroundImage = [System.Convert]::FromBase64String($baseBrowseFolder)
	#endregion
	$button3.BackgroundImageLayout = 'Center'
	$button3.FlatStyle = 'Flat'
	$button3.ForeColor = 'Control'
	$button3.Location = '418, 123'
	$button3.Name = "button3"
	$button3.Size = '30, 26'
	$button3.TabIndex = 8
	$button3.UseVisualStyleBackColor = $False
	$button3.add_Click($button3_Click)
	#
	# textbox10
	#
	$textbox10.Location = '76, 126'
	$textbox10.Name = "textbox10"
	$textbox10.Size = '337, 20'
	$textbox10.TabIndex = 10
	#
	# label14
	#
	$label14.Location = '6, 128'
	$label14.Name = "label14"
	$label14.Size = '100, 23'
	$label14.TabIndex = 9
	$label14.Text = "CmRCViewer:"
	#
	# textbox6
	#
	$textbox6.Location = '76, 100'
	$textbox6.Name = "textbox6"
	$textbox6.Size = '337, 20'
	$textbox6.TabIndex = 8
	#
	# label7
	#
	$label7.Location = '6, 102'
	$label7.Name = "label7"
	$label7.Size = '100, 23'
	$label7.TabIndex = 7
	$label7.Text = "Namespace:"
	#
	# checkbox1
	#
	$checkbox1.Checked = $True
	$checkbox1.CheckState = 'Checked'
	$checkbox1.Location = '76, 19'
	$checkbox1.Name = "checkbox1"
	$checkbox1.Size = '15, 24'
	$checkbox1.TabIndex = 6
	$checkbox1.UseVisualStyleBackColor = $True
	$checkbox1.add_CheckedChanged($checkbox1_CheckedChanged)
	#
	# textbox4
	#
	$textbox4.Location = '76, 47'
	$textbox4.Name = "textbox4"
	$textbox4.Size = '337, 20'
	$textbox4.TabIndex = 5
	#
	# textbox5
	#
	$textbox5.Location = '76, 74'
	$textbox5.Name = "textbox5"
	$textbox5.Size = '337, 20'
	$textbox5.TabIndex = 3
	#
	# label5
	#
	$label5.Location = '7, 49'
	$label5.Name = "label5"
	$label5.Size = '100, 23'
	$label5.TabIndex = 2
	$label5.Text = "Site:"
	#
	# label6
	#
	$label6.Location = '6, 22'
	$label6.Name = "label6"
	$label6.Size = '100, 23'
	$label6.TabIndex = 0
	$label6.Text = "SCCM:"
	#
	# label4
	#
	$label4.Location = '7, 76'
	$label4.Name = "label4"
	$label4.Size = '100, 23'
	$label4.TabIndex = 4
	$label4.Text = "Server:"
	#
	# groupbox1
	#
	$groupbox1.Controls.Add($button6)
	$groupbox1.Controls.Add($button5)
	$groupbox1.Controls.Add($button4)
	$groupbox1.Controls.Add($textbox0)
	$groupbox1.Controls.Add($label13)
	$groupbox1.Controls.Add($combobox1)
	$groupbox1.Controls.Add($textbox3)
	$groupbox1.Controls.Add($label3)
	$groupbox1.Controls.Add($textbox2)
	$groupbox1.Controls.Add($label2)
	$groupbox1.Controls.Add($textbox1)
	$groupbox1.Controls.Add($label1)
	$groupbox1.Controls.Add($label8)
	$groupbox1.Location = '13, 13'
	$groupbox1.Name = "groupbox1"
	$groupbox1.Size = '460, 164'
	$groupbox1.TabIndex = 1
	$groupbox1.TabStop = $False
	$groupbox1.Text = "General"
	#
	# button6
	#
	$button6.BackColor = 'Transparent'
	#region Binary Data
	$button6.BackgroundImage = [System.Convert]::FromBase64String($baseBrowseFolder)
	#endregion
	$button6.BackgroundImageLayout = 'Center'
	$button6.FlatStyle = 'Flat'
	$button6.ForeColor = 'Control'
	$button6.Location = '418, 66'
	$button6.Name = "button6"
	$button6.Size = '30, 26'
	$button6.TabIndex = 13
	$button6.UseVisualStyleBackColor = $False
	$button6.add_Click($button6_Click)
	#
	# button5
	#
	$button5.BackColor = 'Transparent'
	#region Binary Data
	$button5.BackgroundImage = [System.Convert]::FromBase64String($baseBrowseFolder)
	#endregion
	$button5.BackgroundImageLayout = 'Center'
	$button5.FlatStyle = 'Flat'
	$button5.ForeColor = 'Control'
	$button5.Location = '418, 41'
	$button5.Name = "button5"
	$button5.Size = '30, 26'
	$button5.TabIndex = 12
	$button5.UseVisualStyleBackColor = $False
	$button5.add_Click($button5_Click)
	#
	# button4
	#
	$button4.BackColor = 'Transparent'
	#region Binary Data
	$button4.BackgroundImage = [System.Convert]::FromBase64String($baseBrowseFolder)
	#endregion
	$button4.BackgroundImageLayout = 'Center'
	$button4.FlatStyle = 'Flat'
	$button4.ForeColor = 'Control'
	$button4.Location = '418, 93'
	$button4.Name = "button4"
	$button4.Size = '30, 26'
	$button4.TabIndex = 11
	$button4.UseVisualStyleBackColor = $False
	$button4.add_Click($button4_Click)
	#
	# textbox0
	#
	$textbox0.Location = '76, 18'
	$textbox0.Name = "textbox0"
	$textbox0.ReadOnly = $True
	$textbox0.Size = '337, 20'
	$textbox0.TabIndex = 9
	#
	# label13
	#
	$label13.Location = '8, 20'
	$label13.Name = "label13"
	$label13.Size = '100, 23'
	$label13.TabIndex = 8
	$label13.Text = "Configpath:"
	#
	# combobox1
	#
	$combobox1.DisplayMember = "Deutsch, English"
	$combobox1.FormattingEnabled = $True
	$combobox1.Location = '76, 124'
	$combobox1.Name = "combobox1"
	$combobox1.Size = '121, 21'
	$combobox1.TabIndex = 6
	$combobox1.ValueMember = "Deutsch, English"
	#
	# textbox3
	#
	$textbox3.Location = '76, 98'
	$textbox3.Name = "textbox3"
	$textbox3.Size = '337, 20'
	$textbox3.TabIndex = 5
	#
	# label3
	#
	$label3.Location = '7, 100'
	$label3.Name = "label3"
	$label3.Size = '100, 23'
	$label3.TabIndex = 4
	$label3.Text = "Logpath:"
	#
	# textbox2
	#
	$textbox2.Location = '76, 70'
	$textbox2.Name = "textbox2"
	$textbox2.Size = '337, 20'
	$textbox2.TabIndex = 3
	#
	# label2
	#
	$label2.Location = '7, 72'
	$label2.Name = "label2"
	$label2.Size = '100, 23'
	$label2.TabIndex = 2
	$label2.Text = "Homepath:"
	#
	# textbox1
	#
	$textbox1.Location = '76, 44'
	$textbox1.Name = "textbox1"
	$textbox1.Size = '337, 20'
	$textbox1.TabIndex = 1
	#
	# label1
	#
	$label1.Location = '7, 46'
	$label1.Name = "label1"
	$label1.Size = '100, 23'
	$label1.TabIndex = 0
	$label1.Text = "Profilepath:"
	#
	# label8
	#
	$label8.Location = '7, 126'
	$label8.Name = "label8"
	$label8.Size = '100, 23'
	$label8.TabIndex = 7
	$label8.Text = "Sprache:"
	#
	# button_abort
	#
	$button_abort.Anchor = 'Bottom, Right'
	$button_abort.DialogResult = 'Cancel'
	$button_abort.Location = '317, 454'
	$button_abort.Name = "button_abort"
	$button_abort.Size = '75, 23'
	$button_abort.TabIndex = 10
	$button_abort.Text = "Cancel"
	$button_abort.UseVisualStyleBackColor = $True
	$button_abort.add_Click($button_abort_Click)
	#
	# folderbrowserdialog1
	#
	#
	# openfiledialog1
	#
	$openfiledialog1.FileName = "openfiledialog1"
	$openfiledialog1.Filter = "CSV-Config|*.config"
	#endregion Generated Form Code

	#----------------------------------------------

	#Save the initial state of the form
	$InitialFormWindowState = $Options.WindowState
	#Init the OnLoad event to correct the initial state of the form
	$Options.add_Load($Form_StateCorrection_Load)
	#Clean up the control events
	$Options.add_FormClosed($Form_Cleanup_FormClosed)
	#Store the control values when form is closing
	$Options.add_Closing($Form_StoreValues_Closing)
	#Show the Form
	return $Options.ShowDialog()

}