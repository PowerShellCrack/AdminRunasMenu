#region Source
$source = @"
using System;
using System.Collections;
using System.Management.Automation;

namespace Netzwerker.Shell
{
    /// <summary>
    /// A parameter Class to automate parameterized parameterization.
    /// This class models a ParameterName / ParameterValue pair used when invoking commands with given parameters.
    /// This class is designed to faciliate simple user input, while maintaining predictable objects at runtime.
    /// </summary>
    [Serializable]
    public class PSParameter
    {
        /// <summary>
        /// The name of the Parameter
        /// </summary>
        public string Name;

        /// <summary>
        /// The value of the parameter
        /// </summary>
        public object Value;

        /// <summary>
        /// Creates an empty parameter object
        /// </summary>
        public PSParameter()
        {

        }

        /// <summary>
        /// Creates a parameter object with both name and value
        /// </summary>
        /// <param name="Name">The name of the parameter to bind</param>
        /// <param name="Value">The value of the parameter.</param>
        public PSParameter(string Name, object Value)
        {
            this.Name = Name;
            this.Value = Value;
        }

        /// <summary>
        /// Creates a parameter from a PSObject. The object needs to have a name and value property.
        /// </summary>
        /// <param name="Object">The object to create the Parameter object from.</param>
        public PSParameter(PSObject Object)
        {
            // Handle wrong input
            if ((Object.Properties["Name"] == null) && (Object.Properties["name"] == null) && (Object.Properties["N"] == null) && (Object.Properties["n"] == null)) { throw new ArgumentException("Object does not contain valid Name property"); }
            if ((Object.Properties["Value"] == null) && (Object.Properties["value"] == null) && (Object.Properties["V"] == null) && (Object.Properties["v"] == null)) { throw new ArgumentException("Object does not contain valid Value property"); }

            // Get Content
            try
            {
                // Get the Parameter Name
                if (Object.Properties["Name"] != null) { Name = (string)Object.Properties["Name"].Value; }
                if (Object.Properties["name"] != null) { Name = (string)Object.Properties["name"].Value; }
                if (Object.Properties["N"] != null) { Name = (string)Object.Properties["N"].Value; }
                if (Object.Properties["n"] != null) { Name = (string)Object.Properties["n"].Value; }

                // Get the Parameter Value
                if (Object.Properties["Value"] != null) { Value = Object.Properties["Value"].Value; }
                if (Object.Properties["value"] != null) { Value = Object.Properties["value"].Value; }
                if (Object.Properties["V"] != null) { Value = Object.Properties["V"].Value; }
                if (Object.Properties["v"] != null) { Value = Object.Properties["v"].Value; }
            }
            catch (Exception e)
            {
                throw new ArgumentException(("Error trying to parse PSObject: " + e.Message), e);
            }
        }

        /// <summary>
        /// Creates a parameter from a Hashtable. The table needs to have a name and value key/value pair.
        /// </summary>
        /// <param name="Table">The hashtable to create the Parameter object from</param>
        public PSParameter(Hashtable Table)
        {
            if (Table["Name"] != null) { Name = (string)Table["Name"]; }
            else if (Table["name"] != null) { Name = (string)Table["name"]; }
            else if (Table["N"] != null) { Name = (string)Table["N"]; }
            else if (Table["n"] != null) { Name = (string)Table["n"]; }
            else { throw new ArgumentException("Hashtable does not contain a valid Name property"); }

            if (Table["Value"] != null) { Value = Table["Value"]; }
            else if (Table["value"] != null) { Value = Table["value"]; }
            else if (Table["V"] != null) { Value = Table["V"]; }
            else if (Table["v"] != null) { Value = Table["v"]; }
            else { throw new ArgumentException("Hashtable does not contain a valid Value property"); }
        }

        public override string ToString()
        {
            return Name + ": " + Value.ToString();
        }
    }

    public static class ShellHost
    {
        #region Invoke-Runspace Information

        /// <summary>
        /// Variable that counts the finished items in multiple items operations.
        /// </summary>
        public static volatile int RunspaceCountCurrent;

        #endregion Invoke-Runspace Information
    }
}
"@
Add-Type $source
#endregion Source

function Invoke-Runspace
{
    <#
		.SYNOPSIS
			Multithread a script using Runspaces.
		
		.DESCRIPTION
			Multithread a script using Runspaces.
	
			By using the -AddAlias and -AddFunction parameters, user created content may be automatically copied to the new runspaces.
			
			The main probable difficulty handling this script stems from the difference between arguments and parameters.
			Arguments are more intuitive to use, parameters allow greater precision.
			Passing a list of objects as dynamic arguments, will simply run the script once per argument, each in its own thread.
			Parameters however allow you to precisely define which parameter of your script is bound in which way.
			
			For example:
			Let's say you have 10000 Objects you want to run through one script. Simply passing them as dynamic argument will have the function to open and close 10000 runspaces. That's a lot of overhead for creating and disposing runspaces.
			Far more efficient to segment the objects into 10 parts and have one script run process 1000 objects in its own loop. Depending on Powershell Version and how the objects are segmented, it may not be certain the different arrays aren't combined into one big array, which again would cause the function to open 10000 runspaces.
			Explicitly defining 10 Parameters (See documentation of the parameters for details) will guarantee the same, reliable behavior, no matter the machine it runs on.
	
		.PARAMETER ArgsDynamic
			ParSet: Argument
			List of dynamic arguments. For each argument passed here, a new Runspace is launched.
		
		.PARAMETER ParamDynamic
			ParSet: Parameter
			List of dynamic parameters. For each parameter passed here, a new Runspace is launched.
			Parameters are bound before arguments. Arguments are bound in the order of the left-over positional parameters.
	
			Note on Parameters:
			- Can either be a PSParameter Object, a PSObject or a Hashtable
			- Either way, a parameter needs to have a "Name" and a "Value" property.
	
			Example:
			- ArgsDynamic @{ Name = "Test"; Value = 42 }
	
		.PARAMETER ArgsStatic
			List of static arguments. Each of these arguments will be added to each runspace.
			Static Arguments are added AFTER the dynamic argument (so if you use Arguments, the dynamic argument will be bound to the first positional aprameter of your script).
		
		.PARAMETER ParamStatic
			List of static parameters. Each of those parameters will be bound to each runspace.
			Parameters are bound before arguments. Arguments are bound in the order of the left-over positional parameters.
	
			Note on Parameters:
			- Can either be a PSParameter Object, a PSObject or a Hashtable
			- Either way, a parameter needs to have a "Name" and a "Value" property.
	
			Example:
			- ArgsStatic @{ Name = "Test"; Value = 42 }
		
		.PARAMETER Limit
			Default: Number of logical Processor Cores on the local machine
			The maximum number of runspaces open at the same time.
			Exceeding the number of available logical cores is a good idea if your script contains waiting periods. Everything that requires network communication is likely to do so.
		
		.PARAMETER ScriptBlock
			Alias:   script
			The scriptblock to execute.
		
		.PARAMETER TimeoutSeconds
			Default: -1
			Maximum number of seconds until execution terminates automatically.
	
		.PARAMETER TotalNumItems
			Default: 0
			Total number of items passed. This enables the user to write scripts that update the item count.
			When Multithreading, it is more efficient to minimize number of thread creation operations. For pure calculation jobs without need to wait for external data, that optimum is the number of logical cores.
			In this ideal scenario, you'd split the total pool of items to process into just as many collections as there are logical cores, turn each of these collections into a dynamic parameter and then have the script iterate over each collection within its own thread. This however makes it impossible to regularly display progress.
			By incrementing ...
			
			[Netzwerker.Shell.ShellHost]::RunspaceCountCurrent
	
			... when finishing one iteration, a script can report overall progress back to the main thread that will update the progress bar.
	
		.PARAMETER AddAlias
			List of Aliases to add to the runspaces launched by this function. Accepts wildcard input.
	
		.PARAMETER AddFunction
			List of Functions to add to the runspaces launched by this function. Accepts wildcard input.
	
		.EXAMPLE
			PS C:\> $r = Invoke-Runspace $script $Arguments -Limit 200
	
			This will run the script once for each argument in the $Arguments variable. A maximum of 200 Runspaces will run in parallel.
		
		.EXAMPLE
			PS C:\> $r = Invoke-Runspace -ScriptBlock $script -ParamDynamic $dynamic -ParamStatic $static
	
			Runs the script once for each element in $dynamic, adding all $static parameters each time. Finally, it receives all results and stores them in $r.
	
		.EXAMPLE
			PS C:\> $r = Invoke-Runspace -ScriptBlock $script -ParamDynamic $dynamic -ParamStatic $static -AddFunction "*" -AddAlias "*"
	
			Runs the script once for each element in $dynamic, adding all $static parameters each time. This script will have all currently loaded functions and aliases available. Finally, it receives all results and stores them in $r.
		
		.NOTES
			Supported Interfaces:
			------------------------
			
			Author:       Friedrich Weinmann
			Company:      die netzwerker Computernetze GmbH
			Created:      24.11.2014
			LastChanged:  05.11.2014
			Version:      1.3
	#>
	[CmdletBinding(DefaultParameterSetName = "Argument")]
	Param (
		[Parameter(Mandatory = $true, Position = 0)]
		[Alias('script')]
		[System.Management.Automation.ScriptBlock]
		$ScriptBlock,
		
		[Netzwerker.Shell.PSParameter[]]
		$ParamStatic,
		
		[Parameter(Mandatory = $true, ParameterSetName = "Parameter", Position = 1)]
		[Netzwerker.Shell.PSParameter[]]
		$ParamDynamic,
		
		[object[]]
		$ArgsStatic,
		
		[Parameter(Mandatory = $true, ParameterSetName = "Argument", Position = 1)]
		[object[]]
		$ArgsDynamic,
		
		[int]
		$Limit = (@($n = 0; Get-WmiObject Win32_Processor | %{ $n += $_.NumberOfLogicalProcessors }; $n) | Select -First 1),
		
		[int]
		$TimeoutSeconds = -1,
		
		[int]
		$TotalNumItems = 0,
		
		[string[]]
		$AddFunction = "",
		
		[string[]]
		$AddAlias = ""
	)
	
	# Set the functionname variable
	$fn = (Get-PSCallStack)[0].Command
	Write-Debug "[Start] [Multithreading using Runspaces]"
	
	# Get active ParameterSet
	$ParSet = $PSCmdlet.ParameterSetName
	Write-Debug "Active Parameterset: $ParSet"
	
	# Reset Counter
	[Netzwerker.Shell.ShellHost]::RunspaceCountCurrent = 0
	
	#region Prepare Variables
	
	# Collections to add things
	[Collections.Arraylist]$RunspaceCollection = @()
	[Collections.Arraylist]$Results = @()
	
	# Ensure Limit
	if ($Limit -lt 1) { $Limit = 1 }
	
	#region Initial Session State
	$InitialSessionState = [System.Management.Automation.Runspaces.InitialSessionState]::CreateDefault()
	if ($PSBoundParameters["AddFunction"])
	{
		$FPool = Get-Command -CommandType 'Function'
		$ToAdd = @()
		Foreach ($f in $AddFunction) { $FPool | Where-Object { $_.Name -like $f } | %{ $ToAdd += $_ } }
		$ToAdd = $ToAdd | Select-Object -Unique
		foreach ($a in $ToAdd)
		{
			try { $InitialSessionState.Commands.Add((New-Object System.Management.Automation.Runspaces.SessionStateFunctionEntry($a.Name, $a.Definition))) }
			catch { Write-Warning "Failed to add Function: $($a.Name)" }
		}
	}
	if ($PSBoundParameters["AddAlias"])
	{
		$APool = Get-Alias
		$ToAdd = @()
		Foreach ($a in $AddAlias) { $APool | Where-Object { $_.Name -like $a } | %{ $ToAdd += $_ } }
		$ToAdd = $ToAdd | Select-Object -Unique
		foreach ($a in $ToAdd)
		{
			try { $InitialSessionState.Commands.Add((New-Object System.Management.Automation.Runspaces.SessionStateAliasEntry($a.Name, $a.Definition, $a.Description, $a.Options))) }
			catch { Write-Warning "Failed to add Alias: $($a.Name)" }
		}
	}
	#endregion Initial Session State
	
	# Create a Runspace Pool
	$RunspacePool = [RunspaceFactory]::CreateRunspacePool($InitialSessionState)
	$RunspacePool.SetMinRunspaces(1) | Out-Null
	$RunspacePool.SetMaxRunspaces($Limit) | Out-Null
	
	# Set numerical Counters
	if ($ParSet -eq "Parameter") { $Num_Total = $ParamDynamic | Measure-Object | Select-Object -ExpandProperty Count }
	else { $Num_Total = $ArgsDynamic | Measure-Object | Select-Object -ExpandProperty Count }
	$Num_Started = 0
	$Num_Harvested = 0
	$Active = $true
	$Start = Get-Date
	$Timeout = $Start.AddSeconds($TimeoutSeconds)
	
	# Set Static Paramtest
	if ($PSBoundParameters["ParamStatic"]) { $Test_ParamStatic = $True }
	else { $Test_ParamStatic = $false }
	
	#endregion Prepare Variables
	
	#region Main Functions
	function Test-OpenSlot
	{
		Write-Debug "Available Runspaces: $($RunspacePool.GetAvailableRunspaces())"
		return ($RunspacePool.GetAvailableRunspaces() -gt 0)
	}
	
	function Test-Finished
	{
		Write-Debug "Is finished: $(($Num_Total -eq $Num_Started) -and ($Num_Total -eq $Num_Harvested))"
		if (($Num_Total -eq $Num_Started) -and ($Num_Total -eq $Num_Harvested)) { return $true }
		return $false
	}
	
	function Test-Timeout
	{
		Write-Debug "Timed Out: $(if ($TimeoutSeconds -lt 0) { $false } elseif ((Get-Date) -gt $Timeout) { $true } else { $false })"
		if ($TimeoutSeconds -lt 0) { return $false }
		
		if ((Get-Date) -gt $Timeout) { return $true }
		
		return $false
	}
	
	function Start-Runspace
	{
		Param (
			$DynamicArgument
		)
		
		if ($ParSet -eq "Parameter") { Write-Debug "Starting Runspace with $($DynamicArgument.Name) : $($DynamicArgument.Value.ToString())" }
		else { Write-Debug "Starting Runspace with $DynamicArgument" }
		
		# Create a PowerShell object to run add the script and argument.
		$Powershell = [PowerShell]::Create().AddScript($ScriptBlock)
		if ($Test_ParamStatic) { foreach ($static in $ParamStatic) { $Powershell = $Powershell.AddParameter($static.Name, $static.Value) } }
		if ($ParSet -eq "Parameter") { $Powershell = $Powershell.AddParameter($DynamicArgument.Name, $DynamicArgument.Value) }
		else { $Powershell = $Powershell.AddArgument($DynamicArgument) }
		foreach ($static in $ArgsStatic) { $Powershell = $Powershell.AddArgument($static) }
		
		# Specify runspace to use
		$Powershell.RunspacePool = $RunspacePool
		
		# Add Entry to total collection
		$RunspaceCollection.Add((New-Object -TypeName PSObject -Property @{ Runspace = $PowerShell.BeginInvoke(); PowerShell = $PowerShell })) | Out-Null
		
		# Finally: Increment started counter
		Set-Variable -Name "Num_Started" -Scope 1 -Value ($Num_Started + 1)
	}
	
	function Harvest-Runspace
	{
		Write-Debug "Harvesting results from running runspaces"
		foreach ($Run in $RunspaceCollection.ToArray())
		{
			if ($Run.Runspace.IsCompleted)
			{
				Write-Debug "Retrieving Results"
				
				$Results.Add(($Run.PowerShell.EndInvoke($Run.Runspace))) | Out-Null
				$Run.PowerShell.Dispose()
				$RunspaceCollection.Remove($Run)
				Set-Variable -Name "Num_Harvested" -Scope 1 -Value ($Num_Harvested + 1)
			}
		}
	}
	
	function Clean-AfterFinished
	{
		foreach ($run in $RunspaceCollection.ToArray())
		{
			try { $run.PowerShell.Dispose() }
			catch { }
		}
		$RunspacePool.Close()
	}
	
	function Write-RunspaceProgressMain
	{
		[int]$Percent = ($Num_Harvested / $Num_Total * 100)
		Write-Progress -Activity "Running Script" -Id 0 -PercentComplete ([System.Math]::Min(100, $Percent)) -Status "$Num_Harvested out of $Num_Total runspaces received. $Num_Started Runspaces have been launched so far."
	}
	
	function Write-RunspaceProgressSub
	{
		if ($TotalNumItems -gt 0)
		{
			[int]$Percent = (([Netzwerker.Shell.ShellHost]::RunspaceCountCurrent) / $TotalNumItems) * 100
			Write-Progress -Activity "Processing Items" -Id 1 -ParentId 0 -PercentComplete ([System.Math]::Min(100, $Percent)) -Status "$(([Netzwerker.Shell.ShellHost]::RunspaceCountCurrent)) out of $TotalNumItems items processed"
		}
	}
	#endregion Main Functions
	
	#region Main Logic
	$RunspacePool.Open()
	Write-Progress -Activity "Running Script" -Id 0 -PercentComplete 0 -Status "Starting"
	if ($TotalNumItems -gt 0) { Write-Progress -Activity "Processing Items" -Id 1 -ParentId 0 -PercentComplete 0 -Status "Starting" }
	while ($Active)
	{
		if ((Test-OpenSlot) -and ($Num_Started -lt $Num_Total) -and ($ParSet -eq "Parameter")) { Start-Runspace -DynamicArgument $ParamDynamic[$Num_Started] }
		elseif ((Test-OpenSlot) -and ($Num_Started -lt $Num_Total) -and ($ParSet -eq "Argument")) { Start-Runspace -DynamicArgument $ArgsDynamic[$Num_Started] }
		else { Start-Sleep -Milliseconds 250 }
		
		Write-RunspaceProgressMain
		Write-RunspaceProgressSub
		Harvest-Runspace
		
		if (Test-Timeout)
		{
			Write-Warning "Timeout reached, storing intermediate results to `$NW_PartialResult. Terminating function"
			$ScriptBlock:NW_PartialResult = $Results
			Clean-AfterFinished
			return
		}
		
		if (Test-Finished) { $Active = $false }
	}
	if ($TotalNumItems -gt 0) { Write-Progress -Activity "Processing Items" -Id 1 -ParentId 0 -Completed }
	Write-Progress -Activity "Running Script" -Id 0 -Status "Finished" -Completed
	#endregion Main Logic
	
	Clean-AfterFinished
	
	# Reset Counter
	[Netzwerker.Shell.ShellHost]::RunspaceCountCurrent = 0
	
	# Write closing line
	Write-Debug "[End] [Multithreading using Runspaces]"
	
	# Return Results
	if (!$NoRes) { $script:NW_Result = $Results }
	return $Results
}