
#region Remoting Engine
function Create-RemoteSession{
<#
	.SYNOPSIS
		Initialize Remote Powershell Session

	.DESCRIPTION
		Creates remote sessions to management servers.

	.PARAMETER Exchange
		Creates an Exchange remote session

	.PARAMETER Lync
		Creates a Lync remote session

	.PARAMETER ALL
		Creates all available remote sessions

	.EXAMPLE
		Create-RemoteSession
#>

	Param(
		[switch]$Exchange,
		[switch]$Lync,
		[switch]$All
	)

	if($Exchange)
	{
		try
		{
			$Global:sExch = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri $global:PSExchServer -Authentication Kerberos -Name 'PSRExchange' -ea 'Stop'
		}
		catch [Exception]
		{
			[System.Windows.Forms.MessageBox]::Show($_.Exception.Message)
			return
		}
	}

	if($Lync)
	{
		try
		{
			$Global:sLync = New-PSSession -ConnectionUri $Global:PSLync -Name 'PSRLync' -Authentication 'NegotiateWithImplicitCredential' -ea 'Stop'
		}
		catch [Exception]
		{
			[System.Windows.Forms.MessageBox]::Show($_.Exception.Message)
			return
		}
	}

	if($All)
	{
		try
		{
			$Global:sExch = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri $global:PSExchServer -Authentication Kerberos -Name 'PSRExchange' -ea 'Stop'
		}
		catch [Exception]
		{
			[System.Windows.Forms.MessageBox]::Show($_.Exception.Message)
			return
		}
		try
		{
			$Global:sLync = New-PSSession -ConnectionUri $Global:PSLync -Name 'PSRLync' -Authentication 'NegotiateWithImplicitCredential' -ea 'Stop'
		}
		catch [Exception]
		{
			[System.Windows.Forms.MessageBox]::Show($_.Exception.Message)
			return
		}
	}
}

function Check-RemoteSession{
<#
	.SYNOPSIS
		Checks the status of Remote Powershell Session

	.DESCRIPTION
		Checks the status of remote sessions to management servers.
		Returns $true and the sessions if one or more sessions of a particular type is detected.
		Returns $false and an empty variable if there are no sessions active.

	.PARAMETER Exchange
		Checks  the status of an Exchange remote session

	.PARAMETER Lync
		Checks the status of a Lync remote session

	.EXAMPLE
		Check-RemoteSession -Exchange
#>

	Param(
		[switch] $Exchange,
		[switch] $Lync
	)

	if ($Exchange)
	{
		try
		{
			$ExchangeResult = Get-PSSession -Name 'PSRExchange' -ea 'Stop'
		}
		catch [Exception]
		{
			return $false, $ExchangeResult
		}
		return $true, $ExchangeResult
	}

	if ($Lync)
	{
		try
		{
			$LyncResult = Get-PSSession -Name 'PSRExchange' -ea 'Stop'
		}
		catch [Exception]
		{
			return $false, $LyncResult
		}
		return $true, $LyncResult
	}
}

function Repair-RemoteSession{
<#
	.SYNOPSIS
		Repairs Remote Powershell Session

	.DESCRIPTION
		Checks the status of remote sessions to management servers.
		Repairs the session if there are broken or missing sessions.
		Returns $true if a repair had to be performed.

	.PARAMETER Exchange
		Repairs an Exchange remote session

	.PARAMETER Lync
		Repairs a Lync remote session

	.EXAMPLE
		Repair-RemoteSession -Exchange
#>

	Param(
		[switch] $Exchange,
		[switch] $Lync
	)

	if ($Exchange)
	{
		[bool]$bool,$Sessions = Check-RemoteSession -Exchange
		if ($Sessions.count -eq 0)
		{
			Create-RemoteSession -Exchange
			return $true
		}
		elseif ($Sessions.count -gt 1)
		{
			Remove-RemoteSession -Exchange
			Create-RemoteSession -Exchange
			return $true
		}
		else
		{
			if($Sessions.State -eq "Broken"){
				Remove-RemoteSession -Exchange
				Create-RemoteSession -Exchange
				return $true
			}
			else
			{
				return $false
			}
		}
	}

	if ($Lync)
	{
		[bool]$bool,$Sessions = Check-RemoteSession -Lync
		if ($Sessions.count -eq 0)
		{
			Create-RemoteSession -Lync
			return $true
		}
		elseif ($Sessions.count -gt 1)
		{
			Remove-RemoteSession -Lync
			Create-RemoteSession -Lync
			return $true
		}
		else
		{
			if($Sessions.State -eq "Broken"){
				Remove-RemoteSession -Lync
				Create-RemoteSession -Lync
				return $true
			}
			else
			{
				return $false
			}
		}
	}

}

function Remove-RemoteSession
{
<#
	.SYNOPSIS
		Removes Remote Powershell Session

	.DESCRIPTION
		Creates remote sessions to management servers

	.PARAMETER Exchange
		Removes an Exchange remote session

	.PARAMETER Lync
		Removes a Lync remote session

	.PARAMETER ALL
		Removes all available remote sessions

	.EXAMPLE
		Remove-RemoteSession
#>
	Param(
		[switch]$Exchange,
		[switch]$Lync,
		[switch]$All
	)

	# Check and remove Exchange remote sessions if they exist.
	if($Exchange)
	{
		try
		{
			[bool]$bool,$Sessions = Check-RemoteSession -Exchange
		}
		catch
		{
			[System.Windows.Forms.MessageBox]::Show($_.Exception.Message)
		}
		if ($Sessions.count -ge 1)
		{
			Remove-PSSession -Name 'PSRExchange'
			return
		}
		else
		{
			return
		}
	}

	# Check and remove Lync remote sessions if they exist.
	if($Lync)
	{
		try
		{
			[bool]$bool,$Sessions = Check-RemoteSession -Lync
		}
		catch
		{
			[System.Windows.Forms.MessageBox]::Show($_.Exception.Message)
		}
		if ($Sessions.count -ge 1)
		{
			Remove-PSSession -Name 'PSRLync'
			return
		}
		else
		{
			return
		}
	}

	# Check and remove both Exchange and Lync remote sessions if they exist.
	if($All -or (-not $Exchange -and -not $Lync))
	{
		try
		{
			[bool]$bool,$Sessions = Check-RemoteSession -Exchange
		}
		catch
		{
			[System.Windows.Forms.MessageBox]::Show($_.Exception.Message)
		}
		if ($Sessions.count -ge 1)
		{
			Remove-PSSession -Name 'PSRExchange'
		}

		try
		{
			[bool]$bool,$Sessions = Check-RemoteSession -Lync
		}
		catch
		{
			[System.Windows.Forms.MessageBox]::Show($_.Exception.Message)
		}
		if ($Sessions.count -ge 1)
		{
			Remove-PSSession -Name 'PSRLync'
		}
	}
	return
}
#endregion Remoting Engine
