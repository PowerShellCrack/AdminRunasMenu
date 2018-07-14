#========================================================================
#
#       Title: Admin Run-As Menu
#     Created: 2016-11-03
#      Author: Richard tracy
#
# Inspiration: https://gallery.technet.microsoft.com/
#              https://blog.netnerds.net/2016/01/adding-toolbar-icons-to-your-powershell-wpf-guis/
#              https://foxdeploy.com/2015/04/16/part-ii-deploying-powershell-guis-in-minutes-using-visual-studio/
#              http://www.systanddeploy.com/2016/01/powershell-gui-add-mahapps-metro-theme.html?m=0
#
#========================================================================
[CmdletBinding()]
Param (
	[Parameter(Mandatory=$false)]
    [Alias('ConfigCommandLine')]
	[string]$Config,
    [Parameter(Mandatory=$false)]
    [Alias('ForceLocal')]
	[switch]$Local = $false,
	[Parameter(Mandatory=$false)]
	[switch]$DisableLogging = $false
)
#==============================
# Remove variables
#==============================
Remove-Variable * -ErrorAction SilentlyContinue

##*=============================================
##* Runtime Function - REQUIRED
##*=============================================
#http://learningpcs.blogspot.com/2012/06/powershell-v2-test-if-assembly-is.html
function Load-Assembly{
    [CmdletBinding()]
    param(
        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true
        )]
        [ValidateNotNullOrEmpty()]
        [String]$AssemblyName,
        [String]$AssemblyPath
    )

    if(([appdomain]::currentdomain.getassemblies() | Where {$_ -match $AssemblyName}) -eq $null){
        Try {
            Write-Host "Loading $AssemblyName assembly";
            If ($AssemblyPath){
                [Void] [System.Reflection.Assembly]::LoadFrom("$AssemblyPath\$AssemblyName.dll");
            }
            Else{
                [Void] [System.Reflection.Assembly]::LoadFromPartialName("$AssemblyPath\$AssemblyName");
            }
            Return $True
        } 
        Catch {
            $ErrorMessage = $_.Exception.Message
            Write-Host "Unable to load '$AssemblyName': [$ErrorMessage]" -ForegroundColor White -BackgroundColor Red
            Return $false
        }
    }
    else{   
        Write-Output "$AssemblyName is already loaded";
        Return $True
    }
}

# from http://www.eggheadcafe.com/software/aspnet/30358576/powershell-and-ini-files.aspx
Function Parse-IniFile ($file) {
    $ini = @{}
    switch -regex -file $file
    {
      "^\[(.+)\]$"
      {
        $section = $matches[1]
        $ini[$section] = @{}
      }
      "(.+)=(.+)"
      {
        $name,$value = $matches[1..2]
        $ini[$section][$name] = $value
      }
    }
    $ini
}

Function Start-Log{
    param (
        [string]$FilePath
    )
 
    try{
        if (!(Test-Path $FilePath))
        {
             ## Create the log file
             New-Item (Split-Path $FilePath -Parent) -ItemType Directory -ErrorAction SilentlyContinue | Out-Null
             New-Item $FilePath -Type File | Out-Null
        }
 
        ## Set the global variable to be used as the FilePath for all subsequent Write-Log
        ## calls in this session
        $global:ScriptLogFilePath = $FilePath
    }
    catch{
        Write-Error $_.Exception.Message
    }
}

Function Write-Log{
    PARAM(
        [Parameter(Mandatory = $true)]
        [String]$Message,
        [string]$Component,
        [Parameter()]
        [ValidateSet(1, 2, 3)]
        [int]$Severity = 1,
        [switch]$OutputHost = $false,
        [string]$OutputHostColor
    )
    Begin{
        $TimeGenerated = "$(Get-Date -Format HH:mm:ss).$((Get-Date).Millisecond)+000"
        $Line = '<![LOG[{0}]LOG]!><time="{1}" date="{2}" component="{3}" context="" type="{4}" thread="" file="">'
        If ($Component){
            $LineFormat = $Message, $TimeGenerated, (Get-Date -Format MM-dd-yyyy), "$Component".toupper().Replace(" ","_"), $Severity
        }
        Else{
            $LineFormat = $Message, $TimeGenerated, (Get-Date -Format MM-dd-yyyy), "$($MyInvocation.ScriptName | Split-Path -Leaf):$($MyInvocation.ScriptLineNumber)", $Severity
        }
        $Line = $Line -f $LineFormat

        If ($OutputHost){
            If ($OutputHostColor){
                $Color = $OutputHostColor
            }
            Else{
                Switch ($Severity) {
				    3 { $Color = "Red" }
				    2 { $Color = "Yellow" }
				    1 { $Color = "White" }
			    }
            }
            #$OutputBoxMessage = $($OutputBoxMessage).replace("[","(").replace("]",")")
            Write-Host "`n$($Message)" -ForegroundColor $Color
        }
    }
    Process{
        Try{
        Add-Content -Value $Line -Path $global:ScriptLogFilePath
        }
        Catch{
            Write-Error $_.Exception.Message
            Exit
        }
    }
}
##*===============================================
##* VARIABLE DECLARATION
##*===============================================
Start-Log -FilePath "$env:LocalAppData\AdminMenu\Logs\$(Get-Date -Format yyyyMMdd).log"

## Variables: Script Name and Script Paths
[string]$scriptPath = $MyInvocation.MyCommand.Definition
[string]$scriptName = [IO.Path]::GetFileNameWithoutExtension($scriptPath)
[string]$scriptRoot = Split-Path -Path $scriptPath -Parent
[string]$invokingScript = (Get-Variable -Name 'MyInvocation').Value.ScriptName

#  Get the invoking script directory
If ($invokingScript) {
	#  If this script was invoked by another script
	[string]$scriptParentPath = Split-Path -Path $invokingScript -Parent
}
Else {
	#  If this script was not invoked by another script, fall back to the directory one level above this script
	[string]$scriptParentPath = (Get-Item -LiteralPath $scriptRoot).Parent.FullName
}

#Get required folder and File paths
[string]$AssemblyPath = Join-Path -Path $scriptRoot -ChildPath 'Assembly'
[string]$ExtensionPath = Join-Path -Path $scriptRoot -ChildPath 'Extensions'
[string]$XamlPath = Join-Path -Path $scriptRoot -ChildPath 'Resources'
[string]$ModulesPath = Join-Path -Path $scriptRoot -ChildPath 'Modules'
[string]$UtilPath = Join-Path -Path $scriptRoot -ChildPath 'Utilities'
[string]$ConfigPath = Join-Path -Path $scriptRoot -ChildPath 'Configs'
[string]$MenuScriptsPath = Join-Path -Path $scriptRoot -ChildPath 'Scripts'

# When Using Executable Command Line
If ($ConfigCommandLine){
    [string]$ConfigFile = Join-Path -Path $scriptRoot -ChildPath $ConfigCommandLine
}
Else{
    [string]$ConfigFile = Join-Path -Path $ConfigPath -ChildPath 'AdminMenu.ps1.config'
}
[string]$NameFile = Join-Path -Path $ConfigPath -ChildPath 'AdminMenu.prereqs'
#=======================================================
# PARSE CONFIG FILE
#=======================================================
[Xml.XmlDocument]$XmlConfigFile = Get-Content $ConfigFile
[Xml.XmlElement]$xmlConfig = $xmlConfigFile.AdminMenu_Configs
#  Get Config File Details
[Xml.XmlElement]$configDetails = $xmlConfig.Menu_Details
[string]$AppTitle = [string]$configDetails.Detail_Title
[string]$AppVersion = [version]$configDetails.Detail_Version
[string]$AppDate = $configDetails.Detail_Date
# Get Menu Options
[Xml.XmlElement]$xmlMenuOptions = $xmlConfig.Menu_Options
[boolean]$AppOptionRequireAdmin = [boolean]::Parse($xmlMenuOptions.Option_RequireAdmin)
[boolean]$AppOptionRSATCheck = [boolean]::Parse($xmlMenuOptions.Option_RSATCheck)
[boolean]$AppPrereqCheck = [boolean]::Parse($xmlMenuOptions.Option_PrereqCheck)
[boolean]$AppOptionDebugeMode = [boolean]::Parse($xmlMenuOptions.Option_DebugMode)
[string]$AppOptionAccent = $xmlMenuOptions.Option_Accent
[string]$AppOptionTheme = $xmlMenuOptions.Option_Theme
# Get UI Controls
[Xml.XmlElement]$xmlUIControls = $xmlConfig.UI_Controls
[boolean]$AppUIHideApp = [boolean]::Parse($xmlUIControls.Control_HideAppWhenNotUsed)
[boolean]$AppUIHideButtons = [boolean]::Parse($xmlUIControls.Control_HideUnusedButtons)
[boolean]$AppUIHideCredManager = [boolean]::Parse($xmlUIControls.Control_HideCredManager)
[boolean]$AppUIHideQuickAccess = [boolean]::Parse($xmlUIControls.Control_HideQuickAccess)
[boolean]$AppUIDisableOptionMenu = [boolean]::Parse($xmlUIControls.Control_DisableUserOption)
# Get Menu Configurations
[Xml.XmlElement]$xmlMenuConfigs = $xmlConfig.Menu_Configs
[boolean]$AppPreLoadModules = [boolean]::Parse($xmlMenuConfigs.Config_LoadModules)
[boolean]$AppUseRemoteConfig = [boolean]::Parse($xmlMenuConfigs.Config_UseRemote)
[string]$AppRemotePath = $ExecutionContext.InvokeCommand.ExpandString($xmlMenuConfigs.Config_RemotePath)

#check if remote config will be used and path is accessible
If (($AppUseRemoteConfig) -and (Test-Path $AppRemotePath) -and (!$ForceLocal)){
    [string]$remoteConfig = Join-Path -Path $AppRemotePath -ChildPath '\Configs\AdminMenu.ps1.config' -ErrorAction SilentlyContinue
    [string]$remoteNames = Join-Path -Path $AppRemotePath -ChildPath '\Configs\AdminMenu.prereqs' -ErrorAction SilentlyContinue
    If (-not (Test-Path $remoteConfig -ErrorAction SilentlyContinue) -and (-not (Test-Path $remoteNames -ErrorAction SilentlyContinue)) ){
        If ($AppOptionDebugeMode){Write-Log -Message "Remote config files were not found at: $AppRemotePath; local config will be processed instead" -Severity 2 -OutputHost}
        [boolean]$AppUseRemoteConfig = $False
    }
} Else {
    If ($AppOptionDebugeMode){Write-Log -Message "Remote path was not found: $AppRemotePath; local config will be processed instead" -Severity 2 -OutputHost}
    [boolean]$AppUseRemoteConfig = $False
}

[Xml.XmlElement]$AppExtensionScripts = $xmlMenuConfigs.Config_ExtensionScripts
# Get Tab and Buttons
[Xml.XmlElement]$AppMenuTabandButtons = $xmlConfig.Menu_TabAndButtons
[boolean]$AppMenuTabCheckPrereq = [boolean]::Parse($AppMenuTabandButtons.TabAndButtons_CheckPrereq)
#If ($AppUseRemoteConfig){
#    [string]$AppMenuTabPrereqFile = Join-Path -Path $AppRemotePath -ChildPath $AppMenuTabandButtons.TabAndButtons_PrereqFile
#}
#Else{
    [string]$AppMenuTabPrereqFile = Join-Path -Path $scriptRoot -ChildPath $AppMenuTabandButtons.TabAndButtons_PrereqFile
#}

If ($AppMenuTabCheckPrereq){
    If (Test-Path $AppMenuTabPrereqFile){
    $HashPrereq = Parse-IniFile $AppMenuTabPrereqFile
    [string]$strHashPrereq = $HashPrereq.InstalledPath| out-string -stream
        If ($AppOptionDebugeMode){Write-Log -Message "Prereq check enabled; parsing prereq file: `n$strHashPrereq" -Severity 1 -OutputHost}
    } 
    Else {
        If ($AppOptionDebugeMode){Write-Log -Message "Prereq file was not found at: $AppMenuTabPrereqFile; skipping check" -Severity 2 -OutputHost}
        $AppMenuTabCheckPrereq = $false
    }
}
#=======================================================
# LOAD ASSEMBLIES
#=======================================================
[System.Reflection.Assembly]::LoadWithPartialName('WindowsFormsIntegration')  | out-null

[System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms')  | out-null
[System.Reflection.Assembly]::LoadWithPartialName('System.ComponentModel') | out-null
[System.Reflection.Assembly]::LoadWithPartialName('System.Data')           | out-null
[System.Reflection.Assembly]::LoadWithPartialName('System.Drawing')        | out-null
[System.Reflection.Assembly]::LoadWithPartialName('presentationframework') | out-null

[System.Reflection.Assembly]::LoadWithPartialName('PresentationCore')      | out-null

$MahAppsMetroAssemblyLoaded = Load-Assembly -AssemblyPath $AssemblyPath -AssemblyName 'MahApps.Metro'
Load-Assembly -AssemblyPath $AssemblyPath -AssemblyName 'System.Windows.Interactivity'  | out-null

##* LOAD MODULES
##*=======================================================
If ($AppPreLoadModules){
    $modules = Get-ChildItem -Path $ModulesPath -Recurse -Include *.psm1
    foreach($module in $modules){
        Try{
            Import-Module $module.FullName -ErrorAction SilentlyContinue
            If ($AppOptionDebugeMode){write-Host "Module Loaded: $($module.FullName)" -ForegroundColor Cyan}
        }
        Catch {
            Write-Host "Unable to import the module." $_.Exception.Message -ForegroundColor White -BackgroundColor Red
        }
    }
}
Else {
    If ($AppOptionDebugeMode){write-Host "The 'Preload Modules' function is disabled" -ForegroundColor Gray}
}

If (Get-Module WPFRunspace*){
    Write-Host "WPFRunspcae module is loaded, initalizing Windows Platform Foundation accelerators" -ForegroundColor Gray
    Add-WpfAccelerators
}
#=======================================================
# LOAD APP XAML (Built with Visual Studio 2015)
#=======================================================
If ($MahAppsMetroAssemblyLoaded){
    $AppXAMLPath = "$($XamlPath + "\MainWindow-MahApps.xaml")"

    $appXAML = (get-content $AppXAMLPath -ReadCount 0) -replace 'mc:Ignorable="d"','' -replace "x:N",'N' -replace '^<Win.*', '<Window'
    $appXAML = $appXAML | % { $_.Replace("Resources/Icons.xaml", "$XamlPath/Icons.xaml") }
    $appXAML = $appXAML | % { $_.Replace("pack://application:,,,/MahApps.Metro;component/Styles/Accents/Blue.xaml", "pack://application:,,,/MahApps.Metro;component/Styles/Accents/$AppOptionAccent.xaml") }
    $appXAML = $appXAML | % { $_.Replace("pack://application:,,,/MahApps.Metro;component/Styles/Accents/BaseLight.xaml", "pack://application:,,,/MahApps.Metro;component/Styles/Accents/$AppOptionTheme.xaml") }
    [xml]$appXAML = $appXAML
}
Else{
    $AppXAMLPath = "$($XamlPath + "\MainWindow.xaml")"
    [xml]$appXAML = (get-content $AppXAMLPath -ReadCount 0) -replace 'mc:Ignorable="d"','' -replace "x:N",'N' -replace '^<Win.*', '<Window'
}

$readerApp=(New-Object System.Xml.XmlNodeReader $appXAML)
try{
    Write-Host "Loading XAML file: $AppXAMLPath"
    $App=[Windows.Markup.XamlReader]::Load($readerApp)
}
catch{
    $ErrorMessage = $_.Exception.Message
    Write-Host "Unable to load Windows.Markup.XamlReader for $AppXAMLPath. Some possible causes for this problem include: 
    - .NET Framework is missing
    - PowerShell must be launched with PowerShell -sta
    - invalid XAML code was encountered
    - The error message was [$ErrorMessage]" -ForegroundColor White -BackgroundColor Red
    Exit
}

#Connect XAML Names to Control Variables
$appXAML.SelectNodes("//*[@Name]") | ForEach-Object { Set-Variable -Name "WPF$($_.Name)" -Value $App.FindName($_.Name)}
#

#==========================================
# LOAD OPEN APP XAML (Built by Visual Studio 2015)
#==========================================
If ($MahAppsMetroAssemblyLoaded){
    $AppOpenXAMLpath = "$($XamlPath + "\AppOpen-MahApps.xaml")"

    $OXAML = (get-content $AppOpenXAMLpath -ReadCount 0) -replace 'mc:Ignorable="d"','' -replace "x:N",'N' -replace '^<Win.*', '<Window'
    $OXAML = $OXAML | % { $_.Replace("pack://application:,,,/MahApps.Metro;component/Styles/Accents/Blue.xaml", "pack://application:,,,/MahApps.Metro;component/Styles/Accents/$AppOptionAccent.xaml") }
    [xml]$OXAML = $OXAML
}
Else{
    $xamlpathO = "$($XamlPath + "\AppOpen.xaml")"
    [xml]$OXAML = (get-content $xamlpathO -ReadCount 0) -replace 'mc:Ignorable="d"','' -replace "x:N",'N' -replace '^<Win.*', '<Window'

}

$AppOpenReader=(New-Object System.Xml.XmlNodeReader $OXAML)
try{
    Write-Host "Loading XAML file: $AppOpenXAMLpath"
    $OApp=[Windows.Markup.XamlReader]::Load($AppOpenReader)
}
catch{
    $ErrorMessage = $_.Exception.Message
    Write-Host "Unable to load Windows.Markup.XamlReader for $AppOpenXAMLpath. Some possible causes for this problem include: 
    - .NET Framework is missing
    - PowerShell must be launched with PowerShell -sta
    - invalid XAML code was encountered
    - The error message was [$ErrorMessage]" -ForegroundColor White -BackgroundColor Red
    Exit
}

$OXAML.SelectNodes("//*[@Name]") | ForEach-Object { Set-Variable -Name "OApp$($_.Name)" -Value $OApp.FindName($_.Name)}

#==========================================
# LOAD HIDE APP XAML (Built by Visual Studio 2015)
#==========================================
If ($MahAppsMetroAssemblyLoaded){
    $AppHideXAMLpath = "$($XamlPath + "\AppHide-MahApps.xaml")"

    $HXAML = (get-content $AppHideXAMLpath -ReadCount 0) -replace 'mc:Ignorable="d"','' -replace "x:N",'N' -replace '^<Win.*', '<Window'
    $HXAML = $HXAML | % { $_.Replace("pack://application:,,,/MahApps.Metro;component/Styles/Accents/Blue.xaml", "pack://application:,,,/MahApps.Metro;component/Styles/Accents/$AppOptionAccent.xaml") }
    [xml]$HXAML = $HXAML
}
Else{
    $xamlpathH = "$($XamlPath + "\AppHide.xaml")"
    [xml]$HXAML = (get-content $xamlpathH -ReadCount 0) -replace 'mc:Ignorable="d"','' -replace "x:N",'N' -replace '^<Win.*', '<Window'

}

$AppHideReader=(New-Object System.Xml.XmlNodeReader $HXAML)
try{
    Write-Host "Loading XAML file: $AppHideXAMLpath"
    $HApp=[Windows.Markup.XamlReader]::Load($AppHideReader)
}
catch{
    $ErrorMessage = $_.Exception.Message
    Write-Host "Unable to load Windows.Markup.XamlReader for $AppHideXAMLpath. Some possible causes for this problem include: 
    - .NET Framework is missing
    - PowerShell must be launched with PowerShell -sta
    - invalid XAML code was encountered
    - The error message was [$ErrorMessage]" -ForegroundColor White -BackgroundColor Red
    Exit
}

$HXAML.SelectNodes("//*[@Name]") | ForEach-Object { Set-Variable -Name "HApp$($_.Name)" -Value $HApp.FindName($_.Name)}


##* START APP CONFIGURATIONS
##*=======================================================
$WPFlblVersion.Content = "ver. $AppVersion"
$HashNames = @{} #Clear Current list to populate list

#Check if remote will be used
If ($AppUseRemoteConfig){
    If ($AppOptionDebugeMode){Write-Log -Message "Remote config files were found at: $AppRemotePath; remote config will be processed instead" -Severity 1 -OutputHost}
    [xml]$XmlConfigFile = Get-Content $remoteConfig
    $HashNames = Parse-IniFile $NameFile
    [string]$strHashNames = $HashNames| out-string -stream
    Write-Log -Message "Sections found in list: `n$strHashNames" -Severity 1 -OutputHost
    # Get Remote Configurations
    [Xml.XmlElement]$xmlConfig = $xmlConfigFile.AdminMenu_Configs
    [Xml.XmlElement]$xmlMenuConfigs = $xmlConfig.Menu_Configs
    [Xml.XmlElement]$AppExtensionScripts = $xmlMenuConfigs.Config_ExtensionScripts
    [Xml.XmlElement]$AppMenuTabandButtons = $xmlConfig.Menu_TabAndButtons

    $AppTitle = $AppTitle + " [Remote Config]"
    $WPFlblVersion.Content = "ver. $AppVersion [Remote Config]"  
} 
Else{
    If ($AppOptionDebugeMode){Write-Log -Message "Loading configuration file: $ConfigFile" -Severity 1 -OutputHost}
    #$HashNames = Get-Content -raw $NameFile | ConvertFrom-StringData
    $HashNames = Parse-IniFile $NameFile
    [string]$strHashNames = $HashNames| out-string -stream
    If ($strHashNames){
        Write-Log -Message "Parsing names file; sections found in list: `n$strHashNames" -Severity 1 -OutputHost
    }
    Else{
        Write-Log -Message "Parsing names file; there were no sections found" -Severity 2 -OutputHost
    }
}


##* LOAD FUNCTION EXTENSIONS
##*=======================================================
If ($AppUseRemoteConfig){$ExtensionPath = Join-Path -Path $AppRemotePath -ChildPath "Extensions"}

Foreach ($ExtensionScript in $AppExtensionScripts.Script_FileName){
    $extFullPath = Join-Path -Path $ExtensionPath -ChildPath $ExtensionScript
    If (Test-Path -LiteralPath $extFullPath -PathType 'Leaf'){
        If ($AppOptionDebugeMode){write-Host "Loading Extensions: $extFullPath" -ForegroundColor Yellow}
        . "$extFullPath"
    }
}

##* ENABLE/DISABLE QUICK ACCESS CONTEXTMENU
##*=======================================================
$btnVariables = Get-Variable WPFbtnTab* -ValueOnly | Where-Object Name -Match '_'
If (!$AppUIHideQuickAccess){
    $btnVariables |
        Foreach {
            $_.ContextMenu.isEnabled = 'True'
            $_.ContextMenu.Visibility = 'Visible'
        }
    
} 
Else {
    $btnVariables |
        Foreach {
            $_.ContextMenu.isEnabled = 'False'
            $_.ContextMenu.Visibility = 'Hidden'
        }
}

##* ENABLE/DISABLE CRED MANAGER
##*=======================================================
If ($AppUIHideCredManager){
     Get-Variable *Cred* -Exclude App* -ValueOnly | 
        Foreach {
            #$_.isEnabled = 'False'
            $_.Visibility = 'Hidden'
        }
} 
Else {
   Get-Variable *Cred* -Exclude App* -ValueOnly | 
        Foreach {
            #$_.isEnabled = 'True'
            $_.Visibility = 'Visible'
        }
}

##* SHOW/HIDE UNUSED BUTTONS (MUST be before tab extensions load)
##*=======================================================
If ($AppUIHideButtons){
    Get-Variable WPFbtnTab* -ValueOnly |     
        Foreach {
            $_.Visibility = 'Hidden'
        }
} 
Else {
    Get-Variable WPFbtnTab* -ValueOnly | 
        Foreach {
            $_.Visibility = 'Visible'
        }
}


##* LOAD TAB EXTENSION SCRIPTS
##*=============================
#loop through all tab configs and process individual ps1 files
foreach ($tab in $AppMenuTabandButtons.tab){
    $tabfile = $tab.extension

    $TabExtensionPath = Join-Path -Path $ExtensionPath -ChildPath $tabfile
    If (Test-Path -LiteralPath $TabExtensionPath -PathType 'Leaf'){
        Try {
            If ($AppOptionDebugeMode){write-Host "`nLoading Tab Extensions: $TabExtensionPath" -ForegroundColor Yellow}
            . "$TabExtensionPath"
        }
        Catch {
            $line = $_.InvocationInfo.ScriptLineNumber
            $ErrorMessage = $_.Exception.Message
            write-host "Unable to load extension: $tabfile [error: $ErrorMessage] at line: $line" -ForegroundColor White -BackgroundColor Red
        }
    } 
    Else {
        If ($AppOptionDebugeMode){write-Host "Extension missing: $tabfile. Extra Tabs will be hidden from view" -ForegroundColor Yellow}
        
        #remove script extion and path, then get the tab name
        [string]$scriptName = [IO.Path]::GetFileNameWithoutExtension($tabfile)
        [string]$scriptTab = $scriptName.Split("-")[1]
        
        #hide any tabs that don't have an extension file
        If ($scriptTab -eq "Tab1"){
            $WPFtab1.Visibility = 'Hidden'
        }

        If ($scriptTab -eq "Tab2"){
            $WPFtab2.Visibility = 'Hidden'
        }

        If ($scriptTab -eq "Tab3"){
            $WPFtab3.Visibility = 'Hidden'
        }

        If ($scriptTab -eq "Tab4"){
            $WPFtab4.Visibility = 'Hidden'
        }

        If ($scriptTab -eq "Tab5"){
            $WPFtab5.Visibility = 'Hidden'
        }

        If ($scriptTab -eq "Tab6"){
            $WPFtab6.Visibility = 'Hidden'
        }
    }
}

#================================
# LOAD FORMS - NOTIFY IN TASKBAR
#================================
Remove-Event BalloonClicked_event -ea SilentlyContinue
Unregister-Event -SourceIdentifier BalloonClicked_event -ea silentlycontinue
Remove-Event BalloonClosed_event -ea SilentlyContinue
Unregister-Event -SourceIdentifier BalloonClosed_event -ea silentlycontinue #Create the notification object

## PROCESS NOTIFY ICON NEXT
# Create a streaming image by streaming the base64 string to a bitmap streamsource
$NotifyBitmap = New-Object System.Windows.Media.Imaging.BitmapImage
$NotifyBitmap.BeginInit()
$NotifyBitmap.StreamSource = [System.IO.MemoryStream][System.Convert]::FromBase64String($NotifyBase64Icon_32px)
$NotifyBitmap.EndInit()
$NotifyBitmap.Freeze()

# Convert the bitmap into an icon
$image = [System.Drawing.Bitmap][System.Drawing.Image]::FromStream($NotifyBitmap.StreamSource)
$icon = [System.Drawing.Icon]::FromHandle($image.GetHicon())
 
$notifyicon = New-Object System.Windows.Forms.NotifyIcon
$notifyicon.Text = $AppTitle
$notifyicon.Icon = $icon
$notifyicon.Visible = $true

#Display title of balloon window
$notifyicon.BalloonTipTitle = “Menu Available in Taskbar”

#Type of balloon icon
$notifyicon.BalloonTipIcon = “Info”

#Notification message
$BalloonMsg = “$AppTitle is still running, You can access this menu or the quick access menu from the taskbar at anytime”
$notifyicon.BalloonTipText = $BalloonMsg 

## Register a click event with action to take based on event
#Balloon message clicked
#register-objectevent $notification BalloonTipClicked BalloonClicked_event `
#-Action {[System.Windows.Forms.MessageBox]::Show(“Balloon message clicked”,”Information”);$notifyicon.Visible = $False} | Out-Null

#Balloon message closed
#register-objectevent $notification BalloonTipClosed BalloonClosed_event `
#-Action {[System.Windows.Forms.MessageBox]::Show(“Balloon message closed”,”Information”);$notifyicon.Visible = $False} | Out-Null

#Call the balloon notification
$ExitItem = New-Object System.Windows.Forms.MenuItem
$ExitItem.Text = "Exit Tool"
# When Exit is clicked, close everything and kill the PowerShell process
$ExitItem.add_Click({
    $App.Close()
    $HApp.Close()
    $OApp.Close()
	$notifyicon.Visible = $false
    [System.Windows.Forms.Application]::Exit($null)
	If(!$envRunningInISE){Stop-Process $pid}
})

$DebugItem = New-Object System.Windows.Forms.MenuItem
$DebugItem.Text = "Show Debug Console"
$DebugItem.Add_Click({
    If (Show-PSConsole){
        Hide-PSConsole
        $DebugItem.Text = 'Show Debug Console'
    }
    Else {
        Show-PSConsole
        $DebugItem.Text = 'Hide Debug Console'
        write-host "Use the 'Hide Debug button' from the context menu in the taskbar icon to close this debug window.
                `nIf closed with the X button, it will close the menu as well" -ForegroundColor Yellow -BackgroundColor Black
    }
})

$AboutItem = New-Object System.Windows.Forms.MenuItem
$AboutItem.Text = "About"
$AboutItem.Add_Click({Open-AboutWindow})

$QuickItem = New-Object System.Windows.Forms.MenuItem
$QuickItem.Text = "Quick Access"

$SeperatorItem = New-Object System.Windows.Forms.MenuItem
$SeperatorItem.Text = "──────────────────"
$SeperatorItem.Enabled = $false

If (!$AppUIHideQuickAccess){
    $contextmenu = New-Object System.Windows.Forms.ContextMenu
    $notifyicon.ContextMenu = $contextmenu
    If ($AppOptionDebugeMode -and !$envRunningInISE){
        $notifyicon.contextMenu.MenuItems.AddRange(@($DebugItem,$QuickItem,$SeperatorItem,$AboutItem,$ExitItem))
    }
    Else {
        $notifyicon.contextMenu.MenuItems.AddRange(@($QuickItem,$SeperatorItem,$AboutItem,$ExitItem))
    }
    $quickitem.add_Click({Launch-QuickMenu})
} 
Else{
    $contextmenu = New-Object System.Windows.Forms.ContextMenu
    $notifyicon.ContextMenu = $contextmenu
    If ($AppOptionDebugeMode -and !$envRunningInISE){
        $notifyicon.contextMenu.MenuItems.AddRange(@($DebugItem,$SeperatorItem,$AboutItem,$ExitItem))
    }
    Else {
        $notifyicon.contextMenu.MenuItems.AddRange(@($AboutItem,$ExitItem))
    }
}

# Add a left click that makes the Window appear
# part of the screen, above the notify icon.
$notifyicon.add_Click({
	#if ($_.Button -eq [Windows.Forms.MouseButtons]::Left) {
        $App.Add_Closing({$_.Cancel = $True})
        $App.Hide() # ensures the window isn't already open
        $App.Add_Closing({$_.Cancel = $False})
        $App.Show()
	#}
})



##*==============================
##* LOAD FORM - Open / Hide App Button
##*==============================

$OApp.Hide()
# reposition each time, in case the resolution or monitor changes
$OApp.Topmost = $True
$OApp.Left = $([System.Windows.SystemParameters]::WorkArea.Width-$OApp.Width)-20
$OApp.Top = $([System.Windows.SystemParameters]::WorkArea.Height-$OApp.Height)-15


$OAppbtnOpenApp.add_Click({
        $OApp.Hide()
        $HApp.Show()
        $HApp.Activate()

        $App.Add_Closing({$_.Cancel = $False})
        $App.Show()
})


$HApp.Show()
# reposition each time, in case the resolution or monitor changes
$HApp.Topmost = $True
$HApp.Left = $([System.Windows.SystemParameters]::WorkArea.Width-$OApp.Width)-20
$HApp.Top = $([System.Windows.SystemParameters]::WorkArea.Height-$OApp.Height)-15

$HAppbtnHideApp.add_Click({
        $HApp.Hide()
        $OApp.Show()
        $OApp.Activate()

        $App.Add_Closing({$_.Cancel = $True})
	    $App.Hide()
        #$notifyicon.ShowBalloonTip(5)
})

##*==============================
##* LOAD FORM - APP CONTENT AND BUTTONS 
##*==============================
#$App.Opacity = 0.95

#create Local directory for user settings
New-Item "$envLocalAppData\AdminMenu" -ItemType Directory -ErrorAction SilentlyContinue | Out-Null

Write-OutputBox -OutputBoxMessage "Loading $AppTitle [ver. $AppVersion]" -Type "START: " -Object tab1
If ($AppOptionDebugeMode){Get-FormVariables}

# Run prerequisite checks: OS version, powershell version, elevated admin
Step-SystemChecks

#check to see if RSAT is installed locally
If ($AppOptionRSATCheck){
    #Confirm-RSATInstalled
    $App.Add_Loaded({Confirm-RSATInstalled})
}

#Get username
$WPFtxtCurrentUser.text = $envUserName

If ($MahAppsMetroAssemblyLoaded){
    $WPFbtnCred1.Add_Click({If($Global:RunAsCreds1){Select-Credentials -btnID 1}Else{Open-CredentialFlyout -btnID 1}})
    $WPFbtnCred2.Add_Click({If($Global:RunAsCreds2){Select-Credentials -btnID 2}Else{Open-CredentialFlyout -btnID 2}})
    $WPFbtnCred3.Add_Click({If($Global:RunAsCreds3){Select-Credentials -btnID 3}Else{Open-CredentialFlyout -btnID 3}})
    $WPFbtnCred1.Add_MouseDoubleClick({Open-CredentialFlyout -btnID 1})
    $WPFbtnCred2.Add_MouseDoubleClick({Open-CredentialFlyout -btnID 2})
    $WPFbtnCred3.Add_MouseDoubleClick({Open-CredentialFlyout -btnID 3})
}
Else{
    $WPFbtnCred1.Add_Click({If($Global:RunAsCreds1){Select-Credentials -btnID 1}Else{Open-CredentialsForm -btnID 1}})
    $WPFbtnCred2.Add_Click({If($Global:RunAsCreds2){Select-Credentials -btnID 2}Else{Open-CredentialsForm -btnID 2}})
    $WPFbtnCred3.Add_Click({If($Global:RunAsCreds3){Select-Credentials -btnID 3}Else{Open-CredentialsForm -btnID 3}})
    $WPFbtnCred1.Add_MouseDoubleClick({Open-CredentialsForm -btnID 1})
    $WPFbtnCred2.Add_MouseDoubleClick({Open-CredentialsForm -btnID 2})
    $WPFbtnCred3.Add_MouseDoubleClick({Open-CredentialsForm -btnID 3})
}
#reset and clear credentials
$WPFbtnCredReset.Add_Click({Reset-SelectedCred})
$WPFbtnCredClear.Add_Click({Delete-CredentialsFiles})

If ($AppUIDisableOptionMenu){
    $WPFbtnOptions.isEnabled = 'False'
    $WPFbtnOptions.Visibility = 'Hidden'
}
Else{
    $WPFbtnOptions.isEnabled = 'True'
    $WPFbtnOptions.Visibility = 'Visible'
    #$WPFbtnOptions.Add_Click({Show-UserOptions})
    $WPFbtnOptions.Add_Click($App.Refresh())
    #$WPFbtnOptions.Add_Click({$WPFFlyOutContent.IsOpen = $true})
}

$WPFbtnHide.Add_Click({
        $HApp.Hide()
        $OApp.Show()
        $OApp.Activate()

        $App.Add_Closing({$_.Cancel = $True})
	    $App.Hide()
        $notifyicon.ShowBalloonTip(5)
})

 # Hide the window if it loses focus
If ($AppUIHideApp){
    $App.Add_Deactivated({
        $HApp.Hide()
        $OApp.Show()
        $OApp.Activate()

        $App.Add_Closing({$_.Cancel = $True})
	    $App.Hide()
        $notifyicon.ShowBalloonTip(5)
    })
}

#App Window (top right) Exit button
$App.Add_Closing({
        #$App.Close()
        $HApp.Close()
        $OApp.Close()
        $notifyicon.Visible = $false
        [System.Windows.Forms.Application]::Exit($null)
        If(!$envRunningInISE){Stop-Process $pid}    
})

#enable keyboard tab naviagation
$App.Add_KeyDown({ 
    $key = $_.Key  
    If ([System.Windows.Input.Keyboard]::IsKeyDown("RightCtrl") -OR [System.Windows.Input.Keyboard]::IsKeyDown("LeftCtrl")) {
        Switch ($Key) {
            "LEFT" {
                Change-TabItem -increment -1        
            }
            "RIGHT" {
                Change-TabItem -increment 1          
            }
            "UP" {
                $OApp.Hide()
                $HApp.Show()
                $HApp.Activate()

                $App.Add_Closing({$_.Cancel = $False})
                $App.Show()
            }
            "DOWN" {
                $HApp.Hide()
                $OApp.Show()
                $OApp.Activate()

                $App.Add_Closing({$_.Cancel = $True})
	            $App.Hide()
                $notifyicon.ShowBalloonTip(5)
            }
            Default {$Null}
        }
    }
})

# Create a streaming image by streaming the base64 string to a bitmap streamsource
$Listbitmap = New-Object System.Windows.Media.Imaging.BitmapImage
$Listbitmap.BeginInit()
$Listbitmap.StreamSource = [System.IO.MemoryStream][System.Convert]::FromBase64String($AddlistBase64Icon)
$Listbitmap.EndInit()
 
# Freeze() prevents memory leaks.
$Listbitmap.Freeze()

$WPFimgTab1Name1List.Source = $Listbitmap
$WPFimgTab2Name2List.Source = $Listbitmap
$WPFimgTab3Name2List.Source = $Listbitmap
$WPFimgTab4Name1List.Source = $Listbitmap
$WPFimgTab5Name1List.Source = $Listbitmap


## PROCESS APP ICON FIRST
# Create a streaming image by streaming the base64 string to a bitmap streamsource
$AppBitmap = New-Object System.Windows.Media.Imaging.BitmapImage
$AppBitmap.BeginInit()
If ($MahAppsMetroAssemblyLoaded){
    $AppBitmap.StreamSource = [System.IO.MemoryStream][System.Convert]::FromBase64String($AppBase64Icon_48px_MahApps)
}
Else{
    $AppBitmap.StreamSource = [System.IO.MemoryStream][System.Convert]::FromBase64String($AppBase64Icon_32px)
}

$AppBitmap.EndInit()
$AppBitmap.Freeze()
 
#App Title and Icon
$App.Title = $AppTitle
$App.Icon = $AppBitmap
#$App.Topmost = $True
 
# Allow input to window for TextBoxes, etc
[Void][System.Windows.Forms.Integration.ElementHost]::EnableModelessKeyboardInterop($App)

# Make PowerShell Window Disappear
If(!$envRunningInISE){Hide-PSConsole} # hide the console at start when running exe

<#
$windowcode = '[DllImport("user32.dll")] public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);' 
$asyncwindow = Add-Type -MemberDefinition $windowcode -name Win32ShowWindowAsync -namespace Win32Functions -PassThru 
$null = $asyncwindow::ShowWindowAsync((Get-Process -PID $pid).MainWindowHandle, 0) 
#>

[System.GC]::Collect()
[System.GC]::WaitForPendingFinalizers()

# This makes it pop up
$App.Show()
# This makes it the active window
$App.Activate() | Out-Null

Try{
    $AppWindowState = [System.Windows.Forms.FormWindowState]::Normal
    $App.WindowState = $AppWindowState
} 
Catch {
    $ErrorMessage = $_.Exception.Message
    Write-Host "Unable to set WindosState. May be unsupported in OS version"
}
# Create an application context for it to all run within.
# This helps with responsiveness, especially when clicking Exit.
$appContext = New-Object System.Windows.Forms.ApplicationContext
[System.Windows.Forms.Application]::Run($appContext)
