<#
    CORETECH A/S SOFTWARE LICENSE TERMS

    These license terms are an agreement between Coretech A/S and you.  Please read them.  They apply to the software you are downloading from Coretech.dk, 
    which includes the media on which you received it, if any.  The terms also apply to any Coretech A/S updates for this software, unless other terms accompany those items.  
    If so, those terms apply.

    BY USING THE SOFTWARE, YOU ACCEPT THESE TERMS.  IF YOU DO NOT ACCEPT THEM, DO NOT USE THE SOFTWARE.
    If you comply with these license terms, you have the rights below.

1.	INSTALLATION AND USE RIGHTS.  You may install and use any number of copies of the software on your devices.
2.	SCOPE OF LICENSE.  The software is licensed, not sold. This agreement only gives you some rights to use the software.  Coretech reserves all other rights.  
    Unless applicable law gives you more rights despite this limitation, you may use the software only as expressly permitted in this agreement.  
    In doing so, you must comply with any technical limitations in the software that only allow you to use it in certain ways.    You may not
    •	work around any technical limitations in the binary versions of the software;
    •	reverse engineer, decompile or disassemble the binary versions of the software, except and only to the extent that applicable law expressly permits, despite this limitation;
    •	make more copies of the software than specified in this agreement or allowed by applicable law, despite this limitation;
    •	publish the software for others to copy;
    •	rent, lease or lend the software;
    •	transfer the software or this agreement to any third party; or

3.	DOCUMENTATION.  Any person that has valid access to your computer or internal network may copy and use the documentation for your internal, reference purposes.
4.	SUPPORT SERVICES. Because this software is "as is," we may not provide support services for it.
5.	ENTIRE AGREEMENT.  This agreement, and the terms for supplements and updates that you use, are the entire agreement for the software and support services.
6.	APPLICABLE LAW.
a.	United States.  If you acquired the software in the United States, Washington state law governs the interpretation of this agreement and applies to claims for breach of it,
    regardless of conflict of laws principles.  The laws of the state where you live govern all other claims, including claims under state consumer protection laws, unfair competition laws, 
    and in tort.
b.	Outside the United States.  If you acquired the software in any other country, the laws of that country apply.
7.	LEGAL EFFECT.  This agreement describes certain legal rights.  You may have other rights under the laws of your country.  You may also have rights with respect to the party from whom you 
    acquired the software.  This agreement does not change your rights under the laws of your country if the laws of your country do not permit it to do so.
8.	DISCLAIMER OF WARRANTY.   THE SOFTWARE IS LICENSED "AS-IS."  YOU BEAR THE RISK OF USING IT.  CORETECH A/S GIVES NO EXPRESS WARRANTIES, GUARANTEES OR CONDITIONS.  YOU MAY HAVE ADDITIONAL 
    CONSUMER RIGHTS UNDER YOUR LOCAL LAWS WHICH THIS AGREEMENT CANNOT CHANGE.  TO THE EXTENT PERMITTED UNDER YOUR LOCAL LAWS, CORETECH A/S EXCLUDES THE IMPLIED WARRANTIES OF MERCHANTABILITY, 
    FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT.
9.	LIMITATION ON AND EXCLUSION OF REMEDIES AND DAMAGES.  YOU CAN RECOVER FROM CORETECH AND ITS SUPPLIERS ONLY DIRECT DAMAGES UP TO U.S. $1.00.  YOU CANNOT RECOVER ANY OTHER DAMAGES, 
    INCLUDING CONSEQUENTIAL, LOST PROFITS, SPECIAL, INDIRECT OR INCIDENTAL DAMAGES.

    This limitation applies to
    •	anything related to the software, services, content (including code) on third party Internet sites, or third party programs; and
    •	claims for breach of contract, breach of warranty, guarantee or condition, strict liability, negligence, or other tort to the extent permitted by applicable law.

    It also applies even if Coretech A/S knew or should have known about the possibility of the damages.  The above limitation or exclusion may not apply to you because your country may 
    not allow the exclusion or limitation of incidental, consequential or other damages.

#>

Add-Type -AssemblyName PresentationFramework
Add-Type –assemblyName Microsoft.VisualBasic
Add-Type –assemblyName System.Windows.Forms

Function Show-Error
{
    Param($Message)
    $Title = "Error"    $icon = [Windows.Forms.MessageBoxIcon]::Error    [windows.forms.messagebox]::Show($Message,$Title,0,$icon)

}

Function Show-RunAsMessage {
    Param($Message)

    $title = "Warning"
    $button = [System.Windows.Forms.MessageBoxButtons]::YesNo
    $icon = [Windows.Forms.MessageBoxIcon]::Warning
    [windows.forms.messagebox]::Show($message,$title,$button,$icon)
}

If($PSVersionTable.PSVersion.Major -ge 3){
   If(-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltinRole]"Administrator")){
       If((Show-RunAsMessage -Message "You need to run this tool as an administrator.`n Do you want to start it as an administrator?") -eq "YES" -and $Host.Runspace.ApartmentState -eq "STA"){
                Start-Process -File PowerShell.exe -Argument "-STA -noprofile -file $($myinvocation.mycommand.definition)" -Verb Runas                break        }       Else{            $ShowMessage = $True       }   }

}
else{
    Show-Error -Message "Please Install Windows Management Framework 3.0"
    Break
}

$UserInterFace = [Hashtable]::Synchronized(@{})
$WorkerJobs = [System.Collections.ArrayList]::Synchronized((New-Object System.Collections.ArrayList))
$UserInterFace.WorkerRunning = $False
$Global:Path = Split-Path $MyInvocation.MyCommand.Path

[XML]$XAML = @'
<Window
         xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="PoshCAT aka SCCM Client Actions Tool v0.2 PowerShell Edition by Coretech" Height="703.402" Width="818.322">
    <Window.Resources>
        <Style TargetType="{x:Type ListBoxItem}">
            <Style.Triggers>
                <Trigger Property="ItemsControl.AlternationIndex" Value="0">
                    <Setter Property="Background" Value="#19f39611"></Setter>
                </Trigger>
                <Trigger Property="ItemsControl.AlternationIndex" Value="1">
                    <Setter Property="Background" Value="#19000000"></Setter>
                </Trigger>
            </Style.Triggers>
        </Style>
        <Style x:Key="ContainerStyle" TargetType="{x:Type GroupItem}">
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate>
                        <Expander Header="{Binding Name}" IsExpanded="False">
                            <ItemsPresenter />
                        </Expander>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>
        <Style TargetType="TextBlock">
            <Style.Triggers>
                <Trigger Property="IsMouseOver" Value="True">
                    <Setter Property="Cursor" Value="Hand" />
                </Trigger>
            </Style.Triggers>
        </Style>
    </Window.Resources>
    <Grid>
        <Grid.ColumnDefinitions>
            <ColumnDefinition Width="20*" MaxWidth="20" MinWidth="20"/>
            <ColumnDefinition Width="147*"/>
            <ColumnDefinition Width="109*"/>
            <ColumnDefinition Width="84*"/>
            <ColumnDefinition Width="347*"/>
            <ColumnDefinition Width="83*"/>
            <ColumnDefinition Width="20*" MaxWidth="20" MinWidth="20"/>
        </Grid.ColumnDefinitions>
        <Grid.RowDefinitions>
            <RowDefinition Height="20*"/>
            <RowDefinition Height="25*" MaxHeight="25" MinHeight="25"/>
            <RowDefinition Height="23*" MaxHeight="23" MinHeight="23"/>
            <RowDefinition Height="30*" MaxHeight="30" MinHeight="30"/>
            <RowDefinition Height="23*" MaxHeight="23" MinHeight="23"/>
            <RowDefinition Height="30*" MaxHeight="30" MinHeight="30"/>
            <RowDefinition Height="24*" MaxHeight="24" MinHeight="24"/>
            <RowDefinition Height="273*"/>
            <RowDefinition Height="30*" MaxHeight="30" MinHeight="30"/>
            <RowDefinition Height="164*"/>
            <RowDefinition Height="30*" MaxHeight="30" MinHeight="30"/>
        </Grid.RowDefinitions>
        <Label Content="Client Actions:" FontWeight="Bold" FontSize="16" Grid.Column="3" Grid.Row="0" VerticalAlignment="Bottom" Grid.ColumnSpan="3" Grid.RowSpan="2"/>
        <TextBox Grid.Row="3" Grid.Column="1" Margin="2" IsReadOnly="True" Name="TXT_Computers_Source"/>
        <Button Content="Browse" Grid.Row="3" Grid.Column="2" Margin="2" Name="Btn_Browse_Source_File"/>
        <TextBox Grid.Row="5" Grid.Column="1" Margin="2" Name="TXT_ConfigMgr_Server"/>
        <Button Content="Load...." Grid.Row="5" Grid.Column="2" Margin="2" Name="Btn_Open_Collection_Browser"/>
        <ListBox x:Name="LW_ActionsLists" AlternationCount="2" Grid.Row="2" Grid.Column="3"  Margin="2" Grid.ColumnSpan="3" Grid.RowSpan="6" BorderBrush="Black">
            <ListBox.GroupStyle>
                <GroupStyle ContainerStyle="{StaticResource ContainerStyle}"/>
            </ListBox.GroupStyle>
            <ListBox.ItemTemplate>
                <DataTemplate>
                    <RadioButton Content="{Binding Name}" GroupName="Actions" IsChecked="{Binding Path=IsSelected, RelativeSource={RelativeSource AncestorType={x:Type ListBoxItem}},Mode=TwoWay}"/>
                </DataTemplate>
            </ListBox.ItemTemplate>
            <ListBox.ContextMenu>
                <ContextMenu>
                    <MenuItem Header="Reload Client Actions" Name="RightClick_ReLoad_Client_Actions"></MenuItem>
                </ContextMenu>
            </ListBox.ContextMenu>
        </ListBox>
        <Button Content="Start" Name="Btn_START" Grid.Row="8" Grid.Column="5" Margin="2"/>
        <RichTextBox HorizontalAlignment="Left" Name="RXT_LoggingScreen" Grid.Row="9" Grid.ColumnSpan="5" Grid.Column="1" BorderBrush="Black"  ScrollViewer.VerticalScrollBarVisibility="Visible" >
            <FlowDocument>
            </FlowDocument>
        </RichTextBox>
        <Label Content="List of Computers:" FontWeight="Bold" FontSize="16" Grid.Column="1" Grid.Row="0" VerticalAlignment="Bottom" Grid.RowSpan="2" />
        <Button Content="Log" Grid.Row="8" Grid.Column="3" Margin="2" Name="Btn_Open_Log"/>
        <ListView Grid.Column="1" Grid.Row="7" Grid.ColumnSpan="2" Margin="2" BorderBrush="Black" Name="LW_Computers" Grid.RowSpan="1">
            <ListView.ContextMenu>
                <ContextMenu>
                    <MenuItem Header="Add Computers" Name="RightClick_Add_Computers"></MenuItem>
                    <MenuItem Header="Add Computers from Active Directory" Name="RightClick_Add_Computers_From_AD"></MenuItem>
                    <MenuItem Header="Remove selected Computer(s)" Name="RightClick_Remove_Computer"></MenuItem>
                </ContextMenu>
            </ListView.ContextMenu>
        </ListView>
        <Label Grid.Column="1" Grid.Row="2" Content="Select a source file (TXT,CSV).." FontSize="10" VerticalAlignment="Bottom" HorizontalAlignment="Left"/>
        <Label Grid.Column="1" Grid.Row="4" Grid.ColumnSpan="2" Content="..or load computers from Collection..." FontSize="10" VerticalAlignment="Bottom" HorizontalAlignment="Left"></Label>
        <CheckBox Grid.Column="1" Grid.Row="8" Grid.ColumnSpan="2" VerticalAlignment="Bottom" Content="Open Status Report automatically" Name="Chk_Open_Report"></CheckBox>
        <Label Grid.Column="1" Grid.Row="10" Grid.ColumnSpan="2" VerticalAlignment="Center"  HorizontalAlignment="Left" Content="Powered By Coretech - www.Coretech.dk" FontSize="12" Name="Lbl_Coretech"></Label>
        <TextBlock TextWrapping="Wrap" Grid.Column="4" Grid.ColumnSpan="2" HorizontalAlignment="Right" Name="Lbl_Alternate_Credentials" FontSize="10">
             <Underline>Click here to Enter Alternate Credentials</Underline>
        </TextBlock>
        <Label Content="Computers:" Grid.Column="1" Grid.Row="6" FontSize="10" VerticalAlignment="Top" HorizontalAlignment="Left"></Label>
    </Grid>
</Window>
'@

[XML]$XAML2 = @'
<Window
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="Select Collection" Height="459" Width="730" Background="#FFE6E6E6">
    <Grid>
        <Grid.RowDefinitions>
            <RowDefinition Height="15*"/>
            <RowDefinition Height="25*" MaxHeight="25"/>
            <RowDefinition Height="327*"/>
            <RowDefinition Height="30*" MaxHeight="30"/>
            <RowDefinition Height="26*" MaxHeight="26"/>
        </Grid.RowDefinitions>
        <Grid.ColumnDefinitions>
            <ColumnDefinition Width="25*" MaxWidth="25"/>
            <ColumnDefinition Width="257*"/>
            <ColumnDefinition Width="204*"/>
            <ColumnDefinition Width="105*"/>
            <ColumnDefinition Width="105*"/>
            <ColumnDefinition Width="25*" MaxWidth="25"/>
        </Grid.ColumnDefinitions>
        <ComboBox Grid.Column="1" Grid.Row="1" Margin="2" SelectedIndex="0">
            <ComboBoxItem Content="Device Collections"></ComboBoxItem>
        </ComboBox>
        <TextBox Grid.Column="2" Grid.Row="1" Margin="2" Text="" ToolTip="Filter" Grid.ColumnSpan="3" Name="TXT_Filter"></TextBox>
        <TreeView Grid.Column="1" Grid.Row="2" Margin="2" ScrollViewer.VerticalScrollBarVisibility="Visible" Name="Tree_Folders"></TreeView>
        <ListView Grid.Column="2" Grid.Row="2" Margin="2" Grid.ColumnSpan="3" Name="LW_Collections">
            <ListView.View>
                <GridView>
                    <GridViewColumn Header = "Name">
                       <GridViewColumn.CellTemplate>
                          <DataTemplate>
                              <Label Name = "ColName" Content = "{Binding ColName}"></Label>
                          </DataTemplate>
                       </GridViewColumn.CellTemplate>
                       </GridViewColumn>
                       <GridViewColumn Header = "Member Count">
                       <GridViewColumn.CellTemplate>
                          <DataTemplate>
                              <Label Name = "ColCount" Content = "{Binding ColCount}"></Label>
                         </DataTemplate>
                      </GridViewColumn.CellTemplate>
                    </GridViewColumn>
                </GridView>
            </ListView.View>
        </ListView>
        <Button Grid.Column="3" Grid.Row="3" Margin="2" Content="OK" Name="Btn_OK"></Button>
        <Button Grid.Column="4" Grid.Row="3" Margin="2" Content="Cancel" Name="Btn_Cancel"></Button>
    </Grid>
</Window>
'@

[XML]$XAML3 = @'
<Window
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="PoshCAT - Alternate Credentials" Height="163" Width="340" WindowStartupLocation="CenterScreen" ResizeMode="NoResize">
    <Grid>
        <Grid.RowDefinitions>
            <RowDefinition Height="40*"/>
            <RowDefinition Height="30*"/>
            <RowDefinition Height="30*"/>
            <RowDefinition Height="40*"/>
        </Grid.RowDefinitions>
        <Grid.ColumnDefinitions>
            <ColumnDefinition Width="71*"/>
            <ColumnDefinition Width="199*"/>
            <ColumnDefinition Width="64*"/>
        </Grid.ColumnDefinitions>
        <Rectangle Grid.Column="0" Grid.Row="1" Grid.ColumnSpan="3" Grid.RowSpan="2" Fill="AliceBlue"/>
        <Label Content="User:" Grid.Column="0" Grid.Row="1" VerticalAlignment="Center" Name="Lbl_User"></Label>
        <Label Content="Password:" Grid.Column="0" Grid.Row="2" VerticalAlignment="Center" Name="Lbl_User_Password" ></Label>
        <TextBox Grid.Column="1" Grid.Row="1" Margin="2" Name="TXT_UserName"></TextBox>
        <PasswordBox Grid.Column="1" Grid.Row="2" Margin="2" Name="TXT_UserPassword"/>
        <Button Grid.Column="2" Grid.Row="1" Margin="2" Content="Set" Name="Btn_Set_User_Credentials"></Button>
    </Grid>
</Window>
'@
$Reader = (New-Object System.Xml.XmlNodeReader $XAML)
$UserInterFace.Window = [Windows.Markup.XamlReader]::Load($Reader)

$Reader2 = (New-Object System.Xml.XmlNodeReader $XAML2)
$CollectionForm = [Windows.Markup.XamlReader]::Load($Reader2)

$Reader3 = (New-Object System.Xml.XmlNodeReader $XAML3)
$CredentialsForm = [Windows.Markup.XamlReader]::Load($Reader3)

# User Controls
$UserInterFace.TXT_Computers_Source = $UserInterFace.Window.FindName('TXT_Computers_Source')
$UserInterFace.Btn_Browse_Source_File = $UserInterFace.Window.FindName('Btn_Browse_Source_File')
$UserInterFace.Btn_Open_Collection_Browser  = $UserInterFace.Window.FindName('Btn_Open_Collection_Browser')
$UserInterFace.TXT_ConfigMgr_Server = $UserInterFace.Window.FindName('TXT_ConfigMgr_Server')
$UserInterFace.LW_Computers = $UserInterFace.Window.FindName('LW_Computers')
$UserInterFace.LW_ActionsLists = $UserInterFace.Window.FindName('LW_ActionsLists')
$UserInterFace.Btn_START = $UserInterFace.Window.FindName('Btn_START')
$UserInterFace.Btn_Open_Log = $UserInterFace.Window.FindName('Btn_Open_Log')
$UserInterFace.RXT_LoggingScreen = $UserInterFace.Window.FindName('RXT_LoggingScreen')
$UserInterFace.Chk_Open_Report = $UserInterFace.Window.FindName('Chk_Open_Report')
$UserInterFace.Lbl_Coretech = $UserInterFace.Window.FindName('Lbl_Coretech')
$UserInterFace.RightClick_ReLoad_Client_Actions = $UserInterFace.Window.FindName('RightClick_ReLoad_Client_Actions')
$UserInterFace.RightClick_Add_Computers = $UserInterFace.Window.FindName('RightClick_Add_Computers')
$UserInterFace.RightClick_Remove_Computer = $UserInterFace.Window.FindName('RightClick_Remove_Computer')
$UserInterFace.RightClick_Add_Computers_From_AD = $UserInterFace.Window.FindName('RightClick_Add_Computers_From_AD')
$UserInterFace.Lbl_Alternate_Credentials = $UserInterFace.Window.FindName('Lbl_Alternate_Credentials')

#Credentials Controls
$TXT_UserName = $CredentialsForm.FindName('TXT_UserName')
$TXT_UserPassword = $CredentialsForm.FindName('TXT_UserPassword')
$Btn_Set_User_Credentials = $CredentialsForm.FindName('Btn_Set_User_Credentials')

#Collection Browser controls
$TXT_Filter = $CollectionForm.FindName('TXT_Filter')
$Tree_Folders = $CollectionForm.FindName('Tree_Folders')
$LW_Collections = $CollectionForm.FindName('LW_Collections')
$Btn_OK = $CollectionForm.FindName('Btn_OK')
$Btn_Cancel = $CollectionForm.FindName('Btn_Cancel')

Function Create-Cred
{
    Param(
         $Username,
         $Password
         )
   
   Try{
        $Pass = ConvertTo-SecureString $Password -AsPlainText –Force -ErrorAction Stop
        Try{
            New-Object -typename System.Management.Automation.PSCredential -ArgumentList $Username,$Pass -ErrorAction Stop
        }
        Catch{
            Show-Error -Message $_.Exception.Message
        }
   }
   Catch{
        Show-Error -Message $_.Exception.Message
   }
   
}

Function Build-Splatting
{
    Param(
         $UserName = $null,
         $Password = $null
         )

    $SP = @{}
    if($Username.length -eq 0 -and $Password.length -eq 0){
    }
    If($UserName.length -ne 0 -and $Password.length -eq 0){
        Show-Error -Message "Please Enter Correct User and Password"
    }
    If($UserName.length -eq 0 -and $Password.length -ne 0){
        Show-Error -Message "Please Enter Correct User and Password"
    }
    If($UserName.length -ne 0 -and $Password.length -ne 0){
        $SP['Credential'] = Get-Credential -Credential (Create-Cred -Username $UserName -Password $Password)
    }

   return $SP
}

Function Get-CMProviderLocation
{
    [CMDLetBinding()]
    PARAM(
    [Parameter(Mandatory = $True, HelpMessage = "Please enter site server name")]
         $SiteServer
         )
 
    Try{
        Get-WmiObject -Namespace Root\SMS -Class SMS_ProviderLocation -ComputerName $SiteServer -ErrorAction STOP @WorkerCredentials
    }
    Catch{
        Get-ErrorInformation -Component "Get-CMProviderLocation"
    }
}

Function Add-TreeItem
{
    Param(
          $Name,
          $Parent,
          $Header
          )

    
    $StackPanel = New-Object System.Windows.Controls.StackPanel
    $StackPanel.Orientation = "Horizontal"

        $Image = New-Object System.Windows.Controls.Image
        $Image.Source = Read-Image -MainImage $FolderIcon
        $Image.Width = 20
        $Image.Height = 20

    $Label = New-Object System.Windows.Controls.Label
    $Label.Content = $Header

    [Void]$StackPanel.Children.Add($Image)
    [Void]$StackPanel.Children.Add($Label)

    #New TreeViewItem
    $ChildItem = New-Object System.Windows.Controls.TreeViewItem
    $ChildItem.Header = $StackPanel
    $ChildItem.Name = $Name
    [Void]$Parent.Items.Add($ChildItem)
}

Function Get-CMClientCollectionFolders
{
    Param(
         $Root,
         $SiteServer,
         $SiteCode
         )
    
    #Query Folders
    Try{
        $RootTrim = $Root.TrimStart("F")
        $Query = Get-WmiObject -Namespace "Root\SMS\Site_$($SiteCode)" -Class SMS_ObjectContainerNode -Filter "ParentContainerNodeID='$RootTrim' and ObjectType='5000'" -ComputerName $SiteServer @Global:WorkerCredentials -ErrorAction STOP
    
        foreach($Folder in $Query)
        {
           #Get the Parent Node
           $GetParent = [System.Windows.LogicalTreeHelper]::FindLogicalNode($Tree_Folders,"F$($Root)")

           #Add the TreeView Items
           Add-TreeItem -Name "F$($Folder.ContainerNodeID)" -Parent $GetParent -Header $Folder.Name
           Get-CMClientCollectionFolders -Root "$($Folder.ContainerNodeID)" -SiteServer $SiteServer -SiteCode $SiteCode

        }
    }
    Catch{
        Get-ErrorInformation -Component "Get-CMClientCollectionFolders"
    }


}
Function New-ListViewItem
{
    Param(
        $Content,
        $LWObject
    )

    $LWItem = New-Object System.Windows.Controls.ListViewItem
    $LWItem.Content = $Content
    $LWObject.Items.Add($LWItem)
}

#Import computers to Listview
Function Import-ComputersToListView
{
    Param(
        $InputFile
        )
    
    Try{
        $FileExtension = Get-Item $InputFile -ErrorAction STOP | Select-Object -ExpandProperty Extension

        switch($FileExtension)
        {
            ".xlsx"
            {
                    #TODO
            }
            ".csv"
            {
                Try{
                    $Computers = Import-Csv $InputFile -ErrorAction STOP
                    Write-Log -Message "Adding $($Computers.Count) computers" -severity 1 -component "Import-ComputersToListView"
                    $UserInterFace.LW_Computers.Items.Clear()
                    foreach($item in $Computers){
                        New-ListViewItem -Content $item.Name -LWObject $UserInterFace.LW_Computers
                    }
                }
                Catch{
                    Get-ErrorInformation -Component "Import-ComputersToListView"
                }

            }
            ".xls"
            {
                    #TODO
            }
            ".txt"
            {
                Try{
                    $Computers = Get-Content $InputFile -ErrorAction STOP
                    Write-Log -Message "Adding $($Computers.Count) computers" -severity 1 -component "Import-ComputersToListView"
                    $UserInterFace.LW_Computers.Items.Clear()
                    foreach($item in $Computers){
                        New-ListViewItem -Content $item -LWObject $UserInterFace.LW_Computers
                    }
                }
                Catch{
                    Get-ErrorInformation -Component "Import-ComputersToListView"
                }
            }
            Default {Write-Log -Message "Wrong file type. Please choose supported file type" -severity 1 -component "Import-ComputersToListView"}

        }
    }
    Catch{
        Get-ErrorInformation -Component "Import-ComputersToListView"
    }
}

#Browse file location
Function Get-ComputersInputFile
{
    $InputFile = New-Object Microsoft.Win32.OpenFileDialog
    $InputFile.RestoreDirectory = $True
    $InputFile.ShowDialog()

    if($InputFile.FileName.Length -ne 0){
        $UserInterFace.TXT_Computers_Source.Text = $InputFile.FileName
        Import-ComputersToListView -InputFile $UserInterFace.TXT_Computers_Source.Text
    }
}

Function Get-ADComputers
{
    Param($DN)

    $UserInterFace.LW_Computers.Items.Clear()
    Try{
        $OUName = $DN.Split(",")[0].TrimStart("OU=")
        $Root = $DN.Substring($DN.IndexOf("DC"))

            Write-Log -Message "OU: $OUName" -severity 1 -component "Get-ADComputers"
            Write-Log -Message "Domain: $Root" -severity 1 -component "Get-ADComputers"

        $Searcher = New-Object System.DirectoryServices.DirectorySearcher        $Searcher.Filter = "(&(Name=$OUName)(objectCategory=organizationalunit))"        $Searcher.SearchRoot = New-Object System.DirectoryServices.DirectoryEntry("LDAP://$Root")        Try{            $Result = $Searcher.FindOne()
                If($Result.Count -ne 0){
                    $OU = [ADSI]"LDAP://$DN"
                    foreach($Comp in $OU.psbase.children){
                        If($Comp.class -eq "Computer"){
                            New-ListViewItem -Content $Comp.dNSHostName.ToString() -LWObject $UserInterFace.LW_Computers
                        }
                    }
                }                Else{                    Write-Log -Message "No such OU in Active Directory like $OUName" -component "Get-ADComputers" -severity 3                }        }        Catch{            Get-ErrorInformation -Component "Get-ADComputers"        }    }    Catch{            Get-ErrorInformation -Component "Get-ADComputers"    }
}

Function Import-CMClientActions
{
    $ActionsArray = @()

    $ConfigurationFile = "$Global:Path\Commands.xml"
    Try{
        $XML = [XML](Get-Content $ConfigurationFile -Encoding UTF8 -ErrorAction STOP)
        $ToolActions = $XML.configuration.ToolActions.Add

        foreach($item in $ToolActions)
        {
            $tmpObject = Select-Object -InputObject "" Name, Component,IsChecked,ScriptBlockParameter,ScriptBlock,Report,JobType
            $tmpObject.Name = $item.TASK
            $tmpObject.Component = $item.Component
            $tmpObject.IsChecked = $false
            $tmpObject.ScriptBlockParameter = $item.Parameter
            $tmpObject.ScriptBlock = $item.ScriptBlock
            $tmpObject.Report = $item.Report
            $tmpObject.JobType = $item.JobType
            $ActionsArray += $tmpObject
     
        }

           $UserInterFace.LW_ActionsLists.ItemsSource = $ActionsArray
           $UserInterFace.View = [System.Windows.Data.CollectionViewSource]::GetDefaultView($ActionsArray)
           $UserInterFace.GroupDesc = New-object System.Windows.Data.PropertyGroupDescription
           $UserInterFace.GroupDesc.PropertyName = "Component"
           $UserInterFace.view.GroupDescriptions.Add($UserInterFace.GroupDesc)
           $UserInterFace.LW_ActionsLists.ItemsSource = $UserInterFace.view
    }
    Catch{
            Get-ErrorInformation -Component "Import-CMClientActions"
    }
}
# Import Computers
$UserInterFace.Btn_Browse_Source_File.Add_Click({

    Get-ComputersInputFile
})

#Add Closing for Collection form that we can open it again
$CollectionForm.Add_Closing({

      #Hide the Window
      $_.Cancel = $True
      $CollectionForm.Dispatcher.BeginInvoke("Normal",[Action]{$CollectionForm.Hide()})
})

#Show Collection Browser Window
$UserInterFace.Btn_Open_Collection_Browser.Add_Click({

    If($UserInterFace.TXT_ConfigMgr_Server.Text.Length -ne 0){  
    
    $CollectionForm.Dispatcher.BeginInvoke("Normal",[Action]{    [System.Windows.Input.Mouse]::OverrideCursor = [System.Windows.Input.Cursors]::Wait    $SiteCodeQuery = Get-CMProviderLocation -SiteServer $UserInterFace.TXT_ConfigMgr_Server.Text        $UserInterFace.LW_Computers.items.Clear()            $Tree_Folders.Items.Clear()        $LW_Collections.ItemsSource = $null        Try{            $RootFolders = Get-WmiObject -Namespace "Root\SMS\Site_$($SiteCodeQuery.SiteCode)" -Class SMS_ObjectContainerNode -Filter "ObjectType='5000' and ParentContainerNodeID='0'" -ComputerName $UserInterFace.TXT_ConfigMgr_Server.Text -ErrorAction STOP @Global:WorkerCredentials
                # Set the ROOT NODE
                $RootItem = New-Object System.Windows.Controls.TreeViewItem
                $RootItem.Header = "ROOT"
                $RootItem.Name = "F0"
                $Tree_Folders.items.add($RootItem)

            Get-CMClientCollectionFolders -Root "0" -SiteServer $UserInterFace.TXT_ConfigMgr_Server.Text -SiteCode $SiteCodeQuery.SiteCode            #Show window and reset the cursor            [System.Windows.Input.Mouse]::OverrideCursor = $Null            $CollectionForm.ShowDialog()                    }        Catch{            Get-ErrorInformation -Component "Get-CMFolderStructure"        }        [System.Windows.Input.Mouse]::OverrideCursor = $null    })
    
  }
  Else{
    Write-Log -Message "Please Type Correct Server Name" -severity 3 -component "Get-CMFolderStructure"
  } 
})

#Query Folder collections
$Tree_Folders.Add_MouseUP({

    if($this.SelectedItem.Name -ne $null){
    $QuerySplat = @{}
     if($this.selectedItem.Name -eq "F0"){
        $QuerySplat['Query'] = "select * from SMS_Collection where CollectionID not in(select InstanceKey from SMS_ObjectContainerItem where ObjectType='5000') and CollectionType='2'"
     }
     Else{
        $FolderID = $this.selectedItem.Name.ToString().TrimStart("F")
        $QuerySplat['Query'] = "select * from SMS_Collection where CollectionID is in(select InstanceKey from SMS_ObjectContainerItem where ObjectType='5000' and ContainerNodeID='$FolderID') and CollectionType='2'"
     }

        $LW_Collections.Dispatcher.Invoke("Normal",[Action]{ $LW_Collections.ItemsSource = $null})

        $LW_Collections.Dispatcher.Invoke("Normal",[Action]{ 
        [System.Windows.Input.Mouse]::OverrideCursor = [System.Windows.Input.Cursors]::Wait
            Try{
                $CollectionArray = @()
                $CollectionsINFolder = Get-WmiObject -Namespace "Root\SMS\Site_$($SiteCodeQuery.SiteCode)" @QuerySplat -ComputerName $UserInterFace.TXT_ConfigMgr_Server.Text -ErrorAction STOP @Global:WorkerCredentials | Sort-Object
                    foreach($item in $CollectionsINFolder)
                    {
                        $tmpObject2 = Select-Object -InputObject "" ColName,ColID,ColCount
                        $tmpObject2.ColName = $item.Name
                        $tmpObject2.ColID = $item.CollectionID
                        $tmpObject2.ColCount = (Get-WmiObject -Namespace "Root\SMS\Site_$($SiteCodeQuery.SiteCode)" -Query "SELECT * FROM SMS_CollectionMember_a WHERE CollectionID='$($item.CollectionID)'" -ComputerName $UserInterFace.TXT_ConfigMgr_Server.Text @Global:WorkerCredentials).Count
                        $CollectionArray += $tmpObject2
                    }
                    $LW_Collections.ItemsSource = $CollectionArray
            }     
            Catch{
                    Get-ErrorInformation -Component "Get-CMFolderCollections"
             }
        [System.Windows.Input.Mouse]::OverrideCursor = $Null
        })
    }
})

#Hide Collection Browser Window
$Btn_OK.Add_Click({

    $CollectionForm.Dispatcher.BeginInvoke("Normal",[Action]{
      $CollectionForm.Hide()

      Write-Log -Message "Selected CollectionID: $($LW_Collections.SelectedItem.ColID)" -severity 1 -component "Computers-FromCollection"
      Try{
          $ComputersQuery = Get-WmiObject -Namespace "Root\SMS\Site_$($SiteCodeQuery.SiteCode)" -Query "SELECT * FROM SMS_CollectionMember_a WHERE CollectionID='$($LW_Collections.SelectedItem.ColID)'" -ComputerName $UserInterFace.TXT_ConfigMgr_Server.Text -ErrorAction STOP @Global:WorkerCredentials | Sort-Object
          foreach($item in $ComputersQuery){
            if(!$item.Name.ToString().Contains("\") -and !$item.Name.ToString().Contains("(") -and !$item.Name.ToString().Contains(" ")){
                New-ListViewItem -Content $item.Name -LWObject $UserInterFace.LW_Computers
            }
          }
      }
      Catch{
            Get-ErrorInformation -Component "Get-CMCollectionComputers"
      }
    })
      
    
})
#Hide Collection Browser Window
$Btn_Cancel.Add_Click({
    $CollectionForm.Dispatcher.BeginInvoke("Normal",[Action]{

          $CollectionForm.Hide()
    })

})
#Open log file
$UserInterFace.Btn_Open_Log.Add_Click({

    Start-Process "$Global:Path\PoshCAT.log"
})

#if LW selection changes print out the command
$UserInterFace.LW_ActionsLists.Add_SelectionChanged({
    $UserInterFace.RXT_LoggingScreen.Document.Blocks.Clear()
    Write-Log -Message "Selected command: $($This.SelectedItem.Name)" -component "Client Action" -severity 1
})
$UserInterFace.Window.Add_Closed({

    foreach($Witem in $WorkerJobs){
      if($Witem.Worker.InvocationStateInfo.State -ne "Stopped"){
            $Witem.Worker.EndInvoke($Witem.JobStatus)
      }
            $Witem.Worker.Dispose()
            $Witem.RunSpace.Dispose()
            $Witem.RunSpace.Close()
            $Witem.Worker = $null
            $Witem.RunSpace =  $null
    }
   [System.GC]::Collect()
   [System.GC]::WaitForPendingFinalizers()

})
$UserInterFace.Lbl_Coretech.Add_MouseUP({

    Start-Process "WWW.Coretech.dk"
})
$UserInterFace.LW_ActionsLists.Add_SelectionChanged({
    
    if($UserInterFace.LW_ActionsLists.SelectedItem.Report -eq $False){
        $UserInterFace.Chk_Open_Report.IsEnabled = $False
        $UserInterFace.Chk_Open_Report.IsChecked = $False
        Write-Log -Message "Reporting disabled in configuration file" -severity 1 -component "Reporting-Status"
    }
    Else{
        $UserInterFace.Chk_Open_Report.IsEnabled = $True
    }
})

$UserInterFace.RightClick_ReLoad_Client_Actions.Add_Click({
    $UserInterFace.LW_ActionsLists.ItemsSource = ""
    Import-CMClientActions
})
$UserInterFace.RightClick_Add_Computers.Add_Click({
    $Input = [Microsoft.VisualBasic.Interaction]::InputBox("Please Enter Computer names. `n`n`n`nPlease use comma to separate Computers","Add Computer")
    $QuickComputers = $Input.Split(",") | ForEach-Object {$_}
    If($Input.Length -ne 0){
        foreach($item in $QuickComputers){
            New-ListViewItem -Content $item -LWObject $UserInterFace.LW_Computers
        }
    }
    $Input
})
#Remove selected computers
$UserInterFace.RightClick_Remove_Computer.Add_Click({
    $SelectedComputers = @()
    foreach($item in $UserInterFace.LW_Computers.Items){
        if($item.isSelected -eq $True){
        $SelectedComputers += $item
        }
    }
    foreach($item in $SelectedComputers){
        $UserInterFace.LW_Computers.Items.Remove($item)
    }
})

$UserInterFace.RightClick_Add_Computers_From_AD.Add_Click({
    $Input = [Microsoft.VisualBasic.Interaction]::InputBox("Please Enter OU DistinguishedName, `n`nDN example: OU=ViaMonstra Computers,DC=corp,DC=viamonstra,DC=com","Add Computer")
    If($Input.Length -ne 0){
        Get-ADComputers -DN $Input
    }
})
# Cancel the Window Closing, because we need to open it again
$CredentialsForm.Add_Closing({
    #Hide the Window
    $_.Cancel = $True
    $CredentialsForm.Hide()
})

$UserInterFace.Lbl_Alternate_Credentials.Add_MouseUp({
    $CredentialsForm.ShowDialog()
})

$Btn_Set_User_Credentials.Add_Click({
    $CredentialsForm.Hide()
    $Global:WorkerCredentials = Build-Splatting -UserName $TXT_UserName.Text -Password $TXT_UserPassword.Password
    If($WorkerCredentials.ToString() -ne "System.Object[]"){
        if($TXT_UserName.Text.length -eq 0 -and $TXT_UserPassword.Password.length -eq 0){
            $UserInterFace.Lbl_Alternate_Credentials.TextDecorations = "Underline"
            $UserInterFace.Lbl_Alternate_Credentials.Text = "Click here to Enter Alternate Credentials"
            $UserInterFace.Lbl_Alternate_Credentials.Foreground = "Black"
        }
        Else{
            $UserInterFace.Lbl_Alternate_Credentials.TextDecorations = "Underline"
            $UserInterFace.Lbl_Alternate_Credentials.Text = "Using $($TXT_UserName.Text) account"
            $UserInterFace.Lbl_Alternate_Credentials.Foreground = "RED"
        }
    }
})

$UserInterFace.Btn_START.Add_Click({
    $ComputerArray = @()
    $UserInterFace.LW_Computers.Items | ForEach-Object {$ComputerArray +=$_.Content}
    Switch($UserInterFace.LW_ActionsLists.SelectedItem.ScriptBlockParameter)
    {
        "UserPrompt"
        {
            Switch($UserInterFace.LW_ActionsLists.SelectedItem.ScriptBlock)
            {
                "Get-WindowsUpdateStatus"
                {
                    $Input = [Microsoft.VisualBasic.Interaction]::InputBox("Enter KB article number `n(eg. KBXXXXXX or XXXXXX). `n`n`n`nPlease use comma to separate KB articles","KB Article")
                    IF($Input.Length -ne 0){
                        $TaskScriptBlockParameters = $Input
                        Write-Log -Message "Checking following KB Articles: $TaskScriptBlockParameters" -severity 1 -component "Start-CMToolAction"
                    }
                    Else{
                         $UserInterFace.WorkerRunning = "Error"
                    }
                }
            }
        }
        Default
        {
            $TaskScriptBlockParameters = $UserInterFace.LW_ActionsLists.SelectedItem.ScriptBlockParameter
        }
    }
     If($ComputerArray.Count -ne 0 -and $UserInterFace.LW_ActionsLists.SelectedItem.Name.Length -ne 0){
        Switch($UserInterFace.WorkerRunning) {
        $False 
            {
            $WorkerCredentials = Build-Splatting -UserName $TXT_UserName.Text -Password $TXT_UserPassword.Password
            If($WorkerCredentials.ToString() -ne "System.Object[]"){
                $UserInterFace.Btn_START.Content = "Please Wait"
                $UserInterFace.Btn_START.isenabled = $false
                $UserInterFace.WorkerRunning = $True
                    $TaskName = $UserInterFace.LW_ActionsLists.SelectedItem.Name
                    $TaskScriptBlock = $UserInterFace.LW_ActionsLists.SelectedItem.ScriptBlock
                    $Path = $Global:Path
                    $OpenReport = $UserInterFace.Chk_Open_Report.IsChecked
                    $Reporting = $UserInterFace.LW_ActionsLists.SelectedItem.Report
                    $JobType = $UserInterFace.LW_ActionsLists.SelectedItem.JobType
                    $ScriptBlock = {
                        Param(
                             $UserInterFace,
                             $ComputerArray,
                             $TaskName,
                             $TaskScriptBlock,
                             $Path,
                             $TaskScriptBlockParameters,
                             $OpenReport,
                             $Reporting,
                             $JobType,
                             $WorkerCredentials
                        )
        
                    #Include the Worker Functions
                    . "$Path\SharedFunctions.ps1"
                    . "$Path\WorkerFunctions.ps1"
                    Start-CMToolAction -ScriptBlockName $TaskScriptBlock -TaskName $TaskName -Computers $ComputerArray -Reporting $Reporting -TaskScriptBlockParameters $TaskScriptBlockParameters -OpenReport $OpenReport -JobType $JobType -WorkerCredentials $WorkerCredentials
                    }
                    $Session = [system.management.automation.runspaces.initialsessionstate]::CreateDefault()
                    $Script:RunSpacePool = [runspacefactory]::CreateRunspace($Session)
                    $Script:RunSpacePool.ApartmentState = "STA"
                    $Script:RunSpacePool.Open()
                    $Script:Worker = [System.Management.Automation.PowerShell]::Create()
                    $Script:Worker.AddScript($ScriptBlock).AddArgument($UserInterFace).AddArgument($ComputerArray).AddArgument($TaskName).AddArgument($TaskScriptBlock).AddArgument($Path).AddArgument($TaskScriptBlockParameters).AddArgument($OpenReport).AddArgument($Reporting).AddArgument($JobType).AddArgument($WorkerCredentials)
                    $Script:Worker.Runspace = $Script:RunSpacePool
                    $Script:JobStatus = $Script:Worker.BeginInvoke()
                        $tmpWorker = Select-Object -InputObject "" JobStatus,RunSpace,Worker
                        $tmpWorker.JobStatus = $Script:JobStatus
                        $tmpWorker.RunSpace = $Script:RunSpacePool
                        $tmpWorker.Worker = $Script:Worker
                    $WorkerJobs.Add($tmpWorker)
            }

        }
        $True
            {
                $UserInterFace.Btn_START.Content = "Start"
                $UserInterFace.WorkerRunning = $False
                
            }
        "Error"
            {
                Write-Log -Message "Please Enter Correct input" -severity 3 -component "Start-CMToolAction"
                $UserInterFace.WorkerRunning = $False
            }
             
        }
       }
       Else{
            Write-Log -Message "Please import computers first and then select correct command" -severity 3 -component "Start-CMToolAction"
       }
       
})
# Start Up Actions
. "$Global:Path\SharedFunctions.ps1"
Import-CMClientActions
$Global:WorkerCredentials = Build-Splatting -UserName $TXT_UserName.Text -Password $TXT_UserPassword.Password
Create-ReportFolder
# Load defaults
Try{
    $ConfigurationFile = "$Global:Path\Commands.xml"
    $XML = [XML](Get-Content $ConfigurationFile -Encoding UTF8 -ErrorAction STOP)
    $UserInterFace.TXT_ConfigMgr_Server.Text = $XML.configuration.CMServer.Name
}
Catch{
    Get-ErrorInformation -Component "Start-UP"
}

$LWBackGroundImage = New-Object System.Windows.Media.ImageBrush
$LWBackGroundImage.ImageSource = Read-Image -MainImage $MainLogo
$LWBackGroundImage.Opacity = ".09"
$LWBackGroundImage.Stretch = "Uniform"
$UserInterFace.RXT_LoggingScreen.Background = $LWBackGroundImage
$UserInterFace.Window.Icon = Read-Image -MainImage $WindowIcon
$CollectionForm.Icon = Read-Image -MainImage $WindowIcon

#Start Main Window
$UserInterFace.Window.ShowDialog()