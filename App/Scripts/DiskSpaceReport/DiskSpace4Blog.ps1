#set-executionpolicy unrestricted

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Send email to all DBA
# $Emailbody= (Get-Content "D:\PowerShell\test.html" ) | out-string
# $EmailSubject = "this is a test"
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

function Send-EmailToDBA {
 param(
        [Parameter(Mandatory=$true)][string]$emailBody,
        [Parameter(Mandatory=$true)][string]$emailSubject
    )

    $EmailFrom = "noreply@myCompanyorg" 
    # $EmailTo = "abcxyz@myCompanyorg, abc@myCompanyorg, xyz@myCompanyorg" 

    $SMTPServer = "smtpServer.org" 

    $mailer = new-object Net.Mail.SMTPclient($smtpserver)
    $msg = new-object Net.Mail.MailMessage($EmailFrom,$EmailTo,$EmailSubject,$Emailbody)
    $msg.IsBodyHTML = $true
    $mailer.send($msg)
} # end of function


#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Get-DiskInfo
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

function Get-DiskInfo {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$True,ValueFromPipeline=$True)]
        [string[]]$FileFullPath = 'i:\ServerList\servers.txt',
        
        [Parameter(Mandatory=$True,ValueFromPipeline=$True)]
        [decimal]$DiskThreshold = 10
    )
     
    BEGIN {}
    PROCESS {
        $SHBServers = (import-csv $FileFullPath -Header Server, Description)
        foreach ($computer in $SHBServers) {            

            $Server = $($Computer.Server).split("\")[0]
            # $disks =Get-WMIObject -ComputerName $computer.server Win32_LogicalDisk | Where-Object {$_.DriveType -eq 3}
            $disks =Get-WMIObject -ComputerName $Server Win32_LogicalDisk | Where-Object {$_.DriveType -eq 3}
            
            foreach ($disk in $disks ) {

               if ($disks.count -ge 1) {            
                   $Used= $disk.freespace / $disk.size * 100
                   $result =  @{'Server'=$computer.server;
                              'Server Description'=$computer.description;
                              'Volume'=$disk.VolumeName;
                              'Drive'=$disk.name;
                              'Size (gb)'="{0:n2}" -f ($disk.size / 1gb);
                              'Used (gb)'="{0:n2}" -f (($disk.size - $disk.freespace) / 1gb);
                              'Free (gb)'="{0:n2}" -f ($disk.freespace / 1gb);
                              '% free'="{0:n2}" -f ($disk.freespace / $disk.size * 100)}                                                  
        	   $obj = New-Object -TypeName PSObject -Property $result 
                   if ($Used -lt $Diskthreshold){   
                        Write-Output $obj }
               }
            }
        }
    }
    END {}
} # end of function

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Script to generate disk usage report
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
$Today = [string]::Format( "{0:dd-MM-yyyy}", [datetime]::Now.Date )
$ReportFileName = "i:\Sarjen\Report\DiskUsage_$Today.html"

# Custom HTML Report Formatting
$head = @"
        <style>
            BODY{font-family: Arial; font-size: 8pt;}
            H1{font-size: 16px;}
            H2{font-size: 14px;}
            H3{font-size: 12px;}
            TABLE {border-width: 1px;border-style: solid;border-color: black;border-collapse: collapse; background-color:#D5EDFA} 
            TH {border-width: 1px;padding: 3px;border-style: solid;border-color: black;background-color: #94D4F7;} 
            TD {border-width: 1px;padding: 3px;border-style: solid;border-color: black;}         
        </style>
"@

    #define an array for html fragments 
    $fragments=@() 

    # Set free disk space threshold below in percent (default at 10%)
    [decimal]$thresholdspace = 20

    #this is the graph character 
    [string]$g=[char]9608  

    # call the main function
    $Disks = Get-DiskInfo `
                -ErrorAction SilentlyContinue `
                -FileFullPath ("i:\Sarjen\SQLServers.txt") `
                -DiskThreshold $thresholdspace 
            
    #create an html fragment 
    $html= $Disks|select @{name="Server";expression={$_.Server}}, 
                  @{name="Server Description";expression={$_."Server Description"}}, 
                  @{name="Drive";expression={$_.Drive}}, 
                  @{name="Volume";expression={$_.Volume}}, 
                  @{name="Size (gb)" ;expression={($_."size (gb)")}},
                  @{name="Used (gb)";expression={$_."used (gb)"}}, 
                  @{name="Free (gb)";expression ={$_."free (gb)"}}, 
                  @{name="% free";expression ={$_."% free"}},            
                  @{name="Disk usage";expression={ 
                        $UsedPer= (($_."Size (gb)" - $_."Free (gb)")/$_."Size (gb)")*100 
                        $UsedGraph=$g * ($UsedPer/4) 
                        $FreeGraph=$g* ((100-$UsedPer)/4) 
                        #using place holders for the < and > characters 
                         "xopenFont color=Redxclose{0}xopen/FontxclosexopenFont Color=Greenxclose{1}xopen/fontxclose" -f $usedGraph,$FreeGraph }}`
        | sort-Object {[decimal]$_."% free"} `
        | ConvertTo-HTML -fragment 
     
    #replace the tag place holders. It is a hack but it works. 
    $html=$html -replace "xopen","<" 
    $html=$html -replace "xclose",">" 
     
    #add to fragments 
    $Fragments+=$html          

    #write the result to a file 
    ConvertTo-Html -head $head -body $fragments `
     | Out-File $ReportFileName
     
	# Open the html file
	# ii $ReportFileName

    $Emailbody= (Get-Content $ReportFileName ) | out-string
    $EmailSubject = "Disk usage report - Drives less than $thresholdspace% free space" 

    Send-EmailToDBA -EmailBody $Emailbody -EmailSubject $EmailSubject                           

     