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


##*=============================================
##* Functions
##*=============================================
Function Get-FormVariables{
    if ($Global:LogDebugMode -ne $true){Write-host "If you need to reference this display again, run Get-FormVariables" -ForegroundColor Yellow;$Global:LogDebugMode=$true}
    write-host "Found the following interactable elements from our form" -ForegroundColor Cyan
    get-variable WPF*
    get-variable POP*
}

function Validate-RunChecks {
    $ValidateCounter = 0
    if (Validate-PSCheck) {
        $ValidateCounter++
    }
    if (Validate-Elevated) {
        $ValidateCounter++
    }
    if (Validate-OSCheck) {
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

function Validate-Elevated {
    $UserWP = New-Object Security.Principal.WindowsPrincipal($CurrentProcessToken)
    try {
        if ($UserWP.IsInRole("S-1-5-32-544")) {
            $WPFlblElevatedCheck.Content = 'Yes'
		    $WPFlblElevatedCheck.Foreground = '#FF0BEA00'
            Write-OutputBox -OutputBoxMessage "User has local administrative rights, and the tool was launched elevated" -Type "INFO: " -Object Tab1
            return $true
        }
        else {
            Write-OutputBox -OutputBoxMessage "The tool requires local administrative rights and was not launched elevated" -Type "ERROR: " -Object Tab1
            $WPFlblElevatedCheck.Content = 'No'
            $WPFlblElevatedCheck.Foreground = '#FFFF0000'
            return $false
        }
    }
    catch [System.Exception] {
        Write-OutputBox -OutputBoxMessage "An error occured when attempting to query for elevation, possible due to issues contacting the domain or the tool is launched in a sub-domain. If used in a sub-domain, check the override checkbox to enable this tool" -Type "WARNING: " -Object Tab1
    }
}

function Validate-RSATInstalled {
    param(
	    [parameter(Mandatory=$false)]
	    $OutPutBox = $true
	)
    Begin {
        $WPFlblRSAT.Visibility = 'Visible' 
        $WPFlblRSATCheck.Visibility = 'Visible'
        $RSAT = Get-WindowsOptionalFeature -Online | Where {$_.FeatureName -like "RSAT*"}
    }
    Process {
        If ($RSAT) {
            If($OutPutBox){Write-OutputBox -OutputBoxMessage "RSAT is installed." -Type "INFO: " -Object Tab1}
            $WPFlblRSATCheck.Content = 'Yes'
	        $WPFlblRSATCheck.Foreground = '#FF0BEA00'
            return $true
        } Else {
            If($OutPutBox){Write-OutputBox -OutputBoxMessage "RSAT is not installed. " -Type "ERROR: " -Object Tab1}
            $WPFlblRSATCheck.Foreground = '#FFFF0000'
            return $false
        }
	}
}

function Validate-RebootPending {
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

function Validate-RebootPendingCheck {
	$GetComputerName = $env:COMPUTERNAME
	$ValidateRebootPending = Validate-RebootPending -ComputerName $GetComputerName
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

function Validate-OSCheck {
    $WPFlblSupportedOSCheck.Content = $envOSVersion
	if (($envOSProductType -eq 1) -and ($envOSVersion -ge $MinimumOSversion)) {
        Write-OutputBox -OutputBoxMessage "Supported operating system found" -Type "INFO: " -Object Tab1
        $WPFlblSupportedOSCheck.Foreground = '#FF0BEA00'
        return $true
	}
    elseif (($envOSProductType -eq 3) -and ($envOSVersion -ge $MinimumOSversion)) {
		    Write-OutputBox -OutputBoxMessage "The detected operating system is a suported Server OS." -Type "INFO: " -Object Tab1
            $WPFlblElevatedCheck.Content = $envOSVersion
            $WPFlblSupportedOSCheck.Foreground = '#FF0BEA00'
            return $false
    }
    else {
        if ($envOSVersion -lt $MinimumOSversion) {
		    Write-OutputBox -OutputBoxMessage "The detected operating system is not supported. This tool is supported on Windows Server 2008 R2 and above" -Type "ERROR: " -Object Tab1
            $WPFlblElevatedCheck.Content = $envOSVersion
            $WPFlblElevatedCheck.Foreground = '#FFFF0000'
            return $false
        }
        if ($envOSProductType -eq 2) {
		    Write-OutputBox -OutputBoxMessage "The detected system is a Domain Controller. This tool can be ran but not recommended" -Type "WARNING: " -Object Tab1
            $WPFlblElevatedCheck.Content = 'DC'
            $WPFlblSupportedOSCheck.Foreground = '#FFFFE800'
            return $false
        }
        if ($envOSProductType -eq 3) {
		    Write-OutputBox -OutputBoxMessage "The detected operating system is an unsupported Server OS." -Type "ERROR: " -Object Tab1
            $WPFlblElevatedCheck.Content = $envOSVersion
            $WPFlblSupportedOSCheck.Foreground = '#FFFF0000'
            return $false
        }
	}
}


function Validate-PSCheck {
    $PSMajMin = ($envPSVersion[0] + "." + $envPSVersion[2])
    if ($PSMajMin -ge "3.0") {
        Write-OutputBox -OutputBoxMessage "Supported version of PowerShell was detected [$PSMajMin]" -Type "INFO: " -Object Tab1
        $WPFlblPSVersionCheck.Content = $PSMajMin
        $WPFlblPSVersionCheck.Foreground = '#FF0BEA00'
        return $true
    }
    else {
        Write-OutputBox -OutputBoxMessage "Unsupported version of PowerShell detected [$PSMajMin]. This tool requires PowerShell 3.0 and above" -Type "ERROR: " -Object Tab1
        $lblPSVersionCheck.Content = $PSMajMin
        return $false
    }
}

# ——————————————-
# Function Name: Get-LoggedIn
# Return the current logged-in user of a remote machine.
# ——————————————-
function Get-LoggedIn {
    [CmdletBinding()]
    param (
    [Parameter(Mandatory=$True)]
    [string[]]$computername,
    [Parameter(Mandatory=$True)]
    $Outbox
    )

    foreach ($pc in $computername){
        $logged_in = (gwmi win32_computersystem -COMPUTER $pc).username
        $name = $logged_in.split("\")[1]
        
        Write-OutputBox -OutputBoxMessage "Current Logged in user: $("{0}: {1}" -f $pc,$name)" -Type "INFO: " -Object $Outbox
    }
}


Function Test-PSRemoting {
[cmdletbinding()]

Param(
    [Parameter(Position=0,Mandatory,HelpMessage = "Enter a computername",ValueFromPipeline)]
    [ValidateNotNullorEmpty()]
    [string]$Computername,
    [System.Management.Automation.Credential()]$Credential = [System.Management.Automation.PSCredential]::Empty
    )

    Begin {
        Write-Verbose -Message "Starting $($MyInvocation.Mycommand)"  
    } #begin

    Process {
      Write-Verbose -Message "Testing $computername"
      Try {
        $r = Test-WSMan -ComputerName $Computername -Credential $Credential -Authentication Default -ErrorAction Stop
        return $True 
      }
      Catch {
        Write-Verbose $_.Exception.Message
        return $False

      }

    } #Process

    End {
        Write-Verbose -Message "Ending $($MyInvocation.Mycommand)"
    } #end

}


function Ping-System {
    param(
        [parameter(Mandatory=$false)]
        [string]$Remote
    )
    If ($Remote -ne $null){
        $pingResult=ping $Remote | fl | out-string;
    } 
    Else {
        $pingResult=ping | fl | out-string;
    }
    Write-OutputBox -OutputBoxMessage $pingResult -Type "PING: " -Object Tab1
}

function Encrypt-String($String, $Passphrase, $salt="SaltCrypto", $init="IV_Password", [switch]$arrayOutput)
{
	# Create a COM Object for RijndaelManaged Cryptography
	$r = new-Object System.Security.Cryptography.RijndaelManaged
	# Convert the Passphrase to UTF8 Bytes
	$pass = [Text.Encoding]::UTF8.GetBytes($Passphrase)
	# Convert the Salt to UTF Bytes
	$salt = [Text.Encoding]::UTF8.GetBytes($salt)

	# Create the Encryption Key using the passphrase, salt and SHA1 algorithm at 256 bits
	$r.Key = (new-Object Security.Cryptography.PasswordDeriveBytes $pass, $salt, "SHA1", 5).GetBytes(32) #256/8
	# Create the Intersecting Vector Cryptology Hash with the init
	$r.IV = (new-Object Security.Cryptography.SHA1Managed).ComputeHash( [Text.Encoding]::UTF8.GetBytes($init) )[0..15]
	
	# Starts the New Encryption using the Key and IV   
	$c = $r.CreateEncryptor()
	# Creates a MemoryStream to do the encryption in
	$ms = new-Object IO.MemoryStream
	# Creates the new Cryptology Stream --> Outputs to $MS or Memory Stream
	$cs = new-Object Security.Cryptography.CryptoStream $ms,$c,"Write"
	# Starts the new Cryptology Stream
	$sw = new-Object IO.StreamWriter $cs
	# Writes the string in the Cryptology Stream
	$sw.Write($String)
	# Stops the stream writer
	$sw.Close()
	# Stops the Cryptology Stream
	$cs.Close()
	# Stops writing to Memory
	$ms.Close()
	# Clears the IV and HASH from memory to prevent memory read attacks
	$r.Clear()
	# Takes the MemoryStream and puts it to an array
	[byte[]]$result = $ms.ToArray()
	# Converts the array from Base 64 to a string and returns
	return [Convert]::ToBase64String($result)
}

function Decrypt-String($Encrypted, $Passphrase, $salt="SaltCrypto", $init="IV_Password")
{
	# If the value in the Encrypted is a string, convert it to Base64
	if($Encrypted -is [string]){
		$Encrypted = [Convert]::FromBase64String($Encrypted)
   	}

	# Create a COM Object for RijndaelManaged Cryptography
	$r = new-Object System.Security.Cryptography.RijndaelManaged
	# Convert the Passphrase to UTF8 Bytes
	$pass = [Text.Encoding]::UTF8.GetBytes($Passphrase)
	# Convert the Salt to UTF Bytes
	$salt = [Text.Encoding]::UTF8.GetBytes($salt)

	# Create the Encryption Key using the passphrase, salt and SHA1 algorithm at 256 bits
	$r.Key = (new-Object Security.Cryptography.PasswordDeriveBytes $pass, $salt, "SHA1", 5).GetBytes(32) #256/8
	# Create the Intersecting Vector Cryptology Hash with the init
	$r.IV = (new-Object Security.Cryptography.SHA1Managed).ComputeHash( [Text.Encoding]::UTF8.GetBytes($init) )[0..15]


	# Create a new Decryptor
	$d = $r.CreateDecryptor()
	# Create a New memory stream with the encrypted value.
	$ms = new-Object IO.MemoryStream @(,$Encrypted)
	# Read the new memory stream and read it in the cryptology stream
	$cs = new-Object Security.Cryptography.CryptoStream $ms,$d,"Read"
	# Read the new decrypted stream
	$sr = new-Object IO.StreamReader $cs
	# Return from the function the stream
	Write-Output $sr.ReadToEnd()
	# Stops the stream	
	$sr.Close()
	# Stops the crypology stream
	$cs.Close()
	# Stops the memory stream
	$ms.Close()
	# Clears the RijndaelManaged Cryptology IV and Key
	$r.Clear()
}

function Clear-OutputBox {
	$OutputBox.ResetText()	
}


function Write-OutputBox {
	param(
	[parameter(Mandatory=$true)]
	[string]$OutputBoxMessage,
	[ValidateSet("WARNING: ","ERROR: ","INFO: ","PING: ", "START: ")]
	[string]$Type,
    [parameter(Mandatory=$true)]
    [ValidateSet("Tab1","tab2","tab3","tab4","tab5")]
    [string]$Object
	)
	Process {
        if ($Object -like "Tab1") {
			$WPFtxtBoxTab1Output.AppendText("`n$($Type)$($OutputBoxMessage)")
            [System.Windows.Forms.Application]::DoEvents()
            $WPFtxtBoxTab1Output.ScrollToEnd()

        }
        if ($Object -like "tab2") {
			$WPFtxtBoxTab2Output.AppendText("`n$($Type)$($OutputBoxMessage)")
			[System.Windows.Forms.Application]::DoEvents()
            $WPFtxtBoxTab2Output.ScrollToEnd()

        }
        if ($Object -like "tab3") {
		    $WPFtxtBoxTab3Output.AppendText("`n$($Type)$($OutputBoxMessage)")
			[System.Windows.Forms.Application]::DoEvents()
            $WPFtxtBoxTab3Output.ScrollToEnd()
        }
        if ($Object -like "tab4") {
			$WPFtxtBoxTab4Output.AppendText("`n$($Type)$($OutputBoxMessage)")
			[System.Windows.Forms.Application]::DoEvents()
            $WPFtxtBoxTab4Output.ScrollToEnd()
        }
        if ($Object -like "tab5") {
			$WPFtxtBoxTab5Output.AppendText("`n$($Type)$($OutputBoxMessage)")
			[System.Windows.Forms.Application]::DoEvents()
            $WPFtxtBoxTab5Output.ScrollToEnd()
        }
	}
} 

Function Store-CredentialsXAMLPOP {
    param(
    [parameter(Mandatory=$true)]
	[String]$Content,
    [String]$Username,
    [parameter(Mandatory=$true)]
	[Int]$btn
    )
    $CredFile = "$envLocalAppData\AdminMenu\Cred$([string]$btn).tmp"
    $FileExists = Test-Path $CredFile

    $CredPopup.Left = $([System.Windows.SystemParameters]::WorkArea.Width-$CredPopup.Width)
	$CredPopup.Top = $([System.Windows.SystemParameters]::WorkArea.Height-$CredPopup.Height)
    
    $POPlblCredentials.Content = $POPlblCredentials.Content + " ($Content)"
    
    $CredPopup.Show()
	$CredPopup.Activate()

    If ($btn -eq 1){
        # Assuming if password file exist then username and domain does too
        if  ($FileExists) {
            $StoredCred1_Password = get-content $CredFile | convertto-securestring
            $POPtxtBoxUsername.Text = $StoredCred1_Username
            $POPpwdBoxPassword.TextInput = $StoredCred1_Password 
            $POPtxtBoxDomain.Text = $StoredCred1_Domain
        }
        else{
            $StoredCred1_Username = $POPtxtBoxUsername.Text
            $StoredCred1_Password = $POPpwdBoxPassword.TextInput 
            $StoredCred1_Domain = $POPtxtBoxDomain.Text
        }
        $POPbtnSubmit.add_Click({
            $SecurePassword = $StoredCred1_Password | ConvertTo-SecureString -AsPlainText -Force 
            $SecurePassword | ConvertFrom-SecureString | Out-File $CredFile 
            $StoredCred1 = new-object -typename System.Management.Automation.PSCredential -ArgumentList $StoredCred1_Domain\$StoredCred1_Username,$StoredCred1_Password
            $CredPopup.Hide()
            $WPFbtnCred1.Content = "Use`nCred 1"
        })
    }

    #clear content label
    $POPlblCredentials.Content = $POPlblCredentials.Content

}

Function Store-CredentialsForm{
    param(
    [String]$Username,
    [parameter(Mandatory=$true)]
	[Int]$btnID
    )
    $CredUsrFile = "$envLocalAppData\AdminMenu\cred$([string]$btnID).usr"
    $CredPwdFile = "$envLocalAppData\AdminMenu\cred$([string]$btnID).pwd"
    $CredDomFile = "$envLocalAppData\AdminMenu\cred$([string]$btnID).dom"
    $CredGidFile = "$envLocalAppData\AdminMenu\cred$([string]$btnID).gid"
    $UsrFileExists = Test-Path $CredUsrFile
    $PwdFileExists = Test-Path $CredPwdFile
    $DomFileExists = Test-Path $CredDomFile
    $GidFileExists = Test-Path $CredGidFile
    If ($UsrFileExists -and $PwdFileExists -and $DomFileExists -and $GidFileExists){
        $AllFilesExist = $true
        #Decrypt GUID key to use as passphrase
        [string]$GUID = Decrypt-String -Encrypted (Get-Content $CredGidFile) -Passphrase $envUserName
    } 
    Else {
        $AllFilesExist = $false
    }
 

    [void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") 
    [void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") 

    $objForm = New-Object System.Windows.Forms.Form 
    $objForm.Text = "Enter Credentials"
    $objForm.Size = New-Object System.Drawing.Size(280,190) 
    $objForm.StartPosition = "CenterScreen"
    $objForm.ControlBox = $false
    $objForm.TopMost = $True
    $objForm.FormBorderStyle = 'FixedDialog'


    $objForm.KeyPreview = $True
    $objForm.Add_KeyDown({
        if ($_.KeyCode -eq "Enter"){
            $x=$objTextBox.Text;$objForm.Close()
        }
    })
    $objForm.Add_KeyDown({
        if ($_.KeyCode -eq "Escape"){
            $objForm.Close()
    }})
    
    $OKButton = New-Object System.Windows.Forms.Button
    $OKButton.Location = New-Object System.Drawing.Size(60,100)
    $OKButton.Size = New-Object System.Drawing.Size(80,40)
    $OKButton.Text = "OK"
    $OKButton.Add_Click({
        #If nothing is filled in, don't allow submit
        if (($objtbUserName.Text) -and ($objtbPassword.Text) -and ($objtbDomain.Text)){
            #Get Credentials from the form textbox
            $StoredCred_Username=$objtbUserName.Text
            $StoredCred_Password=$objtbPassword.Text
            $StoredCred_Domain=$objtbDomain.Text

            #Generate a guid to use as passphrase
            $GUID = [System.Guid]::NewGuid().toString()

            #Save credential to encrypted files
            Encrypt-String -String $StoredCred_Username -Passphrase $GUID | Out-File $CredUsrFile
            Encrypt-String -String $StoredCred_Domain -Passphrase $GUID | Out-File $CredDomFile
            Encrypt-String -String $GUID -Passphrase $envUserName | Out-File $CredGidFile

            #convert clear text password to an secure string, then convert that to a exportable encrypted string
            #the $securePassword will be used as the PS credentials
            $SecurePassword = $StoredCred_Password | ConvertTo-SecureString -AsPlainText -Force
            $SecurePassword | ConvertFrom-SecureString | Out-File $CredPwdFile

            # Use credential to store in global variable for further use
            If ($btnID -eq 1){
                $Global:RunAsCreds1 = New-Object -typename System.Management.Automation.PSCredential -ArgumentList $($StoredCred_Domain + "\" + $StoredCred_Username), $SecurePassword
                $WPFbtnCred1.Content = "Select`nCred 1"
            }
            If ($btnID -eq 2){
                $Global:RunAsCreds2 = New-Object -typename System.Management.Automation.PSCredential -ArgumentList $($StoredCred_Domain + "\" + $StoredCred_Username), $SecurePassword
                $WPFbtnCred2.Content = "Select`nCred 2"
            }
            If ($btnID -eq 3){
                $Global:RunAsCreds3 = New-Object -typename System.Management.Automation.PSCredential -ArgumentList $($StoredCred_Domain + "\" + $StoredCred_Username), $SecurePassword
                $WPFbtnCred3.Content = "Select`nCred 3"
            }
            Write-OutputBox -OutputBoxMessage "Cred $([string]$btnID) is now configured to use: $($StoredCred_Domain + "\" + $StoredCred_Username) account" -Type "INFO: " -Object Tab1
            #clear all stored variables before closing form
            Clear-Variable Stored*

            $objForm.Close()
        }
    })
    $objForm.Controls.Add($OKButton)

    $CancelButton = New-Object System.Windows.Forms.Button
    $CancelButton.Location = New-Object System.Drawing.Size(145,100)
    $CancelButton.Size = New-Object System.Drawing.Size(80,40)
    $CancelButton.Text = "Cancel"
    $CancelButton.Add_Click({$objForm.Close()})
    $objForm.Controls.Add($CancelButton)

    $objlblUserName = New-Object System.Windows.Forms.Label
    $objlblUserName.Location = New-Object System.Drawing.Size(10,20) 
    $objlblUserName.Size = New-Object System.Drawing.Size(60,20) 
    $objlblUserName.Text = "Username:"
    $objForm.Controls.Add($objlblUserName) 

    $objtbUserName = New-Object System.Windows.Forms.TextBox 
    $objtbUserName.Location = New-Object System.Drawing.Size(75,16) 
    $objtbUserName.Size = New-Object System.Drawing.Size(150,20) 
    If ($AllFilesExist){
        $objtbUserName.Text = Decrypt-String -Encrypted (Get-Content $CredUsrFile) -Passphrase $GUID
    }
    $objForm.Controls.Add($objtbUserName) 

    $objlblPassword = New-Object System.Windows.Forms.Label
    $objlblPassword.Location = New-Object System.Drawing.Size(12,45) 
    $objlblPassword.Size = New-Object System.Drawing.Size(60,20) 
    $objlblPassword.Text = "Password:"
    $objForm.Controls.Add($objlblPassword) 

    $objtbPassword = New-Object System.Windows.Forms.MaskedTextBox
    $objtbPassword.Location = New-Object System.Drawing.Size(75,41)
    $objtbPassword.Size = New-Object System.Drawing.Size(150,20)
    $objtbPassword.PasswordChar = '*'
    If ($AllFilesExist){
        $objtbPassword.Text = "***************"
    }
    $objForm.Controls.Add($objtbPassword)

    $objlblDomain = New-Object System.Windows.Forms.Label
    $objlblDomain.Location = New-Object System.Drawing.Size(22,70) 
    $objlblDomain.Size = New-Object System.Drawing.Size(44,20) 
    $objlblDomain.Text = "Domain:"
    $objForm.Controls.Add($objlblDomain) 

    $objtbDomain = New-Object System.Windows.Forms.TextBox 
    $objtbDomain.Location = New-Object System.Drawing.Size(75,66) 
    $objtbDomain.Size = New-Object System.Drawing.Size(80,20)
    If($IsMachinePartOfDomain){$objtbDomain.Text = $envMachineADDomain}
    If ($AllFilesExist){
         $objtbDomain.Text = Decrypt-String -Encrypted (Get-Content $CredDomFile) -Passphrase $GUID
    }
    $objForm.Controls.Add($objtbDomain)

    $objForm.Add_Shown({$objForm.Activate()})
    [void] $objForm.ShowDialog()
}

Function Select-Credentials {
    param(
    [parameter(Mandatory=$true)]
	[Int]$btnID
    )
    $CredUsrFile = "$envLocalAppData\AdminMenu\cred$([string]$btnID).usr"
    $CredPwdFile = "$envLocalAppData\AdminMenu\cred$([string]$btnID).pwd"
    $CredDomFile = "$envLocalAppData\AdminMenu\cred$([string]$btnID).dom"
    $CredGidFile = "$envLocalAppData\AdminMenu\cred$([string]$btnID).gid"
    $UsrFileExists = Test-Path $CredUsrFile
    $PwdFileExists = Test-Path $CredPwdFile
    $DomFileExists = Test-Path $CredDomFile
    $GidFileExists = Test-Path $CredGidFile
    If ($UsrFileExists -and $PwdFileExists -and $DomFileExists -and $GidFileExists){
        #Decrypt GUID key to use as passphrase
        [string]$StoredGUID = Decrypt-String -Encrypted (Get-Content $CredGidFile) -Passphrase $envUserName
        [string]$StoredCred_Domain = Decrypt-String -Encrypted (Get-Content $CredDomFile) -Passphrase $StoredGUID
        [string]$StoredCred_Username = Decrypt-String -Encrypted (Get-Content $CredUsrFile) -Passphrase $StoredGUID
        $Global:SelectedRunAsUsername = $StoredCred_Username
        $Global:SelectedRunAsDomain = $StoredCred_Domain
        $Global:SelectedRunAsPwdFile = $CredPwdFile
        If ($btnID -eq 1){
            $WPFbtnCred1.Background = "#FFE4E5E8"
            $WPFbtnCred2.Background = "#FFF4F7FC"
            $WPFbtnCred3.Background = "#FFF4F7FC"
            $Global:SelectedRunAs = $Global:RunAsCreds1
        }
        If ($btnID -eq 2){
            $WPFbtnCred1.Background = "#FFF4F7FC"
            $WPFbtnCred2.Background = "#FFE4E5E8"
            $WPFbtnCred3.Background = "#FFF4F7FC"
            $Global:SelectedRunAs = $Global:RunAsCreds2
        }
        If ($btnID -eq 3){
            $WPFbtnCred1.Background = "#FFF4F7FC"
            $WPFbtnCred2.Background = "#FFF4F7FC"
            $WPFbtnCred3.Background = "#FFE4E5E8"
            $Global:SelectedRunAs = $Global:RunAsCreds3
        }
        Write-OutputBox -OutputBoxMessage "Selected runas account is now: $($StoredCred_Domain + "\" + $StoredCred_Username)." -Type "INFO: " -Object Tab1
        $WPFtxtCredUser.Text = $($StoredCred_Domain + "\" + $StoredCred_Username)
        #clear all stored variables before closing form
        Clear-Variable Stored*
    } 
    Else {
        #Since files don't exist, go back prompt
        Store-CredentialsForm -btnID $btnID
    }
}

Function Reset-SelectedCred {
    $WPFbtnCred1.Background = "#FFF4F7FC"
    $WPFbtnCred2.Background = "#FFF4F7FC"
    $WPFbtnCred3.Background = "#FFF4F7FC"
    $WPFtxtCredUser.Text = ''
    $Variables = Get-Variable *Selected*
    If ($Global:LogDebugMode){Write-Host "Found variables:`n $Variables, removing it..."}
    Remove-Variable *Selected* -Verbose -ErrorAction SilentlyContinue
    Write-OutputBox -OutputBoxMessage "Removed selected runas credentials, reverted back to: $envUserName." -Type "INFO: " -Object Tab1
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
    If ($Global:LogDebugMode){Write-Host "Found variables:`n $Variables, removing it..."}
    Remove-Variable *RunAs* -Verbose -ErrorAction SilentlyContinue
    $WPFbtnCred1.Content = "Enter`nCred 1"
    $WPFbtnCred2.Content = "Enter`nCred 2"
    $WPFbtnCred3.Content = "Enter`nCred 3"
    If ($Global:LogDebugMode){Write-Host "Removed files from $envLocalAppData\AdminMenu"}
    Write-OutputBox -OutputBoxMessage "Removed stored credentials." -Type "INFO: " -Object Tab1
}




function Start-ButtonProcess{
    param(
        [Parameter(Mandatory=$false)]
	    [string]$Title,
        [Parameter(Mandatory=$false)]
        [ValidateSet("exe","remote","ps1","bat","cmd","msc","module")]
	    [string]$ProcessCall,
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
	    [ValidateNotNullorEmpty()]
	    [string]$WorkingDirectory,
        [Parameter(Mandatory=$false)]
        [switch]$NeverRunAs = $false,
        [ValidateSet("tab1","tab2","tab3","tab4","tab5")]
        $OutputTab,
        [Parameter(Mandatory=$false)]
	    [string]$CustomRunMsg,
        [Parameter(Mandatory=$false)]
	    [string]$CustomErrMsg
    )
    Begin {
        If ($ProcessCall -eq "ps1"){
            $Parameters = "-ExecutionPolicy Bypass -STA -NoProfile -NoLogo -WindowStyle Hidden -File `"$Path`" " + $Parameters
            $Path = "$PSHOME\powershell.exe"
            #$WindowStyle = 'Hidden'
        }

        If ($ProcessCall -eq "bat" -or $ProcessCall -eq "cmd"){
            $Parameters = "/k `"$Path`""
            $Path = "$envComSpec"
            $WindowStyle = 'Hidden'
        }
        #Hash table: dynamically add Param if not null
        $ProcessHash = @{
            FilePath = "$Path"           
        } 
        #Add additional paramaters to hash table
        if ($WindowStyle){$ProcessHash["WindowStyle"]=$WindowStyle}
        if ($WorkingDirectory){$ProcessHash["WorkingDirectory"]=$WorkingDirectory}
        if ($Parameters) {$ProcessHash["ArgumentList"]=$Parameters}
        if ($Global:SelectedRunAs){$ProcessHash["Credential"]=$Global:SelectedRunAs}
        if ($ProcessCall -eq "ps1" -or $CreateNoWindow) {$ProcessHash["NoNewWindow"]=$true}
        if ($WorkingDirectory){
            $ProcessHash["WorkingDirectory"]=$WorkingDirectory
            $workDir = "in working directory [$WorkingDirectory]"
        }

        If ($Global:SelectedRunAs -and ($NeverRunAs -eq $false)){
            $RunAs = "running as [$($Global:SelectedRunAs.UserName)]"
        }

        If($Title){
            $Title = $($Title).Replace("`n"," ").Replace("`r","")
            $Name = $Title
        }
        Else{
            $Name = $Path
        }

        If($CustomRunMsg){
            $CustomRunMsg = $($CustomRunMsg).Replace("`n"," ").Replace("`r","")
            $runmsg = $CustomRunMsg
        }Else{$runmsg = "Running [$Name] $RunAs"}

        If($CustomErrMsg){
            $CustomErrMsg = $($CustomErrMsg).Replace("`n"," ").Replace("`r","")
            $errmsg = $CustomErrMsg
        }Else{$errmsg = "File [$Path] not found."}

        If ($OutputTab){
            Write-OutputBox -OutputBoxMessage $runmsg -Type "START: " -Object $OutputTab
            If ($Global:LogDebugMode){write-host "Running [$Name] using path [$Path $Parameters] $workDir $RunAs"}
        }
	}
	Process {
		If (-not (Test-Path -LiteralPath $Path -PathType 'Leaf' -ErrorAction 'Stop')) {
			Write-OutputBox -OutputBoxMessage $errmsg -Type "ERROR: " -Object $OutputTab
            Return
		}
		Else {
            Try{
                If($ProcessCall -eq "remote"){
                    $Results = Invoke-Command -ComputerName $($WPFtxtBoxRemote.Text) @ProcessHash
                } 
                Else {
                    $Results = Start-Process @ProcessHash -PassThru
                }
            }
            Catch{
                $ErrorMessage = $_.Exception.Message
                $FailedItem = $_.Exception.ItemName
                If ($Global:LogDebugMode){write-host "failed to launch file [$FailedItem]. The error message was [$ErrorMessage]"}
            }
        }
    }
}



Function Execute-ButtonProcess {
    [CmdletBinding()]
	Param (
        [Parameter(Mandatory=$false)]
		[string]$Title,
        [Parameter(Mandatory=$false)]
        [ValidateSet("exe","remote", "ps1")]
		[string]$ProcessCall,
        [Parameter(Mandatory=$true)]
		[Alias('FilePath')]
		[ValidateNotNullorEmpty()]
		[string]$Path,
		[Parameter(Mandatory=$false)]
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
		[ValidateNotNullorEmpty()]
		[string]$WorkingDirectory,
		[Parameter(Mandatory=$false)]
		[switch]$PassThru = $false,
        [Parameter(Mandatory=$false)]
        [switch]$noRunAsEver = $false,
        [Parameter(Mandatory=$true)]
        [ValidateSet("tab1","tab2","tab3","tab4","tab5")]
        $OutputTab
    )
    
	Begin {
        If ($Title){
            Write-OutputBox -OutputBoxMessage "Running $Title" -Type "START: " -Object $OutputTab
        }
        If ($ProcessCall -eq "ps1"){
            $Parameters = "-ExecutionPolicy Bypass -NoProfile -NoLogo -WindowStyle Hidden -File `"$Path`""
            $Path = "$PSHOME\powershell.exe"
            $WindowStyle = 'Hidden'
            $ContinueOnError = $true
        }
	}
	Process {
		Try {
			$private:returnCode = $null
			## Validate and find the fully qualified path for the $Path variable.
			If (([IO.Path]::IsPathRooted($Path)) -and ([IO.Path]::HasExtension($Path))) {
                If ($Global:LogDebugMode){Write-OutputBox -OutputBoxMessage "[$Path] is a valid fully qualified path" -Type "INFO: " -Object $OutputTab}
				If (-not (Test-Path -LiteralPath $Path -PathType 'Leaf' -ErrorAction 'Stop')) {
					Throw "File [$Path] not found."
				}
			}
			Else {
				#  The first directory to search will be the 'Files' subdirectory of the script directory
				[string]$PathFolders = $Path
				#  Add the current location of the console (Windows always searches this location first)
				[string]$PathFolders = $PathFolders + ';' + (Get-Location -PSProvider 'FileSystem').Path
				#  Add the new path locations to the PATH environment variable
				$env:PATH = $PathFolders + ';' + $env:PATH
				
				#  Get the fully qualified path for the file. Get-Command searches PATH environment variable to find this value.
				[string]$FullyQualifiedPath = Get-Command -Name $Path -CommandType 'Application' -TotalCount 1 -Syntax -ErrorAction 'Stop'
				
				#  Revert the PATH environment variable to it's original value
				$env:PATH = $env:PATH -replace [regex]::Escape($PathFolders + ';'), ''
				
				If ($FullyQualifiedPath) {
                    Write-OutputBox -OutputBoxMessage "[$Path] successfully resolved to fully qualified path [$FullyQualifiedPath]." -Type "INFO: " -Object $OutputTab
					$Path = $FullyQualifiedPath
				}
				Else {
					Throw "[$Path] contains an invalid path or file name."
				}
			}
			
			## Set the Working directory (if not specified)
			If (-not $WorkingDirectory) { $WorkingDirectory = Split-Path -Path $Path -Parent -ErrorAction 'Stop' }
			Try {
                

				## Disable Zone checking to prevent warnings when running executables
				$env:SEE_MASK_NOZONECHECKS = 1
				
				## Define process
				$processStartInfo = New-Object -TypeName 'System.Diagnostics.ProcessStartInfo' -ErrorAction 'Stop'
				$processStartInfo.FileName = $Path
				$processStartInfo.WorkingDirectory = $WorkingDirectory
				$processStartInfo.UseShellExecute = $false
				$processStartInfo.ErrorDialog = $false
				$processStartInfo.RedirectStandardOutput = $true
				$processStartInfo.RedirectStandardError = $true
				$processStartInfo.CreateNoWindow = $false
                If ($Global:SelectedRunAs -and ($noRunAsEver -eq $false)){
                $password = get-content $Global:SelectedRunAsPwdFile | convertto-securestring
                $processStartInfo.UserName = "$($Global:SelectedRunAs.UserName)"
                $processStartInfo.Password = $password
                }
				If ($Parameters) { $processStartInfo.Arguments = $Parameters }
				If ($windowStyle) { $processStartInfo.WindowStyle = $WindowStyle }
				$process = New-Object -TypeName 'System.Diagnostics.Process' -ErrorAction 'Stop'
				$process.StartInfo = $processStartInfo
				
				## Add event handler to capture process's standard output redirection
				[scriptblock]$processEventHandler = { If (-not [string]::IsNullOrEmpty($EventArgs.Data)) { $Event.MessageData.AppendLine($EventArgs.Data) } }
				$stdOutBuilder = New-Object -TypeName 'System.Text.StringBuilder' -ArgumentList ''
				$stdOutEvent = Register-ObjectEvent -InputObject $process -Action $processEventHandler -EventName 'OutputDataReceived' -MessageData $stdOutBuilder -ErrorAction 'Stop'
				
                ## Start Process
                If ($Global:LogDebugMode){Write-OutputBox -OutputBoxMessage "Working Directory is [$WorkingDirectory]." -Type "INFO: " -Object $OutputTab}
				If ($Global:SelectedRunAs -and ($noRunAsEver -eq $false)){
                    $RunAs = "running as [$($Global:SelectedRunAs.UserName)]"
                }
                If ($Parameters) {
					Write-OutputBox -OutputBoxMessage "Launching [$Path $Parameters] $RunAs" -Type "INFO: " -Object $OutputTab
				} Else {
					Write-OutputBox -OutputBoxMessage "Launching [$Path] $RunAs" -Type "INFO: " -Object $OutputTab
				}
				[boolean]$processStarted = $process.Start()
                
                $process.BeginOutputReadLine()
				$stdErr = $($process.StandardError.ReadToEnd()).ToString() -replace $null,''
					
				## Instructs the Process component to wait indefinitely for the associated process to exit.
				$process.WaitForExit()
					
				## HasExited indicates that the associated process has terminated, either normally or abnormally. Wait until HasExited returns $true.
				While (-not ($process.HasExited)) { $process.Refresh(); Start-Sleep -Seconds 1 }
					
				## Get the exit code for the process
				Try {
					[int32]$returnCode = $process.ExitCode
                    
				}
				Catch [System.Management.Automation.PSInvalidCastException] {
					#  Catch exit codes that are out of int32 range
					[int32]$returnCode = 60013
				}
	
				## Unregister standard output event to retrieve process output
				If ($stdOutEvent) { Unregister-Event -SourceIdentifier $stdOutEvent.Name -ErrorAction 'Stop'; $stdOutEvent = $null }
				$stdOut = $stdOutBuilder.ToString() -replace $null,''
					
				If ($stdErr.Length -gt 0) {
					If ($Global:LogDebugMode){Write-OutputBox -OutputBoxMessage "Standard error output from the process: $stdErr" -Type "WARNING: " -Object $OutputTab}
				}
			}
			Finally {
				## Make sure the standard output event is unregistered
				If ($stdOutEvent) { Unregister-Event -SourceIdentifier $stdOutEvent.Name -ErrorAction 'Stop'}
				
				## Free resources associated with the process, this does not cause process to exit
				If ($process) { $process.Close() }
				
				## Re-enable Zone checking
				Remove-Item -LiteralPath 'env:SEE_MASK_NOZONECHECKS' -ErrorAction 'SilentlyContinue'
			}
			
				
			## If the passthru switch is specified, return the exit code and any output from process
			If ($PassThru) {
				If ($Global:LogDebugMode){Write-OutputBox -OutputBoxMessage "[$Path] executed with exit code [$returnCode]." -Type "INFO: " -Object $OutputTab}
				[psobject]$ExecutionResults = New-Object -TypeName 'PSObject' -Property @{ ExitCode = $returnCode; StdOut = $stdOut; StdErr = $stdErr }
				Write-Output -InputObject $ExecutionResults
			} Else {
                If ($Global:LogDebugMode){Write-Host "[$Path] completed with exit code [$returnCode]."}
                return
			}
		}
		Catch {
			If ([string]::IsNullOrEmpty([string]$returnCode)) {
				[int32]$returnCode = 60002
			}Else {
				If ($Global:LogDebugMode){Write-OutputBox -OutputBoxMessage "[$Path] executed with exit code [$returnCode]. Function failed." -Type "ERROR: " -Object $OutputTab}
			}
			
            If ($PassThru) {
				[psobject]$ExecutionResults = New-Object -TypeName 'PSObject' -Property @{ ExitCode = $returnCode; StdOut = If ($stdOut) { $stdOut } Else { '' }; StdErr = If ($stdErr) { $stdErr } Else { '' } }
				Write-Output -InputObject $ExecutionResults
			}Else {
                If ($Global:LogDebugMode){Write-Host "[$Path] executed with exit code [$returnCode]. Function failed."}
                return
			}
		}
	}
}