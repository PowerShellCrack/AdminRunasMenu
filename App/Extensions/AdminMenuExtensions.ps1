##*=============================================
##* VARIABLE DECLARATION
##*=============================================

## Variables: Datetime and Culture
[datetime]$currentDateTime = Get-Date
[string]$currentTime = Get-Date -Date $currentDateTime -UFormat '%T'
[string]$currentDate = Get-Date -Date $currentDateTime -UFormat '%d-%m-%Y'
[timespan]$currentTimeZoneBias = [timezone]::CurrentTimeZone.GetUtcOffset([datetime]::Now)
[Globalization.CultureInfo]$culture = Get-Culture
[string]$currentLanguage = $culture.TwoLetterISOLanguageName.ToUpper()

## Variables: Environment Variables
[psobject]$envHost = $Host
[boolean]$envRunningInISE = [environment]::commandline -like "*powershell_ise.exe*"
[psobject]$envShellFolders = Get-ItemProperty -Path 'HKLM:SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders' -ErrorAction 'SilentlyContinue'
[string]$envAllUsersProfile = $env:ALLUSERSPROFILE
[string]$envAppData = [Environment]::GetFolderPath('ApplicationData')
[string]$envArchitecture = $env:PROCESSOR_ARCHITECTURE
[string]$envComputerName = [Environment]::MachineName.ToUpper()
[string]$envComputerNameFQDN = ([Net.Dns]::GetHostEntry('localhost')).HostName
[string]$envHomeDrive = $env:HOMEDRIVE
[string]$envHomePath = $env:HOMEPATH
[string]$envHomeShare = $env:HOMESHARE
[string]$envLocalAppData = [Environment]::GetFolderPath('LocalApplicationData')
[string[]]$envLogicalDrives = [Environment]::GetLogicalDrives()
[string]$envProgramFiles = [Environment]::GetFolderPath('ProgramFiles')
[string]$envProgramFilesX86 = ${env:ProgramFiles(x86)}
[string]$envProgramData = [Environment]::GetFolderPath('CommonApplicationData')
[string]$envPublic = $env:PUBLIC
[string]$envSystemDrive = $env:SYSTEMDRIVE
[string]$envSystemRoot = $env:SYSTEMROOT
[string]$envTemp = [IO.Path]::GetTempPath()
[string]$envUserCookies = [Environment]::GetFolderPath('Cookies')
[string]$envUserDesktop = [Environment]::GetFolderPath('DesktopDirectory')
[string]$envUserFavorites = [Environment]::GetFolderPath('Favorites')
[string]$envUserInternetCache = [Environment]::GetFolderPath('InternetCache')
[string]$envUserInternetHistory = [Environment]::GetFolderPath('History')
[string]$envUserMyDocuments = [Environment]::GetFolderPath('MyDocuments')
[string]$envUserName = [Environment]::UserName
[string]$envUserPictures = [Environment]::GetFolderPath('MyPictures')
[string]$envUserProfile = $env:USERPROFILE
[string]$envUserSendTo = [Environment]::GetFolderPath('SendTo')
[string]$envUserStartMenu = [Environment]::GetFolderPath('StartMenu')
[string]$envUserStartMenuPrograms = [Environment]::GetFolderPath('Programs')
[string]$envUserStartUp = [Environment]::GetFolderPath('StartUp')
[string]$envUserTemplates = [Environment]::GetFolderPath('Templates')
[string]$envComSpec = $env:ComSpec
[string]$envSystem32Directory = [Environment]::SystemDirectory
[string]$envWinDir = $env:WINDIR
#  Handle X86 environment variables so they are never empty
If (-not $envCommonProgramFilesX86) { [string]$envCommonProgramFilesX86 = $envCommonProgramFiles }
If (-not $envProgramFilesX86) { [string]$envProgramFilesX86 = $envProgramFiles }

## Variables: Domain Membership
[boolean]$IsMachinePartOfDomain = (Get-WmiObject -Class 'Win32_ComputerSystem' -ErrorAction 'SilentlyContinue').PartOfDomain
[string]$envMachineWorkgroup = ''
[string]$envMachineADDomain = ''
[string]$envLogonServer = ''
[string]$MachineDomainController = ''
If ($IsMachinePartOfDomain) {
	[string]$envMachineADDomain = (Get-WmiObject -Class 'Win32_ComputerSystem' -ErrorAction 'SilentlyContinue').Domain | Where-Object { $_ } | ForEach-Object { $_.ToLower() }
	Try {
		[string]$envLogonServer = $env:LOGONSERVER | Where-Object { (($_) -and (-not $_.Contains('\\MicrosoftAccount'))) } | ForEach-Object { $_.TrimStart('\') } | ForEach-Object { ([Net.Dns]::GetHostEntry($_)).HostName }
		# If running in system context, fall back on the logonserver value stored in the registry
		If (-not $envLogonServer) { [string]$envLogonServer = Get-ItemProperty -LiteralPath 'HKLM:SOFTWARE\Microsoft\Windows\CurrentVersion\Group Policy\History' -ErrorAction 'SilentlyContinue' | Select-Object -ExpandProperty 'DCName' -ErrorAction 'SilentlyContinue' }
		[string]$MachineDomainController = [DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain().FindDomainController().Name
	}
	Catch { }
}
Else {
	[string]$envMachineWorkgroup = (Get-WmiObject -Class 'Win32_ComputerSystem' -ErrorAction 'SilentlyContinue').Domain | Where-Object { $_ } | ForEach-Object { $_.ToUpper() }
}
[string]$envMachineDNSDomain = [Net.NetworkInformation.IPGlobalProperties]::GetIPGlobalProperties().DomainName | Where-Object { $_ } | ForEach-Object { $_.ToLower() }
[string]$envUserDNSDomain = $env:USERDNSDOMAIN | Where-Object { $_ } | ForEach-Object { $_.ToLower() }
Try {
	[string]$envUserDomain = [Environment]::UserDomainName.ToUpper()
}
Catch { }

## Variables: Operating System
[psobject]$envOS = Get-WmiObject -Class 'Win32_OperatingSystem' -ErrorAction 'SilentlyContinue'
[string]$envOSName = $envOS.Caption.Trim()
[string]$envOSServicePack = $envOS.CSDVersion
[version]$envOSVersion = [Environment]::OSVersion.Version
[string]$envOSVersionMajor = $envOSVersion.Major
[string]$envOSVersionMinor = $envOSVersion.Minor
[string]$envOSVersionBuild = $envOSVersion.Build
[string]$envOSVersionRevision = $envOSVersion.Revision
[string]$envOSVersion = $envOSVersion.ToString()
#  Get the operating system type
[int32]$envOSProductType = $envOS.ProductType
[boolean]$IsServerOS = [boolean]($envOSProductType -eq 3)
[boolean]$IsDomainControllerOS = [boolean]($envOSProductType -eq 2)
[boolean]$IsWorkStationOS = [boolean]($envOSProductType -eq 1)
Switch ($envOSProductType) {
	3 { [string]$envOSProductTypeName = 'Server' }
	2 { [string]$envOSProductTypeName = 'Domain Controller' }
	1 { [string]$envOSProductTypeName = 'Workstation' }
	Default { [string]$envOSProductTypeName = 'Unknown' }
}
#  Get the OS Architecture
[boolean]$Is64Bit = [boolean]((Get-WmiObject -Class 'Win32_Processor' | Where-Object { $_.DeviceID -eq 'CPU0' } | Select-Object -ExpandProperty 'AddressWidth') -eq 64)
If ($Is64Bit) { [string]$envOSArchitecture = '64-bit' } Else { [string]$envOSArchitecture = '32-bit' }

## Variables: Current Process Architecture
[boolean]$Is64BitProcess = [boolean]([IntPtr]::Size -eq 8)
If ($Is64BitProcess) { [string]$psArchitecture = 'x64' } Else { [string]$psArchitecture = 'x86' }

## Variables: PowerShell And CLR (.NET) Versions
[hashtable]$envPSVersionTable = $PSVersionTable
#  PowerShell Version
[version]$envPSVersion = $envPSVersionTable.PSVersion
[string]$envPSVersionMajor = $envPSVersion.Major
[string]$envPSVersionMinor = $envPSVersion.Minor
[string]$envPSVersionBuild = $envPSVersion.Build
[string]$envPSVersionRevision = $envPSVersion.Revision
[string]$envPSVersion = $envPSVersion.ToString()
#  CLR (.NET) Version used by PowerShell
[version]$envCLRVersion = $envPSVersionTable.CLRVersion
[string]$envCLRVersionMajor = $envCLRVersion.Major
[string]$envCLRVersionMinor = $envCLRVersion.Minor
[string]$envCLRVersionBuild = $envCLRVersion.Build
[string]$envCLRVersionRevision = $envCLRVersion.Revision
[string]$envCLRVersion = $envCLRVersion.ToString()

## Variables: Permissions/Accounts
[Security.Principal.WindowsIdentity]$CurrentProcessToken = [Security.Principal.WindowsIdentity]::GetCurrent()
[Security.Principal.SecurityIdentifier]$CurrentProcessSID = $CurrentProcessToken.User
[string]$ProcessNTAccount = $CurrentProcessToken.Name
[string]$ProcessNTAccountSID = $CurrentProcessSID.Value
[boolean]$IsAdmin = [boolean]($CurrentProcessToken.Groups -contains [Security.Principal.SecurityIdentifier]'S-1-5-32-544')
[boolean]$IsLocalSystemAccount = $CurrentProcessSID.IsWellKnown([Security.Principal.WellKnownSidType]'LocalSystemSid')
[boolean]$IsLocalServiceAccount = $CurrentProcessSID.IsWellKnown([Security.Principal.WellKnownSidType]'LocalServiceSid')
[boolean]$IsNetworkServiceAccount = $CurrentProcessSID.IsWellKnown([Security.Principal.WellKnownSidType]'NetworkServiceSid')
[boolean]$IsServiceAccount = [boolean]($CurrentProcessToken.Groups -contains [Security.Principal.SecurityIdentifier]'S-1-5-6')


## Default Credbutton colors
[string]$btnDefaultColor = '#FFBCD5FF'
[string]$btnSelectedColor = '#FFA7BBDE'


#Console control
# Credits to - http://powershell.cz/2013/04/04/hide-and-show-console-window-from-gui/
Add-Type -Name Window -Namespace Console -MemberDefinition '
[DllImport("Kernel32.dll")]
public static extern IntPtr GetConsoleWindow();

[DllImport("user32.dll")]
public static extern bool ShowWindow(IntPtr hWnd, Int32 nCmdShow);
'

function Show-PSConsole {
    $consolePtr = [Console.Window]::GetConsoleWindow()
    [Console.Window]::ShowWindow($consolePtr, 5)
    return
}

function Hide-PSConsole {
    $consolePtr = [Console.Window]::GetConsoleWindow()
    [Console.Window]::ShowWindow($consolePtr, 0)
    return
}

Function Get-ErrorInformation
{
    Param($Component)
          Write-Log -Message "Exception: $($Error[0].Exception.Message)" -severity 3 -component $Component          Write-Log -Message "ErrorID: $($Error[0].FullyQualifiedErrorId)" -severity 3 -component $Component          Write-Log -Message "ScriptLineNumber: $($Error[0].InvocationInfo.ScriptLineNumber)" -severity 3 -component $Component          Write-Log -Message "Message: $($Error[0].InvocationInfo.PositionMessage)" -severity 3 -component $Component
}

##*=============================================
##* Functions
##*=============================================
function Set-WindowStyle {
    param(
        [Parameter()]
        [ValidateSet('FORCEMINIMIZE', 'HIDE', 'MAXIMIZE', 'MINIMIZE', 'RESTORE', 
                     'SHOW', 'SHOWDEFAULT', 'SHOWMAXIMIZED', 'SHOWMINIMIZED', 
                     'SHOWMINNOACTIVE', 'SHOWNA', 'SHOWNOACTIVATE', 'SHOWNORMAL')]
        $Style = 'SHOW',
    
        [Parameter()]
        $MainWindowHandle = (Get-Process –id $pid).MainWindowHandle
    )
    $WindowStates = @{
        'FORCEMINIMIZE'   = 11
        'HIDE'            = 0
        'MAXIMIZE'        = 3
        'MINIMIZE'        = 6
        'RESTORE'         = 9
        'SHOW'            = 5
        'SHOWDEFAULT'     = 10
        'SHOWMAXIMIZED'   = 3
        'SHOWMINIMIZED'   = 2
        'SHOWMINNOACTIVE' = 7
        'SHOWNA'          = 8
        'SHOWNOACTIVATE'  = 4
        'SHOWNORMAL'      = 1
    }
    
    $Win32ShowWindowAsync = Add-Type –memberDefinition @” 
[DllImport("user32.dll")] 
public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow); 
“@ -name “Win32ShowWindowAsync” -namespace Win32Functions –passThru
    
    $Win32ShowWindowAsync::ShowWindowAsync($MainWindowHandle, $WindowStates[$Style]) | Out-Null
    Write-Verbose ("Set Window Style '{1} on '{0}'" -f $MainWindowHandle, $Style)

}

Function Set-State{
    param(
        [Parameter()]
        [ValidateSet('MINIMIZED', 'NORMAL')]
        $State = 'NORMAL'
    )
    $AppWindowState = [System.Windows.Forms.FormWindowState]::$State
}

Function Get-State{
    Return $AppWindowState
}

Function Get-DiskInfo {
    param($computername =$env:COMPUTERNAME)
 
    Get-WMIObject Win32_logicaldisk -ComputerName $computername | 
        Select-Object @{Name='ComputerName';Ex={$computername}},`
        @{Name=‘Drive Letter‘;Expression={$_.DeviceID}},`
        @{Name=‘Drive Label’;Expression={$_.VolumeName}},`
        @{Name=‘Size(MB)’;Expression={[int]($_.Size / 1MB)}},`
        @{Name=‘FreeSpace%’;Expression={[math]::Round($_.FreeSpace / $_.Size,2)*100}}
}
 

function Get-WindowByTitle($WindowTitle="*")
{
	Write-Verbose "WindowTitle is: $WindowTitle"
	
	if($WindowTitle -eq "*")
	{
		Write-Verbose "WindowTitle is *, print all windows title"
		Get-Process | Where-Object {$_.MainWindowTitle} | Select-Object Id,Name,MainWindowHandle,MainWindowTitle
	}
	else
	{
		Write-Verbose "WindowTitle is $WindowTitle"
		Get-Process | Where-Object {$_.MainWindowTitle -like "*$WindowTitle*"} | Select-Object Id,Name,MainWindowHandle,MainWindowTitle
	}
}

function Change-TabItem($increment){
    $newIndex=$WPFTabControl.SelectedIndex + $increment
    If ($newIndex -ge $WPFTabControl.items.count) {
        $newIndex=0
    }
    elseif ($newIndex -lt 0) {
          $newIndex=$WPFTabControl.SelectedIndex - 1
    }
    $WPFTabControl.SelectedIndex = $newIndex
}

Function Get-FormVariables{
    Write-host "`nIf you need to reference this display again, run Get-FormVariables" -ForegroundColor Cyan
    write-host "Found the following interactable elementsin the menu" -ForegroundColor Cyan
    get-variable WPF*
    get-variable CW*
    get-variable Qmenu*
    get-variable *App*
}

function Step-SystemChecks {
    $ValidateCounter = 0
    if (Confirm-PSVersion) {
        $ValidateCounter++
    }
    if (Confirm-Elevated) {
        $ValidateCounter++
    }
    if (Confirm-OSVersion) {
        $ValidateCounter++
    }
    if ($ValidateCounter -ge 3) {
        #Interactive-TabPages -Mode Enable
        Write-OutputBox -OutputBoxMessage "All validation checks passed successfully" -Type "INFO: " -Object Tab1
    }
    else {
        #Interactive-TabPages -Mode Disable
        Write-OutputBox -OutputBoxMessage "All validation checks did not pass successfully, remediate the errors and re-launch the tool or check the override checkbox to use the tool anyway" -Type "ERROR: " -Object Tab1
    }
}

function Confirm-Elevated {
    $UserWP = New-Object Security.Principal.WindowsPrincipal( [Security.Principal.WindowsIdentity]::GetCurrent( ) )
    try {
        if ($UserWP.IsInRole( [Security.Principal.WindowsBuiltInRole]::Administrator )) {
            $WPFtxtElevated.Text = 'Yes'
		    $WPFtxtElevated.Foreground = '#FF0BEA00'
            Write-OutputBox -OutputBoxMessage "User has local administrative rights and was launched elevated" -Type "INFO: " -Object Tab1
            return $true
        }
        else {
            Write-OutputBox -OutputBoxMessage "The tool requires local administrative rights and was not launched elevated" -Type "ERROR: " -Object Tab1
            $WPFtxtElevated.Text = 'No'
            $WPFtxtElevated.Foreground = '#FFFF0000'
            return $false
        }
    }
    catch [System.Exception] {
        Write-OutputBox -OutputBoxMessage "An error occured when attempting to query for elevation, possible due to issues contacting the domain or the tool is launched in a sub-domain. If used in a sub-domain, check the override checkbox to enable this tool" -Type "WARNING: " -Object Tab1
    }
}

function Confirm-RSATInstalled {
    param(
	    [parameter(Mandatory=$false)]
	    $OutPutBox = $true
	)
    Begin {
        $WPFlblRSAT.Visibility = 'Visible' 
        $WPFtxtRSAT.Visibility = 'Visible'
        $RSAT = Get-Module -list ActiveDirectory
    }
    Process {
        If ($RSAT) {
            If($OutPutBox){Write-OutputBox -OutputBoxMessage "RSAT is installed." -Type "INFO: " -Object Tab1}
            $WPFtxtRSAT.Text = 'Yes'
	        $WPFtxtRSAT.Foreground = '#FF0BEA00'
            return $true
        } Else {
            If($OutPutBox){Write-OutputBox -OutputBoxMessage "RSAT is not installed. " -Type "ERROR: " -Object Tab1}
            $WPFtxtRSAT.Text = 'No'
            $WPFtxtRSAT.Foreground = '#FFFF0000'
            return $false
        }
	}
}

function Confirm-RebootPending {
	param(
	[parameter(Mandatory=$true)]
	$ComputerName
	)
	$RebootPendingCBS = $null
	$RebootPendingWUAU = $null
	$GetOS = Get-WmiObject -Class Win32_OperatingSystem -Property BuildNumber,CSName -ComputerName $ComputerName
	$ConnectRegistry = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey([Microsoft.Win32.RegistryHive]"LocalMachine",$ComputerName)   
	if ($GetOS.BuildNumber -ge 6001) {
		$RegistryCBS = $ConnectRegistry.OpenSubKey("SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\").GetSubKeyNames() 
		$RebootPendingCBS = $RegistryCBS -contains "RebootPending"
	}
	$RegistryWUAU = $ConnectRegistry.OpenSubKey("SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\").GetSubKeyNames()
	$RebootPendingWUAU = $RegistryWUAU -contains "RebootRequired"
	$RegistryPFRO = $ConnectRegistry.OpenSubKey("SYSTEM\CurrentControlSet\Control\Session Manager\") 
	$RegistryValuePFRO = $RegistryPFRO.GetValue("PendingFileRenameOperations",$null) 
	if ($RegistryValuePFRO) {
		$RebootPendingPFRO = $true
	}
	if (($RebootPendingCBS) -or ($RebootPendingWUAU) -or ($RebootPendingPFRO)) {
		return $true
	}
	else {
		return $false
	}	
}

function Confirm-RebootPendingCheck {
	$GetComputerName = $env:COMPUTERNAME
	$ValidateRebootPending = Confirm-RebootPending -ComputerName $GetComputerName
	if ($ValidateRebootPending) {
        $PicBoxReboot.Image = $ErrorImage
		$LabelPendingRestart.Visible = $true
        Write-OutputBox -OutputBoxMessage "A reboot is pending, please restart the system" -Type "ERROR: " -Object Tab1
        return $false
	}
	else {
        $PicBoxReboot.Image = $ValidatedImage
		$LabelPendingRestart.Visible = $true
        Write-OutputBox -OutputBoxMessage "Pending reboot checks validated successfully" -Type "INFO: " -Object Tab1
        return $true
	}
}

function Confirm-OSVersion {
    $WPFtxtSupportedOS.Text = $envOSVersion
    [version]$MinimumOSversion= $MinimumOSversion
    [version]$envOSMajorMinor = ($envOSVersionMajor + "." + $envOSVersionMinor)
	if (($envOSProductType -eq 1) -and ($envOSMajorMinor -ge $MinimumOSversion)) {
        Write-OutputBox -OutputBoxMessage "Supported operating system found [$envOSMajorMinor]" -Type "INFO: " -Object Tab1
        $WPFtxtSupportedOS.Foreground = '#FF0BEA00'
        return $true
	}
    elseif (($envOSProductType -eq 3) -and ($envOSMajorMinor -ge $MinimumOSversion)) {
		    Write-OutputBox -OutputBoxMessage "The detected operating system is a supported Server OS [$envOSMajorMinor]" -Type "INFO: " -Object Tab1
            $WPFtxtSupportedOS.Text = $envOSVersion
            $WPFtxtSupportedOS.Foreground = '#FF0BEA00'
            return $false
    }
    else {
        if ($envOSMajorMinor -lt $MinimumOSversion) {
		    Write-OutputBox -OutputBoxMessage "The detected operating system is not supported [$envOSMajorMinor]. This tool is supported on Windows Server 2008 R2 and above [$MinimumOSversion]" -Type "ERROR: " -Object Tab1
            $WPFtxtSupportedOS.Text = $envOSVersion
            $WPFtxtSupportedOS.Foreground = '#FFFF0000'
            return $false
        }
        if ($envOSProductType -eq 2) {
		    Write-OutputBox -OutputBoxMessage "The detected system is a Domain Controller. This tool can be ran but not recommended [$envOSMajorMinor]" -Type "WARNING: " -Object Tab1
            $WPFtxtSupportedOS.Text = 'DC'
            $WPFtxtSupportedOS.Foreground = '#FFFFE800'
            return $false
        }
        if ($envOSProductType -eq 3) {
		    Write-OutputBox -OutputBoxMessage "The detected operating system is an unsupported Server OS [$envOSMajorMinor]" -Type "ERROR: " -Object Tab1
            $WPFtxtSupportedOS.Text = $envOSVersion
            $WPFtxtSupportedOS.Foreground = '#FFFF0000'
            return $false | Out-Null
        }
	}
}


function Confirm-PSVersion {
    $PSMajMin = ($envPSVersion[0] + "." + $envPSVersion[2])
    if ($PSMajMin -ge "3.0") {
        Write-OutputBox -OutputBoxMessage "Supported version of PowerShell was detected [$PSMajMin]" -Type "INFO: " -Object Tab1
        $WPFtxtPSVersion.Text = $PSMajMin
        $WPFtxtPSVersion.Foreground = '#FF0BEA00'
        return $true
    }
    else {
        Write-OutputBox -OutputBoxMessage "Unsupported version of PowerShell detected [$PSMajMin]. This tool requires PowerShell 3.0 and above" -Type "ERROR: " -Object Tab1
        $lblPSVersionCheck.Content = $PSMajMin
        return $false
    }
}



#http://learningpcs.blogspot.com/2011/08/powershell-function-encrypt.html
function Encrypt-String {
    <# 
    .AUTHOR Joel Bennett Modified by Will Steele 
    .DEPENDENCIES None. 
    .DESCRIPTION This function encrypts an input string with a passphrase and salt using the Rijndael algorithm. 
    .EXAMPLE Encrypt-String.Rinjdael 'EncryptedString' 'Encrypted' # Using 'Test' as salt. mSPUjt827Y8wrhTHkVATTQ== 
    .EXTERNALHELP None. 
    .FORWARDHELPTARGETNAME None. 
    .INPUTS System.Object 
    .LINK http://poshcode.org/116. 
    .NAME Encrypt-String.Rinjdael 
    .NOTES None. 
    .OUTPUTS System.String. 
    .PARAMETER String A required plaintext string to be encrypted. 
    .PARAMETER Passphrase A required string used to encrypt the plaintext. 
    .PARAMETER Salt A required string used as salt for the algorithm. 
    .PARAMETER Init A second required string to ensure salting. 
    .PARAMETER ArrayOutput An optional switch to specify if the output should be an array. 
    .SYNOPSIS Encrypt a string using salt and Rijndael algorithm. 
    #>

    [CmdletBinding()]
    param(
    [Parameter(
    Mandatory = $true,
    ValueFromPipeline = $true
    )]
    [String]
    $String,

    [Parameter(
    Mandatory = $true,
    ValueFromPipeline = $true
    )]
    $Passphrase,

    [Parameter(
    Mandatory = $false,
    ValueFromPipeline = $true
    )]
    $salt = 'SaltCrypto',

    [Parameter(
    Mandatory = $false,
    ValueFromPipeline = $true
    )]
    [String] 
    $init = "IV_Password",

    [Parameter(
    Mandatory = $false,
    ValueFromPipeline = $true
    )] 
    [switch]
    $arrayOutput
    )
    Begin {
        [Reflection.Assembly]::LoadWithPartialName("System.Security") | Out-Null;
    }
    Process{
        Try{
            $r = new-Object System.Security.Cryptography.RijndaelManaged
            $pass = [Text.Encoding]::UTF8.GetBytes($Passphrase)
            $salt = [Text.Encoding]::UTF8.GetBytes($salt)

            $r.Key = (new-Object Security.Cryptography.PasswordDeriveBytes $pass, $salt, "SHA1", 5).GetBytes(32) #256/8
            $r.IV = (new-Object Security.Cryptography.SHA1Managed).ComputeHash( [Text.Encoding]::UTF8.GetBytes($init) )[0..15]

            $c = $r.CreateEncryptor()
            $ms = new-Object IO.MemoryStream
            $cs = new-Object Security.Cryptography.CryptoStream $ms,$c,"Write"
            $sw = new-Object IO.StreamWriter $cs
            $sw.Write($String)
            $sw.Close()
            $cs.Close()
            $ms.Close()
            $r.Clear()  
        }
        Catch{
            $ErrorMessage = $_.Exception.Message
            Write-Host ("Unable to Encrypt String $String" + ":[$ErrorMessage]") -ForegroundColor White -BackgroundColor Red
            return
        }
    }
    End{
        [byte[]]$result = $ms.ToArray()
        if($arrayOutput) {
            return $result
        } else {
            return [Convert]::ToBase64String($result)
        }
    }
}

#http://learningpcs.blogspot.com/2011/08/powershell-function-decrypt.html
function Decrypt-String {
    <# 
    .AUTHOR Will Steele 
    .DEPENDENCIES None. 
    .DESCRIPTION This function decrypts an input ciphertext with a passphrase and salt using the Rijndael algorithm. 
    .EXAMPLE Decrypt-String 'mSPUjt827Y8wrhTHkVATTQ==' 'Encrypted' # Salt of 'Test' EncryptedString 
    .EXTERNALHELP None. 
    .FORWARDHELPTARGETNAME None. 
    .INPUTS System.Object 
    .LINK http://poshcode.org/116. 
    .NAME PenetrationTesting.Decrypt-String.Rinjdael 
    .NOTES None. 
    .OUTPUTS System.String. 
    .PARAMETER String A required plaintext string to be encrypted. 
    .PARAMETER Passphrase A required string used to encrypt the plaintext. 
    .PARAMETER Salt A required string used as salt for the algorithm. 
    .PARAMETER Init A second required string to ensure salting. 
    .SYNOPSIS Encrypt a string using salt and Rijndael algorithm. 
    #>

    [CmdletBinding()]
    param(
    [Parameter(
    Mandatory = $true,
    ValueFromPipeline = $true
    )]
    $Encrypted,

    [Parameter(
    Mandatory = $true,
    ValueFromPipeline = $true
    )]
    $Passphrase,

    [Parameter(
    Mandatory = $false,
    ValueFromPipeline = $true
    )]
    [String]
    $salt = 'SaltCrypto',

    [Parameter(
    Mandatory = $false,
    ValueFromPipeline = $true
    )]
    [String] 
    $init = "IV_Password"
    )
    Begin {
    [Reflection.Assembly]::LoadWithPartialName("System.Security") | Out-Null;
    }
    Process{
        Try{
            if($Encrypted -is [string]){
            $Encrypted = [Convert]::FromBase64String($Encrypted)
            }

            $r = new-Object System.Security.Cryptography.RijndaelManaged
            $r.Padding = [System.Security.Cryptography.PaddingMode]::ISO10126
            $pass = [System.Text.Encoding]::UTF8.GetBytes($Passphrase)
            $saltBytes = [System.Text.Encoding]::UTF8.GetBytes($salt)

            $r.Key = (new-Object Security.Cryptography.PasswordDeriveBytes $pass, $saltBytes, "SHA1", 5).GetBytes(32) #256/8
            $r.IV = (new-Object Security.Cryptography.SHA1Managed).ComputeHash( [Text.Encoding]::UTF8.GetBytes($init) )[0..15]

            $d = $r.CreateDecryptor()
            $ms = new-Object IO.MemoryStream @(,$Encrypted)
            $cs = new-Object Security.Cryptography.CryptoStream $ms,$d,"Read"
            $sr = new-Object IO.StreamReader $cs
            Write-Output $sr.ReadToEnd()
            $sr.Close()
            $cs.Close()
            $ms.Close()
            $r.Clear()
        }
        Catch{
            $ErrorMessage = $_.Exception.Message
            Write-Host ("Unable to Encrypt String $String" + ":[$ErrorMessage]") -ForegroundColor White -BackgroundColor Red
            return
        }
    }
    End{}
}


function Write-OutputBox {
	param(
	[parameter(Mandatory=$true)]
	[string]$OutputBoxMessage,
	[ValidateSet("WARNING: ","ERROR: ","INFO: ","PING: ", "START: ")]
	[string]$Type,
    [parameter(Mandatory=$true)]
    [ValidateSet("Tab1","Tab2","Tab3","Tab4","Tab5")]
    [string]$Object,
    [switch]$LogOutput,
    [switch]$OutputHost
	)
	Process {
        if ($Object -like "Tab1") {
			$WPFtxtBoxTab1Output.AppendText("`n$($Type)$($OutputBoxMessage)")
            [System.Windows.Forms.Application]::DoEvents()
            $WPFtxtBoxTab1Output.ScrollToEnd()
        }
        if ($Object -like "Tab2") {
			$WPFtxtBoxTab2Output.AppendText("`n$($Type)$($OutputBoxMessage)")
			[System.Windows.Forms.Application]::DoEvents()
            $WPFtxtBoxTab2Output.ScrollToEnd()
        }
        if ($Object -like "Tab3") {
		    $WPFtxtBoxTab3Output.AppendText("`n$($Type)$($OutputBoxMessage)")
			[System.Windows.Forms.Application]::DoEvents()
            $WPFtxtBoxTab3Output.ScrollToEnd()
        }
        if ($Object -like "Tab4") {
			$WPFtxtBoxTab4Output.AppendText("`n$($Type)$($OutputBoxMessage)")
			[System.Windows.Forms.Application]::DoEvents()
            $WPFtxtBoxTab4Output.ScrollToEnd()
        }
        if ($Object -like "Tab5") {
			$WPFtxtBoxTab5Output.AppendText("`n$($Type)$($OutputBoxMessage)")
			[System.Windows.Forms.Application]::DoEvents()
            $WPFtxtBoxTab5Output.ScrollToEnd()
        }
        If ($LogOutput){
            Switch ($Type) {
				"INFO: "    { $SeverityType = 1 }
				"START: "   { $SeverityType = 1 }
				"WARNING: " { $SeverityType = 2 }
                "ERROR: "   {$SeverityType = 3}
			}
            If ($OutputHost){
                Write-Log -Message "`n$($Type)$($OutputBoxMessage)" -Severity $SeverityType -OutputHost
            }
            Else{
                Write-Log -Message "`n$($Type)$($OutputBoxMessage)" -Severity $SeverityType
            }
        }
	}
} 

Function Get-CredentialsFile {
    param(
    [parameter(Mandatory=$true)]
	[Int]$btnID
    )
    $Global:CredUsrFile = "$envLocalAppData\AdminMenu\cred$([string]$btnID).usr"
    $Global:CredPwdFile = "$envLocalAppData\AdminMenu\cred$([string]$btnID).pwd"
    $Global:CredDomFile = "$envLocalAppData\AdminMenu\cred$([string]$btnID).dom"
    $Global:CredGidFile = "$envLocalAppData\AdminMenu\cred$([string]$btnID).gid"
    $Global:CredKeyFile = "$envLocalAppData\AdminMenu\cred$([string]$btnID).key"
    $UsrFileExists = Test-Path $Global:CredUsrFile
    $PwdFileExists = Test-Path $Global:CredPwdFile
    $DomFileExists = Test-Path $Global:CredDomFile
    $GidFileExists = Test-Path $Global:CredGidFile
    $KeyFileExists = Test-Path $Global:CredKeyFile
    If ($UsrFileExists -and $PwdFileExists -and $DomFileExists -and $GidFileExists -and $KeyFileExists){
        Return $true
    } 
    Else {
        Return $false
    }
}


#http://blog.coretech.dk/rja/store-encrypted-password-in-a-powershell-script/
#http://www.adminarsenal.com/admin-arsenal-blog/secure-password-with-powershell-encrypting-credentials-part-2/
Function Store-Credentials {
    param(
    [parameter(Mandatory=$true)]
	[Int]$btnID
    )

    #get the files needed to store based on ID
    write-host "Storing Credentials: $btnID"
    Get-CredentialsFile -btnID $btnID | Out-Null

    #Generate a guid to use as passphrase
    $GUID = [System.Guid]::NewGuid().toString()

    #Creating AES key with random data and export to file
    $KeyFile = "$envLocalAppData\AdminMenu\cred$([string]$btnID).key"
    $Key = New-Object Byte[] 16   # You can use 16, 24, or 32 for AES
    [Security.Cryptography.RNGCryptoServiceProvider]::Create().GetBytes($Key)
    $Key | out-file $KeyFile

    #Save credential to encrypted files
    Encrypt-String -String $Global:StoredCred_Username -Passphrase $GUID | Out-File $Global:CredUsrFile
    Encrypt-String -String $Global:StoredCred_Domain -Passphrase $GUID | Out-File $Global:CredDomFile

    #encrypt the GUID using the user name as the passphrase
    Encrypt-String -String $GUID -Passphrase $envUserName | Out-File $Global:CredGidFile

    #convert clear text password to an secure string, then convert that to a exportable encrypted string
    #the $securePassword will be used as the PS credentials
    $SecurePassword = $Global:StoredCred_Password | ConvertTo-SecureString -AsPlainText -Force

    #This will create the text file with an encrypted standard string representing the password. It will use AES.
    $SecurePassword | ConvertFrom-SecureString -Key $Key | Out-File $Global:CredPwdFile
    #$SecurePassword | ConvertFrom-SecureString | Out-File $Global:CredPwdFile

    # Stored username, password and domain credential in a global variable for further use
    If ($btnID -eq 1){
        $Global:RunAsCreds1 = New-Object -typename System.Management.Automation.PSCredential -ArgumentList $($Global:StoredCred_Domain + "\" + $Global:StoredCred_Username), $SecurePassword
        $WPFbtnCred1.Content = "Select`nCred 1"
    }
    If ($btnID -eq 2){
        $Global:RunAsCreds2 = New-Object -typename System.Management.Automation.PSCredential -ArgumentList $($Global:StoredCred_Domain + "\" + $Global:StoredCred_Username), $SecurePassword
        $WPFbtnCred2.Content = "Select`nCred 2"
    }
    If ($btnID -eq 3){
        $Global:RunAsCreds3 = New-Object -typename System.Management.Automation.PSCredential -ArgumentList $($Global:StoredCred_Domain + "\" + $Global:StoredCred_Username), $SecurePassword
        $WPFbtnCred3.Content = "Select`nCred 3"
    }
    Write-OutputBox -OutputBoxMessage "Cred $([string]$btnID) is now configured to use: $($Global:StoredCred_Domain + "\" + $Global:StoredCred_Username) account" -Type "INFO: " -Object Tab1 -LogOutput
    #clear all stored variables before closing form
    Clear-Variable Stored*
}


Function Open-CredentialFlyout {
    param(
    [parameter(Mandatory=$true)]
	[Int]$btnID
    )

    If ($btnID -eq 1){
        write-host "Opening flyout for [Credential $btnID]"

        If (Get-CredentialsFile -btnID $btnID){
            write-host "Grabbing files for [Credential $btnID]: $Global:CredGidFile, $Global:CredUsrFile,$Global:CredDomFile"
            #decrypt the GUID file first to find the passphrase
            [string]$GUID = Decrypt-String -Encrypted (Get-Content $Global:CredGidFile) -Passphrase $envUserName
            $WPFflyout1TxtUsername.Text = Decrypt-String -Encrypted (Get-Content $Global:CredUsrFile) -Passphrase $GUID
            $WPFflyout1TxtDomain.Text = Decrypt-String -Encrypted (Get-Content $Global:CredDomFile) -Passphrase $GUID
        }
        Else{
            write-host "No files found for [Credential $btnID]"
            If($IsMachinePartOfDomain){$WPFflyout1TxtDomain.Text = $envMachineADDomain}Else{$WPFflyout1TxtDomain.Text = $envComputerName}
        }

        #open flyout1 (from right)
        $WPFflyout1Content.IsOpen = $true

        $WPFflyout1BtnClear.Add_Click({
            #$WPFflyout1Content.IsOpen = $false
            $WPFflyout1TxtUsername.Text = ""
            $WPFflyout1TxtPassword.Password = ""
            $WPFflyout1TxtDomain.Text = ""
            $WPFflyout1Msg.Content = ""
        })
        $WPFflyout1BtnSave.Add_Click({
            if (($WPFflyout1TxtUsername.Text) -and ($WPFflyout1TxtPassword.Password) -and ($WPFflyout1TxtDomain.Text)){ 
                $Global:StoredCred_Username=$WPFflyout1TxtUsername.Text
                $Global:StoredCred_Password=$WPFflyout1TxtPassword.Password
                $Global:StoredCred_Domain=$WPFflyout1TxtDomain.Text
                #write-host "Storing [credentials 1]: $Global:StoredCred_Username, $Global:StoredCred_Password,$Global:StoredCred_Domain"
                Store-Credentials -btnID 1
                $WPFflyout1Content.IsOpen = $false 
            }
            Else{
                $WPFflyout1Msg.Content = "All fields must be filled"
            }  
        })
    }

    If ($btnID -eq 2){
        write-host "Opening flyout for [Credential $btnID]"

        If (Get-CredentialsFile -btnID $btnID){
            write-host "Grabbing files for [Credential $btnID]: $Global:CredGidFile, $Global:CredUsrFile,$Global:CredDomFile"
            #decrypt the GUID file first to find the passphrase
            [string]$GUID = Decrypt-String -Encrypted (Get-Content $Global:CredGidFile) -Passphrase $envUserName
            $WPFflyout2TxtUsername.Text = Decrypt-String -Encrypted (Get-Content $Global:CredUsrFile) -Passphrase $GUID
            $WPFflyout2TxtDomain.Text = Decrypt-String -Encrypted (Get-Content $Global:CredDomFile) -Passphrase $GUID
        }
        Else{
            write-host "No files found for [Credential $btnID]"
            If($IsMachinePartOfDomain){$WPFflyout2TxtDomain.Text = $envMachineADDomain}Else{$WPFflyout2TxtDomain.Text = $envComputerName}
        }

        #open flyout2 (from right)
        $WPFflyout2Content.IsOpen = $true

        $WPFflyout2BtnClear.Add_Click({
            #$WPFflyout2Content.IsOpen = $false
            $WPFflyout2TxtUsername.Text = ""
            $WPFflyout2TxtPassword.Password = ""
            $WPFflyout2TxtDomain.Text = ""
            $WPFflyout2Msg.Content = ""
        })
        $WPFflyout2BtnSave.Add_Click({
            if (($WPFflyout2TxtUsername.Text) -and ($WPFflyout2TxtPassword.Password) -and ($WPFflyout2TxtDomain.Text)){
                $Global:StoredCred_Username=$WPFflyout2TxtUsername.Text
                $Global:StoredCred_Password=$WPFflyout2TxtPassword.Password
                $Global:StoredCred_Domain=$WPFflyout2TxtDomain.Text
                #write-host "Storing [credentials 2]: $Global:StoredCred_Username, $Global:StoredCred_Password,$Global:StoredCred_Domain"
                Store-Credentials -btnID 2
                $WPFFlyOut2Content.IsOpen = $false 
            }
            Else{
                $WPFflyout2Msg.Content = "All fields must be filled"
            }  
        })
    }

    If ($btnID -eq 3){
        write-host "Opening flyout for [Credential $btnID]"

        If (Get-CredentialsFile -btnID $btnID){
            write-host "Grabbing files for [Credential $btnID]: $Global:CredGidFile, $Global:CredUsrFile,$Global:CredDomFile"
            #decrypt the GUID file first to find the passphrase
            [string]$GUID = Decrypt-String -Encrypted (Get-Content $Global:CredGidFile) -Passphrase $envUserName
            $WPFflyout3TxtUsername.Text = Decrypt-String -Encrypted (Get-Content $Global:CredUsrFile) -Passphrase $GUID
            $WPFflyout3TxtDomain.Text = Decrypt-String -Encrypted (Get-Content $Global:CredDomFile) -Passphrase $GUID
        }
        Else{
            write-host "No files found for [Credential $btnID]"
            If($IsMachinePartOfDomain){$WPFflyout3TxtDomain.Text = $envMachineADDomain}Else{$WPFflyout3TxtDomain.Text = $envComputerName}
        }

        #open flyout2 (from right)
        $WPFflyout3Content.IsOpen = $true

        $WPFflyout3BtnClear.Add_Click({
            #$WPFflyout3Content.IsOpen = $false
            $WPFflyout3TxtUsername.Text = ""
            $WPFflyout3TxtPassword.Password = ""
            $WPFflyout3TxtDomain.Text = ""
            $WPFflyout3Msg.Content = ""
        })
        $WPFflyout3BtnSave.Add_Click({
            if (($WPFflyout3TxtUsername.Text) -and ($WPFflyout3TxtPassword.Password) -and ($WPFflyout3TxtDomain.Text)){
                #Get Credentials from the form textbox
                $Global:StoredCred_Username=$WPFflyout3TxtUsername.Text
                $Global:StoredCred_Password=$WPFflyout3TxtPassword.Password
                $Global:StoredCred_Domain=$WPFflyout3TxtDomain.Text
                #write-host "Storing [credentials 3]: $Global:StoredCred_Username, $Global:StoredCred_Password,$Global:StoredCred_Domain"
                Store-Credentials -btnID 3
                $WPFFlyOut3Content.IsOpen = $false 
            }
            Else{
                $WPFflyout3Msg.Content = "All fields must be filled"
            }  
        })
    }
}



Function Open-CredentialsForm {
    param(
    [parameter(Mandatory=$true)]
	[Int]$btnID
    )

    If (Get-CredentialsFile -btnID $btnID){
        write-host "Retrieving Passphrase for [credentials $btnID] from $Global:CredGidFile"
        #Decrypt GUID key to use as passphrase
        [string]$GUID = Decrypt-String -Encrypted (Get-Content $Global:CredGidFile) -Passphrase $envUserName

        #Get Password
        $StoredUsername = Decrypt-String -Encrypted (Get-Content $Global:CredUsrFile) -Passphrase $GUID
        $StoredDomain = Decrypt-String -Encrypted (Get-Content $Global:CredDomFile) -Passphrase $GUID
        $StoredPassword = Get-Content $Global:CredPwdFile
        #$credential = New-Object -typename System.Management.Automation.PSCredential -ArgumentList $($StoredDomain + "\" + $StoredUsername), $StoredPassword
        #$credPassword = $credential.GetNetworkCredential().Password
    }
 
    #[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") 
    #[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") 

    $credForm = New-Object System.Windows.Forms.Form 
    $credForm.Text = "Enter Credentials"
    $credForm.Size = New-Object System.Drawing.Size(280,190) 
    $credForm.StartPosition = "CenterScreen"
    $credForm.ControlBox = $false
    $credForm.TopMost = $True
    $credForm.FormBorderStyle = 'FixedDialog'


    $credForm.KeyPreview = $True
    $credForm.Add_KeyDown({
        if ($_.KeyCode -eq "Enter"){
            $x=$objTextBox.Text;$credForm.Close()
        }
    })
    $credForm.Add_KeyDown({
        if ($_.KeyCode -eq "Escape"){
            $credForm.Close()
    }})
    
    $credlblUserName = New-Object System.Windows.Forms.Label
    $credlblUserName.Location = New-Object System.Drawing.Size(10,20) 
    $credlblUserName.Size = New-Object System.Drawing.Size(60,20) 
    $credlblUserName.Text = "Username:"
    $credForm.Controls.Add($credlblUserName) 

    $credtbUserName = New-Object System.Windows.Forms.TextBox 
    $credtbUserName.Location = New-Object System.Drawing.Size(75,16) 
    $credtbUserName.Size = New-Object System.Drawing.Size(150,20) 
    If (Get-CredentialsFile -btnID $btnID){
        $credtbUserName.Text = Decrypt-String -Encrypted (Get-Content $Global:CredUsrFile) -Passphrase $GUID
    } 
    $credForm.Controls.Add($credtbUserName) 

    $credlblPassword = New-Object System.Windows.Forms.Label
    $credlblPassword.Location = New-Object System.Drawing.Size(12,45) 
    $credlblPassword.Size = New-Object System.Drawing.Size(60,20) 
    $credlblPassword.Text = "Password:"
    $credForm.Controls.Add($credlblPassword) 

    $credtbPassword = New-Object System.Windows.Forms.MaskedTextBox
    $credtbPassword.Location = New-Object System.Drawing.Size(75,41)
    $credtbPassword.Size = New-Object System.Drawing.Size(150,20)
    $credtbPassword.PasswordChar = '*'

    $credForm.Controls.Add($credtbPassword)

    $credlblDomain = New-Object System.Windows.Forms.Label
    $credlblDomain.Location = New-Object System.Drawing.Size(22,70) 
    $credlblDomain.Size = New-Object System.Drawing.Size(44,20) 
    $credlblDomain.Text = "Domain:"
    $credForm.Controls.Add($credlblDomain) 

    $credtbDomain = New-Object System.Windows.Forms.TextBox 
    $credtbDomain.Location = New-Object System.Drawing.Size(75,66) 
    $credtbDomain.Size = New-Object System.Drawing.Size(80,20)
    If (Get-CredentialsFile -btnID $btnID){
        $credtbDomain.Text = Decrypt-String -Encrypted (Get-Content $Global:CredDomFile) -Passphrase $GUID
    } 
    Else {
        If($IsMachinePartOfDomain){$credtbDomain.Text = $envMachineADDomain}Else{$credtbDomain.Text = $envComputerName}
    }
    $credForm.Controls.Add($credtbDomain)

    $OKButton = New-Object System.Windows.Forms.Button
    $OKButton.Location = New-Object System.Drawing.Size(60,100)
    $OKButton.Size = New-Object System.Drawing.Size(80,40)
    $OKButton.Text = "OK"
    $OKButton.Add_Click({
        #If nothing is filled in, don't allow submit
        if (($credtbUserName.Text) -and ($credtbPassword.Text) -and ($credtbDomain.Text)){
            
            #Get Credentials from the form textbox
            $Global:StoredCred_Username=$credtbUserName.Text
            $Global:StoredCred_Password=$credtbPassword.Text
            $Global:StoredCred_Domain=$credtbDomain.Text
            If ($btnID -eq 1){Store-Credentials -btnID 1}
            If ($btnID -eq 2){Store-Credentials -btnID 2}
            If ($btnID -eq 3){Store-Credentials -btnID 3}
            $credForm.Close()
        } 
        Else {
            
        }
    })
    $credForm.Controls.Add($OKButton)

    $CancelButton = New-Object System.Windows.Forms.Button
    $CancelButton.Location = New-Object System.Drawing.Size(145,100)
    $CancelButton.Size = New-Object System.Drawing.Size(80,40)
    $CancelButton.Text = "Cancel"
    $CancelButton.Add_Click({$credForm.Close()})
    $credForm.Controls.Add($CancelButton)

    $credForm.Add_Shown({$credForm.Activate()})
    [void] $credForm.ShowDialog()
}


Function Select-Credentials {
    param(
    [parameter(Mandatory=$true)]
	[Int]$btnID
    )

    If (Get-CredentialsFile -btnID $btnID){
        #Decrypt GUID key to use as passphrase
        Get-CredentialsFile -btnID $btnID | Out-Null
        [string]$StoredGUID = Decrypt-String -Encrypted (Get-Content $Global:CredGidFile) -Passphrase $envUserName
        [string]$Global:StoredCred_Domain = Decrypt-String -Encrypted (Get-Content $Global:CredDomFile) -Passphrase $StoredGUID
        [string]$Global:StoredCred_Username = Decrypt-String -Encrypted (Get-Content $Global:CredUsrFile) -Passphrase $StoredGUID
        $SelectedRunAsUsername = $Global:StoredCred_Username
        $SelectedRunAsDomain = $Global:StoredCred_Domain
        $SelectedRunAsPwdFile = $Global:CredPwdFile
        If ($btnID -eq 1){
            $WPFbtnCred1.Background = $btnSelectedColor
            $WPFbtnCred2.Background = $btnDefaultColor
            $WPFbtnCred3.Background = $btnDefaultColor
            $Global:SelectedRunAs = $Global:RunAsCreds1
        }
        If ($btnID -eq 2){
            $WPFbtnCred1.Background = $btnDefaultColor
            $WPFbtnCred2.Background = $btnSelectedColor 
            $WPFbtnCred3.Background = $btnDefaultColor
            $Global:SelectedRunAs = $Global:RunAsCreds2
        }
        If ($btnID -eq 3){
            $WPFbtnCred1.Background = $btnDefaultColor
            $WPFbtnCred2.Background = $btnDefaultColor
            $WPFbtnCred3.Background = $btnSelectedColor
            $Global:SelectedRunAs = $Global:RunAsCreds3
        }
        Write-OutputBox -OutputBoxMessage "Selected runas account is now: $($Global:StoredCred_Domain + "\" + $Global:StoredCred_Username)." -Type "INFO: " -Object Tab1 -LogOutput
        $WPFtxtCredUser.Text = $($Global:StoredCred_Domain + "\" + $Global:StoredCred_Username)
        #clear all stored variables before closing form
        Clear-Variable Stored*
    } 
    Else {
        #Since files don't exist, go back prompt
        Store-CredentialsForm -btnID $btnID
    }
}


Function Reset-SelectedCred {
    $WPFbtnCred1.Background = $btnDefaultColor
    $WPFbtnCred2.Background = $btnDefaultColor
    $WPFbtnCred3.Background = $btnDefaultColor
    $WPFtxtCredUser.Text = ''
    $Variables = Get-Variable *Selected*
    If ($AppOptionDebugeMode){Write-Host -Message "Found variables:`n $Variables, clearing it.." -ForegroundColor Yellow}
    Clear-Variable *Selected* -Verbose -Scope Global -ErrorAction SilentlyContinue 
    Remove-Variable *Selected* -Verbose -Scope Global -ErrorAction SilentlyContinue
    [System.GC]::Collect()
    Write-OutputBox -OutputBoxMessage "Cleared selected runas credentials, reverted back to: $envUserName." -Type "INFO: " -Object Tab1 -LogOutput -OutputHost
}


Function Delete-CredentialsFiles {
    [void][System.Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic')
    $result = [Microsoft.VisualBasic.Interaction]::MsgBox("Are you sure you want to remove all stored credentials?", 'YesNo,Question', "Confirm removal")
    switch ($result) {
      'Yes'		{ Continue }
      'No'		{ Return }
    }

    Remove-Item -Path "$envLocalAppData\AdminMenu\cred*" -ErrorAction SilentlyContinue | Out-Null
    Reset-SelectedCred
    $Variables =  Get-Variable *RunAs*
    If ($AppOptionDebugeMode){Write-Host "Found variables:`n $Variables, removing it..." -ForegroundColor Yellow}
    Clear-Variable *RunAsCreds* -Verbose -Scope Global -ErrorAction SilentlyContinue
    Remove-Variable *RunAsCreds* -Verbose -Scope Global -ErrorAction SilentlyContinue
    $WPFbtnCred1.Content = "Enter`nCred 1"
    $WPFbtnCred2.Content = "Enter`nCred 2"
    $WPFbtnCred3.Content = "Enter`nCred 3"
    If ($AppOptionDebugeMode){Write-Host "Removed files from $envLocalAppData\AdminMenu" -ForegroundColor Yellow}
    Write-OutputBox -OutputBoxMessage "Removed All stored credentials." -Type "INFO: " -Object Tab1 -LogOutput -OutputHost
}

function Start-ButtonProcess{
    param(
        [Parameter(Mandatory=$false)]
        [ValidateSet("exe","bat","cmd","msc","remote","ps1","module","invoke","function","hta","vbs","url","java","registry")]
	    [string]$ProcessCall,
        [Parameter(Mandatory=$false)]
        [Alias('Title')]
	    [string]$Alias,
        [Parameter(Mandatory=$false)]
	    $Function,
        [Parameter(Mandatory=$true)]
	    [Alias('FilePath')]
	    [ValidateNotNullorEmpty()]
	    [string]$Path,
	    [Alias('Arguments')]
	    [ValidateNotNullorEmpty()]
	    [string[]]$Parameters,
	    [Parameter(Mandatory=$false)]
	    [ValidateSet('Normal','Hidden','Maximized','Minimized')]
	    [Diagnostics.ProcessWindowStyle]$WindowStyle = 'Normal',
        [Parameter(Mandatory=$false)]
		[ValidateNotNullorEmpty()]
		[switch]$CreateNoWindow = $false,	    
        [Parameter(Mandatory=$false)]
        [Alias('WorkingScriptDirectory')]
	    [ValidateNotNullorEmpty()]
	    [string]$WorkingDirectory,
        [Parameter(Mandatory=$false)]
        [switch]$NeverRunAs = $false,
        [ValidateSet("Tab1","Tab2","Tab3","Tab4","Tab5")]
        $OutputTab,
        [Parameter(Mandatory=$false)]
	    [string]$CustomRunMsg,
        [Parameter(Mandatory=$false)]
	    [string]$CustomErrMsg
    )
    Begin {
        $originalPath = $Path
        $ExtensionScriptsPath = Join-Path -Path $ExtensionPath -ChildPath "\Scripts"

        Switch ($ProcessCall) 
        {
            "ps1" 
            {
                If ($Parameters){$Parameters = "-ExecutionPolicy Bypass -STA -NoProfile -NoLogo -Windowstyle Hidden -File `"$Path`" $Parameters"}
                Else {$Parameters = "-ExecutionPolicy Bypass -STA -NoProfile -NoLogo -Windowstyle Hidden -File `"$Path`""}
                $Path = "$PSHOME\powershell.exe"
                $WorkingDirectory = Join-Path -Path $ExtensionScriptsPath -ChildPath $WorkingDirectory
            }

            "invoke" 
            {
                $Path = Join-Path -Path $ExtensionScriptsPath -ChildPath $Path
                If ($Parameters){$Path = "`"$Path`" $Parameters"}
            }

            "module"
            {
                $Parameters = "-ExecutionPolicy Bypass -NoExit -Command `"& Import-Module $Path`" $Parameters"
                $Path = "$PSHOME\powershell.exe"
            }

            "function" {$Path = $Parameters}
            
            "bat" 
            {
                $Parameters = "/C `"$Path`" $Parameters"
                $Path = "$envComSpec"
            }

            "cmd"
            {
                $Parameters = "/K `"$Path`" $Parameters"
                $Path = "$envComSpec"
            }

            "vbs"
            {
                $Parameters = "`"$Path`" $Parameters"
                $Path = "$envWinDir\System32\wscript.exe"
            }

            "hta"
            {
                $Parameters = " `"$Path`" $Parameters"
                $Path = "$envWinDir\System32\mshta.exe"
            }
        }

        #START PUTTING IT TOGETHER IN HASH
        #Hash table: dynamically add Param if not null
        $ProcessHash = @{FilePath = "$Path"} 

        # Build Run message
        $runmsg = "Starting"

        If($Alias){
            $Alias = $($Alias).Replace("`n"," ").Replace("`r","")
            # append Alias to runmsg
            $runmsg += " [$Alias]"
        }
        ElseIf($ButtonClicked){
            $ButtonClicked = $($ButtonClicked).Replace("`n"," ").Replace("`r","")
            # append Button to runmsg
            $runmsg += " [$ButtonClicked]"
        }
        Else{$runmsg += " [$Path]"}

        #Add additional paramaters to hash table
        if ($Parameters) {
            $ProcessHash["ArgumentList"]=$Parameters
            # append Parameters to runmsg
            $runmsg += " with Parameters [$Parameters]"
        }
        #get saved credentials if any
        if ($Global:SelectedRunAs){$ProcessHash["Credential"]=$Global:SelectedRunAs}

        #Check if no new window is needed
        if ($CreateNoWindow){$ProcessHash["NoNewWindow"]=$true}Else{
        if ($WindowStyle){$ProcessHash["WindowStyle"]=$WindowStyle}}

        #process working directory
        if ($WorkingDirectory){
            $ProcessHash["WorkingDirectory"]=$WorkingDirectory
            # append working directory to runmsg
            $runmsg += " from working directory [$WorkingDirectory]"
        } 
        Else {$ProcessHash["WorkingDirectory"]=$ExtensionScriptsPath}

        # append Selected Credentials to runmsg
        If ($Global:SelectedRunAs -and ($NeverRunAs -eq $false)){$runmsg += " running as [$($Global:SelectedRunAs.UserName)]"}

        If($CustomRunMsg){
            $CustomRunMsg = $($CustomRunMsg).Replace("`n"," ").Replace("`r","")
            $runmsg = $CustomRunMsg
        }

        If($CustomErrMsg){
            $CustomErrMsg = $($CustomErrMsg).Replace("`n"," ").Replace("`r","")
            $errmsg = $CustomErrMsg
        }
        Else{$errmsg = "[$Path] not found."}

        If ($OutputTab){
            Write-OutputBox -OutputBoxMessage $runmsg -Type "START: " -Object $OutputTab -LogOutput
            If ($AppOptionDebugeMode){Write-Log -Message "$runmsg" -Severity 1 -OutputHost}
        }
	}
	Process {
		If (($ProcessCall -ne "registry") -and !(Test-Path -LiteralPath $Path -PathType 'Leaf' -ErrorAction 'Stop') ) {
			Write-OutputBox -OutputBoxMessage $errmsg -Type "ERROR: " -Object $OutputTab -LogOutput
            Return 
		}
		Else {
            Try{
                Switch ($ProcessCall) 
                {
				    "remote"    
                    {
                        $Results = Invoke-Command -ComputerName $($WPFtxtBoxRemote.Text) @ProcessHash
                        Write-Log -Message "Invoking remote command to [$($WPFtxtBoxRemote.Text)]:" $Results -Severity 1
                    }
                    "registry"    
                    {
                        $Name = $Parameters.Split("=")[0]
                        $Value = $Parameters.Split("=")[1]
                        $Results = Set-ItemProperty -Path $Path -Name $Name -Value $Value -Force
                        Write-Log -Message "Configured registry key:" $Results -Severity 1
                    }
				    "invoke"    
                    {
                        $Results = Invoke-Expression -Command $Path
                        Write-Log -Message "Invoking expression to with command [$Path]:" $Results -Severity 1
                    }

				    "exe"       
                    {
                        $ps = new-object System.Diagnostics.Process
                        $ps.StartInfo.Filename = "$Path"
                        If ($Parameters) { $ps.StartInfo.Arguments = "$Parameters" }
                        $ps.StartInfo.UseShellExecute = $false
                        $ps.StartInfo.WorkingDirectory = $WorkingDirectory
				        $ps.StartInfo.ErrorDialog = $false
                        $ps.StartInfo.RedirectStandardOutput = $true
				        $ps.StartInfo.RedirectStandardError = $true
                        If ($Global:SelectedRunAs){
                            $RawUserName = $Global:SelectedRunAs.UserName 
                            if ($RawUserName -match "@") 
                                {$Domain = $RawUserName.Split('@')[1]; $User = $RawUserName.Split('@')[0]} 
                            if ($RawUserName -match "\\") 
                                {$Domain = $RawUserName.Split('\')[0]; $User = $RawUserName.Split('\')[1]} 
                            $ps.StartInfo.Username = $User
                            $ps.StartInfo.Password = $Global:SelectedRunAs.Password 
                            $ps.StartInfo.Domain = $Domain 
				        }
                        #$ps.StartInfo.CreateNoWindow = $CreateNoWindow
                        If ($windowStyle) { $ps.StartInfo.WindowStyle = $WindowStyle }
                        $ps.start()
                        #$ps.WaitForExit()
                        [string] $Out = $ps.StandardOutput.ReadToEnd();
                        Write-Log -Message "Executing [$Path $Parameters]:" $Out -Severity 1
                    }

                    "function"  
                    {
                        "$Function $Path"
                        Write-Log -Message "Calling function [$Function $Path]" -Severity 1
                    }

                    "url"       
                    {
                        $Results = Invoke-Expression “cmd.exe /C start $Path”
                        Write-Log -Message "Opening web url [$Path]:" $Results -Severity 1
                    }

                    default     
                    {
                        $Results = Start-Process @ProcessHash -PassThru
                        Write-Log -Message "Starting process": $Results -Severity 1  
                    }
                   
                } # end Process call switch
            } 
            Catch{
                $ErrorMessage = $_.Exception.Message
                If ($AppOptionDebugeMode){Write-Log -Message "failed to start [$ProcessCall] process. The error message was [$ErrorMessage]" -Severity 3 -OutputHost}
                Write-OutputBox -OutputBoxMessage "failed to start process. The error message was [$ErrorMessage]" -Type "ERROR: " -Object $OutputTab -LogOutput
            }
        }
    }
    End {}
}



Function Launch-QuickMenu{
    $xamlQMPath = "$($XamlPath + "\QuickAccessHorizontal.xaml")"
    [xml]$quickXAML = (get-content $xamlQMPath -ReadCount 0) -replace 'mc:Ignorable="d"','' -replace "x:N",'N' -replace '^<Win.*', '<Window'

    #Load APP Form
    $readerQM=(New-Object System.Xml.XmlNodeReader $quickXAML)
    try{
        $QMenu=[Windows.Markup.XamlReader]::Load($readerQM)
    }
    catch{
        Write-Host "Unable to load Windows.Markup.XamlReader. Some possible causes for this problem include: 
        - .NET Framework is missing
        - PowerShell must be launched with PowerShell -sta
        - invalid XAML code was encountered
        - The error message was [$ErrorMessage]" -ForegroundColor White -BackgroundColor Red
    }
    #====================================
    # Store Form Objects In PowerShell
    #===================================

    # Turn XAML into PowerShell objects
    $quickXAML.SelectNodes("//*[@Name]") | ForEach-Object { Set-Variable -Name "QMenu$($_.Name)" -Value $QMenu.FindName($_.Name)}



    ##*===============================
    ##* QUICK CONTENT AND BUTTONS 
    ##*===============================

    # hide the credential window if it's double clicked
    $QMenu.Add_MouseDoubleClick({
    
	    $QMenu.Hide()
    })

    # hide the credential window if it loses focus
    #$QMenu.Add_Deactivated({
    #	$QMenu.Hide()
    #})

    #$App.Hide()			
    # reposition each time, in case the resolution or monitor changes
	$QMenu.Left = $([System.Windows.SystemParameters]::WorkArea.Width-$QMenu.Width)
	$QMenu.Top = $([System.Windows.SystemParameters]::WorkArea.Height-$QMenu.Height)
	$QMenu.Show()
	$QMenu.Activate()
}


Function Build-QuickAccess{
    # Set the File Name
    $filePath = "$envLocalAppData\AdminMenu\QuickAccess.config"

    # Create The Document
    $XmlWriter = New-Object System.XMl.XmlTextWriter($filePath,$Null)

    # Set The Formatting
    $xmlWriter.Formatting = "Indented"
    $xmlWriter.Indentation = "4"

    # Write the XML Decleration
    $xmlWriter.WriteStartDocument()

    # Set the XSL
    #$XSLPropText = "type='text/xsl' href='style.xsl'"
    #$xmlWriter.WriteProcessingInstruction("xml-stylesheet", $XSLPropText)

    # Write Root Element
    $xmlWriter.WriteStartElement("QuickMenu")

    # Write the Document
    $xmlWriter.WriteStartElement("button")
    $xmlWriter.WriteElementString("TabID","1")
    $xmlWriter.WriteElementString("BtnID","1")
    $xmlWriter.WriteElementString("Name","Powershell")
    $xmlWriter.WriteElementString("fgColor","#FFFFFFFF")
    $xmlWriter.WriteElementString("bgColor","#FF000000")
    $xmlWriter.WriteEndElement # <-- Closing Servers

    # Write Close Tag for Root Element
    $xmlWriter.WriteEndElement # <-- Closing button
    # End the XML Document
    $xmlWriter.WriteEndDocument()

    # Finish The Document
    $xmlWriter.Finalize
    $xmlWriter.Flush
    $xmlWriter.Close()

}

#https://learn-powershell.net/2012/12/02/powershell-and-wpf-listbox/
Function Save-ComputerList {
     param(       
        [parameter(Mandatory=$true)]
        [ValidateSet("Tab1","Tab2","Tab3","Tab4","Tab5")]
        $TabObject,
        $TitleDesc
    )

    $Title = $TitleDesc


    $SavedPath = "$envLocalAppData\AdminMenu\SAVEDLIST.$TabObject"
    [scriptblock]$AddBtnScript = {
        If ((-NOT [string]::IsNullOrEmpty($inputTextBox.text))) {
            if ($inputTextBox.text.split('.')[0].Length -gt 15) {
                [System.Windows.Forms.MessageBox]::Show('System name cannot be more than 15 characters.','To Long',
                [System.Windows.Forms.MessageBoxButtons]::OK,[System.Windows.Forms.MessageBoxIcon]::Error)
            }
            #Validation Rule for computer names.
            elseif ($inputTextBox.text -notmatch "(?=^.{1,253}$)(^(((?!-)[a-zA-Z0-9-]{1,63}(?<!-))|((?!-)[a-zA-Z0-9-]{1,63}(?<!-)\.)+[a-zA-Z]{2,63})$)"){
                [System.Windows.Forms.MessageBox]::Show('System name is invalid, please correct the computer name.','Invalid Characters',
                [System.Windows.Forms.MessageBoxButtons]::OK,[System.Windows.Forms.MessageBoxIcon]::Error)
            }
            else{
                $listbox.Items.Add($inputTextBox.text)
                $inputTextBox.text | Out-File $SavedPath -Append
                If ($AppOptionDebugeMode){Write-Log -Message "Added Item: $($inputTextBox.text)" -Severity 1 -OutputHost}
                $inputTextBox.Clear()
            }
        }
    }

    #Build the GUI
    $listXAML = "$($XamlPath + "\ListboxWindow.xaml")"
    [xml]$listXAML = (get-content $listXAML -ReadCount 0) -replace 'mc:Ignorable="d"','' -replace "x:N",'N' -replace '^<Win.*', '<Window'

    #Load APP Form
    $listreader=(New-Object System.Xml.XmlNodeReader $listXAML)
    try{
        $SaveForm=[Windows.Markup.XamlReader]::Load($listreader)
    }
    catch{
        Write-Host "Unable to load Windows.Markup.XamlReader. Some possible causes for this problem include: 
        - .NET Framework is missing
        - PowerShell must be launched with PowerShell -sta
        - invalid XAML code was encountered
        - The error message was [$ErrorMessage]" -ForegroundColor White -BackgroundColor Red
        exit
    }

    $SaveForm.Title = $Title
    ## PROCESS APP ICON FIRST
    # Create a streaming image by streaming the base64 string to a bitmap streamsource
    $SaveFormBitmap = New-Object System.Windows.Media.Imaging.BitmapImage
    $SaveFormBitmap.BeginInit()
    $SaveFormBitmap.StreamSource = [System.IO.MemoryStream][System.Convert]::FromBase64String($AddlistBase64Icon)
    $SaveFormBitmap.EndInit()
    $SaveFormBitmap.Freeze()

    $SaveForm.Topmost = $True

    $SaveForm.Icon = $SaveFormBitmap

    #Connect to Controls
    $inputTextBox = $SaveForm.FindName('inputTextBox')
    $addButton = $SaveForm.FindName('addButton')
    $listbox = $SaveForm.FindName('listbox')
    $removeButton = $SaveForm.FindName('removeButton')
    $selectButton = $SaveForm.FindName('selectButton')

    If (Test-Path -Path $SavedPath){
         (Get-Content $SavedPath) | ForEach {
            [void]$listbox.Items.Add($_)
            If ($AppOptionDebugeMode){Write-Log -Message "Retrieved Item: $_" -Severity 1 -OutputHost}
        } 
        
    }
 
    #Events
    $addButton.Add_Click($AddBtnScript)

    $removeButton.Add_Click({
        While ($listbox.SelectedItems.count -gt 0) {
            $listbox.Items.RemoveAt($listbox.SelectedIndex)
            $listbox.Items | Out-File $SavedPath
        }  
    })

    $listbox.Add_Drop({
        (Get-Content $_.Data.GetFileDropList()) | ForEach {
            $listbox.Items.Add($_)
        }
    })

    #Alternate way to handle the selection change
    $listbox.Add_SelectionChanged({
        $inputTextBox.text  = $listbox.SelectedItem
    })


    $selectButton.Add_Click({
        If ($listbox.SelectedItems.count -eq 1) {
            If($TabObject -eq 'Tab1'){
                $WPFtxtTab1Name1.Text = $listbox.SelectedItem 
            }
            If($TabObject -eq 'Tab2'){
                $WPFtxtTab2Name2.Text = $listbox.SelectedItem 
            }
            If($TabObject -eq 'Tab3'){
                $WPFtxtTab3Name2.Text = $listbox.SelectedItem 
            }
            If($TabObject -eq 'Tab4'){
                $WPFtxtTab4Name1.Text = $listbox.SelectedItem 
            }
            If($TabObject -eq 'Tab5'){
                $WPFtxtTab5Name1.Text = $listbox.SelectedItem 
            }
            $SaveForm.Close()
        } 
        Else{
            [System.Windows.Forms.MessageBox]::Show("Please highlight only one item and try again") 
        }
    })

    $SaveForm.Add_KeyDown({ 
        $key = $_.Key  
        If ([System.Windows.Input.Keyboard]::IsKeyDown("RightCtrl") -OR [System.Windows.Input.Keyboard]::IsKeyDown("LeftCtrl")) {
            Switch ($Key) {
                "C" {
                    [Windows.Clipboard]::SetText($listbox.SelectedItem)          
                }
                "R" {
                    While ($listbox.SelectedItems.count -gt 0) {
                        $listbox.Items.RemoveAt($listbox.SelectedIndex)
                        $listbox.Items | Out-File $SavedPath
                    }           
                }
                "E" {
                    $This.Close()
                }
                Default {$Null}
                }
            }
        })

    # Build form
    [void]$SaveForm.ShowDialog()

}

Function Open-AboutWindow {
    #Build the GUI
    $AboutXAML = "$($XamlPath + "\About.xaml")"
    [xml]$AboutXAML = (get-content $AboutXAML -ReadCount 0) -replace 'mc:Ignorable="d"','' -replace "x:N",'N' -replace '^<Win.*', '<Window'

    #Load APP Form
    $Aboutreader=(New-Object System.Xml.XmlNodeReader $AboutXAML)
    try{
        $AboutForm=[Windows.Markup.XamlReader]::Load($Aboutreader)
    }
    catch{
        Write-Host "Unable to load Windows.Markup.XamlReader. Some possible causes for this problem include: 
        - .NET Framework is missing
        - PowerShell must be launched with PowerShell -sta
        - invalid XAML code was encountered
        - The error message was [$ErrorMessage]" -ForegroundColor White -BackgroundColor Red
        exit
    }
    $AboutFormIcon = New-Object System.Windows.Media.Imaging.BitmapImage
    $AboutFormIcon.BeginInit()
    $AboutFormIcon.StreamSource = [System.IO.MemoryStream][System.Convert]::FromBase64String($AppBase64Icon_32px)
    $AboutFormIcon.EndInit()
    $AboutFormIcon.Freeze()

    #Connect to Controls
    $AboutImage = $AboutForm.FindName('AboutImage')
    $AboutAuthor = $AboutForm.FindName('AbouttxtAuthor')
    $AboutVersion = $AboutForm.FindName('AbouttxtVersion')
    $AboutDate = $AboutForm.FindName('AbouttxtDate')
    $AboutLicense = $AboutForm.FindName('AbouttxtLicense')
    $AboutEULA = $AboutForm.FindName('AboutEULA')

    $AboutForm.Title = "About $Title"
    $AboutForm.Icon = $AboutFormIcon
    $AboutForm.Topmost = $True

    ## PROCESS APP ICON FIRST
    # Create a streaming image by streaming the base64 string to a bitmap streamsource
    
    $AboutFormBitmap = New-Object System.Windows.Media.Imaging.BitmapImage
    $AboutFormBitmap.BeginInit()
    $AboutFormBitmap.StreamSource = [System.IO.MemoryStream][System.Convert]::FromBase64String($AboutBase64Image_100x100)
    $AboutFormBitmap.EndInit()
    $AboutFormBitmap.Freeze()

    $AboutImage.Source = $AboutFormBitmap

    #Update Info
    $AboutAuthor.Text = $AppAuthor
    $AboutVersion.Text = $AppVersion
    $AboutDate.Text = $AppDate
    $AboutLicense.Text = $env:COMPUTERNAME
    
    $licensefile = Join-Path -Path $scriptRoot -ChildPath 'License.txt'
    [string]$licenseinfo = Get-Content $licensefile
    If (Test-Path $licensefile){
        $AboutEULA.AppendText("$licenseinfo")
    }
    Else{
        $AboutEULA.Visibility = 'Hidden'
    }
    # Build form
    [void]$AboutForm.ShowDialog()
}