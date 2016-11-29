Function Retrieve-SystemInfo {
    <#
    .SYNOPSIS
    Get Complete details of any server Local or remote
    .DESCRIPTION
    This function uses WMI class to connect to remote machine and get all related details
    .PARAMETER COMPUTERNAMES
    Just Pass computer name as Its parameter
    .EXAMPLE 
    Retrieve-SystemInfo
    .EXAMPLE 
    Retrieve-SystemInfo -ComputerName HQSPDBSP01
    .NOTES
    To get help:
    Get-Help Retrieve-SystemInfo
    .LINK
    http://sqlpowershell.wordpress.com
    #>


    param(
        [Parameter(Mandatory=$true)] $ComputerName,
        [switch] $IgnorePing
     )

    $computer = $ComputerName

    # Declare main data hash to be populated later
    $data = @{}
    $data.' ComputerName'=$computer

    # Try an ICMP ping the only way Powershell knows how...
    $ping = Test-Connection -quiet -count 1 $computer
    $Ping = $(if ($ping) {$true} else {$false})

    # Do a DNS lookup with a .NET class method. Suppress error messages.
    $ErrorActionPreference = 'SilentlyContinue'
    if ( $ips = [System.Net.Dns]::GetHostAddresses($computer) | foreach { $_.IPAddressToString } ) {
    
        $data.'IP Address(es) from DNS' = ($ips -join ', ')
    }
    else {
        $data.'IP Address from DNS' = 'Could not resolve'
    }
    # Make errors visible again
    $ErrorActionPreference = 'Continue'

    # We'll assume no ping reply means it's dead. Try this anyway if -IgnorePing is specified
    if ($ping -or $ignorePing) {
        $data.'WMI Data Collection Attempt' = 'Yes (ping reply or -IgnorePing)'
    
        # Get various info from the ComputerSystem WMI class
        if ($wmi = Get-WmiObject -Computer $computer -Class Win32_ComputerSystem -ErrorAction SilentlyContinue) {
            $data.'Computer Hardware Manufacturer' = $wmi.Manufacturer
            $data.'Computer Hardware Model'        = $wmi.Model
            $data.'Memory Physical in MB'          = ($wmi.TotalPhysicalMemory/1MB).ToString('N')
            $data.'Logged On User'                 = $wmi.Username
        }
        $wmi = $null
    
        # Get the free/total disk space from local disks (DriveType 3)
        if ($wmi = Get-WmiObject -Computer $computer -Class Win32_LogicalDisk -Filter 'DriveType=3' -ErrorAction SilentlyContinue) { 
            $wmi | Select 'DeviceID', 'Size', 'FreeSpace' | Foreach { 
                $data."Local disk $($_.DeviceID)" = ('' + ($_.FreeSpace/1MB).ToString('N') + ' MB free of ' + ($_.Size/1MB).ToString('N') + ' MB total space with ' + ($_.Size/1MB - $_.FreeSpace/1MB).ToString('N') +' MB Used Space')
            }
        }
        $wmi = $null
    
        # Get IP addresses from all local network adapters through WMI
        if ($wmi = Get-WmiObject -Computer $computer -Class Win32_NetworkAdapterConfiguration -ErrorAction SilentlyContinue) {
            $Ips = @{}
            $wmi | Where { $_.IPAddress -match '\S+' } | Foreach { $Ips.$($_.IPAddress -join ', ') = $_.MACAddress }
            $counter = 0
            $Ips.GetEnumerator() | Foreach {
                $counter++; $data."IP Address $counter" = '' + $_.Name + ' (MAC: ' + $_.Value + ')'
            }
        }
        $wmi = $null
	
        # Get CPU information with WMI
        if ($wmi = Get-WmiObject -Computer $computer -Class Win32_Processor -ErrorAction SilentlyContinue) {
            $wmi | Foreach {
                $maxClockSpeed     =  $_.MaxClockSpeed
                $numberOfCores     += $_.NumberOfCores
                $description       =  $_.Description
                $numberOfLogProc   += $_.NumberOfLogicalProcessors
                $socketDesignation =  $_.SocketDesignation
                $status            =  $_.Status
                $manufacturer      =  $_.Manufacturer
                $name              =  $_.Name
            }
            $data.'CPU Clock Speed'        = $maxClockSpeed
            $data.'CPU Cores'              = $numberOfCores
            $data.'CPU Description'        = $description
            $data.'CPU Logical Processors' = $numberOfLogProc
            $data.'CPU Socket'             = $socketDesignation
            $data.'CPU Status'             = $status
            $data.'CPU Manufacturer'       = $manufacturer
            $data.'CPU Name'               = $name -replace '\s+', ' '
        }
        $wmi = $null
	
        # Get BIOS info from WMI
        if ($wmi = Get-WmiObject -Computer $computer -Class Win32_Bios -ErrorAction SilentlyContinue) {
            $data.'BIOS Manufacturer' = $wmi.Manufacturer
            $data.'BIOS Name'         = $wmi.Name
            $data.'BIOS Version'      = $wmi.Version
        }
        $wmi = $null
	
        # Get operating system info from WMI
        if ($wmi = Get-WmiObject -Computer $computer -Class Win32_OperatingSystem -ErrorAction SilentlyContinue) {  
            $data.'OS Boot Time'     = $wmi.ConvertToDateTime($wmi.LastBootUpTime)
            $data.'OS System Drive'  = $wmi.SystemDrive
            $data.'OS System Device' = $wmi.SystemDevice
            $data.'OS Language     ' = $wmi.OSLanguage
            $data.'OS Version'       = $wmi.Version
            $data.'OS Windows dir'   = $wmi.WindowsDirectory
            $data.'OS Name'          = $wmi.Caption
            $data.'OS Install Date'  = $wmi.ConvertToDateTime($wmi.InstallDate)
            $data.'OS Service Pack'  = [string]$wmi.ServicePackMajorVersion + '.' + $wmi.ServicePackMinorVersion
        }
        # Scan for open ports
        $ports = @{ 
                    'File shares/RPC' = '139' ;
                    'File shares'     = '445' ;
                    'RDP'             = '3389';
                    #'Zenworks'        = '1761';
                  }
        foreach ($service in $ports.Keys) {
            $socket = New-Object Net.Sockets.TcpClient
            # Suppress error messages
            $ErrorActionPreference = 'SilentlyContinue'
            # Try to connect
            $socket.Connect($computer, $ports.$service)
            # Make error messages visible again
            $ErrorActionPreference = 'Continue'
            if ($socket.Connected) {  
                $data."Port $($ports.$service) ($service)" = 'Open'
                $socket.Close()
            }
            else {  
                $data."Port $($ports.$service) ($service)" = 'Closed or filtered'
            }
            $socket = $null   
        }
    }
    else { 
        #$data.'WMI Data Collected' = 'No (no ping reply and -IgnorePing not specified)'
        Write-OutputBox -OutputBoxMessage "Unable to connect to $computer" -Type "ERROR: " -Object Tab1
        Return
    }
    $wmi = $null

    if ($wmi = Get-WmiObject -Class Win32_OperatingSystem -computername $Computer -ErrorAction SilentlyContinue| Select-Object Name, TotalVisibleMemorySize, FreePhysicalMemory,TotalVirtualMemorySize,FreeVirtualMemory,FreeSpaceInPagingFiles,NumberofProcesses,NumberOfUsers ) {
            $wmi | Foreach {   
                $TotalRAM     =  $_.TotalVisibleMemorySize/1MB
                $FreeRAM     = $_.FreePhysicalMemory/1MB
                $UsedRAM       =  $_.TotalVisibleMemorySize/1MB - $_.FreePhysicalMemory/1MB
                $TotalRAM = [Math]::Round($TotalRAM, 2)
                $FreeRAM = [Math]::Round($FreeRAM, 2)
                $UsedRAM = [Math]::Round($UsedRAM, 2)
                $RAMPercentFree = ($FreeRAM / $TotalRAM) * 100
                $RAMPercentFree = [Math]::Round($RAMPercentFree, 2)
                $TotalVirtualMemorySize  = [Math]::Round($_.TotalVirtualMemorySize/1MB, 3)
                $FreeVirtualMemory =  [Math]::Round($_.FreeVirtualMemory/1MB, 3)
                $FreeSpaceInPagingFiles            =  [Math]::Round($_.FreeSpaceInPagingFiles/1MB, 3)
                $NumberofProcesses      =  $_.NumberofProcesses
                $NumberOfUsers              =  $_.NumberOfUsers
            }
            $data.'Memory - Total RAM GB '  = $TotalRAM
            $data.'Memory - RAM Free GB'    = $FreeRAM
            $data.'Memory - RAM Used GB'    = $UsedRAM
            $data.'Memory - Percentage Free'= $RAMPercentFree
            $data.'Memory - TotalVirtualMemorySize' = $TotalVirtualMemorySize
            $data.'Memory - FreeVirtualMemory' = $FreeVirtualMemory
            $data.'Memory - FreeSpaceInPagingFiles' = $FreeSpaceInPagingFiles
            $data.'NumberofProcesses'= $NumberofProcesses
            $data.'NumberOfUsers'    = $NumberOfUsers -replace '\s+', ' '
        }
    # Output data
    "#"*80
    "OS Complete Information"
    "Generated $(get-date)"
    "Generated from $(gc env:computername)"
    "#"*80

    $data.GetEnumerator() | Sort-Object 'Name' | Format-Table -AutoSize
    $data.GetEnumerator() | Sort-Object 'Name' | Out-GridView -Title "$computer Information"
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
        return $True  | Out-Null
      }
      Catch {
        Write-Verbose $_.Exception.Message
        return $False | Out-Null

      }

    } #Process

    End {
        Write-Verbose -Message "Ending $($MyInvocation.Mycommand)"
    } #end

}

#http://gallery.technet.microsoft.com/scriptcenter/56962f03-0243-4c83-8cdd-88c37898ccc4
function Run-RemoteCMD { 
 
    param( 
    [Parameter(Mandatory=$true,valuefrompipeline=$true)] 
    [string]$ComputerName,
    [string]$command = "gpupdate /force"
    ) 
    begin { 
        [void][Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic')
	    $command = [microsoft.visualbasic.interaction]::InputBox('Enter command to run','Command',$command)
        [string]$cmd = "CMD.EXE /C " +$command 
    } 
    process { 
        $newproc = Invoke-WmiMethod -class Win32_process -name Create -ArgumentList ($cmd) -ComputerName $ComputerName 
        if ($newproc.ReturnValue -eq 0 ) 
                { Write-Output " Command $($command) invoked Sucessfully on $($ComputerName)" } 
                # if command is sucessfully invoked it doesn't mean that it did what its supposed to do 
                #it means that the command only sucessfully ran on the cmd.exe of the server 
                #syntax errors can occur due to user input 
    } 
    End{Write-Output "Script ...END"} 
} 


function Ping-RemoteSystem {
    param(
        [parameter(Mandatory=$true,ValueFromPipeline)]
        [string]$Remote,
        [switch]$TestOnly
    )
    If ($Remote -ne $null){
        If (Test-Connection -quiet -count 1 $Remote){
            If (!$TestOnly){$pingResult=ping $Remote | fl | out-string;}
            Write-OutputBox -OutputBoxMessage $pingResult -Type "PING: " -Object Tab1
        }
        Else{
            Write-OutputBox -OutputBoxMessage "Unable to connect to $Remote" -Type "ERROR: " -Object Tab1
        }
    } 
    Else {
        If (!$TestOnly){$pingResult=ping | fl | out-string;};
    }
    Write-OutputBox -OutputBoxMessage $pingResult -Type "PING: " -Object Tab1
}

function Get-DiskSpace {
    [CmdletBinding(DefaultParameterSetName="Computer")]
    Param (
        [Parameter(ParameterSetName="Computer", Position=1, Mandatory=$False)] [string] $Computername
    )
    ######################################################################## 
    # Code Generated By: SAPIEN Technologies PrimalForms (Community Edition) v1.0.9.0 
    # Generated On: 4/29/2011 9:19 PM 
    # Generated By: tparthib 
    ######################################################################## 
 
    #region Import the Assemblies 
    [reflection.assembly]::loadwithpartialname("System.Drawing") | Out-Null 
    [reflection.assembly]::loadwithpartialname("System.Windows.Forms") | Out-Null 
    #endregion 
 
    #region Generated Form Objects 
    $form1 = New-Object System.Windows.Forms.Form 
    $label2 = New-Object System.Windows.Forms.Label 
    $textBox3 = New-Object System.Windows.Forms.TextBox 
    $textBox2 = New-Object System.Windows.Forms.TextBox 
    $label4 = New-Object System.Windows.Forms.Label 
    $label3 = New-Object System.Windows.Forms.Label 
    $panel1 = New-Object System.Windows.Forms.Panel 
    $dataGridView1 = New-Object System.Windows.Forms.DataGridView 
    $textBox1 = New-Object System.Windows.Forms.TextBox 
    $label1 = New-Object System.Windows.Forms.Label 
    $button1 = New-Object System.Windows.Forms.Button 
    $InitialFormWindowState = New-Object System.Windows.Forms.FormWindowState 
    #endregion Generated Form Objects 
 
    #---------------------------------------------- 
    #Generated Event Script Blocks 
    #---------------------------------------------- 
    #Provide Custom Code for events specified in PrimalForms. 
    $handler_dataGridView1_CurrentCellChanged=  
    { 
        $graphics =  $form1.createGraphics() 
        #$myBrush = new-object Drawing.SolidBrush red  
        #$graphics.FillEllipse($myBrush, 590, 80, 140, 140) 
        $rectangle = New-Object Drawing.Rectangle 590,95,140,140 
        $greenBrush = New-Object Drawing.SolidBrush Green 
        $redBrush = New-Object Drawing.SolidBrush Red 
        $pen = New-Object Drawing.Pen Black 
        #$pen.Color = "Black" 
        $pen.Width = 4  
        $currentRow = $dataGridView1.CurrentRow.Index 
        [int]$abc = $dataGridView1.rows[$currentRow].Cells[5].value 
        [int]$xyz = 100 - $abc 
        [double]$tt = $abc + $xyz 
        [double]$deg1 = ($abc/$tt) * 360 
        [double]$deg2 = ($xyz/$tt) * 360  
        $graphics.DrawPie($pen,$rectangle,0,$deg1) 
        $graphics.FillPie($greenBrush,$rectangle,0,$deg1) 
        $graphics.DrawPie($pen,$rectangle,$deg1,$deg2) 
        $graphics.FillPie($redBrush,$rectangle,$deg1,$deg2) 
 
    }

    $handler_button1_Click=  
    { 
        if ($textBox1.text -eq ""){ 
                [System.Windows.Forms.MessageBox]::Show("Please type in a computer, then click Check Space") 
        } 
        else 
            {                 
            if ( Test-Connection $textBox1.text -Quiet -Count 1){ 
            $dataGridView1.ColumnCount = 0 
            $dataGridView1.RowCount=0 
            $dataGridView1.ColumnCount = 6         
            [double]$warningPercent = $textBox2.text 
            [double]$criticalPercent = $textBox3.text                 
            $dataGridView1.Columns[0].Name = "Drive" 
            $dataGridView1.Columns[1].Name = "Label" 
            $dataGridView1.Columns[2].Name = "Total(GB)" 
            $dataGridView1.Columns[3].Name = "Used(GB)" 
            $dataGridView1.Columns[4].Name = "Free(GB)" 
            $dataGridView1.Columns[5].Name = "Free(%)" 
            $disks = Get-WmiObject -Class Win32_LogicalDisk -ComputerName "localhost" | Where {$_.drivetype -eq 3}                             
            foreach($disk in $disks) 
                    { 
                        $totalSize = "{0:N2}" -f ($disk.size/1gb)                             
                        $freeSpace = "{0:N2}" -f ($disk.freespace/1gb)                             
                        $usedSize = "{0:N2}" -f ($totalSize - $freeSpace)                             
                        $freeP = ($freeSpace/$totalSize) * 100 
                        $freeP = [math]::round($freeP, 2)                             
                        $dataGridView1.Rows.Add($disk.deviceid,$disk.volumename,$totalSize,$usedSize,$freeSpace,$freeP)                                                                                                             
                    }                         
                for ($r = 0; $r -lt $disks.count; $r++)  
                { 
                    $value = $dataGridView1.rows[$r].Cells[5].value                         
                         
                    if ($value -gt $warningPercent) 
                        {                                                     
                            $dataGridView1.Rows[$r].Cells[5].Style.BackColor = [System.Drawing.Color]::FromArgb(0,153,0)     
                        } 
                    elseif ($value -lt $criticalPercent)  
                        { 
                            $dataGridView1.Rows[$r].Cells[5].Style.BackColor = [System.Drawing.Color]::FromArgb(255, 0, 51) 
                        } 
                    else 
                        {                                                         
                            $dataGridView1.Rows[$r].Cells[5].Style.BackColor = [System.Drawing.Color]::FromArgb(255, 227, 3) 
                        }             
                } 
                     
            } 
            else{ 
                [System.Windows.Forms.MessageBox]::Show("Unable to query free space, Computer may not be online or you don't have permissions to quary disks.") 
            }             
                     
                     
        } 
  
    } 
 
    $OnLoadForm_StateCorrection= 
    {#Correct the initial state of the form to prevent the .Net maximized form issue 
        $form1.WindowState = $InitialFormWindowState 
    } 
 
    #---------------------------------------------- 
    #region Generated Form Code 
    $form1.AutoScaleMode = 3 
    $System_Drawing_Size = New-Object System.Drawing.Size 
    $System_Drawing_Size.Height = 250 
    $System_Drawing_Size.Width = 765 
    $form1.ClientSize = $System_Drawing_Size 
    $form1.DataBindings.DefaultDataSourceUpdateMode = 0 
    $form1.MaximizeBox = $False 
    $form1.Name = "form1" 
    $form1.StartPosition = 1 
    $form1.Text = "DiskSpace Tool" 
 
    $label2.DataBindings.DefaultDataSourceUpdateMode = 0 
    $label2.Font = New-Object System.Drawing.Font("Tahoma",9.75,5,3,1) 
 
    $System_Drawing_Point = New-Object System.Drawing.Point 
    $System_Drawing_Point.X = 615 
    $System_Drawing_Point.Y = 70 
    $label2.Location = $System_Drawing_Point 
    $label2.Name = "label2" 
    $System_Drawing_Size = New-Object System.Drawing.Size 
    $System_Drawing_Size.Height = 23 
    $System_Drawing_Size.Width = 100 
    $label2.Size = $System_Drawing_Size 
    $label2.TabIndex = 1 
    $label2.Text = "PIE CHART" 
 
    $form1.Controls.Add($label2) 
 
    $textBox3.DataBindings.DefaultDataSourceUpdateMode = 0 
    $textBox3.Font = New-Object System.Drawing.Font("Microsoft Sans Serif",9.75,1,3,1) 
    $System_Drawing_Point = New-Object System.Drawing.Point 
    $System_Drawing_Point.X = 498 
    $System_Drawing_Point.Y = 26 
    $textBox3.Location = $System_Drawing_Point 
    $textBox3.Name = "textBox3" 
    $System_Drawing_Size = New-Object System.Drawing.Size 
    $System_Drawing_Size.Height = 22 
    $System_Drawing_Size.Width = 27 
    $textBox3.Size = $System_Drawing_Size 
    $textBox3.TabIndex = 7 
    $textBox3.Text = "10" 
 
    $form1.Controls.Add($textBox3) 
 
    $textBox2.DataBindings.DefaultDataSourceUpdateMode = 0 
    $textBox2.Font = New-Object System.Drawing.Font("Tahoma",9.75,1,3,1) 
    $System_Drawing_Point = New-Object System.Drawing.Point 
    $System_Drawing_Point.X = 419 
    $System_Drawing_Point.Y = 26 
    $textBox2.Location = $System_Drawing_Point 
    $textBox2.Name = "textBox2" 
    $System_Drawing_Size = New-Object System.Drawing.Size 
    $System_Drawing_Size.Height = 23 
    $System_Drawing_Size.Width = 28 
    $textBox2.Size = $System_Drawing_Size 
    $textBox2.TabIndex = 6 
    $textBox2.Text = "20" 
 
    $form1.Controls.Add($textBox2) 
 
    $label4.BackColor = [System.Drawing.Color]::FromArgb(255,255,0,0) 
    $label4.DataBindings.DefaultDataSourceUpdateMode = 0 
    $label4.Font = New-Object System.Drawing.Font("Tahoma",8.25,1,3,1) 
 
    $System_Drawing_Point = New-Object System.Drawing.Point 
    $System_Drawing_Point.X = 483 
    $System_Drawing_Point.Y = 8 
    $label4.Location = $System_Drawing_Point 
    $label4.Name = "label4" 
    $System_Drawing_Size = New-Object System.Drawing.Size 
    $System_Drawing_Size.Height = 15 
    $System_Drawing_Size.Width = 78 
    $label4.Size = $System_Drawing_Size 
    $label4.TabIndex = 5 
    $label4.Text = "CRITICAL %" 
 
    $form1.Controls.Add($label4) 
 
    $label3.BackColor = [System.Drawing.Color]::FromArgb(255,255,255,0) 
    $label3.DataBindings.DefaultDataSourceUpdateMode = 0 
    $label3.Font = New-Object System.Drawing.Font("Tahoma",8.25,1,3,1) 
 
    $System_Drawing_Point = New-Object System.Drawing.Point 
    $System_Drawing_Point.X = 397 
    $System_Drawing_Point.Y = 8 
    $label3.Location = $System_Drawing_Point 
    $label3.Name = "label3" 
    $System_Drawing_Size = New-Object System.Drawing.Size 
    $System_Drawing_Size.Height = 15 
    $System_Drawing_Size.Width = 79 
    $label3.Size = $System_Drawing_Size 
    $label3.TabIndex = 4 
    $label3.Text = "WARNING %" 
 
    $form1.Controls.Add($label3) 
 
 
    $panel1.DataBindings.DefaultDataSourceUpdateMode = 0 
    $System_Drawing_Point = New-Object System.Drawing.Point 
    $System_Drawing_Point.X = 13 
    $System_Drawing_Point.Y = 55 
    $panel1.Location = $System_Drawing_Point 
    $panel1.Name = "panel1" 
    $System_Drawing_Size = New-Object System.Drawing.Size 
    $System_Drawing_Size.Height = 178 
    $System_Drawing_Size.Width = 548 
    $panel1.Size = $System_Drawing_Size 
    $panel1.TabIndex = 3 
 
    $form1.Controls.Add($panel1) 
    $dataGridView1.AllowUserToAddRows = $False 
    $dataGridView1.AutoSizeColumnsMode = 6 
    $dataGridView1.AutoSizeRowsMode = 7 
    $System_Windows_Forms_DataGridViewCellStyle_1 = New-Object System.Windows.Forms.DataGridViewCellStyle 
    $System_Windows_Forms_DataGridViewCellStyle_1.Alignment = 16 
    $System_Windows_Forms_DataGridViewCellStyle_1.BackColor = [System.Drawing.Color]::FromArgb(255,240,240,240) 
    $System_Windows_Forms_DataGridViewCellStyle_1.Font = New-Object System.Drawing.Font("Tahoma",8.25,0,3,1) 
    $System_Windows_Forms_DataGridViewCellStyle_1.ForeColor = [System.Drawing.Color]::FromArgb(255,0,0,0) 
    $System_Windows_Forms_DataGridViewCellStyle_1.SelectionBackColor = [System.Drawing.Color]::FromArgb(255,51,153,255) 
    $System_Windows_Forms_DataGridViewCellStyle_1.SelectionForeColor = [System.Drawing.Color]::FromArgb(255,255,255,255) 
    $System_Windows_Forms_DataGridViewCellStyle_1.WrapMode = 1 
    $dataGridView1.ColumnHeadersDefaultCellStyle = $System_Windows_Forms_DataGridViewCellStyle_1 
    $dataGridView1.DataBindings.DefaultDataSourceUpdateMode = 0 
    $System_Windows_Forms_DataGridViewCellStyle_2 = New-Object System.Windows.Forms.DataGridViewCellStyle 
    $System_Windows_Forms_DataGridViewCellStyle_2.Alignment = 16 
    $System_Windows_Forms_DataGridViewCellStyle_2.BackColor = [System.Drawing.Color]::FromArgb(255,255,255,255) 
    $System_Windows_Forms_DataGridViewCellStyle_2.Font = New-Object System.Drawing.Font("Tahoma",9.75,0,3,1) 
    $System_Windows_Forms_DataGridViewCellStyle_2.ForeColor = [System.Drawing.Color]::FromArgb(255,0,0,0) 
    $System_Windows_Forms_DataGridViewCellStyle_2.SelectionBackColor = [System.Drawing.Color]::FromArgb(255,51,153,255) 
    $System_Windows_Forms_DataGridViewCellStyle_2.SelectionForeColor = [System.Drawing.Color]::FromArgb(255,255,255,255) 
    $System_Windows_Forms_DataGridViewCellStyle_2.WrapMode = 2 
    $dataGridView1.DefaultCellStyle = $System_Windows_Forms_DataGridViewCellStyle_2 
    $System_Drawing_Point = New-Object System.Drawing.Point 
    $System_Drawing_Point.X = 4 
    $System_Drawing_Point.Y = 4 
    $dataGridView1.Location = $System_Drawing_Point 
    $dataGridView1.Name = "dataGridView1" 
    $System_Windows_Forms_DataGridViewCellStyle_3 = New-Object System.Windows.Forms.DataGridViewCellStyle 
    $System_Windows_Forms_DataGridViewCellStyle_3.Alignment = 16 
    $System_Windows_Forms_DataGridViewCellStyle_3.BackColor = [System.Drawing.Color]::FromArgb(255,240,240,240) 
    $System_Windows_Forms_DataGridViewCellStyle_3.Font = New-Object System.Drawing.Font("Tahoma",9.75,0,3,1) 
    $System_Windows_Forms_DataGridViewCellStyle_3.ForeColor = [System.Drawing.Color]::FromArgb(255,0,0,0) 
    $System_Windows_Forms_DataGridViewCellStyle_3.SelectionBackColor = [System.Drawing.Color]::FromArgb(255,51,153,255) 
    $System_Windows_Forms_DataGridViewCellStyle_3.SelectionForeColor = [System.Drawing.Color]::FromArgb(255,255,255,255) 
    $System_Windows_Forms_DataGridViewCellStyle_3.WrapMode = 1 
    $dataGridView1.RowHeadersDefaultCellStyle = $System_Windows_Forms_DataGridViewCellStyle_3 
    $System_Drawing_Size = New-Object System.Drawing.Size 
    $System_Drawing_Size.Height = 169 
    $System_Drawing_Size.Width = 544 
    $dataGridView1.Size = $System_Drawing_Size 
    $dataGridView1.TabIndex = 0 
    $dataGridView1.add_CurrentCellChanged($handler_dataGridView1_CurrentCellChanged) 
    $panel1.Controls.Add($dataGridView1) 
 
 
    $textBox1.DataBindings.DefaultDataSourceUpdateMode = 0 
    $textBox1.Font = New-Object System.Drawing.Font("Tahoma",9.75,0,3,1) 
    $textBox1.ForeColor = [System.Drawing.Color]::FromArgb(255,65,105,225) 
    $System_Drawing_Point = New-Object System.Drawing.Point 
    $System_Drawing_Point.X = 140 
    $System_Drawing_Point.Y = 13 
    $textBox1.Location = $System_Drawing_Point 
    $textBox1.Name = "textBox1" 
    $System_Drawing_Size = New-Object System.Drawing.Size 
    $System_Drawing_Size.Height = 23 
    $System_Drawing_Size.Width = 140 
    $textBox1.Size = $System_Drawing_Size 
    $textBox1.TabIndex = 2
    $textBox1.Text = "$ComputerName" 
 
    $form1.Controls.Add($textBox1) 
 
    $label1.DataBindings.DefaultDataSourceUpdateMode = 0 
    $label1.Font = New-Object System.Drawing.Font("Tahoma",9.75,1,3,1) 
 
    $System_Drawing_Point = New-Object System.Drawing.Point 
    $System_Drawing_Point.X = 13 
    $System_Drawing_Point.Y = 15 
    $label1.Location = $System_Drawing_Point 
    $label1.Name = "label1" 
    $System_Drawing_Size = New-Object System.Drawing.Size 
    $System_Drawing_Size.Height = 23 
    $System_Drawing_Size.Width = 123 
    $label1.Size = $System_Drawing_Size 
    $label1.TabIndex = 1 
    $label1.Text = "Computer Name : " 
 
    $form1.Controls.Add($label1) 
 
 
    $button1.DataBindings.DefaultDataSourceUpdateMode = 0 
 
    $System_Drawing_Point = New-Object System.Drawing.Point 
    $System_Drawing_Point.X = 678 
    $System_Drawing_Point.Y = 8 
    $button1.Location = $System_Drawing_Point 
    $button1.Name = "button1" 
    $System_Drawing_Size = New-Object System.Drawing.Size 
    $System_Drawing_Size.Height = 60 
    $System_Drawing_Size.Width = 80 
    $button1.Size = $System_Drawing_Size 
    $button1.TabIndex = 0 
    $button1.Text = " Check Space" 
    $button1.UseVisualStyleBackColor = $True 
    $button1.add_Click($handler_button1_Click) 
 
    $form1.Controls.Add($button1) 
 
    #endregion Generated Form Code 
 
    #Save the initial state of the form 
    $InitialFormWindowState = $form1.WindowState 
    #Init the OnLoad event to correct the initial state of the form 
    $form1.add_Load($OnLoadForm_StateCorrection) 
    #Show the Form 
    $form1.ShowDialog()| Out-Null 
 
} #End Function 
 

Function Get-InstalledSoftware {
    <#
    .Synopsis
    Generates a list of installed programs on a computer

    .DESCRIPTION
    This function generates a list by querying the registry and returning the installed programs of a local or remote computer.

    .NOTES   
    Name: Get-InstalledSoftware
    Author: Jaap Brasser
    Version: 1.2.1
    DateCreated: 2013-08-23
    DateUpdated: 2015-02-28
    Blog: http://www.jaapbrasser.com

    .LINK
    http://www.jaapbrasser.com

    .PARAMETER ComputerName
    The computer to which connectivity will be checked

    .PARAMETER Property
    Additional values to be loaded from the registry. Can contain a string or an array of string that will be attempted to retrieve from the registry for each program entry

    .EXAMPLE
    Get-InstalledSoftware

    Description:
    Will generate a list of installed programs on local machine

    .EXAMPLE
    Get-InstalledSoftware -ComputerName server01,server02

    Description:
    Will generate a list of installed programs on server01 and server02

    .EXAMPLE
    Get-InstalledSoftware -ComputerName Server01 -Property DisplayVersion,VersionMajor

    Description:
    Will gather the list of programs from Server01 and attempts to retrieve the displayversion and versionmajor subkeys from the registry for each installed program

    .EXAMPLE
    'server01','server02' | Get-InstalledSoftware -Property Uninstallstring

    Description
    Will retrieve the installed programs on server01/02 that are passed on to the function through the pipeline and also retrieves the uninstall string for each program
    #>
    [CmdletBinding(SupportsShouldProcess=$true)]
    param(
        [Parameter(ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true,
            Position=0)]
        [string[]]
            $ComputerName = $env:COMPUTERNAME,
        [Parameter(Position=0)]
        [string[]]$Property 
    )

    begin {
        Write-OutputBox -OutputBoxMessage "Collecting Installed software for: $ComputerName" -Type "START: " -Object Tab1
        $RegistryLocation = 'SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\',
                           'SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\'
        $HashProperty = @{}
        $SelectProperty = @('ComputerName','ProgramName','Version','Date')
        if ($Property) {
            $SelectProperty += $Property
        }
        $products = @()
        
    }
    process {
        If (Test-Connection -quiet -count 1 $ComputerName){
            foreach ($Computer in $ComputerName) {
                $RegBase = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey([Microsoft.Win32.RegistryHive]::LocalMachine,$Computer)
                foreach ($CurrentReg in $RegistryLocation) {
                    if ($RegBase) {
                        $CurrentRegKey = $RegBase.OpenSubKey($CurrentReg)
                        if ($CurrentRegKey) {
                            $CurrentRegKey.GetSubKeyNames() | ForEach-Object {
                                if ($Property) {
                                    foreach ($CurrentProperty in $Property) {
                                        $HashProperty.$CurrentProperty = ($RegBase.OpenSubKey("$CurrentReg$_")).GetValue($CurrentProperty)
                                    }
                                }
                                $HashProperty.ComputerName = $Computer
                                $HashProperty.ProgramName = ($DisplayName = ($RegBase.OpenSubKey("$CurrentReg$_")).GetValue('DisplayName'))
                                $HashProperty.Version = ($Version = ($RegBase.OpenSubKey("$CurrentReg$_")).GetValue('DisplayVersion'))
                                $HashProperty.Date = ($installedOn = ($RegBase.OpenSubKey("$CurrentReg$_")).GetValue('InstallDate'))
                                If ($installedOn) {
                                    try {
                                        $HashProperty.Date = [DateTime] $installedOn 
                                    } catch {
                                        try {
                                            $HashProperty.Date = [DateTime] ('{0}-{1}-{2}' -f ($installedOn.Substring(0, 4)), ($installedOn.Substring(4, 2)), ($installedOn.Substring(6, 2)) )
                                        } catch {
                                            $HashProperty.Date = $null
                                        }
                                    }
                                }
                                if ($DisplayName) {
                                    $product = New-Object -TypeName PSCustomObject -Property $HashProperty |
                                    Select-Object -Property $SelectProperty
                                }
                                $products += $product 
                            }
                        }
                    }
                }
            }
            $products | Sort ComputerName | Out-GridView -Title "Installed Software"
        }
        Else{
            Write-OutputBox -OutputBoxMessage "Error collecting Installed software for: $ComputerName, system is not available" -Type "START: " -Object Tab1
            Return $false
        }
    }
}