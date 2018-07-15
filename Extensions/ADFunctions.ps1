Function Get-AllDomainControllers{
    If (($IsMachinePartOfDomain) -and ($WPFtxtRSAT.Text -eq 'Yes')){
        Try{
            Import-Module ActiveDirectory
        } 
        Catch {
            Write-OutputBox -OutputBoxMessage "Unable to import Active Directory Module" -Type "ERROR: " -Object Tab2
            Return
        }
    
        $domain = [System.Directoryservices.Activedirectory.Domain]::GetCurrentDomain()
        $domain | ForEach-Object {$_.DomainControllers} |
            ForEach-Object {
                $hostEntry= [System.Net.Dns]::GetHostByName($_.Name)
                New-Object -TypeName PSObject -Property @{
                Name = $_.Name
                IPAddress = $hostEntry.AddressList[0].IPAddressToString
                OS = $_.OSVersion
                Roles = $_.Roles
                Site = $_.SiteName
            }
        } | Select Name, OS, IPAddress, Site, Roles | Out-GridView -OutputMode Single  
            
        $SelectedDC = $domain | Out-GridView -Title "Domain Controllers [$domain]" -OutputMode Single
        $WPFtxtTab2Name1.Text = $SelectedDC.Name
            
    }
    Else{
        Write-OutputBox -OutputBoxMessage "RSAT tools are not installed" -Type "ERROR: " -Object Tab2
    }
}