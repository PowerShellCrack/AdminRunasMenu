#========================================================================
#
#    Created:   2016-04-22
#     Author:   Richard tracy
#
#========================================================================
#==================
# Clear variables
#==================
Remove-Variable *script* -ErrorAction SilentlyContinue
Remove-Variable *WPF* -ErrorAction SilentlyContinue
Remove-Variable *POP* -ErrorAction SilentlyContinue
Remove-Variable *Config* -ErrorAction SilentlyContinue
Remove-Variable *Cred* -ErrorAction SilentlyContinue
Remove-Variable *RunAs* -ErrorAction SilentlyContinue

#==================
# LOAD ASSEMBLIES
#==================
[void][Reflection.Assembly]::LoadWithPartialName("System.Security")
Add-Type -AssemblyName PresentationFramework, System.Drawing, System.Windows.Forms, WindowsFormsIntegration

## Variables: Script Name and Script Paths
[string]$scriptPath = $MyInvocation.MyCommand.Definition
[string]$scriptName = [IO.Path]::GetFileNameWithoutExtension($scriptPath)
[string]$scriptFileName = Split-Path -Path $scriptPath -Leaf
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

#===========================================================================
# XAML CODE (Built by Visual Studio 2015)
#===========================================================================
[string]$appXAML = @'
<Window x:Class="AdminMenu.MainWindow"
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
        xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
        xmlns:local="clr-namespace:AdminMenu"
        mc:Ignorable="d"
        ResizeMode="NoResize"
        WindowStartupLocation = "CenterScreen"
        Height="530" Width="800">
    <Window.Resources>
        <ResourceDictionary>


            <!-- TabControl Style-->
            <Style TargetType="TabControl">
                <Setter Property="OverridesDefaultStyle" Value="true"/>
                <Setter Property="SnapsToDevicePixels" Value="true"/>
                <Setter Property="Template">
                    <Setter.Value>
                        <ControlTemplate TargetType="TabControl">

                            <!-- Visual Tree
                        The KeyboardNavigation class is responsible for implementing default keyboard
                        focus navigation when one of the navigation keys is pressed. The navigation keys
                        are: Tab, Shift+Tab, Ctrl+Tab, Ctrl+Shift+Tab, UpArrow, DownArrow, LeftArrow,
                        and RightArrow keys. An example of logical navigation is using the tab key to move
                        focus. An example of directional navigation is using the arrow keys to move focus

                        Note that the visual tree of the tab control is based on a grid with two rows.
                        First row is a TabPanel while second row
                        -->
                            <Grid KeyboardNavigation.TabNavigation="Local" ShowGridLines="True" >
                                <Grid.RowDefinitions>
                                    <RowDefinition Height="Auto"/>
                                    <RowDefinition Height="*"/>
                                </Grid.RowDefinitions>

                                <!-- The TabPanel serves as an item host for the tab items in a TabControl. It
                            determines the correct sizing and positioning for tab items and handles the
                            logic for multiple rows of TabItem objects -->
                                <TabPanel   Name="HeaderPanel"
                                        Grid.Row="0" Grid.Column="0"
                                        Panel.ZIndex="1"
                                        IsItemsHost="True"
                                        KeyboardNavigation.TabIndex="1"/>
                                <Border Name="Border"
                                    Grid.Row="1" Grid.Column="0"
                                    BorderThickness="2"
                                    CornerRadius="15"
                                    KeyboardNavigation.TabNavigation="Local"
                                    KeyboardNavigation.DirectionalNavigation="Contained"
                                    KeyboardNavigation.TabIndex="2" >
                                    <ContentPresenter Name="PART_SelectedContentHost" Margin="4" ContentSource="SelectedContent" />
                                </Border>
                            </Grid>

                            <!-- Behaviour -->
                        </ControlTemplate>
                    </Setter.Value>
                </Setter>
            </Style>

            <!-- TabItem Style -->
            <Style TargetType="{x:Type TabItem}">
                <Setter Property="Template">
                    <Setter.Value>
                        <ControlTemplate TargetType="{x:Type TabItem}">
                            <Grid>
                                <Border
                                    Name="Border"
                                    Margin="5"
                                    Background="Gray"
                                    BorderThickness="2"
                                    CornerRadius="50">
                                    <ContentPresenter x:Name="ContentSite" VerticalAlignment="Center"
                                        HorizontalAlignment="Center" ContentSource="Header" Margin="2,2,2,2"
                                        RecognizesAccessKey="True" />
                                </Border>
                            </Grid>

                            <ControlTemplate.Triggers>
                                <Trigger Property="IsSelected" Value="True">
                                    <Setter Property="Panel.ZIndex" Value="100" />
                                    <Setter TargetName="Border" Property="Background" Value="white" />
                                    <Setter TargetName="Border" Property="BorderThickness" Value="2" />
                                    <Setter TargetName="Border" Property="BorderBrush" Value="gray" />
                                </Trigger>

                            </ControlTemplate.Triggers>
                        </ControlTemplate>
                    </Setter.Value>
                </Setter>
            </Style>

            <Style TargetType="{x:Type Button}">
                <!-- This style is used for buttons, to remove the WPF default 'animated' mouse over effect -->
                <Setter Property="OverridesDefaultStyle" Value="True"/>
                <Setter Property="Foreground" Value="#FFEAEAEA"/>
                <Setter Property="Template">
                    <Setter.Value>
                        <ControlTemplate TargetType="Button" >

                            <Border Name="border" 
                                    BorderThickness="1"
                                    Padding="4,2" 
                                    BorderBrush="#FFEAEAEA" 
                                    CornerRadius="2" 
                                    Background="{TemplateBinding Background}">
                                <ContentPresenter HorizontalAlignment="Center" 
                                                  VerticalAlignment="Center" 
                                                  TextBlock.FontSize="10px"
                                                  TextBlock.TextAlignment="Center"
                                                  />
                            </Border>
                            <ControlTemplate.Triggers>
                                <Trigger Property="IsMouseOver" Value="True">
                                    <Setter TargetName="border" Property="BorderBrush" Value="Black" />
                                </Trigger>
                            </ControlTemplate.Triggers>
                        </ControlTemplate>
                    </Setter.Value>
                </Setter>
            </Style>

            <Style TargetType="{x:Type Paragraph}">
                <Setter Property="Margin" Value="0"/>
            </Style>

        </ResourceDictionary>

    </Window.Resources>


    <Grid>
        <Label x:Name="lblCurrentUser" Content="Currently Running as:" Margin="504,9,196,469" FontSize="9" Foreground="#FF919191"/>
        <TextBox x:Name="txtCurrentUser" HorizontalAlignment="Left" Height="18" Margin="598,14,0,0" TextWrapping="NoWrap" VerticalAlignment="Top" Width="113" BorderThickness="0" FontSize="10" IsReadOnly="True" />
        <Label x:Name="lblCredUser" Content="Selected Credentials:" Margin="504,32,196,446" FontSize="9" Foreground="#FF919191"/>
        <TextBox x:Name="txtCredUser" HorizontalAlignment="Left" Height="18" Margin="594,37,0,0" TextWrapping="NoWrap" VerticalAlignment="Top" Width="113" BorderThickness="0" FontSize="10" IsReadOnly="True" />
        <Border BorderBrush="#FF919191" BorderThickness="1" HorizontalAlignment="Left" Height="24" Margin="504,31,0,0" VerticalAlignment="Top" Width="207"/>
        <GroupBox x:Name="grpBoxCredManage" Header="Credential Management" HorizontalAlignment="Left" Margin="628,100,-88,0" VerticalAlignment="Top" Height="76" Width="255" RenderTransformOrigin="0.5,0.5" Foreground="#FF919191">
            <GroupBox.RenderTransform>
                <TransformGroup>
                    <ScaleTransform ScaleY="1" ScaleX="1"/>
                    <SkewTransform AngleY="0" AngleX="0"/>
                    <RotateTransform Angle="90"/>
                    <TranslateTransform/>
                </TransformGroup>
            </GroupBox.RenderTransform>
            <Separator HorizontalAlignment="Left" Height="12" Margin="123,21,0,0" VerticalAlignment="Top" Width="38" RenderTransformOrigin="0.5,0.5">
                <Separator.RenderTransform>
                    <TransformGroup>
                        <ScaleTransform/>
                        <SkewTransform/>
                        <RotateTransform Angle="90"/>
                        <TranslateTransform/>
                    </TransformGroup>
                </Separator.RenderTransform>
            </Separator>
        </GroupBox>

        <Button x:Name="btnCred1" Content="Enter&#xA;Cred 1" HorizontalAlignment="Left" Margin="730,20,0,0" VerticalAlignment="Top" Width="40" Height="40" Background="#FFF4F7FC" Foreground="#FF0C0274"/>
        <Button x:Name="btnCred2" Content="Enter&#xD;&#xA;Cred 2" HorizontalAlignment="Left" Margin="730,65,0,0" VerticalAlignment="Top" Width="40" Height="40" Background="#FFF4F7FC" Foreground="#FF0C0274"/>
        <Button x:Name="btnCred3" Content="Enter&#xD;&#xA;Cred 3" HorizontalAlignment="Left" Margin="730,110,0,0" VerticalAlignment="Top" Width="40" Height="40" Background="#FFF4F7FC" Foreground="#FF0C0274"/>
        <Button x:Name="btnCredReset" Content="Reset&#xA;Creds" HorizontalAlignment="Left" Margin="730,169,0,0" VerticalAlignment="Top" Width="40" Height="40" Background="#FF5D639C" Foreground="White"/>
        <Button x:Name="btnCredClear" Content="Clear&#xA;Creds" HorizontalAlignment="Left" Margin="730,214,0,0" VerticalAlignment="Top" Width="40" Height="40" Background="#FFB83333" Foreground="#FFF9F9F9"/>

        <TabControl x:Name="tabControl" HorizontalAlignment="Left" Height="445" Margin="10,10,0,0" VerticalAlignment="Top" Width="701">
            <TabItem x:Name="tab1" Header="tab1" Width="60" Height="60" BorderThickness="1" Margin="-2,0,-2,5">
                <Grid Background="White">
                    <Label x:Name="lblTab1Section1" HorizontalAlignment="Left" Margin="10,10,0,0" VerticalAlignment="Top" FontWeight="Bold" FontSize="14"/>
                    <Label x:Name="lblTab1Section2" HorizontalAlignment="Left" Margin="259,10,0,0" VerticalAlignment="Top" FontWeight="Bold" FontSize="14"/>
                    <Label x:Name="lblRemoteInto" Content="Remote System:" HorizontalAlignment="Left" Margin="434,7,0,0" VerticalAlignment="Top"/>
                    <TextBox x:Name="txtBoxRemote" HorizontalAlignment="Left" Height="23" Margin="528,10,0,0" TextWrapping="NoWrap" VerticalAlignment="Top" Width="156" />
                    <Border x:Name="boxRemoteInto" BorderBrush="Black" BorderThickness="1" HorizontalAlignment="Left" Height="23" Margin="429,10,0,0" VerticalAlignment="Top" Width="255"/>

                    <Button x:Name="btnTab1_01" Content="btnTab1_01" HorizontalAlignment="Left" Margin="10,45,0,0" VerticalAlignment="Top" Width="80" Height="80" IsEnabled="False"/>
                    <Button x:Name="btnTab1_02" Content="btnTab1_02" HorizontalAlignment="Left" Margin="95,45,0,0" VerticalAlignment="Top" Width="80" Height="80" IsEnabled="False"/>
                    <Button x:Name="btnTab1_03" Content="btnTab1_03" HorizontalAlignment="Left" Margin="10,130,0,0" VerticalAlignment="Top" Width="80" Height="80" IsEnabled="False"/>
                    <Button x:Name="btnTab1_04" Content="btnTab1_04" HorizontalAlignment="Left" Margin="95,130,0,0" VerticalAlignment="Top" Width="80" Height="80" IsEnabled="False"/>
                    <Button x:Name="btnTab1_05" Content="btnTab1_05" HorizontalAlignment="Left" Margin="10,215,0,0" VerticalAlignment="Top" Width="80" Height="80" IsEnabled="False"/>
                    <Button x:Name="btnTab1_06" Content="btnTab1_06" HorizontalAlignment="Left" Margin="95,215,0,0" VerticalAlignment="Top" Width="80" Height="80" IsEnabled="False"/>
                    <Button x:Name="btnTab1_07" Content="btnTab1_07" HorizontalAlignment="Left" Margin="180,45,0,0" VerticalAlignment="Top" Width="60" Height="60" IsEnabled="False"/>
                    <Button x:Name="btnTab1_08" Content="btnTab1_08" HorizontalAlignment="Left" Margin="180,110,0,0" VerticalAlignment="Top" Width="60" Height="60" IsEnabled="False"/>
                    <Button x:Name="btnTab1_09" Content="btnTab1_09" HorizontalAlignment="Left" Margin="180,175,0,0" VerticalAlignment="Top" Width="60" Height="60" IsEnabled="False"/>
                    <Button x:Name="btnTab1_10" Content="btnTab1_10" HorizontalAlignment="Left" Margin="180,240,0,0" VerticalAlignment="Top" Width="60" Height="60" IsEnabled="False"/>
                    <Button x:Name="btnTab1_11" Content="btnTab1_11" HorizontalAlignment="Left" Margin="259,45,0,0" VerticalAlignment="Top" Width="80" Height="80" IsEnabled="False"/>
                    <Button x:Name="btnTab1_12" Content="btnTab1_12" HorizontalAlignment="Left" Margin="344,45,0,0" VerticalAlignment="Top" Width="80" Height="80" IsEnabled="False"/>
                    <Button x:Name="btnTab1_13" Content="btnTab1_13" HorizontalAlignment="Left" Margin="259,130,0,0" VerticalAlignment="Top" Width="80" Height="80" IsEnabled="False"/>
                    <Button x:Name="btnTab1_14" Content="btnTab1_14" HorizontalAlignment="Left" Margin="344,130,0,0" VerticalAlignment="Top" Width="80" Height="80" IsEnabled="False"/>
                    <Button x:Name="btnTab1_15" Content="btnTab1_15" HorizontalAlignment="Left" Margin="429,45,0,0" VerticalAlignment="Top" Width="60" Height="60" IsEnabled="False"/>
                    <Button x:Name="btnTab1_16" Content="btnTab1_16" HorizontalAlignment="Left" Margin="494,44,0,0" VerticalAlignment="Top" Width="60" Height="60" IsEnabled="False"/>
                    <Button x:Name="btnTab1_17" Content="btnTab1_17" HorizontalAlignment="Left" Margin="559,45,0,0" VerticalAlignment="Top" Width="60" Height="60" IsEnabled="False"/>
                    <Button x:Name="btnTab1_18" Content="btnTab1_18" HorizontalAlignment="Left" Margin="624,44,0,0" VerticalAlignment="Top" Width="60" Height="60" IsEnabled="False"/>
                    <Button x:Name="btnTab1_19" Content="btnTab1_19" HorizontalAlignment="Left" Margin="429,110,0,0" VerticalAlignment="Top" Width="60" Height="60" IsEnabled="False"/>
                    <Button x:Name="btnTab1_20" Content="btnTab1_20" HorizontalAlignment="Left" Margin="494,109,0,0" VerticalAlignment="Top" Width="60" Height="60" IsEnabled="False"/>
                    <Button x:Name="btnTab1_21" Content="btnTab1_21" HorizontalAlignment="Left" Margin="559,109,0,0" VerticalAlignment="Top" Width="60" Height="60" IsEnabled="False"/>
                    <Button x:Name="btnTab1_22" Content="btnTab1_22" HorizontalAlignment="Left" Margin="624,109,0,0" VerticalAlignment="Top" Width="60" Height="60" IsEnabled="False"/>
                    <Button x:Name="btnTab1_23" Content="btnTab1_23" HorizontalAlignment="Left" Margin="429,175,0,0" VerticalAlignment="Top" Width="60" Height="60" IsEnabled="False"/>
                    <Button x:Name="btnTab1_24" Content="btnTab1_24" HorizontalAlignment="Left" Margin="494,174,0,0" VerticalAlignment="Top" Width="60" Height="60" IsEnabled="False"/>
                    <Button x:Name="btnTab1_25" Content="btnTab1_25" HorizontalAlignment="Left" Margin="559,175,0,0" VerticalAlignment="Top" Width="60" Height="60" IsEnabled="False"/>
                    <Button x:Name="btnTab1_26" Content="btnTab1_26" HorizontalAlignment="Left" Margin="624,174,0,0" VerticalAlignment="Top" Width="60" Height="60" IsEnabled="False"/>

                    <Label x:Name="lblTab1Logging" Content="Logging" HorizontalAlignment="Left" Margin="252,215,0,0" VerticalAlignment="Top" FontWeight="Bold" FontSize="14" RenderTransformOrigin="0.25,0.483" Width="64"/>
                    <RichTextBox x:Name="txtBoxTab1Output" HorizontalAlignment="Left" Height="120" Margin="252,243,0,0" VerticalAlignment="Top" Width="432" IsReadOnly="True">
                        <FlowDocument/>
                    </RichTextBox>
                </Grid>
            </TabItem>
            <TabItem x:Name="tab2" Header="tab2" Width="60" Height="60" Margin="4,-1,-4,5" BorderThickness="1">
                <Grid Background="White">
                    <Label x:Name="lblTab2Section1" HorizontalAlignment="Left" Margin="10,10,0,0" VerticalAlignment="Top" FontWeight="Bold" FontSize="14"/>
                    <Label x:Name="lblTab2Section2" HorizontalAlignment="Left" Margin="259,10,0,0" VerticalAlignment="Top" FontWeight="Bold" FontSize="14"/>
                    <Label x:Name="lblDomain" Content="Manage domain:" HorizontalAlignment="Left" Margin="465,7,0,0" VerticalAlignment="Top"/>
                    <TextBox x:Name="txtDomain" HorizontalAlignment="Left" Height="23" Margin="564,10,0,0" TextWrapping="NoWrap" VerticalAlignment="Top" Width="120" />
                    <Border x:Name="boxDomain" BorderBrush="Black" BorderThickness="1" HorizontalAlignment="Left" Height="23" Margin="460,10,0,0" VerticalAlignment="Top" Width="224"/>

                    <Button x:Name="btnTab2_01" Content="btnTab2_01" HorizontalAlignment="Left" Margin="10,45,0,0" VerticalAlignment="Top" Width="80" Height="80" IsEnabled="False"/>
                    <Button x:Name="btnTab2_02" Content="btnTab2_02" HorizontalAlignment="Left" Margin="95,45,0,0" VerticalAlignment="Top" Width="80" Height="80" IsEnabled="False"/>
                    <Button x:Name="btnTab2_03" Content="btnTab2_03" HorizontalAlignment="Left" Margin="10,130,0,0" VerticalAlignment="Top" Width="80" Height="80" IsEnabled="False"/>
                    <Button x:Name="btnTab2_04" Content="btnTab2_04" HorizontalAlignment="Left" Margin="95,130,0,0" VerticalAlignment="Top" Width="80" Height="80" IsEnabled="False"/>
                    <Button x:Name="btnTab2_05" Content="btnTab2_05" HorizontalAlignment="Left" Margin="10,215,0,0" VerticalAlignment="Top" Width="80" Height="80" IsEnabled="False"/>
                    <Button x:Name="btnTab2_06" Content="btnTab2_06" HorizontalAlignment="Left" Margin="95,215,0,0" VerticalAlignment="Top" Width="80" Height="80" IsEnabled="False"/>
                    <Button x:Name="btnTab2_07" Content="btnTab2_07" HorizontalAlignment="Left" Margin="180,45,0,0" VerticalAlignment="Top" Width="60" Height="60" IsEnabled="False"/>
                    <Button x:Name="btnTab2_08" Content="btnTab2_08" HorizontalAlignment="Left" Margin="180,110,0,0" VerticalAlignment="Top" Width="60" Height="60" IsEnabled="False"/>
                    <Button x:Name="btnTab2_09" Content="btnTab2_09" HorizontalAlignment="Left" Margin="180,175,0,0" VerticalAlignment="Top" Width="60" Height="60" IsEnabled="False"/>
                    <Button x:Name="btnTab2_10" Content="btnTab2_10" HorizontalAlignment="Left" Margin="180,240,0,0" VerticalAlignment="Top" Width="60" Height="60" IsEnabled="False"/>
                    <Button x:Name="btnTab2_11" Content="btnTab2_11" HorizontalAlignment="Left" Margin="259,45,0,0" VerticalAlignment="Top" Width="80" Height="80" IsEnabled="False"/>
                    <Button x:Name="btnTab2_12" Content="btnTab2_12" HorizontalAlignment="Left" Margin="344,45,0,0" VerticalAlignment="Top" Width="80" Height="80" IsEnabled="False"/>
                    <Button x:Name="btnTab2_13" Content="btnTab2_13" HorizontalAlignment="Left" Margin="259,130,0,0" VerticalAlignment="Top" Width="80" Height="80" IsEnabled="False"/>
                    <Button x:Name="btnTab2_14" Content="btnTab2_14" HorizontalAlignment="Left" Margin="344,130,0,0" VerticalAlignment="Top" Width="80" Height="80" IsEnabled="False"/>
                    <Button x:Name="btnTab2_15" Content="btnTab2_15" HorizontalAlignment="Left" Margin="429,45,0,0" VerticalAlignment="Top" Width="60" Height="60" IsEnabled="False"/>
                    <Button x:Name="btnTab2_16" Content="btnTab2_16" HorizontalAlignment="Left" Margin="494,44,0,0" VerticalAlignment="Top" Width="60" Height="60" IsEnabled="False"/>
                    <Button x:Name="btnTab2_17" Content="btnTab2_17" HorizontalAlignment="Left" Margin="559,45,0,0" VerticalAlignment="Top" Width="60" Height="60" IsEnabled="False"/>
                    <Button x:Name="btnTab2_18" Content="btnTab2_18" HorizontalAlignment="Left" Margin="624,44,0,0" VerticalAlignment="Top" Width="60" Height="60" IsEnabled="False"/>
                    <Button x:Name="btnTab2_19" Content="btnTab2_19" HorizontalAlignment="Left" Margin="429,110,0,0" VerticalAlignment="Top" Width="60" Height="60" IsEnabled="False"/>
                    <Button x:Name="btnTab2_20" Content="btnTab2_20" HorizontalAlignment="Left" Margin="494,109,0,0" VerticalAlignment="Top" Width="60" Height="60" IsEnabled="False"/>
                    <Button x:Name="btnTab2_21" Content="btnTab2_21" HorizontalAlignment="Left" Margin="559,109,0,0" VerticalAlignment="Top" Width="60" Height="60" IsEnabled="False"/>
                    <Button x:Name="btnTab2_22" Content="btnTab2_22" HorizontalAlignment="Left" Margin="624,109,0,0" VerticalAlignment="Top" Width="60" Height="60" IsEnabled="False"/>
                    <Button x:Name="btnTab2_23" Content="btnTab2_23" HorizontalAlignment="Left" Margin="429,175,0,0" VerticalAlignment="Top" Width="60" Height="60" IsEnabled="False"/>
                    <Button x:Name="btnTab2_24" Content="btnTab2_24" HorizontalAlignment="Left" Margin="494,174,0,0" VerticalAlignment="Top" Width="60" Height="60" IsEnabled="False"/>
                    <Button x:Name="btnTab2_25" Content="btnTab2_25" HorizontalAlignment="Left" Margin="559,175,0,0" VerticalAlignment="Top" Width="60" Height="60" IsEnabled="False"/>
                    <Button x:Name="btnTab2_26" Content="btnTab2_26" HorizontalAlignment="Left" Margin="624,174,0,0" VerticalAlignment="Top" Width="60" Height="60" IsEnabled="False"/>

                    <Label x:Name="lblTab2Logging" Content="Logging" HorizontalAlignment="Left" Margin="252,215,0,0" VerticalAlignment="Top" FontWeight="Bold" FontSize="14" RenderTransformOrigin="0.25,0.483" Width="64"/>
                    <RichTextBox x:Name="txtBoxTab2Output" HorizontalAlignment="Left" Height="120" Margin="252,243,0,0" VerticalAlignment="Top" Width="432" IsReadOnly="True">
                        <FlowDocument/>
                    </RichTextBox>

                </Grid>
            </TabItem>
            <TabItem x:Name="tab3" Header="tab3" Width="60" Height="60" Margin="10,-1,-10,5" BorderThickness="1">
                <Grid Background="White">
                    <Label x:Name="lblTab3Section1" HorizontalAlignment="Left" Margin="10,10,0,0" VerticalAlignment="Top" FontWeight="Bold" FontSize="14"/>
                    <Label x:Name="lblTab3Section2" HorizontalAlignment="Left" Margin="259,10,0,0" VerticalAlignment="Top" FontWeight="Bold" FontSize="14"/>
                    <Label x:Name="lblAutoSite" Content="Site Code:" HorizontalAlignment="Left" Margin="556,7,0,0" VerticalAlignment="Top"/>
                    <TextBox x:Name="txtBoxSiteCode" HorizontalAlignment="Left" Height="23" Margin="621,10,0,0" TextWrapping="NoWrap" VerticalAlignment="Top" Width="63" />
                    <Border x:Name="boxSiteCode" BorderBrush="Black" BorderThickness="1" HorizontalAlignment="Left" Height="23" Margin="556,10,0,0" VerticalAlignment="Top" Width="128"/>

                    <Button x:Name="btnTab3_01" Content="btnTab3_01" HorizontalAlignment="Left" Margin="10,45,0,0" VerticalAlignment="Top" Width="80" Height="80" IsEnabled="False"/>
                    <Button x:Name="btnTab3_02" Content="btnTab3_02" HorizontalAlignment="Left" Margin="95,45,0,0" VerticalAlignment="Top" Width="80" Height="80" IsEnabled="False"/>
                    <Button x:Name="btnTab3_03" Content="btnTab3_03" HorizontalAlignment="Left" Margin="10,130,0,0" VerticalAlignment="Top" Width="80" Height="80" IsEnabled="False"/>
                    <Button x:Name="btnTab3_04" Content="btnTab3_04" HorizontalAlignment="Left" Margin="95,130,0,0" VerticalAlignment="Top" Width="80" Height="80" IsEnabled="False"/>
                    <Button x:Name="btnTab3_05" Content="btnTab3_05" HorizontalAlignment="Left" Margin="10,215,0,0" VerticalAlignment="Top" Width="80" Height="80" IsEnabled="False"/>
                    <Button x:Name="btnTab3_06" Content="btnTab3_06" HorizontalAlignment="Left" Margin="95,215,0,0" VerticalAlignment="Top" Width="80" Height="80" IsEnabled="False"/>
                    <Button x:Name="btnTab3_07" Content="btnTab3_07" HorizontalAlignment="Left" Margin="180,45,0,0" VerticalAlignment="Top" Width="60" Height="60" IsEnabled="False"/>
                    <Button x:Name="btnTab3_08" Content="btnTab3_08" HorizontalAlignment="Left" Margin="180,110,0,0" VerticalAlignment="Top" Width="60" Height="60" IsEnabled="False"/>
                    <Button x:Name="btnTab3_09" Content="btnTab3_09" HorizontalAlignment="Left" Margin="180,175,0,0" VerticalAlignment="Top" Width="60" Height="60" IsEnabled="False"/>
                    <Button x:Name="btnTab3_10" Content="btnTab3_10" HorizontalAlignment="Left" Margin="180,240,0,0" VerticalAlignment="Top" Width="60" Height="60" IsEnabled="False"/>
                    <Button x:Name="btnTab3_11" Content="btnTab3_11" HorizontalAlignment="Left" Margin="259,45,0,0" VerticalAlignment="Top" Width="80" Height="80" IsEnabled="False"/>
                    <Button x:Name="btnTab3_12" Content="btnTab3_12" HorizontalAlignment="Left" Margin="344,45,0,0" VerticalAlignment="Top" Width="80" Height="80" IsEnabled="False"/>
                    <Button x:Name="btnTab3_13" Content="btnTab3_13" HorizontalAlignment="Left" Margin="259,130,0,0" VerticalAlignment="Top" Width="80" Height="80" IsEnabled="False"/>
                    <Button x:Name="btnTab3_14" Content="btnTab3_14" HorizontalAlignment="Left" Margin="344,130,0,0" VerticalAlignment="Top" Width="80" Height="80" IsEnabled="False"/>
                    <Button x:Name="btnTab3_15" Content="btnTab3_15" HorizontalAlignment="Left" Margin="429,45,0,0" VerticalAlignment="Top" Width="60" Height="60" IsEnabled="False"/>
                    <Button x:Name="btnTab3_16" Content="btnTab3_16" HorizontalAlignment="Left" Margin="494,44,0,0" VerticalAlignment="Top" Width="60" Height="60" IsEnabled="False"/>
                    <Button x:Name="btnTab3_17" Content="btnTab3_17" HorizontalAlignment="Left" Margin="559,45,0,0" VerticalAlignment="Top" Width="60" Height="60" IsEnabled="False"/>
                    <Button x:Name="btnTab3_18" Content="btnTab3_18" HorizontalAlignment="Left" Margin="624,44,0,0" VerticalAlignment="Top" Width="60" Height="60" IsEnabled="False"/>
                    <Button x:Name="btnTab3_19" Content="btnTab3_19" HorizontalAlignment="Left" Margin="429,110,0,0" VerticalAlignment="Top" Width="60" Height="60" IsEnabled="False"/>
                    <Button x:Name="btnTab3_20" Content="btnTab3_20" HorizontalAlignment="Left" Margin="494,109,0,0" VerticalAlignment="Top" Width="60" Height="60" IsEnabled="False"/>
                    <Button x:Name="btnTab3_21" Content="btnTab3_21" HorizontalAlignment="Left" Margin="559,109,0,0" VerticalAlignment="Top" Width="60" Height="60" IsEnabled="False"/>
                    <Button x:Name="btnTab3_22" Content="btnTab3_22" HorizontalAlignment="Left" Margin="624,109,0,0" VerticalAlignment="Top" Width="60" Height="60" IsEnabled="False"/>
                    <Button x:Name="btnTab3_23" Content="btnTab3_23" HorizontalAlignment="Left" Margin="429,175,0,0" VerticalAlignment="Top" Width="60" Height="60" IsEnabled="False"/>
                    <Button x:Name="btnTab3_24" Content="btnTab3_24" HorizontalAlignment="Left" Margin="494,174,0,0" VerticalAlignment="Top" Width="60" Height="60" IsEnabled="False"/>
                    <Button x:Name="btnTab3_25" Content="btnTab3_25" HorizontalAlignment="Left" Margin="559,175,0,0" VerticalAlignment="Top" Width="60" Height="60" IsEnabled="False"/>
                    <Button x:Name="btnTab3_26" Content="btnTab3_26" HorizontalAlignment="Left" Margin="624,174,0,0" VerticalAlignment="Top" Width="60" Height="60" IsEnabled="False"/>

                    <Label x:Name="lblTab3Logging" Content="Logging" HorizontalAlignment="Left" Margin="252,215,0,0" VerticalAlignment="Top" FontWeight="Bold" FontSize="14" RenderTransformOrigin="0.25,0.483" Width="64"/>
                    <RichTextBox x:Name="txtBoxTab3Output" HorizontalAlignment="Left" Height="120" Margin="252,243,0,0" VerticalAlignment="Top" Width="432" IsReadOnly="True">
                        <FlowDocument/>
                    </RichTextBox>
                </Grid>
            </TabItem>
            <TabItem x:Name="tab4" Header="tab4" Width="60" Height="60" Margin="15,-1,-15,5" BorderThickness="1">
                <Grid Background="White">
                    <Label x:Name="lblTab4Section1" HorizontalAlignment="Left" Margin="10,10,0,0" VerticalAlignment="Top" FontWeight="Bold" FontSize="14"/>
                    <Label x:Name="lblTab4Section2" HorizontalAlignment="Left" Margin="259,10,0,0" VerticalAlignment="Top" FontWeight="Bold" FontSize="14"/>

                    <Button x:Name="btnTab4_01" Content="btnTab4_01" HorizontalAlignment="Left" Margin="10,45,0,0" VerticalAlignment="Top" Width="80" Height="80" IsEnabled="False"/>
                    <Button x:Name="btnTab4_02" Content="btnTab4_02" HorizontalAlignment="Left" Margin="95,45,0,0" VerticalAlignment="Top" Width="80" Height="80" IsEnabled="False"/>
                    <Button x:Name="btnTab4_03" Content="btnTab4_03" HorizontalAlignment="Left" Margin="10,130,0,0" VerticalAlignment="Top" Width="80" Height="80" IsEnabled="False"/>
                    <Button x:Name="btnTab4_04" Content="btnTab4_04" HorizontalAlignment="Left" Margin="95,130,0,0" VerticalAlignment="Top" Width="80" Height="80" IsEnabled="False"/>
                    <Button x:Name="btnTab4_05" Content="btnTab4_05" HorizontalAlignment="Left" Margin="10,215,0,0" VerticalAlignment="Top" Width="80" Height="80" IsEnabled="False"/>
                    <Button x:Name="btnTab4_06" Content="btnTab4_06" HorizontalAlignment="Left" Margin="95,215,0,0" VerticalAlignment="Top" Width="80" Height="80" IsEnabled="False"/>
                    <Button x:Name="btnTab4_07" Content="btnTab4_07" HorizontalAlignment="Left" Margin="180,45,0,0" VerticalAlignment="Top" Width="60" Height="60" IsEnabled="False"/>
                    <Button x:Name="btnTab4_08" Content="btnTab4_08" HorizontalAlignment="Left" Margin="180,110,0,0" VerticalAlignment="Top" Width="60" Height="60" IsEnabled="False"/>
                    <Button x:Name="btnTab4_09" Content="btnTab4_09" HorizontalAlignment="Left" Margin="180,175,0,0" VerticalAlignment="Top" Width="60" Height="60" IsEnabled="False"/>
                    <Button x:Name="btnTab4_10" Content="btnTab4_10" HorizontalAlignment="Left" Margin="180,240,0,0" VerticalAlignment="Top" Width="60" Height="60" IsEnabled="False"/>
                    <Button x:Name="btnTab4_11" Content="btnTab4_11" HorizontalAlignment="Left" Margin="259,45,0,0" VerticalAlignment="Top" Width="80" Height="80" IsEnabled="False"/>
                    <Button x:Name="btnTab4_12" Content="btnTab4_12" HorizontalAlignment="Left" Margin="344,45,0,0" VerticalAlignment="Top" Width="80" Height="80" IsEnabled="False"/>
                    <Button x:Name="btnTab4_13" Content="btnTab4_13" HorizontalAlignment="Left" Margin="259,130,0,0" VerticalAlignment="Top" Width="80" Height="80" IsEnabled="False"/>
                    <Button x:Name="btnTab4_14" Content="btnTab4_14" HorizontalAlignment="Left" Margin="344,130,0,0" VerticalAlignment="Top" Width="80" Height="80" IsEnabled="False"/>
                    <Button x:Name="btnTab4_15" Content="btnTab4_15" HorizontalAlignment="Left" Margin="429,45,0,0" VerticalAlignment="Top" Width="60" Height="60" IsEnabled="False"/>
                    <Button x:Name="btnTab4_16" Content="btnTab4_16" HorizontalAlignment="Left" Margin="494,44,0,0" VerticalAlignment="Top" Width="60" Height="60" IsEnabled="False"/>
                    <Button x:Name="btnTab4_17" Content="btnTab4_17" HorizontalAlignment="Left" Margin="559,45,0,0" VerticalAlignment="Top" Width="60" Height="60" IsEnabled="False"/>
                    <Button x:Name="btnTab4_18" Content="btnTab4_18" HorizontalAlignment="Left" Margin="624,44,0,0" VerticalAlignment="Top" Width="60" Height="60" IsEnabled="False"/>
                    <Button x:Name="btnTab4_19" Content="btnTab4_19" HorizontalAlignment="Left" Margin="429,110,0,0" VerticalAlignment="Top" Width="60" Height="60" IsEnabled="False"/>
                    <Button x:Name="btnTab4_20" Content="btnTab4_20" HorizontalAlignment="Left" Margin="494,109,0,0" VerticalAlignment="Top" Width="60" Height="60" IsEnabled="False"/>
                    <Button x:Name="btnTab4_21" Content="btnTab4_21" HorizontalAlignment="Left" Margin="559,109,0,0" VerticalAlignment="Top" Width="60" Height="60" IsEnabled="False"/>
                    <Button x:Name="btnTab4_22" Content="btnTab4_22" HorizontalAlignment="Left" Margin="624,109,0,0" VerticalAlignment="Top" Width="60" Height="60" IsEnabled="False"/>
                    <Button x:Name="btnTab4_23" Content="btnTab4_23" HorizontalAlignment="Left" Margin="429,175,0,0" VerticalAlignment="Top" Width="60" Height="60" IsEnabled="False"/>
                    <Button x:Name="btnTab4_24" Content="btnTab4_24" HorizontalAlignment="Left" Margin="494,174,0,0" VerticalAlignment="Top" Width="60" Height="60" IsEnabled="False"/>
                    <Button x:Name="btnTab4_25" Content="btnTab4_25" HorizontalAlignment="Left" Margin="559,175,0,0" VerticalAlignment="Top" Width="60" Height="60" IsEnabled="False"/>
                    <Button x:Name="btnTab4_26" Content="btnTab4_26" HorizontalAlignment="Left" Margin="624,174,0,0" VerticalAlignment="Top" Width="60" Height="60" IsEnabled="False"/>

                    <Label x:Name="lblTab4Logging" Content="Logging" HorizontalAlignment="Left" Margin="252,215,0,0" VerticalAlignment="Top" FontWeight="Bold" FontSize="14" RenderTransformOrigin="0.25,0.483" Width="64"/>
                    <RichTextBox x:Name="txtBoxTab4Output" HorizontalAlignment="Left" Height="120" Margin="252,243,0,0" VerticalAlignment="Top" Width="432" IsReadOnly="True">
                        <FlowDocument/>
                    </RichTextBox>
                </Grid>
            </TabItem>
            <TabItem x:Name="tab5" Header="tab5" Width="60" Height="60" Margin="20,-1,-20,5" BorderThickness="1">
                <Grid Background="White">
                    <Label x:Name="lblTab5Section1" HorizontalAlignment="Left" Margin="10,10,0,0" VerticalAlignment="Top" FontWeight="Bold" FontSize="14"/>
                    <Label x:Name="lblTab5Section2" HorizontalAlignment="Left" Margin="259,10,0,0" VerticalAlignment="Top" FontWeight="Bold" FontSize="14"/>

                    <Button x:Name="btnTab5_01" Content="btnTab5_01" HorizontalAlignment="Left" Margin="10,45,0,0" VerticalAlignment="Top" Width="80" Height="80" IsEnabled="False"/>
                    <Button x:Name="btnTab5_02" Content="btnTab5_02" HorizontalAlignment="Left" Margin="95,45,0,0" VerticalAlignment="Top" Width="80" Height="80" IsEnabled="False"/>
                    <Button x:Name="btnTab5_03" Content="btnTab5_03" HorizontalAlignment="Left" Margin="10,130,0,0" VerticalAlignment="Top" Width="80" Height="80" IsEnabled="False"/>
                    <Button x:Name="btnTab5_04" Content="btnTab5_04" HorizontalAlignment="Left" Margin="95,130,0,0" VerticalAlignment="Top" Width="80" Height="80" IsEnabled="False"/>
                    <Button x:Name="btnTab5_05" Content="btnTab5_05" HorizontalAlignment="Left" Margin="10,215,0,0" VerticalAlignment="Top" Width="80" Height="80" IsEnabled="False"/>
                    <Button x:Name="btnTab5_06" Content="btnTab5_06" HorizontalAlignment="Left" Margin="95,215,0,0" VerticalAlignment="Top" Width="80" Height="80" IsEnabled="False"/>
                    <Button x:Name="btnTab5_07" Content="btnTab5_07" HorizontalAlignment="Left" Margin="180,45,0,0" VerticalAlignment="Top" Width="60" Height="60" IsEnabled="False"/>
                    <Button x:Name="btnTab5_08" Content="btnTab5_08" HorizontalAlignment="Left" Margin="180,110,0,0" VerticalAlignment="Top" Width="60" Height="60" IsEnabled="False"/>
                    <Button x:Name="btnTab5_09" Content="btnTab5_09" HorizontalAlignment="Left" Margin="180,175,0,0" VerticalAlignment="Top" Width="60" Height="60" IsEnabled="False"/>
                    <Button x:Name="btnTab5_10" Content="btnTab5_10" HorizontalAlignment="Left" Margin="180,240,0,0" VerticalAlignment="Top" Width="60" Height="60" IsEnabled="False"/>
                    <Button x:Name="btnTab5_11" Content="btnTab5_11" HorizontalAlignment="Left" Margin="259,45,0,0" VerticalAlignment="Top" Width="80" Height="80" IsEnabled="False"/>
                    <Button x:Name="btnTab5_12" Content="btnTab5_12" HorizontalAlignment="Left" Margin="344,45,0,0" VerticalAlignment="Top" Width="80" Height="80" IsEnabled="False"/>
                    <Button x:Name="btnTab5_13" Content="btnTab5_13" HorizontalAlignment="Left" Margin="259,130,0,0" VerticalAlignment="Top" Width="80" Height="80" IsEnabled="False"/>
                    <Button x:Name="btnTab5_14" Content="btnTab5_14" HorizontalAlignment="Left" Margin="344,130,0,0" VerticalAlignment="Top" Width="80" Height="80" IsEnabled="False"/>
                    <Button x:Name="btnTab5_15" Content="btnTab5_15" HorizontalAlignment="Left" Margin="429,45,0,0" VerticalAlignment="Top" Width="60" Height="60" IsEnabled="False"/>
                    <Button x:Name="btnTab5_16" Content="btnTab5_16" HorizontalAlignment="Left" Margin="494,44,0,0" VerticalAlignment="Top" Width="60" Height="60" IsEnabled="False"/>
                    <Button x:Name="btnTab5_17" Content="btnTab5_17" HorizontalAlignment="Left" Margin="559,45,0,0" VerticalAlignment="Top" Width="60" Height="60" IsEnabled="False"/>
                    <Button x:Name="btnTab5_18" Content="btnTab5_18" HorizontalAlignment="Left" Margin="624,44,0,0" VerticalAlignment="Top" Width="60" Height="60" IsEnabled="False"/>
                    <Button x:Name="btnTab5_19" Content="btnTab5_19" HorizontalAlignment="Left" Margin="429,110,0,0" VerticalAlignment="Top" Width="60" Height="60" IsEnabled="False"/>
                    <Button x:Name="btnTab5_20" Content="btnTab5_20" HorizontalAlignment="Left" Margin="494,109,0,0" VerticalAlignment="Top" Width="60" Height="60" IsEnabled="False"/>
                    <Button x:Name="btnTab5_21" Content="btnTab5_21" HorizontalAlignment="Left" Margin="559,109,0,0" VerticalAlignment="Top" Width="60" Height="60" IsEnabled="False"/>
                    <Button x:Name="btnTab5_22" Content="btnTab5_22" HorizontalAlignment="Left" Margin="624,109,0,0" VerticalAlignment="Top" Width="60" Height="60" IsEnabled="False"/>
                    <Button x:Name="btnTab5_23" Content="btnTab5_23" HorizontalAlignment="Left" Margin="429,175,0,0" VerticalAlignment="Top" Width="60" Height="60" IsEnabled="False"/>
                    <Button x:Name="btnTab5_24" Content="btnTab5_24" HorizontalAlignment="Left" Margin="494,174,0,0" VerticalAlignment="Top" Width="60" Height="60" IsEnabled="False"/>
                    <Button x:Name="btnTab5_25" Content="btnTab5_25" HorizontalAlignment="Left" Margin="559,175,0,0" VerticalAlignment="Top" Width="60" Height="60" IsEnabled="False"/>
                    <Button x:Name="btnTab5_26" Content="btnTab5_26" HorizontalAlignment="Left" Margin="624,174,0,0" VerticalAlignment="Top" Width="60" Height="60" IsEnabled="False"/>

                    <Label x:Name="lblTab5Logging" Content="Logging" HorizontalAlignment="Left" Margin="252,215,0,0" VerticalAlignment="Top" FontWeight="Bold" FontSize="14" RenderTransformOrigin="0.25,0.483" Width="64"/>
                    <RichTextBox x:Name="txtBoxTab5Output" HorizontalAlignment="Left" Height="120" Margin="252,243,0,0" VerticalAlignment="Top" Width="432" IsReadOnly="True">
                        <FlowDocument/>
                    </RichTextBox>
                </Grid>
            </TabItem>
            <TabItem x:Name="tab6" Header="tab5" Width="60" Height="60" Margin="20,-1,-20,5" BorderThickness="1">
                <Grid Background="White">
                    <Label x:Name="lblTab6Section1" HorizontalAlignment="Left" Margin="10,10,0,0" VerticalAlignment="Top" FontWeight="Bold" FontSize="14"/>

                    <Button x:Name="btnTab6_01" Content="btnTab6_01" HorizontalAlignment="Left" Margin="10,45,0,0" VerticalAlignment="Top" Width="80" Height="80" IsEnabled="False"/>
                    <Button x:Name="btnTab6_02" Content="btnTab6_02" HorizontalAlignment="Left" Margin="95,45,0,0" VerticalAlignment="Top" Width="80" Height="80" IsEnabled="False"/>
                    <Button x:Name="btnTab6_03" Content="btnTab6_03" HorizontalAlignment="Left" Margin="180,45,0,0" VerticalAlignment="Top" Width="80" Height="80" IsEnabled="False"/>
                    <Button x:Name="btnTab6_04" Content="btnTab6_04" HorizontalAlignment="Left" Margin="265,45,0,0" VerticalAlignment="Top" Width="80" Height="80" IsEnabled="False"/>
                    <Button x:Name="btnTab6_05" Content="btnTab6_05" HorizontalAlignment="Left" Margin="350,45,0,0" VerticalAlignment="Top" Width="80" Height="80" IsEnabled="False"/>
                    <Button x:Name="btnTab6_06" Content="btnTab6_06" HorizontalAlignment="Left" Margin="435,45,0,0" VerticalAlignment="Top" Width="80" Height="80" IsEnabled="False"/>
                    <Button x:Name="btnTab6_07" Content="btnTab6_07" HorizontalAlignment="Left" Margin="520,45,0,0" VerticalAlignment="Top" Width="80" Height="80" IsEnabled="False"/>
                    <Button x:Name="btnTab6_08" Content="btnTab6_08" HorizontalAlignment="Left" Margin="605,45,0,0" VerticalAlignment="Top" Width="80" Height="80" IsEnabled="False"/>
                    <Button x:Name="btnTab6_09" Content="btnTab6_09" HorizontalAlignment="Left" Margin="10,130,0,0" VerticalAlignment="Top" Width="80" Height="80" IsEnabled="False"/>
                    <Button x:Name="btnTab6_10" Content="btnTab6_10" HorizontalAlignment="Left" Margin="95,130,0,0" VerticalAlignment="Top" Width="80" Height="80" IsEnabled="False"/>
                    <Button x:Name="btnTab6_11" Content="btnTab6_11" HorizontalAlignment="Left" Margin="180,130,0,0" VerticalAlignment="Top" Width="80" Height="80" IsEnabled="False"/>
                    <Button x:Name="btnTab6_12" Content="btnTab6_12" HorizontalAlignment="Left" Margin="265,130,0,0" VerticalAlignment="Top" Width="80" Height="80" IsEnabled="False"/>
                    <Button x:Name="btnTab6_13" Content="btnTab6_13" HorizontalAlignment="Left" Margin="350,130,0,0" VerticalAlignment="Top" Width="80" Height="80" IsEnabled="False"/>
                    <Button x:Name="btnTab6_14" Content="btnTab6_14" HorizontalAlignment="Left" Margin="435,130,0,0" VerticalAlignment="Top" Width="80" Height="80" IsEnabled="False"/>
                    <Button x:Name="btnTab6_15" Content="btnTab6_15" HorizontalAlignment="Left" Margin="520,130,0,0" VerticalAlignment="Top" Width="80" Height="80" IsEnabled="False"/>
                    <Button x:Name="btnTab6_16" Content="btnTab6_16" HorizontalAlignment="Left" Margin="605,130,0,0" VerticalAlignment="Top" Width="80" Height="80" IsEnabled="False"/>
                    <Button x:Name="btnTab6_17" Content="btnTab6_17" HorizontalAlignment="Left" Margin="10,215,0,0" VerticalAlignment="Top" Width="80" Height="80" IsEnabled="False"/>
                    <Button x:Name="btnTab6_18" Content="btnTab6_18" HorizontalAlignment="Left" Margin="95,215,0,0" VerticalAlignment="Top" Width="80" Height="80" IsEnabled="False"/>
                    <Button x:Name="btnTab6_19" Content="btnTab6_19" HorizontalAlignment="Left" Margin="180,215,0,0" VerticalAlignment="Top" Width="80" Height="80" IsEnabled="False"/>
                    <Button x:Name="btnTab6_20" Content="btnTab6_20" HorizontalAlignment="Left" Margin="265,215,0,0" VerticalAlignment="Top" Width="80" Height="80" IsEnabled="False"/>
                    <Button x:Name="btnTab6_21" Content="btnTab6_21" HorizontalAlignment="Left" Margin="350,215,0,0" VerticalAlignment="Top" Width="80" Height="80" IsEnabled="False"/>
                    <Button x:Name="btnTab6_22" Content="btnTab6_22" HorizontalAlignment="Left" Margin="435,215,0,0" VerticalAlignment="Top" Width="80" Height="80" IsEnabled="False"/>
                    <Button x:Name="btnTab6_23" Content="btnTab6_23" HorizontalAlignment="Left" Margin="520,215,0,0" VerticalAlignment="Top" Width="80" Height="80" IsEnabled="False"/>
                    <Button x:Name="btnTab6_24" Content="btnTab6_24" HorizontalAlignment="Left" Margin="605,215,0,0" VerticalAlignment="Top" Width="80" Height="80" IsEnabled="False"/>

                </Grid>
            </TabItem>
        </TabControl>
        <Label x:Name="lblSupportedOS" Content="Operating System:" Margin="20,468,671,10" FontSize="10"/>
        <Label x:Name="lblSupportedOSCheck" Content="6.0" Margin="105,468,615,10" FontSize="10" Foreground="Red" FontWeight="Bold"/>
        <Label x:Name="lblPSVersion" Content="Powershell Version:" Margin="193,468,505,10" FontSize="10"/>
        <Label x:Name="lblPSVersionCheck" Content="2.0" Margin="280,468,470,10" FontSize="10" Foreground="Red" FontWeight="Bold"/>
        <Label x:Name="lblElevated" Content="Running Elevated:" Margin="334,468,370,10" FontSize="10"/>
        <Label x:Name="lblElevatedCheck" Content="No" Margin="415,468,335,10" FontSize="10" Foreground="Red" FontWeight="Bold"/>
        <Label x:Name="lblRSAT" Content="RSAT Installed:" Margin="464,468,254,10" FontSize="10"/>
        <Label x:Name="lblRSATCheck" Content="No" Margin="531,468,219,10" FontSize="10" Foreground="Red" FontWeight="Bold"/>
        <Button x:Name="btnHide" Content="Hide" HorizontalAlignment="Left" Margin="619,451,0,0" VerticalAlignment="Top" Width="80" Height="40" Background="#FFF4F7FC" Foreground="#FF0C0274"/>
        <Button x:Name="btnExit" Content="Exit" HorizontalAlignment="Left" Margin="704,451,0,0" VerticalAlignment="Top" Width="80" Height="40" Background="#FFF4F7FC" Foreground="#FF0C0274"/>

    </Grid>
</Window>
'@       

[string]$CredPopupXAML = @'
<Window x:Class="AdminMenu.CredPopup"
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
        xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" 
        Name="CredPopup" 
        WindowStyle="None" 
        Height="200" Width="400" 
        ResizeMode="NoResize" 
        ShowInTaskbar="False">
    <Window.Resources>
        <Style TargetType="{x:Type Button}">
            <!-- This style is used for buttons, to remove the WPF default 'animated' mouse over effect -->
            <Setter Property="OverridesDefaultStyle" Value="True"/>
            <Setter Property="Foreground" Value="#FFEAEAEA"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="Button" >

                        <Border Name="border" 
                                    BorderThickness="1"
                                    Padding="4,2" 
                                    BorderBrush="#FFEAEAEA" 
                                    CornerRadius="2" 
                                    Background="{TemplateBinding Background}">
                            <ContentPresenter HorizontalAlignment="Center" 
                                                  VerticalAlignment="Center" 
                                                  TextBlock.FontSize="10px"
                                                  TextBlock.TextAlignment="Center"
                                                  />
                        </Border>
                        <ControlTemplate.Triggers>
                            <Trigger Property="IsMouseOver" Value="True">
                                <Setter TargetName="border" Property="BorderBrush" Value="#FF919191" />
                            </Trigger>
                        </ControlTemplate.Triggers>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>
    </Window.Resources>
    <Grid Background="#313130">
        <Label x:Name="lblCredentials" Content="Enter Credentials" HorizontalAlignment="Left" Margin="10,6,0,0" VerticalAlignment="Top" Width="243" Foreground="White" FontSize="16"/>

        <Label x:Name="lblUsername" Content="Username:" HorizontalAlignment="Left" Margin="59,53,0,0" VerticalAlignment="Top" Foreground="White"/>
        <TextBox x:Name="txtBoxUsername" HorizontalAlignment="Left" Height="24" Margin="127,58,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="180"/>

        <Label x:Name="lblPassword" Content="Password:" HorizontalAlignment="Left" Margin="62,87,0,0" VerticalAlignment="Top" Foreground="White"/>
        <Label x:Name="lblBoxPassword" Foreground="White" FontSize="18" Margin="122,87,88,74">
            <PasswordBox x:Name="pwdBoxPassword" Width="180" Height="24"/>
        </Label>
        <Label x:Name="lblDomain" Content="Domain:" HorizontalAlignment="Left" Margin="70,119,0,0" VerticalAlignment="Top" Foreground="White"/>
        <TextBox x:Name="txtBoxDomain" HorizontalAlignment="Left" Height="24" Margin="127,126,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="122"/>
        <Button x:Name="btnSubmit" Content="Submit" HorizontalAlignment="Left" Margin="301,150,0,0" VerticalAlignment="Top" Width="80" Height="40" Background="Black" Foreground="White"/>

    </Grid>
</Window>

'@
#format XAML for Powershell
$appXAML = $appXAML -replace 'mc:Ignorable="d"','' -replace "x:N",'N'  -replace '^<Win.*', '<Window'
[xml]$appXAML = $appXAML

#format XAML for Powershell
$CredPopupXAML  = $CredPopupXAML  -replace 'mc:Ignorable="d"','' -replace "x:N",'N'  -replace '^<Win.*', '<Window'
[xml]$CredPopupXAML = $CredPopupXAML

#===========================================================================
# Store Form Objects In PowerShell
#===========================================================================
#Load APP Form
try{
    $App = [Windows.Markup.XamlReader]::Load((New-Object System.Xml.XmlNodeReader $appXAML))
}
catch{
    Write-Host "Unable to load Windows.Markup.XamlReader. XAML syntax may be invalid"
    Exit
}

# Turn XAML into PowerShell objects
$appXAML.SelectNodes("//*[@Name]") | ForEach-Object { Set-Variable -Name "WPF$($_.Name)" -Value $App.FindName($_.Name)}

#Load popup Form 
try{
    $CredPopup = [Windows.Markup.XamlReader]::Load((New-Object System.Xml.XmlNodeReader $CredPopupXAML))
}
catch{
    Write-Host "Unable to load Windows.Markup.XamlReader. XAML syntax may be invalid"
    Exit
}

# Turn XAML into PowerShell objects
$CredPopupXAML.SelectNodes("//*[@Name]") | ForEach-Object { Set-Variable -Name "POP$($_.Name)" -Value $CredPopup.FindName($_.Name)}


##*=============================================
##* READ CONFIG.XML FILE
##*=============================================
[string]$ConfigFile = Join-Path -Path $scriptRoot -ChildPath 'AdminMenu-Config.xml'
[xml]$XmlConfigFile = Get-Content $ConfigFile

#Check if remote will be used
$UseRemoteInstead = $XmlConfigFile.app.configs.useRemote.remote
If ($UseRemoteInstead -eq $true){
    $remoteConfig = $XmlConfigFile.app.configs.useRemote.path
    If (Test-Path $remoteConfig){
        [xml]$XmlConfigFile = Get-Content $remoteConfig
    }
}

If ($XmlConfigFile.app.configs.debugmode -eq 'true'){
    [Boolean]$Global:LogDebugMode = $True 
} Else {
    [Boolean]$Global:LogDebugMode = $False
}

If ($XmlConfigFile.app.configs.hideIfNotUsed -eq 'true'){
    [Boolean]$HideWindow = $True 
} Else {
    [Boolean]$HideWindow = $False
}

$apptitle = $XmlConfigFile.app.title
$appversion = $XmlConfigFile.app.version


$SupportedOperatingSystems = $XmlConfigFile.app.supported.OSbuilds.OS
$MinimumOS = $SupportedOperatingSystems | Where-Object id -eq "minimum"
[int]$MinimumOSversion = $MinimumOS.version 

##*=========================
##* LOAD EXTENSION SCRIPT
##*=========================
$FunctionScripts = $XmlConfigFile.app.configs.functionScripts.Path
Foreach ($script in $FunctionScripts){
    If (Test-Path -Path ($scriptRoot + "\" + $script)){
    If ($Global:LogDebugMode){write-Host "Loading Extensions: $script."}
    . ($scriptRoot + "\" + $script)
    }
}

##*=============================
##* LOAD TAB EXTENSION SCRIPTS
##*=============================
#Get configs for tabs and buttons
$TabConfigs = $XmlConfigFile.app.tabAndButtons

#Hide any buttons not configured in xml
If ($TabConfigs.hideUnusedButtons -eq 'True'){[Boolean]$Global:HideUnusedBtns = $True } Else {[Boolean]$Global:HideUnusedBtns = $False}
If ($Global:HideUnusedBtns){Get-Variable WPFbtnTab* -ValueOnly | Foreach {$_.Visibility = 'Hidden'}} Else {Get-Variable WPFbtnTab* -ValueOnly | Foreach {$_.Visibility = 'Visible'}}

#loop through all tab configs and process individual ps1 files
foreach ($tab in $TabConfigs.tab){
    $script = $tab.extension
    If (Test-Path -Path ($scriptRoot + "\" + $script)){
        Try {
            . ($scriptRoot + "\" + $script)
        }
        Catch {
            $ErrorMessage = $_.Exception.Message
            $FailedItem = $_.Exception.ItemName 
            write-host "Unable to load extension: $script [error: $ErrorMessage] [$FailedItem]"  

        }
    } 
    Else {
        If ($Global:LogDebugMode){write-Host "Extension missing: $script. Extra Tabs will be hidden from view"}
        
        #remove script extion and path, then get the tab name
        [string]$scriptName = [IO.Path]::GetFileNameWithoutExtension($script)
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

If ($Global:LogDebugMode){Get-FormVariables}

#===================================
# LOAD NOTIFY IN TASKBAR
#===================================
$NotifyBase64Icon = "iVBORw0KGgoAAAANSUhEUgAAABgAAAAYCAYAAADgdz34AAAABmJLR0QAAAAAAAD5Q7t/AAAACXBIWXMA
AAsTAAALEwEAmpwYAAAAB3RJTUUH4AcUDBEbZ22+YgAABRRJREFUSMeNVV1sFFUU/s6d2ZnZ0t/tbreBtgIipUALGmh4UJDCUgVST
AgmIqQPyq8PmiigMSEENRjCC2JMASFBDTEkRQztS9d2QU1NqEZYUEMAxbb0d9vt/+7O7Nzjy4DbtYA3uck9d8537p1zznc/CgZDCv
47GAA9wn7USPVl1VmQM9mxRYozLCtJa9cGkqlRGhubFE1zUQp+Sqw6hQPS1lRQ4MkIh8O1DpiZmS0reSYaHRl/HNY5gNlScxDX/Gy
Y/USJQc735LiJQD09AxOqqngAHH2AIoKqKhdN0xovKPAYzJB9fQNxXddEygEEQAqAcb10pSy5d1Z75o83Zs7++5j+4gurbMPQzum6
dqyoyF8shKhJT7QQYsP06QVFuq4dMwztK78/f1p19S4rPSN04ce7ovTOoWk5sVstAJ4COM4s9/evOO0RyfFDACIAcgC40s6wAAwD8
Dipu2KaZqC3d3BC0x64ssiIt9MPlXUTN+Z+tIyBEEB+InE87+f9f7FQfwPgdYInAYw6M+nseVOKWqlp2hmfL89IrYFYs3q5fWMuZE
LJwnDW4q0AOgGCGut7TbqyD7FQbwIIAdglpVzHzOsA7ATQnPZHEsAYkZjUWdRVV9WQUPK2z9pW39V5orpKSLPZaeMkg8JWZsknM18
9/SWIZH19gwIwDw4OY9GieW7D0PYC2O8EjNi2rOzo6Gl3u/X7xWbqqnu+FRALAGoA5Oap+MTAbSblbdOV39o2//MokYRn7CplZ2Xo
hqF9C2CVU5N3bNtukJIHursjY7ruAnUeX71OsGxIC8kATcXc60x0zibjfMn2xt8BIBwObwNwIs1vX0VFxeFgMKSKroINTZKUlwF5j
8EgO340kTm7jOLRTQD/mQYsJ+YPVBlrvVdX1dJZFwiM+cobQUorALBifBjzlM+PlJafvH9RCgZblECgyv5+hL3GMAr1kVtbyI7vAy
lXxgrmv1TyTWCegHwPQKXTrukJvEvmyPuJ7Llt+nj7W6y4djNEH0h5s8u3tp6CwZASCKy0r127to+IPk5Db6+oqDgJAO0n15cqMr6
RWG4CsPjx7yMgSamhYDCkmKYFvz8/U1WVfIe1h50+b47HzQ0joxOJSHYlg5NYemNbrmENLCNOHgEwb+rnlL4gcA2YbwoA0DQXRaMj
452dve22LS84DAWAVYah7c3OytDHw+fZ1RHC1ZzNQzN2NDVO39G8wMyatZVBvzjEA8CQQl0+Y2dzbUzzlYHQR44eEADKzc02dN31K
YAtKQyFQ6qvmfmmw6FSIrzCQi2xXbkH/Jdqa4ntAIDO4azystvFO+JtC8vkQQ/JSc81MzOA3LTgcPp8BRHFHNsNQCWZhGINvZt0+w
+6JroCAIqyR6+f9Qz8ujEzVoam7y6rk8Sht3cglkiYtQDaUugfcUikAshypursRUgmF0aXHJjDLF8H0EPAc7N6T/1U07I7M+Hy8qS
bGoYmli5dMmSaVgDARQBnbVtWAtgzRS33ON++FMmJqhm7Lp0acs950lIyn+72rnn28pLPxgyzFxQMhgQAJVWJTNOCz5dnEAnq7u6f
KC4ufEJRxJ1JLSjl7I6OnvbCQm8GAI5EhmLS7UVSySTNikK1RwEQq1OIOWmai4eHx+IA4HbrQko5qChiT2qz27aMGoZOQ0OjMQBQV
YVgRUmzovxvWR9I5iSZm6SpALi7u390/frqI2mirzqi/yisvJ8ieljwh9j/2/cfCAo02q+zNJcAAAAASUVORK5CYII="
## PROCESS NOTIFY ICON NEXT
# Create a streaming image by streaming the base64 string to a bitmap streamsource
$NotifyBitmap = New-Object System.Windows.Media.Imaging.BitmapImage
$NotifyBitmap.BeginInit()
$NotifyBitmap.StreamSource = [System.IO.MemoryStream][System.Convert]::FromBase64String($NotifyBase64Icon)
$NotifyBitmap.EndInit()
$NotifyBitmap.Freeze()

# Convert the bitmap into an icon
$image = [System.Drawing.Bitmap][System.Drawing.Image]::FromStream($NotifyBitmap.StreamSource)
$icon = [System.Drawing.Icon]::FromHandle($image.GetHicon())
 
$notifyicon = New-Object System.Windows.Forms.NotifyIcon
$notifyicon.Text = $apptitle
$notifyicon.Icon = $icon
$notifyicon.Visible = $true

$menuitem = New-Object System.Windows.Forms.MenuItem
$menuitem.Text = "Exit Tool"

$contextmenu = New-Object System.Windows.Forms.ContextMenu
$notifyicon.ContextMenu = $contextmenu
$notifyicon.contextMenu.MenuItems.AddRange($menuitem)

# Add a left click that makes the Window appear
# part of the screen, above the notify icon.
$notifyicon.add_Click({
	if ($_.Button -eq [Windows.Forms.MouseButtons]::Left) {
			# reposition each time, in case the resolution or monitor changes
			#$App.Left = $([System.Windows.SystemParameters]::WorkArea.Width-$App.Width)
			#$App.Top = $([System.Windows.SystemParameters]::WorkArea.Height-$App.Height)
			$App.Show()
			$App.Activate()
	}
})

# When Exit is clicked, close everything and kill the PowerShell process
$menuitem.add_Click({
    $App.Close()
	$notifyicon.Visible = $false
	Stop-Process $pid
})

##*===============================
##* CRED POPUP CONTENT AND BUTTONS 
##*===============================

# hide the credential window if it's double clicked
$CredPopup.Add_MouseDoubleClick({
	$CredPopup.Hide()
})

# hide the credential window if it loses focus
$CredPopup.Add_Deactivated({
	$CredPopup.Hide()
})

$POPbtnSubmit.add_click({
    $POPtxtBoxUsername
    $POPpwdBoxPassword
    $POPtxtBoxDomain

})

##*==============================
##* MAIN FORM CONTENT AND BUTTONS  
##*==============================
Write-OutputBox -OutputBoxMessage "Loading $apptitle ($appversion)" -Type "START: " -Object tab1

# Run prerequisite checks: OS version, powershell version, elevated admin
Validate-RunChecks

#check to see if RSAT is installed locally
If ($XmlConfigFile.app.configs.checkRSAT -eq 'true'){
    Validate-RSATInstalled
} 
Else {
    $WPFlblRSAT.Visibility = 'Hidden' 
    $WPFlblRSATCheck.Visibility = 'Hidden' 
}

$App.Add_Closing({$_.Cancel = $true})

#Get username
$WPFtxtCurrentUser.text = $envUserName

$WPFbtnCred1.Add_Click({If($Global:RunAsCreds1){Select-Credentials -btnID 1}Else{Store-CredentialsForm -btnID 1}})
$WPFbtnCred1.Add_MouseDoubleClick({Store-CredentialsForm -btnID 1})

$WPFbtnCred2.Add_Click({If($Global:RunAsCreds2){Select-Credentials -btnID 2}Else{Store-CredentialsForm -btnID 2}})
$WPFbtnCred2.Add_MouseDoubleClick({Store-CredentialsForm -btnID 2})

$WPFbtnCred3.Add_Click({If($Global:RunAsCreds3){Select-Credentials -btnID 3}Else{Store-CredentialsForm -btnID 3}})
$WPFbtnCred3.Add_MouseDoubleClick({Store-CredentialsForm -btnID 3})

$WPFbtnCredReset.Add_Click({Reset-SelectedCred})

$WPFbtnCredClear.Add_Click({Delete-CredentialsFiles})


$WPFbtnExit.Add_Click({
            $App.Add_Closing({$_.Cancel = $false}) # Required to re-enable close button
            $App.Close()
            $notifyicon.Visible = $false
            [System.Windows.Forms.Application]::Exit($null)
            If ($Global:LogDebugMode -eq $false){Stop-Process $pid}
        })

$WPFbtnHide.Add_Click({
	$App.Hide()
})


# hide the window if it's double clicked
#$App.Add_MouseDoubleClick({
#	$App.Hide()
#})

If ($HideWindow){
    # Close the window if it loses focus
    $App.Add_Deactivated({
	    $App.Hide()
    })
}



#===================================
# LOAD MAIN FORM AS APP
#===================================

New-Item "$envLocalAppData\AdminMenu" -ItemType Directory -ErrorAction SilentlyContinue | Out-Null

$AppBase64Icon = "iVBORw0KGgoAAAANSUhEUgAAABgAAAAYCAYAAADgdz34AAAABmJLR0QA/wD/AP+gvaeTAAAACXBIWXMAAAs
TAAALEwEAmpwYAAAAB3RJTUUH4AcUDA00KsveZgAABThJREFUSMeNVWtsVFUQ/ubcu3e37+6yZWlpi4oEEFgxYkOiYFu2/qAGBIIJ
BkKCCFUTNZGHhgQJmmAIfxAMIPADIcSQaDC04dVSjUlNoPijDWAREVpo2O37tXufZ/zRW7wtBTnJTc7cnJnJfDPffBSLlSp49DAAe
oL9pON9y6p7Ifdj1xaex/D5VDp7ttb2Rlm8uEIxTYs8/uP6quM8wJg7dXT0pEej0bXMLIiIAXA83nUsGMwe+j9fNwGxz+5DwIyzru
UR+0Pc1d2fBoAikVDSsuwQM+8lIjAP+9u2c0bTfEOJRHeACHLixAm6YZjCk4AASAEQ5rTUyzsFq7SrM/c/c6v4I/+585ccwzBP6bq
x7969eJGUcok3OABIKZe2tycKDcPcp+vmiXi8K+P8+QPWWERo6avFouXZbRn9mdMuATQNYB0Q2/N+XReSasYuAJ1ElMPMvod1Dyez
APQBCLm4X9Y0rSISCSVN03oIl0gGptCCxo3J6dc3zQdzPUARQB7qmbfzH5L2NSIKu8FtAANENMDMNgAfgLCnqSWmaR7r6OgJeHsgL
tb95sy+CZkBA7lDf6wB+B5AsNMnvqvY/bvgWC0A6gG8L4SoZOZKAFUA6rxTRUSSCINSylGTRQVV9dWa1b3hztEV7YUbzpdLobmObA
PcpA7e/ebuiXXHCZDLl1cqAHEolI2mpr/SUil9C4DtLmSdQoiS4uJJramUMdJspvyq+gYCzwK4GqB3/uvPKJ7dIrY/1cyuhnnX1vc
AAt2Zc6mvP+k3TetnZl4EwCLCJiGUaiGoKz8/PGgYFmjyxouVTEq1h3wAyJNhFDGbiZ1TwjF+ajvy5nUAiEaj7zHzd57mg4i2NjU1
7Y7FSlVRkDh9gdh+G8B9AGDFv1cbvD1T+nNXArg9uhKaw6R+6agZDQVVdZcKN16oSE801YCdhmFypL4KdDW/EG5pOjzCL4rFypTa2
npnQRbCeg4mGdnTVrMS2Ap2Lmcmrr/VtuzCDEnq5wBKAMoZZzXdYX/WNq335hUzc8on5JgfAEgQ2x/nd9T8SLFYqVJb+4sTjUa3Mv
PX3lIBbGhubj4MAEXrq6dLJbCCSawEaO7T7EFiawnFYqWKpvkQj3dl2rYzgZmXMPNud87r0tICS7MyA0a4/zIzFDTOOZJraOH5TOo
eADMeXboAgO8BLAGoRQCAaVoUDGYPFRZGWoWg0y5DAWBRKqVv6etP+jOiy9guLsPcvpO99w+9UdN6sHyWr//2GkBeHSbhcCVCmgvb
D5av9ZvxmQAnyNUDAkC9vf0Bw7D2A1jtYSiIqA7ADwBa3F/TmXkVSbtYmL07EuXH1oJ8FQDfyxlonjm19aD+SvMN+UUv5Kh17a7i3
DHB4c756wBSrp0GQGWhQvqDn6nJ+E47Y3IFQIV9WbNPduS8uGIo4wYqXl6ojhKHSGRCyu/X1gK4MkJ/Zu4EYAFQiSiLmbNcHbGIqJ
NJmR1s3PE8iNYD/AAQC9oKN/x+uvTbTL/VycLbdV03xZUrjb2a5qsAcAbgk0KIEiJsHruuiWgzEZUAOC7V9PL2A2VHswf/nKrafS9
F4udeK7v64aCuRUCxWKkAoHhHQNN86OjoCUgpqaAgL9nWFp/iOM7fXtiI6LmiokmtDx50pgPgcDg3JVKdUJ1BMn1B2EoWAGZ1nCEm
07Q4JydTB4BUyhBCULeUtJmZmYiImaGqSo+uG5Sbm5VyFY7gC5LpC7IH9RHJHCVzozQVAOfn5w3U1FzYM0b0VVf0n+QrRyCixwV/j
P3Ub/8F226B2BmGh7QAAAAASUVORK5CYII="

## PROCESS APP ICON FIRST
# Create a streaming image by streaming the base64 string to a bitmap streamsource
$AppBitmap = New-Object System.Windows.Media.Imaging.BitmapImage
$AppBitmap.BeginInit()
$AppBitmap.StreamSource = [System.IO.MemoryStream][System.Convert]::FromBase64String($AppBase64Icon)
$AppBitmap.EndInit()
$AppBitmap.Freeze()
 
#App Title and Icon
$App.Title = $apptitle
$App.Icon = $AppBitmap

# Allow input to window for TextBoxes, etc
[Void][System.Windows.Forms.Integration.ElementHost]::EnableModelessKeyboardInterop($App)

# Make PowerShell Disappear 
If ($Global:LogDebugMode -eq $False){
    $windowcode = '[DllImport("user32.dll")] public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);' 
    $asyncwindow = Add-Type -MemberDefinition $windowcode -name Win32ShowWindowAsync -namespace Win32Functions -PassThru 
    $null = $asyncwindow::ShowWindowAsync((Get-Process -PID $pid).MainWindowHandle, 0) 
}
# Running this without $appContext and ::Run would actually cause a really poor response.
$App.Show()
# This makes it pop up
$App.Activate()

# Force garbage collection just to start slightly lower RAM usage.
[System.GC]::Collect()

# Create an application context for it to all run within.
# This helps with responsiveness, especially when clicking Exit.
$appContext = New-Object System.Windows.Forms.ApplicationContext
[void][System.Windows.Forms.Application]::Run($appContext)