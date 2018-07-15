#http://www.adamtheautomator.com/reading-sccm-client-logs/
#Get functions when possible

Function Get-MDTOData{
    <#
    .Synopsis
        Function for getting MDTOdata
    .DESCRIPTION
        Function for getting MDTOdata
    .EXAMPLE
        Get-MDTOData -MDTMonitorServer MDTSERVER01
    .NOTES
        Created:     2016-03-07
        Version:     1.0
 
        Author - Mikael Nystrom
        Twitter: @mikael_nystrom
        Blog   : http://deploymentbunny.com
 
    .LINK
        http://www.deploymentbunny.com
    #>
    Param(
    $MDTMonitorServer
    ) 
    $URL = "http://" + $MDTMonitorServer + ":9801/MDTMonitorData/Computers"
    $Data = Invoke-RestMethod $URL
    foreach($property in ($Data.content.properties) ){
        $Hash =  [ordered]@{ 
            Name = $($property.Name); 
            PercentComplete = $($property.PercentComplete.’#text’); 
            Warnings = $($property.Warnings.’#text’); 
            Errors = $($property.Errors.’#text’); 
            DeploymentStatus = $( 
            Switch($property.DeploymentStatus.’#text’){ 
                1 { "Active/Running"} 
                2 { "Failed"} 
                3 { "Successfully completed"} 
                Default {"Unknown"} 
                }
            );
            StepName = $($property.StepName);
            TotalSteps = $($property.TotalStepS.'#text')
            CurrentStep = $($property.CurrentStep.'#text')
            DartIP = $($property.DartIP);
            DartPort = $($property.DartPort);
            DartTicket = $($property.DartTicket);
            VMHost = $($property.VMHost.'#text');
            VMName = $($property.VMName.'#text');
            LastTime = $($property.LastTime.'#text') -replace "T"," ";
            StartTime = $($property.StartTime.’#text’) -replace "T"," "; 
            EndTime = $($property.EndTime.’#text’) -replace "T"," "; 
            }
        New-Object PSObject -Property $Hash
    }
}



# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Author: Benjamin Holbrook
# Creation Date: December 2012
#
# Disclaimer:
# All functions have been tested in a production environment but I will not provide a guarentee that they
# will work in all environments and that all functions will work exactly as intended.
# Suggestions and improvements are very welcome and will be acted upon.
#
# Contact:
# Email: holbrook.benjamin@gmail.com
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 

function Get-CMObject {
    <#
    .SYNOPSIS
       Retrieves a WMI object in ConfigMgr.
    .OUTPUTS
        Retrieves a ConfigMgr WMI object which can be filtered using a WMI query.
    .PARAMETER SiteProvider
        The computer name of the ConfigMgr site.
    .PARAMETER SiteCode
        The site code of the ConfigMgr site.
    .PARAMETER Class
        The WMI class type name to be retrieved.
    .PARAMETER Filter
        A query for filtering the returned WMI object.
    .EXAMPLE
        Get-CMObject -SiteProvider "cm-prov01" -SiteCode "WES" -Class "SMS_Collection"
    .EXAMPLE
        Get-CMObject "cm-prov01" "WES" -Class "SMS_TaskSequence" -Filter "Name = 'Windows 7 x64 Build'"
    #>

    [CmdletBinding()]
    Param (
        [Parameter(Position=1, Mandatory=$True)] [string] $SiteProvider,
        [Parameter(Position=2, Mandatory=$True)] [string] $SiteCode,
        [Parameter(Position=3, Mandatory=$True)] [string] $Class,
        [Parameter(Position=4, Mandatory=$False)] [string] $Filter
    )

    PROCESS {
        if ($Filter -eq $null -or $Filter -eq "") {
            Get-WmiObject -ComputerName $SiteProvider -Namespace “root\sms\site_$SiteCode” -Class $Class -ErrorVariable +err -ErrorAction Stop
        } else {
            Get-WmiObject -ComputerName $SiteProvider -Namespace “root\sms\site_$SiteCode" -Query "SELECT * FROM $Class WHERE $Filter" -ErrorVariable +err -ErrorAction Stop
        }
    }
}

function Get-CMCollection {
    <#
    .SYNOPSIS
       Retrieves a WMI SMS_Collection object in ConfigMgr.
    .OUTPUTS
        Retrieves a ConfigMgr WMI SMS_Collection object which can be filtered using a WMI query.
    .PARAMETER SiteProvider
        The computer name of the ConfigMgr site.
    .PARAMETER SiteCode
        The site code of the ConfigMgr site.
    .PARAMETER Filter
        A query for filtering the returned WMI object.
    .EXAMPLE
        Get-CMCollection -SiteProvider "cm-prov01" -SiteCode "WES"
    .EXAMPLE
        Get-CMCollection "cm-prov01" "WES" -Filter "Name = 'Toshiba Laptops'"
    #>

    [CmdletBinding()]
    Param (
        [Parameter(Position=1, Mandatory=$True)] [string] $SiteProvider,
        [Parameter(Position=2, Mandatory=$True)] [string] $SiteCode,
        [Parameter(Position=3, Mandatory=$False)] [string] $Filter
    )

    PROCESS {
        Get-CMObject $SiteProvider $SiteCode "SMS_Collection" $Filter -ErrorVariable +err -ErrorAction Stop
    }
}

function Get-CMCollectionMember {
    <#
    .SYNOPSIS
       Retrieves a WMI SMS_CollectionMember object in ConfigMgr.
    .OUTPUTS
        Retrieves a ConfigMgr WMI SMS_CollectionMember object which can be filtered using a WMI query.
    .PARAMETER SiteProvider
        The computer name of the ConfigMgr site.
    .PARAMETER SiteCode
        The site code of the ConfigMgr site.
    .PARAMETER Filter
        A query for filtering the returned WMI object.
    .EXAMPLE
        Get-CMCollectionMember -SiteProvider "cm-prov01" -SiteCode "WES"
    .EXAMPLE
        Get-CMCollectionMember "cm-prov01" "WES" -Filter "Name = 'PC01'"
    #>

    [CmdletBinding()]
    Param (
        [Parameter(Position=1, Mandatory=$True)] [string] $SiteProvider,
        [Parameter(Position=2, Mandatory=$True)] [string] $SiteCode,
        [Parameter(Position=3, Mandatory=$False)] [string] $Filter
    )

    PROCESS {
        Get-CMObject $SiteProvider $SiteCode "SMS_CollectionMember" $Filter -ErrorVariable +err -ErrorAction Stop
    }
}

function Get-CMFullCollectionMembership {
    <#
    .SYNOPSIS
       Retrieves a WMI SMS_FullCollectionMembership object in ConfigMgr.
    .OUTPUTS
        Retrieves a ConfigMgr WMI SMS_FullCollectionMembership object which can be filtered using a WMI query.
    .PARAMETER SiteProvider
        The computer name of the ConfigMgr site.
    .PARAMETER SiteCode
        The site code of the ConfigMgr site.
    .PARAMETER Filter
        A query for filtering the returned WMI object.
    .EXAMPLE
        Get-CMFullCollectionMembership -SiteProvider "cm-prov01" -SiteCode "WES"
    .EXAMPLE
        Get-CMFullCollectionMembership "cm-prov01" "WES" -Filter "Name = 'PC01'"
    #>

    [CmdletBinding()]
    Param (
        [Parameter(Position=1, Mandatory=$True)] [string] $SiteProvider,
        [Parameter(Position=2, Mandatory=$True)] [string] $SiteCode,
        [Parameter(Position=3, Mandatory=$False)] [string] $Filter
    )

    PROCESS {
        Get-CMObject $SiteProvider $SiteCode "SMS_FullCollectionMembership" $Filter -ErrorVariable +err -ErrorAction Stop
    }
}

function Get-CMPackage {
    <#
    .SYNOPSIS
       Retrieves a WMI SMS_Package object in ConfigMgr.
    .OUTPUTS
        Retrieves a ConfigMgr WMI SMS_Package object which can be filtered using a WMI query.
    .PARAMETER SiteProvider
        The computer name of the ConfigMgr site.
    .PARAMETER SiteCode
        The site code of the ConfigMgr site.
    .PARAMETER Filter
        A query for filtering the returned WMI object.
    .EXAMPLE
        Get-CMPackage -SiteProvider "cm-prov01" -SiteCode "WES"
    .EXAMPLE
        Get-CMPackage "cm-prov01" "WES" -Filter "Name = 'Microsoft Office'"
    #>

    [CmdletBinding()]
    Param (
        [Parameter(Position=1, Mandatory=$True)] [string] $SiteProvider,
        [Parameter(Position=2, Mandatory=$True)] [string] $SiteCode,
        [Parameter(Position=3, Mandatory=$False)] [string] $Filter
    )

    PROCESS {
        Get-CMObject $SiteProvider $SiteCode "SMS_Package" $Filter -ErrorVariable +err -ErrorAction Stop
    }
}

function Get-CMAdvertisement {
    <#
    .SYNOPSIS
       Retrieves a WMI SMS_Advertisement object in ConfigMgr.
    .OUTPUTS
        Retrieves a ConfigMgr WMI SMS_Advertisement object which can be filtered using a WMI query.
    .PARAMETER SiteProvider
        The computer name of the ConfigMgr site.
    .PARAMETER SiteCode
        The site code of the ConfigMgr site.
    .PARAMETER Filter
        A query for filtering the returned WMI object.
    .EXAMPLE
        Get-CMAdvertisement -SiteProvider "cm-prov01" -SiteCode "WES"
    .EXAMPLE
        Get-CMAdvertisement "cm-prov01" "WES" -Filter "Name = 'Automatic Advertisement'"
    #>

    [CmdletBinding()]
    Param (
        [Parameter(Position=1, Mandatory=$True)] [string] $SiteProvider,
        [Parameter(Position=2, Mandatory=$True)] [string] $SiteCode,
        [Parameter(Position=3, Mandatory=$False)] [string] $Filter
    )

    PROCESS {
        Get-CMObject $SiteProvider $SiteCode "SMS_Advertisement" $Filter -ErrorVariable +err -ErrorAction Stop
    }
}

function Get-CMDriver {
    <#
    .SYNOPSIS
       Retrieves a WMI SMS_Driver object in ConfigMgr.
    .OUTPUTS
        Retrieves a ConfigMgr WMI SMS_Driver object which can be filtered using a WMI query.
    .PARAMETER SiteProvider
        The computer name of the ConfigMgr site.
    .PARAMETER SiteCode
        The site code of the ConfigMgr site.
    .PARAMETER Filter
        A query for filtering the returned WMI object.
    .EXAMPLE
        Get-CMDriver -SiteProvider "cm-prov01" -SiteCode "WES"
    .EXAMPLE
        Get-CMDriver "cm-prov01" "WES" -Filter "Name = 'Intel HD Graphics'"
    #>

    [CmdletBinding()]
    Param (
        [Parameter(Position=1, Mandatory=$True)] [string] $SiteProvider,
        [Parameter(Position=2, Mandatory=$True)] [string] $SiteCode,
        [Parameter(Position=3, Mandatory=$False)] [string] $Filter
    )

    PROCESS {
        Get-CMObject $SiteProvider $SiteCode "SMS_Driver" $Filter -ErrorVariable +err -ErrorAction Stop
    }
}

function Get-CMDriverPackage {
    <#
    .SYNOPSIS
       Retrieves a WMI SMS_DriverPackage object in ConfigMgr.
    .OUTPUTS
        Retrieves a ConfigMgr WMI SMS_DriverPackage object which can be filtered using a WMI query.
    .PARAMETER SiteProvider
        The computer name of the ConfigMgr site.
    .PARAMETER SiteCode
        The site code of the ConfigMgr site.
    .PARAMETER Filter
        A query for filtering the returned WMI object.
    .EXAMPLE
        Get-CMDriverPackage -SiteProvider "cm-prov01" -SiteCode "WES"
    .EXAMPLE
        Get-CMDriverPackage "cm-prov01" "WES" -Filter "Name = 'Intel HD Graphics'"
    #>

    [CmdletBinding()]
    Param (
        [Parameter(Position=1, Mandatory=$True)] [string] $SiteProvider,
        [Parameter(Position=2, Mandatory=$True)] [string] $SiteCode,
        [Parameter(Position=3, Mandatory=$False)] [string] $Filter
    )

    PROCESS {
        Get-CMObject $SiteProvider $SiteCode "SMS_DriverPackage" $Filter -ErrorVariable +err -ErrorAction Stop
    }
}

function Get-CMSupportedPlatforms {

    [CmdletBinding()]
    Param (
        [Parameter(Position=1, Mandatory=$True)] [string] $SiteProvider,
        [Parameter(Position=2, Mandatory=$True)] [string] $SiteCode,
        [Parameter(Position=3, Mandatory=$False)] [string] $Filter
    )

    PROCESS {
        Get-CMObject $SiteProvider $SiteCode "SMS_SupportedPlatforms" $Filter -ErrorVariable +err -ErrorAction Stop
    }
}

function Get-CMTaskSequence {
    <#
    .SYNOPSIS
       Retrieves a WMI SMS_TaskSequence object in ConfigMgr.
    .OUTPUTS
        Retrieves a ConfigMgr WMI SMS_TaskSequence object which can be filtered using a WMI query.
    .PARAMETER SiteProvider
        The computer name of the ConfigMgr site.
    .PARAMETER SiteCode
        The site code of the ConfigMgr site.
    .PARAMETER Filter
        A query for filtering the returned WMI object.
    .EXAMPLE
        Get-CMTaskSequence -SiteProvider "cm-prov01" -SiteCode "WES"
    .EXAMPLE
        Get-CMTaskSequence "cm-prov01" "WES" -Filter "Name = 'Toshiba Laptop Builds'"
    #>

    [CmdletBinding()]
    Param (
        [Parameter(Position=1, Mandatory=$True)] [string] $SiteProvider,
        [Parameter(Position=2, Mandatory=$True)] [string] $SiteCode,
        [Parameter(Position=3, Mandatory=$False)] [string] $Filter
    )

    PROCESS {
        Get-CMObject $SiteProvider $SiteCode "SMS_TaskSequence" $Filter -ErrorVariable +err -ErrorAction Stop
    }
}

function Get-CMTaskSequencePackage {
    <#
    .SYNOPSIS
       Retrieves a WMI SMS_TaskSequencePackage object in ConfigMgr.
    .OUTPUTS
        Retrieves a ConfigMgr WMI SMS_TaskSequencePackage object which can be filtered using a WMI query.
    .PARAMETER SiteProvider
        The computer name of the ConfigMgr site.
    .PARAMETER SiteCode
        The site code of the ConfigMgr site.
    .PARAMETER Filter
        A query for filtering the returned WMI object.
    .EXAMPLE
        Get-CMTaskSequencePackage -SiteProvider "cm-prov01" -SiteCode "WES"
    .EXAMPLE
        Get-CMTaskSequencePackage "cm-prov01" "WES" -Filter "Name = 'Toshiba Laptop Builds'"
    #>

    [CmdletBinding()]
    Param (
        [Parameter(Position=1, Mandatory=$True)] [string] $SiteProvider,
        [Parameter(Position=2, Mandatory=$True)] [string] $SiteCode,
        [Parameter(Position=3, Mandatory=$False)] [string] $Filter
    )

    PROCESS {
        Get-CMObject $SiteProvider $SiteCode "SMS_TaskSequencePackage" $Filter -ErrorVariable +err -ErrorAction Stop
    }
}

function Get-CMMachineSettings {
    <#
    .SYNOPSIS
       Retrieves a WMI SMS_MachineSettings object in ConfigMgr.
    .OUTPUTS
        Retrieves a ConfigMgr WMI SMS_MachineSettings object which can be filtered using a WMI query.
    .PARAMETER SiteProvider
        The computer name of the ConfigMgr site.
    .PARAMETER SiteCode
        The site code of the ConfigMgr site.
    .PARAMETER Filter
        A query for filtering the returned WMI object.
    .EXAMPLE
        Get-CMMachineSettings -SiteProvider "cm-prov01" -SiteCode "WES"
    .EXAMPLE
        Get-CMMachineSettings "cm-prov01" "WES" -Filter "PropertyCount = '0'"
    #>

    [CmdletBinding()]
    Param (
        [Parameter(Position=1, Mandatory=$True)] [string] $SiteProvider,
        [Parameter(Position=2, Mandatory=$True)] [string] $SiteCode,
        [Parameter(Position=3, Mandatory=$False)] [string] $Filter
    )

    PROCESS {
        Get-CMObject $SiteProvider $SiteCode "SMS_MachineSettings" $Filter -ErrorVariable +err -ErrorAction Stop
    }
}

function Get-CMCollectionSettings {
    <#
    .SYNOPSIS
       Retrieves a WMI SMS_CollectionSettings object in ConfigMgr.
    .OUTPUTS
        Retrieves a ConfigMgr WMI SMS_CollectionSettings object which can be filtered using a WMI query.
    .PARAMETER SiteProvider
        The computer name of the ConfigMgr site.
    .PARAMETER SiteCode
        The site code of the ConfigMgr site.
    .PARAMETER Filter
        A query for filtering the returned WMI object.
    .EXAMPLE
        Get-CMCollectionSettings -SiteProvider "cm-prov01" -SiteCode "WES"
    .EXAMPLE
        Get-CMCollectionSettings "cm-prov01" "WES" -Filter "PropertyCount = '0'"
    #>

    [CmdletBinding()]
    Param (
        [Parameter(Position=1, Mandatory=$True)] [string] $SiteProvider,
        [Parameter(Position=2, Mandatory=$True)] [string] $SiteCode,
        [Parameter(Position=3, Mandatory=$False)] [string] $Filter
    )

    PROCESS {
        Get-CMObject $SiteProvider $SiteCode "SMS_CollectionSettings" $Filter -ErrorVariable +err -ErrorAction Stop
    }
}

function Get-CMSite {
    <#
    .SYNOPSIS
       Retrieves a WMI SMS_Site object in ConfigMgr.
    .OUTPUTS
        Retrieves a ConfigMgr WMI SMS_Site object which can be filtered using a WMI query.
    .PARAMETER SiteProvider
        The computer name of the ConfigMgr site.
    .PARAMETER SiteCode
        The site code of the ConfigMgr site.
    .PARAMETER Filter
        A query for filtering the returned WMI object.
    .EXAMPLE
        Get-CMSite -SiteProvider "cm-prov01" -SiteCode "WES"
    .EXAMPLE
        Get-CMSite "cm-prov01" "WES" -Filter "SiteCode = 'WES'"
    #>

    [CmdletBinding()]
    Param (
        [Parameter(Position=1, Mandatory=$True)] [string] $SiteProvider,
        [Parameter(Position=2, Mandatory=$True)] [string] $SiteCode,
        [Parameter(Position=3, Mandatory=$False)] [string] $Filter
    )

    PROCESS {
        Get-CMObject $SiteProvider $SiteCode "SMS_Site" $Filter -ErrorVariable +err -ErrorAction Stop
    }
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function New-CMComputer {
    <#
    .SYNOPSIS
       Converts a file into an array of computer objects.
    .DESCRIPTION
       Each object contains a ComputerName, SerialNumber, MACAddress and Username associated with it.
       This cmdlet's output should be used in conjunction with other cmdlets such as Import-CMComputerAssociation to supply the required input.
       CSV files are preferred, otherwise cannot guarentee completion.
    .OUTPUTS
        Returns an array of ComputerObjects with the ComputerName, SerialNumber, MACAddress and Username as attributes.
    .PARAMETER FileName
        The path to the file to be processed.
    .EXAMPLE
        New-CMComputer -FileName "C:\Computer_File.csv"
    .EXAMPLE
        New-CMComputer -FileName "C:\Computer_File.csv","C:\Computers.txt"
    .EXAMPLE
        New-CMComputer "PC-01" "0123456789ab" "SN1234" "BJones"
    .EXAMPLE
        New-CMComputer "PC-01","PC02" "0123456789ab","0123456789cd" "SN1234","SN5678" "BJones","TGeorge"
    #>

    [CmdletBinding(DefaultParameterSetName="Details")]
    Param (
        [Parameter(ParameterSetName="File", Position=1, Mandatory=$True, ValueFromPipeline=$True, ValueFromPipelineByPropertyName=$True)] [string[]] $FileName,
        [Parameter(ParameterSetName="Details", Position=1, Mandatory=$True, ValueFromPipelineByPropertyName=$True)] [string[]] $ComputerName,
        [Parameter(ParameterSetName="Details", Position=2, Mandatory=$True, ValueFromPipelineByPropertyName=$True)] [string[]] $MACAddress,
        [Parameter(ParameterSetName="Details", Position=3, Mandatory=$True, ValueFromPipelineByPropertyName=$True)] [string[]] $SerialNumber,
        [Parameter(ParameterSetName="Details", Position=4, Mandatory=$True, ValueFromPipelineByPropertyName=$True)] [string[]] $Username
    )

    BEGIN {
        $computers = @()
    }

    PROCESS {
        switch ($PSCmdlet.ParameterSetName) {
            "File" {
                foreach ($file in $FileName) {
                    try {
                        Write-Verbose "Importing csv file"
                        $fileContent = Import-CSV $file | Select ComputerName,SerialNumber,MACAddress,Username -ErrorVariable +err -ErrorAction Stop

                        foreach ($row in $fileContent) {
                            if ($row.ComputerName -eq "" -or $row.SerialNumber -eq "" -or  $row.MACAddress -eq "") {
                                Write-Verbose "Empty field in input file"
                                continue
                            }

                            Write-Verbose "Creating computer object"
                            $computerProperties = @{'ComputerName' = $row.ComputerName;
                                                    'SerialNumber' = $row.SerialNumber;
                                                    'MACAddress' = $row.MACAddress;
                                                    'Username' = $row.Username}

                            $computers += New-Object -TypeName PSObject -Property $computerProperties
                        }
                    }
                    catch {
                        Write-Error $_.Exception
                        Write-Verbose "Failed to import $file"
                    }
                }

                break
            }

            "Details" {
                if ($ComputerName.Length -ne $MACAddress.Length -ne $SerialNumber.Length -ne $Username.Length) {
                    Write-Debug "Parameters are of unequal lengths: $ComputerName.Length, $MACAddress.Length, $SerialNumber.Length, $Username.Length"
                    break
                }
                else {
                    Write-Verbose "Creating computer objects"
                    for ($i=0; $i -lt $ComputerName.Length; $i++) {
                        $computerProperties = @{'ComputerName' = $ComputerName[$i];
                                                'SerialNumber' = $SerialNumber[$i];
                                                'MACAddress' = $MACAddress[$i];
                                                'Username' = $Username[$i]}

                        $computers += New-Object -TypeName PSObject -Property $computerProperties
                    }
                }

                break
            }
        }
    }

    END {
        Write-Output $computers
    }
}

function Import-CMComputerAssociation {
    <#
    .SYNOPSIS
       Imports a computer association into ConfigMgr.
    .DESCRIPTION
       Uses WMI to create a new SMS_Site WMI class to invoke a ImportMachineEntry method using the provided
       ComputerName and MACAddress as properties to import a new computer associations into ConfigMgr.
    .OUTPUTS
        Returns a WMI computer association object iff the -Output switch is specified.
    .PARAMETER SiteProvider
        The computer name of the ConfigMgr site.
    .PARAMETER SiteCode
        The site code of the ConfigMgr site.
    .PARAMETER ComputerName
        The ComputerName used for the computer association.
    .PARAMETER MACAddress
        The MACAddress used for the computer association.
    .PARAMETER Overwrite
        An optional switch used to overwrite any existing computer association with an identical computer name.
    .PARAMETER Output
        An optional switch used to return the computer association WMI object.
    .EXAMPLE
        Import-CMComputerAssociation "cm-prov01" "WES" "PC01" "01:23:45:67:89:ab" 
    .EXAMPLE
        Import-CMComputerAssociation "cm-prov01" "WES" "PC01","PC02","PC03" "01:23:45:67:89:ab","01:23:45:67:89:cd","01:23:45:67:89:ef"
    .EXAMPLE
        Import-CMComputerAssociation "cm-prov01" "WES" "PC01" "01:23:45:67:89:ab" -Overwrite
    .EXAMPLE
        Import-CMComputerAssociation "cm-prov01" "WES" "PC01" "01:23:45:67:89:ab" -Output
    .EXAMPLE
        New-CMComputer -Filename "C:\Machine_List.csv" | Import-CMComputerAssociation "cm-prov01" "WES"
    #>

    [CmdletBinding()]
    Param (
        [Parameter(Position=1, Mandatory=$True)] [string] $SiteProvider,
        [Parameter(Position=2, Mandatory=$True)] [string] $SiteCode,
        [Parameter(Position=3, Mandatory=$True, ValueFromPipelineByPropertyName=$True)] [string[]] $ComputerName,
        [Parameter(Position=4, Mandatory=$True, ValueFromPipelineByPropertyName=$True)] [Alias("MAC")] [string[]] $MACAddress,
        [switch] $Overwrite,
        [switch] $Output
    )

    BEGIN {
        $siteClass = [WmiClass]”\\$SiteProvider\root\sms\site_$($SiteCode):SMS_Site”
        $methodAddEntry = ”ImportMachineEntry”
        $computerAssociations = @()
    }

    PROCESS {
        Write-Verbose "Importing computer associations"
        if ($ComputerName.Length -eq $MACAddress.Length) {
            for ($i=0; $i -lt $ComputerName.Length; $i++) {
                try {
                    $inParamsAddEntry = $siteClass.psbase.GetMethodParameters($methodAddEntry)
                    $inParamsAddEntry.MACAddress = $MACAddress[$i]
                    $inParamsAddEntry.OverwriteExistingRecord = [bool] $Overwrite
                    $inParamsAddEntry.NetbiosName = $ComputerName[$i]

                    $computerAssociationS += $siteClass.psbase.InvokeMethod($methodAddEntry, $inParamsAddEntry, $null)
                }
                catch {
                    Write-Error $_.Exception
                    Write-Verbose "Unable to import computer association"
                }
            }
        }
        else {
            Write-Verbose "Input parameter lengths aren't of equal length."
        }
    }

    END {
        if ($Output) {
            Write-Output $computerAssociations
        }
    }
}

function New-CMDeviceCollection {
    <#
    .SYNOPSIS
       Creates a new ConfigMgr device collection.
    .DESCRIPTION
       Uses WMI to create a new instance of SMS_Collection as a device collection.
    .PARAMETER SiteProvider
        The computer name of the ConfigMgr site.
    .PARAMETER SiteCode
        The site code of the ConfigMgr site.
    .PARAMETER CollectionName
        The name of the collection to create.
    .PARAMETER LimittingCollectionID
        An optional parameter used to limit the colleciton. If no collection ID is specified will default to All Systems.
    .PARAMETER Output
        An optional switch used to return the ComputerCollection WMI object.
    .EXAMPLE
        New-CMDeviceCollection "cm-prov01" "WES" -CollectionName "New Build Collection" -LimittingCollectionID "SMS00001"
    .EXAMPLE
        New-CMDeviceCollection "cm-prov01" "WES" "Collection A","Collection B","Collection C"
    .EXAMPLE
        "Collection A","Collection B","Collection C" | New-CMDeviceCollection "cm-prov01" "WES"
    .EXAMPLE
        "Collection A","Collection B","Collection C" | New-CMDeviceCollection "cm-prov01" "WES" -LimittingCollectionID = "SMS00001"
    #>

    [CmdletBinding()]
    Param (
        [Parameter(Position=1, Mandatory=$True)] [string] $SiteProvider,
        [Parameter(Position=2, Mandatory=$True)] [string] $SiteCode,
        [Parameter(Position=3, Mandatory=$True, ValueFromPipeline=$True, ValueFromPipelineByPropertyName=$True)] [string[]] $CollectionName,
        [Parameter(Position=4, Mandatory=$False)] [string] $LimittingCollectionID = "SMS00001"
    )

    BEGIN {
        $collectionClass = [WmiClass]"\\$SiteProvider\root\sms\site_$($SiteCode):SMS_Collection"
        $intervalClass = [WmiClass]"\\$SiteProvider\root\sms\site_$($SiteCode):SMS_ST_RecurInterval"
    }

    PROCESS {
        Write-Verbose "Creating device collections"
        foreach ($name in $CollectionName) {
            Write-Debug $name
            try {
                $newCollection = $collectionClass.PSBase.CreateInstance()
                $interval = $intervalClass.CreateInstance()
                $newCollection.Name = $name
                $newCollection.OwnedByThisSite = $True
                $newCollection.LimitToCollectionID = $LimittingCollectionID
                $newCollection.CollectionType = 2

                $interval = $intervalClass.CreateInstance()
                $interval.MinuteSpan = 0
                $interval.HourSpan = 0
                $interval.DaySpan = 0
                $newCollection.RefreshSchedule = $interval

                Write-Output $newCollection.Put()
            }
            catch {
                Write-Error $_.Exception
                Write-Verbose "Unable to create new device collection"
            }
        }
    }
}

function New-CMUserCollection {
    <#
    .SYNOPSIS
       Creates a new ConfigMgr user collection.
    .DESCRIPTION
       Uses WMI to create a new instance of SMS_Collection as a user collection.
    .OUTPUTS
        Returns a WMI collection object iff the -Output switch is specified.
    .PARAMETER SiteProvider
        The computer name of the ConfigMgr site.
    .PARAMETER SiteCode
        The site code of the ConfigMgr site.
    .PARAMETER CollectionName
        The name of the collection to create.
    .PARAMETER LimittingCollectionID
        An optional parameter used to limit the colleciton. If no collection ID is specified will default to All Systems.
    .EXAMPLE
        New-CMUserCollection "cm-prov01" "WES" -CollectionName "Admin Users" -LimittingCollectionID "SMS00002"
    .EXAMPLE
        New-CMUserCollection "cm-prov01" "WES" "Admin Users A","Admin Users B","Admin Users C"
    .EXAMPLE
        "Admin Users A","Admin Users B","Admin Users C" | New-CMUserCollection "cm-prov01" "WES"
    .EXAMPLE
        "Admin Users A","Admin Users B","Admin Users C" | New-CMUserCollection "cm-prov01" "WES" -LimittingCollectionID "SMS00002"
    #>

    [CmdletBinding()]
    Param (
        [Parameter(Position=1, Mandatory=$True)] [string] $SiteProvider,
        [Parameter(Position=2, Mandatory=$True)] [string] $SiteCode,
        [Parameter(Position=3, Mandatory=$True, ValueFromPipeline=$True, ValueFromPipelineByPropertyName=$True)] [string[]] $CollectionName,
        [Parameter(Position=4, Mandatory=$False)] [string] $LimittingCollectionID = "SMS00002"
    )

    BEGIN {
        $collectionClass = [WmiClass]"\\$SiteProvider\root\sms\site_$($SiteCode):SMS_Collection"
        $intervalClass = [WmiClass]"\\$SiteProvider\root\sms\site_$($SiteCode):SMS_ST_RecurInterval"
    }

    PROCESS {
        Write-Verbose "Creating device collections"
        foreach ($name in $CollectionName) {
            Write-Debug $name
            try {
                $newCollection = $collectionClass.PSBase.CreateInstance()
                $newCollection.Name = $name
                $newCollection.OwnedByThisSite = $True
                $newCollection.LimitToCollectionID = $LimittingCollectionID
                $newCollection.CollectionType = 1

                $interval = $intervalClass.CreateInstance()
                $interval.MinuteSpan = 0
                $interval.HourSpan = 0
                $interval.DaySpan = 0
                $newCollection.RefreshSchedule = $interval

                Write-Output $newCollection.Put()
            }
            catch {
                Write-Error $_.Exception
                Write-Verbose "Unable to create new user collection"
            }
        }
    }
}

function Remove-CMCollection {
    <#
    .SYNOPSIS
        Removes a collection in ConfigMgr.
    .DESCRIPTION
        Uses WMI to get the collection object to be removed and then removes it from ConfigMgr.
    .PARAMETER SiteProvider
        The computer name of the ConfigMgr site.
    .PARAMETER SiteCode
        The site code of the ConfigMgr site.
    .PARAMETER CollectionName
        The name of the collection to remove.
    .EXAMPLE
        Remove-CMCollection "cm-prov01" "WES" "Build Collection"
    .EXAMPLE
        Remove-CMCollection "cm-prov01" "WES" "Collection A", "Collection B", "Collection C"
    .EXAMPLE
        "Collection A", "Collection B", "Collection C" | Remove-CMCollection "cm-prov01" "WES"
    #>

    [CmdletBinding()]
    Param (
        [Parameter(Position=1, Mandatory=$True)] [string] $SiteProvider,
        [Parameter(Position=2, Mandatory=$True)] [string] $SiteCode,
        [Parameter(Position=3, Mandatory=$True, ValueFromPipeline=$True, ValueFromPipelineByPropertyName=$True)] [string[]] $CollectionName
    )

    PROCESS {
        Write-Verbose "Removing collections"
        foreach ($name in $CollectionName) {
            Write-Debug $name
            try {
                $targetCollection = Get-CMCollection $SiteProvider $SiteCode -Filter "Name = '$($name)'" -ErrorVariable +err -ErrorAction Stop
                $targetCollection.Delete()
            }
            catch {
                Write-Error $_.Exception
                Write-Verbose "Cannot delete collection - collection does not exist"
            }
        }
    }
}

function Add-CMDirectMembership {
    <#
    .SYNOPSIS
       Adds a direct membership to a device collection in ConfigMgr.
    .DESCRIPTION
       Uses WMI to create a new SMS_CollectionRuleDirect WMI class to invoke an AddMembershipRule method using the provided
       CollectionName as the collection and ComputerName as the member to add.
    .OUTPUTS
        Returns a WMI CollectionRuleDirect object iff the -Output switch is specified.
    .PARAMETER SiteProvider
        The computer name of the ConfigMgr site.
    .PARAMETER SiteCode
        The site code of the ConfigMgr site.
    .PARAMETER CollectionName
        The name of the collection to add the member to.
    .PARAMETER ComputerName
        The name of the computer member to add.
    .PARAMETER Output
        An optional switch used to return the CollectionRuleDirect WMI object.
    .EXAMPLE
        Add-CMDirectMembership "cm-prov01" "WES" "Build Collection" "PC-01"
    .EXAMPLE
        Add-CMDirectMembership "cm-prov01" "WES" "Build Collection" "PC-01","PC=02","PC-03"
    .EXAMPLE
        "PC-01", "PC-02", "PC-03" | Add-CMDirectMembership "cm-prov01" "WES" "Build Collection"
    #>

    [CmdletBinding()]
    Param (
        [Parameter(Position=1, Mandatory=$True)] [string] $SiteProvider,
        [Parameter(Position=2, Mandatory=$True)] [string] $SiteCode,
        [Parameter(Position=3, Mandatory=$True)] [string] $CollectionName,
        [Parameter(Position=4, Mandatory=$True, ValueFromPipeline=$True, ValueFromPipelineByPropertyName=$True)] [string[]] $ComputerName
    )

    BEGIN {
        $collectionRuleDirectClass = [WmiClass]”\\$siteProvider\root\sms\site_$($siteCode):SMS_CollectionRuleDirect”
        $methodAddToCollection = ”AddMembershipRule”
    }

    PROCESS {
        Write-Verbose "Adding direct membership rules"
        foreach ($name in $ComputerName) {
            Write-Debug "ComputerName: $name"
            try {
                $targetCollection = Get-CMCollection $SiteProvider $SiteCode -Filter "Name = '$($CollectionName)'" -ErrorVariable +err -ErrorAction Stop
                $computerMember = Get-CMFullCollectionMembership $SiteProvider $SiteCode -Filter "Name = '$($name)'" -ErrorVariable +err -ErrorAction Stop

                if ($targetCollection -eq $null) {
                    Write-Error "Unable to add direct membership - collection not found"
                    Write-Verbose "Unable to add direct membership - collection not found"
                    break
                }
                if ($computerMember -eq $null) {
                    Write-Error "Unable to add direct membership - machine not found"
                    Write-Verbose "Unable to add direct membership - collection not found"
                    break
                }

                if ($computerMember.Length -gt 1) {
                    $computerResourceID = $computerMember[0].ResourceID
                } else {
                    $computerResourceID = $computerMember.ResourceID
                }
                Write-Debug "ResourceID: $computerResourceID"

                $collectionRuleDirectClass.psbase.Properties["ResourceClassName"].Value = “SMS_R_System”
                $collectionRuleDirectClass.psbase.Properties["ResourceID"].Value = $computerResourceID

                $inParamsAddToCollection = $targetCollection.psbase.GetMethodParameters($methodAddToCollection)
                $inParamsAddToCollection.CollectionRule = $collectionRuleDirectClass

                Write-Output $targetCollection.psbase.InvokeMethod($methodAddToCollection, $inParamsAddToCollection, $null)
            }
            catch {
                Write-Error $_.Exception
                Write-Verbose "Unable to add direct membership"
            }
        }
    }
}

function Remove-CMDirectMembership {
    <#
    .SYNOPSIS
       Removes a direct membership from a device collection in ConfigMgr.
    .DESCRIPTION
       Uses WMI to create a new SMS_CollectionRuleDirect WMI class to invoke a DeleteMembershipRule method using the provided
       CollectionName as the collection and ComputerName as the member to remove.
    .PARAMETER SiteProvider
        The computer name of the ConfigMgr site.
    .PARAMETER SiteCode
        The site code of the ConfigMgr site.
    .PARAMETER CollectionName
        The name of the collection to remove the member from.
    .PARAMETER ComputerName
        The name of the computer member to remove.
    .EXAMPLE
        Remove-CMDirectMembershipRule "cm-prov01" "WES" "Build Collection" "PC-01"
    .EXAMPLE
        Remove-CMDirectMembershipRule "cm-prov01" "WES" "Build Collection" "PC-01","PC-02","PC-03"
    .EXAMPLE
        "PC-01", "PC-02", "PC-03" | Remove-CMDirectMembershipRule "cm-prov01" "WES" "Build Collection"
    #>

    [CmdletBinding(DefaultParameterSetName="Computer")]
    Param (
        [Parameter(Position=1, Mandatory=$True)] [string] $SiteProvider,
        [Parameter(Position=2, Mandatory=$True)] [string] $SiteCode,
        [Parameter(Position=3, Mandatory=$True, ValueFromPipelineByPropertyName=$True)] [Alias("Collection")] [string[]] $CollectionName,
        [Parameter(ParameterSetName="Computer", Position=4, Mandatory=$True, ValueFromPipelineByPropertyName=$True)] [Alias("Computer")] [string[]] $ComputerName,
        [Parameter(ParameterSetName="Collection")] [switch] $All
    )

    BEGIN {
        $ruleClass = [WmiClass]"\\$SiteProvider\root\sms\site_$($SiteCode):SMS_CollectionRuleDirect"
    }

    PROCESS {
        switch ($PSCmdlet.ParameterSetName) {
            "Computer" {
                Write-Verbose "Removing direct membership rules"
                foreach ($collection in $CollectionName) {
                    foreach ($name in $ComputerName) {
                        Write-Debug "Removing $name from $collection"
                        try {
                            $targetCollection = Get-CMCollection $SiteProvider $SiteCode -Filter "Name = '$($collection)'" -ErrorVariable +err -ErrorAction Stop
                            $computerMember = Get-CMFullCollectionMembership $SiteProvider $SiteCode -Filter "Name = '$($name)'" -ErrorVariable +err -ErrorAction Stop

                            if ($targetCollection -eq $null) {
                                Write-Error "Unable to add direct membership - collection not found"
                                Write-Verbose "Unable to add direct membership - collection not found"
                                break
                            }
                            if ($computerMember -eq $null) {
                                Write-Error "Unable to add direct membership - machine not found"
                                Write-Verbose "Unable to add direct membership - collection not found"
                                break
                            }

                            Write-Verbose "Getting computer resource ID"
                            if ($computerMember.Length -gt 1) {
                                $computerResourceID = $computerMember[0].ResourceID
                            } else {
                                $computerResourceID = $computerMember.ResourceID
                            }
                            Write-Debug "ResourceID: $computerResourceID"

                            if ($targetCollection.CollectionRules -eq $null) {
                                $targetCollection.Get()
                            }
                            
                            foreach ($rule in $targetCollection.CollectionRules) {
                                if ($computerResourceID -eq $rule.ResourceID) {
                                    $newRule = $ruleClass.CreateInstance()
                                    $newRule.ResourceClassName = "SMS_FullCollectionMembership"
                                    $newRule.ResourceID = $computerResourceID
                                    $newRule.RuleName = $name

                                    $targetCollection.psbase.InvokeMethod("DeleteMembershipRule", $newRule)
                                    break
                                }
                            }
                        }
                        catch {
                            Write-Error $_.Exception
                            Write-Verbose "Failed to remove direct membership rule"
                        }
                    }
                }

                break
            }

            "Collection" {
                Write-Verbose "Removing direct membership rules"
                foreach ($collection in $CollectionName) {
                    Write-Debug $collection
                    try {
                        $targetCollection = Get-CMCollection $SiteProvider $SiteCode -Filter "Name = '$($collection)'" -ErrorVariable +err -ErrorAction Stop

                        $targetCollection.psbase.InvokeMethod("DeleteAllMembers", $null)
                    }
                    catch {
                        Write-Error $_.Exception
                        Write-Verbose "Unable to remove direct membership rules - method failure"
                    }
                }

                break
            }
        }
    }
}

function New-CMTaskSequenceAdvertisement {
    <#
    .SYNOPSIS
       Advertises a task sequence to a collection in ConfigMgr.
    .DESCRIPTION
       Uses WMI to create a new instance of a SMS_Advertisement WMI class with the given attributes as properties.
       An output switch can be used to output the result of the function.
    .OUTPUTS
        Returns a WMI SMS object iff the -Output switch is specified.
    .PARAMETER SiteProvider
        The computer name of the ConfigMgr site.
    .PARAMETER SiteCode
        The site code of the ConfigMgr site.
    .PARAMETER TaskSequenceName
        The name of the task sequence to advertise.
    .PARAMETER CollectionName
        The name of the collection to advertise the task sequence to.
    .PARAMETER AdvertisementName
        The name of the new advertisement.
    .PARAMETER Comment
        An optional parameter used to specify the comment used in the creation of the advertisement.
        If not specified an empty string will be used.
    .PARAMETER ExpirationTime
        An optional parameter of the advertisement's expiry time.
        If not specified the current time will be used.
        Must have the following format:
            "yyyymmddhhmmff"
    .PARAMETER Output
        An optional switch used to return the Advertisement WMI object.
    .EXAMPLE
        New-CMTaskSequenceAdvertisement "cm-prov01" "WES" "Windows 7 x64" "Build Collection"
    .EXAMPLE
        New-CMTaskSequenceAdvertisement "cm-prov01" "WES" "Windows 7 x64" "Build Collection" -AdvertisementName "New Advertisement" -Comment "This is a comment" -ExpirationTime "20120113000000"
    .EXAMPLE
        New-CMTaskSequenceAdvertisement "cm-prov01" "WES" "Windows 7 x64" "Build Collection" -Output
    #>

    [CmdletBinding()]
    Param (
        [Parameter(Position=1, Mandatory=$True)] [string] $SiteProvider,
        [Parameter(Position=2, Mandatory=$True)] [string] $SiteCode,
        [Parameter(Position=3, Mandatory=$True)] [string] $TaskSequenceName,
        [Parameter(Position=4, Mandatory=$True, ValueFromPipeline=$True, ValueFromPipelineByPropertyName=$True)] [string[]] $CollectionName,
        [Parameter(Position=5, Mandatory=$False)] [string] $AdvertisementName = "Default Advertisement Name",
        [Parameter(Position=6, Mandatory=$False)] [string] $Comment = "",
        [Parameter(Position=7, Mandatory=$False)] $ExpirationTime = (Get-Date).ToString("yyyyMMddhhmmff")
    )
    
    BEGIN {
        $advertisementClass = [WmiClass]”\\$SiteProvider\root\sms\site_$($SiteCode):SMS_Advertisement”
        $presentTime = (Get-Date).ToString("yyyyMMddhhmmff") + ".000000+***"
        $ExpirationTime += ".000000+***"
    }

    PROCESS {
        Write-Verbose "Creating new task sequence advertisement"
        foreach ($collection in $CollectionName) {
            try {
                $taskSequence = Get-CMTaskSequencePackage $SiteProvider $SiteCode -Filter "Name = '$($TaskSequenceName)'" -ErrorVariable +err -ErrorAction Stop
                $taskSequenceID = $taskSequence.PackageID
                Write-Debug "Task sequence ID: $taskSequenceID"

                $targetCollection = Get-CMCollection $SiteProvider $SiteCode -Filter "Name = '$($collection)'" -ErrorVariable +err -ErrorAction Stop
                $targetCollectionID = $targetCollection.CollectionID
                Write-Debug "Collection ID: $targetCollectionID"

                $newAdvertisement = $advertisementClass.PSBase.CreateInstance()
                $newAdvertisement.AdvertisementName = $AdvertisementName
                $newAdvertisement.Comment = $Comment
                $newAdvertisement.CollectionID = $targetCollectionID
                $newAdvertisement.PackageID = $taskSequenceID
                $newAdvertisement.ProgramName = "*"
                $newAdvertisement.PresentTime = $presentTime
                $newAdvertisement.ExpirationTime = $ExpirationTime
                $newAdvertisement.AdvertFlags = 42860576
                $newAdvertisement.RemoteClientFlags = 8480
                Write-Output $newAdvertisement.Put()
            }
            catch {
                Write-Error $_.Exception
                Write-Verbose "Unable to create new task sequence advertisement"
            }
        }
    }
}

function Remove-CMTaskSequenceAdvertisement {
    <#
    .SYNOPSIS
       Removes a task sequence advertisement in ConfigMgr.
    .DESCRIPTION
       Uses WMI to get the collection and advertisement objects. Then uses the CollectionID to remove the correct advertisement.
    .PARAMETER SiteProvider
        The computer name of the ConfigMgr site.
    .PARAMETER SiteCode
        The site code of the ConfigMgr site.
    .PARAMETER CollectionName
        The name of the collection to remove the advertisement from.
    .PARAMETER AdvertisementName
        The name of the advertisement to remove from the collection.
    .EXAMPLE
        Remove-CMTaskSequenceAdvertisement "cm-prov01" "WES" "Build Collection" "Advertisement Name"
    .EXAMPLE
        Remove-CMTaskSequenceAdvertisement "cm-prov01" "WES" "Build Collection" "Advertisement A","Advertisement B","Advertisement C"
    .EXAMPLE
        "Advertisement A","Advertisement B","Advertisement C" | Remove-CMTaskSequenceAdvertisement "cm-prov01" "WES" -CollectionName "Build Collection"
    #>

    [CmdletBinding()]
    Param (
        [Parameter(Position=1, Mandatory=$True)] [string] $SiteProvider,
        [Parameter(Position=2, Mandatory=$True)] [string] $SiteCode,
        [Parameter(Position=3, Mandatory=$True)] [string] $CollectionName,
        [Parameter(Position=4, Mandatory=$True, ValueFromPipeline=$True, ValueFromPipelineByPropertyName=$True)] [string[]] $AdvertisementName
    )
    
    PROCESS {
        Write-Verbose "Removing advertisements"
        foreach ($advertisement in $AdvertisementName) {
            Write-Debug $advertisement
            try {
                $targetCollection = Get-CMCollection $SiteProvider $SiteCode -Filter "Name = '$($CollectionName)'"
                $targetCollectionID = $targetCollection.CollectionID
                Write-Debug $targetCollectionID
            
                $targetAdvertisement = Get-CMAdvertisement $SiteProvider $SiteCode -Filter "AdvertisementName = '$($advertisement)' AND CollectionID = '$($targetCollectionID)'"
                $targetAdvertisement.Delete()
            }
            catch {
                Write-Error $_.Exception
                Write-Verbose "Collection not deleted"
            }
        }
    }
}

function Get-CMCollectionMembers {
    <#
    .SYNOPSIS
       Gets a list of the direct member names of a collection in ConfigMgr.
    .DESCRIPTION
       Uses WMI to get the collection object to be listed. Then gets the FullCollectionMembership object list from
       the collection and returns each of the member names as an array.
    .PARAMETER SiteProvider
        The computer name of the ConfigMgr site.
    .PARAMETER SiteCode
        The site code of the ConfigMgr site.
    .PARAMETER CollectionName
        The name of the collection to get the members from.
    .EXAMPLE
        Get-CMCollectionMemberList "cm-prov01" "WES" "Build Collection"
    #>

    [CmdletBinding()]
    Param (
        [Parameter(Position=1, Mandatory=$True)] [string] $SiteProvider,
        [Parameter(Position=2, Mandatory=$True)] [string] $SiteCode,
        [Parameter(Position=3, Mandatory=$True)] [string] $CollectionName
    )

    BEGIN {
        $memberNames = @()
    }

    PROCESS {
        try {
            $targetCollection = Get-CMCollection $SiteProvider $SiteCode -Filter "Name = '$($CollectionName)'" -ErrorVariable +err -ErrorAction Stop
            $collectionID = $targetCollection.CollectionID
            $collectionMembers = Get-CMFullCollectionMembership $SiteProvider $SiteCode -Filter "CollectionID = '$($collectionID)'" -ErrorVariable +err -ErrorAction Stop

            foreach ($machine in $collectionMembers) {
                $memberNames += $machine.Name
            }
        }
        catch {
            Write-Error $_.Exception
            Write-Verbose "Failed to get collection member names"
        }
    }

    END {
        Write-Output $memberNames
    }
}

function Clear-CMPXEAdvertisement {
    <#
    .SYNOPSIS
       Clears a machines' PXE advertisement flag in ConfigMgr.
    .DESCRIPTION
       Uses WMI to get the machine to be cleared and then clears the PXE advertisement flag associated.
    .PARAMETER SiteProvider
        The computer name of the ConfigMgr site.
    .PARAMETER SiteCode
        The site code of the ConfigMgr site.
    .PARAMETER MachineName
        The name of the machine to be cleared.
    .EXAMPLE
        Clear-CMPXEAdvertisement "cm-prov01" "WES" "PC-01"
    .EXAMPLE
        Clear-CMPXEAdvertisement "cm-prov01" "WES" "PC-01","PC-02","PC-03"
    .EXAMPLE
        "PC-01","PC-02","PC-03" | Clear-CMPXEAdvertisement "cm-prov01" "WES"
    .EXAMPLE
        Clear-CMPXEAdvertisement "cm-prov01" "WES" -CollectionName "Collection A","Collection B","Collection C"
    #>

    [CmdletBinding(DefaultParameterSetName="Machine")]
    Param (
        [Parameter(Position=1, Mandatory=$True)] [string] $SiteProvider,
        [Parameter(Position=2, Mandatory=$True)] [string] $SiteCode,
        [Parameter(ParameterSetName="Machine", Position=3, Mandatory=$True, ValueFromPipeline=$True, ValueFromPipelineByPropertyName=$True)] [string[]] $MachineName,
        [Parameter(ParameterSetName="Collection", Position=3, Mandatory=$True, ValueFromPipeline=$True, ValueFromPipelineByPropertyName=$True)] [string[]] $CollectionName
    )

    BEGIN {
        $resourceIDs = @()
    }

    PROCESS {
        switch ($PSCmdlet.ParameterSetName) {
            "Machine" {
                Write-Verbose "Clearing machine PXE advertisement"
                foreach ($name in $MachineName) {
                    Write-Debug $name
                    try {
                        $computerMember = Get-CMFullCollectionMembership $SiteProvider $SiteCode -Filter "Name = '$($name)'" -ErrorVariable +err -ErrorAction Stop

                        if ($computerMember.Length -gt 1) {
                            $computerResourceID = $computerMember[0].ResourceID
                        } else {
                            $computerResourceID = $computerMember.ResourceID
                        }
                        Write-Debug "ResourceID: $computerResourceID"

                        $resourceIDs += $computerResourceID
                    }
                    catch {
                        Write-Error $_.Exception
                        Write-Verbose "Unable to clear PXE advertisemment - machine doesn't exist"
                    }
                }

                try {
                    Invoke-WmiMethod -Namespace "root\sms\site_$SiteCode" -Class SMS_Collection -Name ClearLastNBSAdvForMachines -ArgumentList $resourceIDs -ComputerName $SiteProvider -ErrorVariable +err -ErrorAction Stop
                }
                catch {
                    Write-Error $_.Exception
                    Write-Verbose "Unable to clear PXE advertisemment - method failure"
                }

                break
            }

            "Collection" {
                foreach ($collection in $CollectionName) {
                    try {
                        $targetCollection = Get-CMCollection $SiteProvider $SiteCode -Filter "Name = '$($collection)'" -ErrorVariable +err -ErrorAction Continue

                        $targetCollection.psbase.InvokeMethod("ClearLastNBSAdvForCollection", $null, $null)
                    }
                    catch {
                        Write-Error $_.Exception
                        Write-Verbose "Failed to clear PXE advertisemment"
                    }
                }

                try {
                    $targetCollection = Get-CMCollection $SiteProvider $SiteCode -Filter "Name = '$($CollectionName)'" -ErrorVariable +err -ErrorAction Stop

                    $targetCollection.psbase.InvokeMethod("ClearLastNBSAdvForCollection", $null, $null)
                }
                catch {
                    Write-Error $_.Exception
                    Write-Verbose "Failed to clear PXE advertisemment"
                }

                break
            }
        }
    }       
}

function Update-CMCollectionMembership {
    <#
    .SYNOPSIS
       Updates the collection membership of a collection in ConfigMgr.
    .DESCRIPTION
       Uses WMI to get a collection object and then invokes an RequestRefresh method on the collection.
    .PARAMETER SiteProvider
        The computer name of the ConfigMgr site.
    .PARAMETER SiteCode
        The site code of the ConfigMgr site.
    .PARAMETER CollectionName
        The name of the collection to update the membership of.
    .PARAMETER IncludeSubCollections
        An optional switch to update memberships of all sub-collections.
    .EXAMPLE
        Update-CMCollectionMembership "cm-prov01" "WES" "Build Collection" -IncludeSubCollections
    .EXAMPLE
        Update-CMCollectionMembership "cm-prov01" "WES" "Collection A","Collection B","Collection C"
    .EXAMPLE
        "Collection A","Collection B","Collection C" | Update-CMCollectionMembership "cm-prov01" "WES"
    .EXAMPLE
        "Collection A","Collection B","Collection C" | Update-CMCollectionMembership "cm-prov01" "WES" -IncludeSubCollection
    #>

    [CmdletBinding()]
    Param (
        [Parameter(Position=1, Mandatory=$True)] [string] $SiteProvider,
        [Parameter(Position=2, Mandatory=$True)] [string] $SiteCode,
        [Parameter(Position=3, Mandatory=$True, ValueFromPipeline=$True, ValueFromPipelineByPropertyName=$True)] [string[]] $CollectionName,
        [switch] [Alias("Recurse")] $IncludeSubCollections
    )

    PROCESS {
        Write-Verbose "Updating collection memberships"
        foreach ($collection in $CollectionName) {
            Write-Debug $collection
            try {
                $targetCollection = Get-CMCollection $SiteProvider $SiteCode -Filter "Name = '$($collection)'" -ErrorVariable +err -ErrorAction Stop

                $targetCollection.psbase.InvokeMethod("RequestRefresh", [bool] $IncludeSubCollections)
            }
            catch {
                Write-Error $_.Exception
                Write-Verbose "Unable to update collection membership - method failure"
            }
        }
    }
}

function Add-CMVariable {
    <#
    .SYNOPSIS
        Adds a machine or collection variable in ConfigMgr.
    .DESCRIPTION
        Uses WMI to get a machine or collection settings object and then adds a machine variable or collection variable WMI object.
    .PARAMETER SiteProvider
        The computer name of the ConfigMgr site.
    .PARAMETER SiteCode
        The site code of the ConfigMgr site.
    .PARAMETER ComputerName
        The name of the machine to add the machine variable to.
    .PARAMETER CollectionName
        The name of the collection to add the collection variable to.
    .PARAMETER VariableName
        The name of the variable to add.
    .PARAMETER Value
        The value assigned to the variable.
    .PARAMETER IsMasked
        An optional switch to define whether the variable is masked or not.
    .EXAMPLE
        Add-CMVariable "cm-prov01" "WES" "PC-01" -VariableName "Architecture" -Value "x64"
    .EXAMPLE
        Add-CMVariable "cm-prov01" "WES" "PC-01" -VariableName "Architecture" -Value "x64" -IsMasked
    .EXAMPLE
        Add-CMVariable "cm-prov01" "WES" "PC-01","PC-02","PC-03" -VariableName "Architecture" -Value "x64"
    .EXAMPLE
        "PC-01","PC-02","PC-03" | Add-CMVariable "cm-prov01" "WES" -VariableName "Architecture" -Value "x64"
    .EXAMPLE
        Add-CMVariable "cm-prov01" "WES" -CollectionName "Build Collection" -VariableName "Architecture" -Value "x64"
    .EXAMPLE
        Add-CMVariable "cm-prov01" "WES" -CollectionName "Collection A,""Collection B","Collection C" -VariableName "Architecture" -Value "x64"
    #>

    [CmdletBinding(DefaultParameterSetName="Computer")]
    Param (
        [Parameter(Position=1, Mandatory=$True)] [string] $SiteProvider,
        [Parameter(Position=2, Mandatory=$True)] [string] $SiteCode,
        [Parameter(ParameterSetName="Computer", Position=3, Mandatory=$True, ValueFromPipeline=$True, ValueFromPipelineByPropertyName=$True)] [Alias("Computer")] [string[]] $ComputerName,
        [Parameter(ParameterSetName="Collection", Position=3, Mandatory=$True, ValueFromPipeline=$True, ValueFromPipelineByPropertyName=$True)] [Alias("Collection")] [string[]] $CollectionName,
        [Parameter(Position=4, Mandatory=$True)] [string] $VariableName,
        [Parameter(Position=5, Mandatory=$True)] [string] $Value,
        [switch] $IsMasked
    )

    BEGIN {
        $machineSettingsClass = [WmiClass]”\\$siteProvider\root\sms\site_$($siteCode):SMS_MachineSettings”
        $machineVariableClass = [WmiClass]”\\$siteProvider\root\sms\site_$($siteCode):SMS_MachineVariable”
        $collectionSettingsClass = [WmiClass]”\\$siteProvider\root\sms\site_$($siteCode):SMS_CollectionSettings”
        $collectionVariableClass = [WmiClass]”\\$siteProvider\root\sms\site_$($siteCode):SMS_CollectionVariable”
    }

    PROCESS {
        switch ($PSCmdlet.ParameterSetName) {
            "Computer" {
                Write-Verbose "Adding computer variables"
                foreach ($computer in $ComputerName) {
                    Write-Debug "Computer: $computer, Variable: $VariableName - $Value"
                    try {
                        $machineMember = Get-CMFullCollectionMembership $SiteProvider $SiteCode -Filter "Name = '$($computer)'"
                        if ($machineMember -eq $null) {
                            Write-Error "Unable to add computer variable - machine not found"
                            Write-Verbose "Unable to add computer variable - machine not found"
                            break
                        }

                        if ($machineMember.Length -gt 1) {
                            $machineResourceID = $machineMember[0].ResourceID
                        } else {
                            $machineResourceID = $machineMember.ResourceID
                        }
                        Write-Debug "ResourceID: $machineResourceID"

                        $machineSettings = Get-CMMachineSettings $SiteProvider $SiteCode -Filter "ResourceID = '$($machineResourceID)'"

                        if ($machineSettings -eq $null) {
                            Write-Verbose "Creating new machine settings"
                            $machineSettings = $machineSettingsClass.CreateInstance()
                            $machineSettings.ResourceID = $machineResourceID
                            $machineSettings.SourceSite = $SiteCode
                        }
                        else {
                            Write-Verbose "Fetching machine settings"
                            $machineSettings.Get()
                        }
                        
                        Write-Verbose "Updating computer variables"
                        $newMachineVariable = $machineVariableClass.CreateInstance()
                        $newMachineVariable.Name = $VariableName
                        $newMachineVariable.Value = $Value
                        $newMachineVariable.IsMasked = [bool] $IsMasked

                        $machineSettings.MachineVariables += $newMachineVariable
                        
                        $machineSettings.Put()
                    }
                    catch {
                        Write-Error $_.Exception
                        Write-Verbose "Unable to add machine variable"
                    }
                }
            }

            "Collection" {
                Write-Verbose "Adding computer variables"
                foreach ($collection in $CollectionName) {
                    Write-Debug "Collection: $collection, Variable: $VariableName - $Value"
                    try {
                        $collectionMember = Get-CMCollection $SiteProvider $SiteCode -Filter "Name = '$($collection)'"
                        $collectionID = $collectionMember[0].CollectionID
                        Write-Debug $collectionID

                        $collectionSettings = Get-CMCollectionSettings $SiteProvider $SiteCode -Filter "CollectionID = '$($collectionID)'"

                        if ($collectionSettings -eq $null) {
                            Write-Verbose "Creating new machine settings"
                            $collectionSettings = $collectionSettingsClass.CreateInstance()
                            $collectionSettings.SourceSite = $SiteCode
                        }
                        else {
                            Write-Verbose "Fetching machine settings"
                            $collectionSettings.Get()
                        }
                        
                        Write-Verbose "Updating collection variables"
                        $newCollectionVariable = $collectionVariableClass.CreateInstance()
                        $newCollectionVariable.Name = $VariableName
                        $newCollectionVariable.Value = $Value
                        $newCollectionVariable.IsMasked = [bool] $IsMasked

                        $collectionSettings.CollectionVariables += $newCollectionVariable
                        
                        $collectionSettings.Put()
                    }
                    catch {
                        Write-Error $_.Exception
                        Write-Verbose "Unable to add collection variable"
                    }
                }
            }
        }
    }
}

function Remove-CMVariable {
    <#
    .SYNOPSIS
        Removes a machine or collection variable in ConfigMgr.
    .DESCRIPTION
        Uses WMI to get a machine or collection settings object and then removes a machine variable or collection variable WMI object.
        Rebuilds the machine variable or collection variable list without the select variable.
    .PARAMETER SiteProvider
        The computer name of the ConfigMgr site.
    .PARAMETER SiteCode
        The site code of the ConfigMgr site.
    .PARAMETER ComputerName
        The name of the machine to remove the machine variable from.
    .PARAMETER CollectionName
        The name of the collection to remove the collection variable from.
    .PARAMETER VariableName
        The name of the variable to remove.
    .EXAMPLE
        Remove-CMVariable "cm-prov01" "WES" "PC-01" -VariableName "Architecture"
    .EXAMPLE
        Remove-CMVariable "cm-prov01" "WES" "PC-01","PC-02","PC-03" -VariableName "Architecture"
    .EXAMPLE
        "PC-01","PC-02","PC-03" | Remove-CMVariable "cm-prov01" "WES" -VariableName "Architecture"
    .EXAMPLE
        Remove-CMVariable "cm-prov01" "WES" -CollectionName "Build Collection" -VariableName "Architecture"
    .EXAMPLE
        Remove-CMVariable "cm-prov01" "WES" -CollectionName "Collection A,""Collection B","Collection C" -VariableName "Architecture"
    #>

    [CmdletBinding(DefaultParameterSetName="Computer")]
    Param (
        [Parameter(Position=1, Mandatory=$True)] [string] $SiteProvider,
        [Parameter(Position=2, Mandatory=$True)] [string] $SiteCode,
        [Parameter(ParameterSetName="Computer", Position=3, Mandatory=$True)] [Alias("Computer")] [string[]] $ComputerName,
        [Parameter(ParameterSetName="Collection", Position=3, Mandatory=$True)] [Alias("Collection")] [string[]] $CollectionName,
        [Parameter(Position=4, Mandatory=$True)] [Alias("Variable")] [string] $VariableName
    )

    BEGIN {
        $machineSettingsClass = [WmiClass]”\\$siteProvider\root\sms\site_$($siteCode):SMS_MachineSettings”
        $machineVariableClass = [WmiClass]”\\$siteProvider\root\sms\site_$($siteCode):SMS_MachineVariable”
        $collectionSettingsClass = [WmiClass]”\\$siteProvider\root\sms\site_$($siteCode):SMS_CollectionSettings”
        $collectionVariableClass = [WmiClass]”\\$siteProvider\root\sms\site_$($siteCode):SMS_CollectionVariable”
    }

    PROCESS {
        switch ($PSCmdlet.ParameterSetName) {
            "Computer" {
                Write-Verbose "Removing computer variable"
                foreach ($computer in $ComputerName) {
                    Write-Debug "Computer: $computer, Variable: $VariableName"
                    try {
                        $machineMember = Get-CMFullCollectionMembership $SiteProvider $SiteCode -Filter "Name = '$($computer)'"
                        if ($machineMember -eq $null) {
                            Write-Error "Unable to remove computer variable - machine not found"
                            Write-Verbose "Unable to remove computer variable - machine not found"
                            break
                        }

                        if ($machineMember.Length -gt 1) {
                            $machineResourceID = $machineMember[0].ResourceID
                        } else {
                            $machineResourceID = $machineMember.ResourceID
                        }
                        Write-Debug "ResourceID: $machineResourceID"

                        $machineSettings = Get-CMMachineSettings $SiteProvider $SiteCode -Filter "ResourceID = '$($machineResourceID)'"

                        if ($machineSettings -ne $null) {
                            $machineSettings.Get()

                            $variableIndex = -1
                            for ($i=0; $i -lt $machineSettings.MachineVariables.Length; $i++) {
                                if ($machineSettings.MachineVariables[$i].Name -eq $VariableName) {
                                    $variableIndex = $i
                                    break
                                }
                            }
                            
                            Write-Verbose "Rebuilding the machine variables without the requested one if variable found"
                            if ($variableIndex -ne -1) {
                                $newMachineVariables = @()
                                for ($i=0; $i -lt $machineSettings.MachineVariables.Length; $i++) {
                                    if ($i -ne $variableIndex) {
                                        $machineVariable = $machineVariableClass.CreateInstance()
                                        $machineVariable.Name = $machineSettings.MachineVariables[$i].Name
                                        $machineVariable.Value = $machineSettings.MachineVariables[$i].Value
                                        $machineVariable.IsMasked = $machineSettings.MachineVariables[$i].IsMasked

                                        $newMachineVariables += $machineVariable
                                    }
                                }

                                $machineSettings.MachineVariables = $newMachineVariables
                                $machineSettings.Put()
                            }
                            else {
                                Write-Verbose "Machine variable not removed - variable not found"
                            }
                        }
                        else {
                            Write-Verbose "Machine variable not removed"
                        }                        
                    }
                    catch {
                        Write-Error $_.Exception
                        Write-Verbose "Unable to remove machine variable"
                    }
                }
            }

            "Collection" {
                Write-Verbose "Removing computer variable"
                foreach ($collection in $CollectionName) {
                    Write-Debug "Collection: $collection, Variable: $VariableName"
                    try {
                        $collectionMember = Get-CMCollection $SiteProvider $SiteCode -Filter "Name = '$($collection)'"
                        $collectionID = $collectionMember[0].CollectionID
                        Write-Debug "CollectionID: $collectionID"

                        $collectionSettings = Get-CMCollectionSettings $SiteProvider $SiteCode -Filter "CollectionID = '$($collectionID)'"

                        if ($collectionSettings -ne $null) {
                            $collectionSettings.Get()

                            $variableIndex = -1
                            for ($i=0; $i -lt $collectionSettings.CollectionVariables.Length; $i++) {
                                if ($collectionSettings.CollectionVariables[$i].Name -eq $VariableName) {
                                    $variableIndex = $i
                                    break
                                }
                            }
                            
                            Write-Verbose "Rebuilding the collection variables without the requested one if variable found"
                            if ($variableIndex -ne -1) {
                                $newCollectionVariables = @()
                                for ($i=0; $i -lt $collectionSettings.CollectionVariables.Length; $i++) {
                                    if ($i -ne $variableIndex) {
                                        $collectionVariable = $collectionVariableClass.CreateInstance()
                                        $collectionVariable.Name = $collectionSettings.CollectionVariables[$i].Name
                                        $collectionVariable.Value = $collectionSettings.CollectionVariables[$i].Value
                                        $collectionVariable.IsMasked = $collectionSettings.CollectionVariables[$i].IsMasked

                                        $newCollectionVariables += $collectionVariable
                                    }
                                }

                                $collectionSettings.CollectionVariables = $newCollectionVariables
                                $collectionSettings.Put()
                            }
                            else {
                                Write-Verbose "Collection variable not removed - variable not found"
                            }
                        }
                        else {
                            Write-Verbose "Collection variable not removed"
                        }                        
                    }
                    catch {
                        Write-Error $_.Exception
                        Write-Verbose "Unable to remove collection variable"
                    }
                }
            }
        }
    }
}

function New-CMUserDeviceRelationship {
    <#
    .SYNOPSIS
        Created a new user-device affinity in ConfigMgr.
    .DESCRIPTION
        Uses WMI to get a FullCollectionMembership object to get the device's resourceID.
        Invokes a WMI CreateRelationship method on the device with the associated username.
    .PARAMETER SiteProvider
        The computer name of the ConfigMgr site.
    .PARAMETER SiteCode
        The site code of the ConfigMgr site.
    .PARAMETER ComputerName
        The name of the machine to create the affinity with.

        Notes:
        This can be an array of names but it must be the same length as Username.
    .PARAMETER Username
        The username to create the affinity with.

        Notes:
        This can be an array of names but it must be the same length as ComputerName.
    .PARAMETER AffinityType
        The type of user-device affinity to create.
        Is optional but if not used will default to type 2.
        
        Notes:
        Must be 1-4, inclusive.
    .EXAMPLE
        New-CMUserDeviceRelationship "cm-prov01" "WES" "PC-01" "FBloggs" -AffinityType 3
    .EXAMPLE
        New-CMUserDeviceRelationship "cm-prov01" "WES" "PC-01" "FBloggs"
    .EXAMPLE
        New-CMUserDeviceRelationship "cm-prov01" "WES" "PC-01","PC-02" "FBloggs","GWhite" -AffinityType 2
    #>

    [CmdletBinding()]
    Param (
        [Parameter(Position=1, Mandatory=$True)] [string] $SiteProvider,
        [Parameter(Position=2, Mandatory=$True)] [string] $SiteCode,
        [Parameter(Position=3, Mandatory=$True, ValueFromPipeline=$True, ValueFromPipelineByPropertyName=$True)] [string[]] $ComputerName,
        [Parameter(Position=4, Mandatory=$True, ValueFromPipeline=$True, ValueFromPipelineByPropertyName=$True)] [Alias("User")] [string[]] $Username,
        [Parameter(Position=5, Mandatory=$False)] [ValidateRange(1,4)] [string] $AffinityType = 2
    )

    PROCESS {
        if ($ComputerName.Length -ne $Username.Length) {
            Write-Error "The number of computer names and usernames do not match"
            break
        }

        for ($i=0; $i -lt $ComputerName.Length; $i++) {
            $computer = $ComputerName[$i]
            $user = $Username[$i]

            try {
                $computerMember = Get-CMFullCollectionMembership $SiteProvider $SiteCode -Filter "Name = '$computer'" -ErrorVariable +err -ErrorAction Stop
                if ($computerMember -eq $null) {
                    Write-Error "Unable to add user device relationship - machine not found"
                    Write-Verbose "Unable to user device relationship - collection not found"
                    break
                }

                if ($computerMember.Length -gt 1) {
                    $computerResourceID = $computerMember[0].ResourceID
                } else {
                    $computerResourceID = $computerMember.ResourceID
                }
                Write-Debug "ResourceID: $computerResourceID"

                Invoke-WmiMethod -Namespace "root\sms\site_$siteCode" -Class "SMS_UserMachineRelationship" -Name "CreateRelationship" -ArgumentList @($computerResourceID, $affinityType, 1, $name) -ComputerName $siteProvider
            }
            catch {            
                Write-Error $_.Exception
                Write-Verbose "Unable to user device relationship"
            }
        }
    }
}

function Disable-CMDriver {
    <#
    .SYNOPSIS
        Disables a driver in ConfigMgr.
    .DESCRIPTION
        Uses WMI to get a Driver object to disable.
    .PARAMETER SiteProvider
        The computer name of the ConfigMgr site.
    .PARAMETER SiteCode
        The site code of the ConfigMgr site.
    .PARAMETER DriverName
        The name of the driver to disable.

        Notes:
        Multiple drivers may have identical names. All drivers with the specified name will be disabled.
    .PARAMETER LimittingDriverCategory
        Optional.
        Limits the scrope of the drivers that can be disabled.
    .EXAMPLE
        Disable-CMDriver "cm-prov01" "WES" "Realtek High Definition Audio"
    .EXAMPLE
        Disable-CMDriver "cm-prov01" "WES" -DriverName "Realtek High Definition Audio","Intel(R) Management Engine Interface Device"
    .EXAMPLE
        Disable-CMDriver "cm-prov01" "WES" "Realtek High Definition Audio" -LimittingDriverCategory "Dell Latitude Drivers"
    .EXAMPLE
        Disable-CMDriver "cm-prov01" "WES" "Realtek High Definition Audio" -LimittingDriverCategory "Dell Latitude Drivers","Toshiba M10 Drivers"
    #>

    [CmdletBinding()]
    Param (
        [Parameter(Position=1, Mandatory=$True)] [string] $SiteProvider,
        [Parameter(Position=2, Mandatory=$True)] [string] $SiteCode,
        [Parameter(Position=3, Mandatory=$True, ValueFromPipeline=$True, ValueFromPipelineByPropertyName=$True)] [Alias("Driver")] [string[]] $DriverName,
        [Parameter(Position=4, Mandatory=$False)] [string[]] $LimittingDriverCategory
    )

    PROCESS {
        foreach ($driver in $DriverName) {
            $targetDrivers = Get-CMDriver $SiteProvider $SiteCode -Filter "LocalizedDisplayName = '$driver'"
            foreach ($targetDriver in $targetDrivers) {
                if ($LimittingDriverCategory -ne $Null) {
                    foreach ($driverCategory in $LimittingDriverCategory) {
                        if ($targetDriver.LocalizedCategoryInstanceNames.Contains($driverCategory)) {
                            Write-Verbose "Disabling: $($targetDriver.LocalizedDisplayName) in $driverCategory"
                            $targetDriver.IsEnabled = $false
                        }
                    }
                }
                else {
                    Write-Verbose "Disabling: $($targetDriver.LocalizedDisplayName)"
                    $targetDriver.IsEnabled = $false
                }
            }
        }
    }
}

function Enable-CMDriver {
    <#
    .SYNOPSIS
        Enables a driver in ConfigMgr.
    .DESCRIPTION
        Uses WMI to get a Driver object to enable.
    .PARAMETER SiteProvider
        The computer name of the ConfigMgr site.
    .PARAMETER SiteCode
        The site code of the ConfigMgr site.
    .PARAMETER DriverName
        The name of the driver to enable.

        Notes:
        Multiple drivers may have identical names. All drivers with the specified name will be enabled.
    .PARAMETER LimittingDriverCategory
        Optional.
        Limits the scrope of the drivers that can be disabled.
    .EXAMPLE
        Disable-CMDriver "cm-prov01" "WES" "Realtek High Definition Audio"
    .EXAMPLE
        Disable-CMDriver "cm-prov01" "WES" -DriverName "Realtek High Definition Audio","Intel(R) Management Engine Interface Device"
    .EXAMPLE
        Disable-CMDriver "cm-prov01" "WES" "Realtek High Definition Audio" -LimittingDriverCategory "Dell Latitude Drivers"
    .EXAMPLE
        Disable-CMDriver "cm-prov01" "WES" "Realtek High Definition Audio" -LimittingDriverCategory "Dell Latitude Drivers","Toshiba M10 Drivers"
    #>

    [CmdletBinding()]
    Param (
        [Parameter(Position=1, Mandatory=$True)] [string] $SiteProvider,
        [Parameter(Position=2, Mandatory=$True)] [string] $SiteCode,
        [Parameter(Position=3, Mandatory=$True, ValueFromPipeline=$True, ValueFromPipelineByPropertyName=$True)] [string[]] $DriverName,
        [Parameter(Position=4, Mandatory=$False)] [string[]] $LimittingDriverCategory
    )

    PROCESS {
        foreach ($driver in $DriverName) {
            $targetDrivers = Get-CMDriver $SiteProvider $SiteCode -Filter "LocalizedDisplayName = '$driver'"
            foreach ($targetDriver in $targetDrivers) {
                if ($LimittingDriverCategory -ne $Null) {
                    foreach ($driverCategory in $LimittingDriverCategory) {
                        if ($targetDriver.LocalizedCategoryInstanceNames.Contains($driverCategory)) {
                            Write-Verbose "Enabling: $($targetDriver.LocalizedDisplayName) in $driverCategory"
                            $targetDriver.IsEnabled = $true
                        }
                    }
                }
                else {
                    Write-Verbose "Enabling: $($targetDriver.LocalizedDisplayName)"
                    $targetDriver.IsEnabled = $true
                }
            }
        }
    }
}