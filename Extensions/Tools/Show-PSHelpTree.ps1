function Add-Node { 
        param ( 
            $selectedNode, 
            $name, 
            $tag 
        ) 
        $newNode = new-object System.Windows.Forms.TreeNode  
        $newNode.Name = $name 
        $newNode.Text = $name 
        $newNode.Tag = $tag 
        $selectedNode.Nodes.Add($newNode) | Out-Null 
        return $newNode 
} 
 
function Get-HelpTree { 
    if ($script:cmdletNodes)  
    {  
          $treeview1.Nodes.remove($script:cmdletNodes) 
        $form1.Refresh() 
    } 
    $script:cmdletNodes = New-Object System.Windows.Forms.TreeNode 
    $script:cmdletNodes.text = "PowerShell Help" 
    $script:cmdletNodes.Name = "PowerShell Help" 
    $script:cmdletNodes.Tag = "root" 
    $treeView1.Nodes.Add($script:cmdletNodes) | Out-Null 
     
    $treeView1.add_AfterSelect({ 
        if ($this.SelectedNode.Tag -eq "Cmdlet") { 
            $helpText = Get-Help $this.SelectedNode.Name -Full 
            $richTextBox1.Text = $helpText | Out-String 
            $linkLabel1.Text = $helpText.relatedLinks.navigationLink[0].uri 
            $form1.refresh() 
        } else { 
            $richTextBox1.Text = "Example to show how to use TreeView control in PowerShell script" 
            $linkLabel1.Text = "http://www.ravichaganti.com/blog" 
        } 
    }) 
     
    #Generate Module nodes 
    $modules = @("Microsoft.PowerShell.Core","Microsoft.PowerShell.Diagnostics","Microsoft.PowerShell.Host","Microsoft.PowerShell.Management","Microsoft.PowerShell.Security","Microsoft.PowerShell.Utility") 
     
    $modules | % { 
        $parentNode = Add-Node $script:cmdletNodes $_ "Module" 
        $moduleCmdlets = Get-Command -Module $_ 
        $moduleCmdlets | % { 
            $childNode = Add-Node $parentNode $_.Name "Cmdlet" 
        } 
    } 
    $script:cmdletNodes.Expand() 
} 
 
#Generated Form Function 
function GenerateForm { 
######################################################################## 
# Code Generated By: SAPIEN Technologies PrimalForms (Community Edition) v1.0.7.0 
# Generated On: 3/2/2010 5:46 PM 
# Generated By: Ravikanth Chaganti (http://www.ravichaganti.com/blog) 
######################################################################## 
 
#region Import the Assemblies 
[reflection.assembly]::loadwithpartialname("System.Windows.Forms") | Out-Null 
[reflection.assembly]::loadwithpartialname("System.Drawing") | Out-Null 
#endregion 
 
#region Generated Form Objects 
$form1 = New-Object System.Windows.Forms.Form 
$linkLabel1 = New-Object System.Windows.Forms.LinkLabel 
$label4 = New-Object System.Windows.Forms.Label 
$label3 = New-Object System.Windows.Forms.Label 
$label2 = New-Object System.Windows.Forms.Label 
$button1 = New-Object System.Windows.Forms.Button 
$richTextBox1 = New-Object System.Windows.Forms.RichTextBox 
$treeView1 = New-Object System.Windows.Forms.TreeView 
$InitialFormWindowState = New-Object System.Windows.Forms.FormWindowState 
#endregion Generated Form Objects 
 
#---------------------------------------------- 
#Generated Event Script Blocks 
#---------------------------------------------- 
#Provide Custom Code for events specified in PrimalForms. 
$button1_OnClick=  
{ 
$form1.Close() 
 
} 
 
$OnLoadForm_StateCorrection= 
{Get-HelpTree 
} 
 
$linkLabel1_OpenLink= 
{ 
    [system.Diagnostics.Process]::start($linkLabel1.text) 
} 
#---------------------------------------------- 
#region Generated Form Code 
$form1.Text = "PowerShell Help Tree" 
$form1.Name = "form1" 
$form1.DataBindings.DefaultDataSourceUpdateMode = 0 
$System_Drawing_Size = New-Object System.Drawing.Size 
$System_Drawing_Size.Width = 838 
$System_Drawing_Size.Height = 612 
$form1.ClientSize = $System_Drawing_Size 
 
 
$linkLabel1.Font = New-Object System.Drawing.Font("Microsoft Sans Serif",9,0,3,0) 
$System_Drawing_Size = New-Object System.Drawing.Size 
$System_Drawing_Size.Width = 539 
$System_Drawing_Size.Height = 23 
$linkLabel1.Size = $System_Drawing_Size 
$linkLabel1.TabIndex = 10 
$linkLabel1.Text = "http://www.ravichaganti.com/blog" 
$System_Drawing_Point = New-Object System.Drawing.Point 
$System_Drawing_Point.X = 253 
$System_Drawing_Point.Y = 541 
$linkLabel1.Location = $System_Drawing_Point 
$linkLabel1.TabStop = $True 
$linkLabel1.DataBindings.DefaultDataSourceUpdateMode = 0 
$linkLabel1.Name = "linkLabel1" 
$linkLabel1.add_click($linkLabel1_OpenLink) 
 
$form1.Controls.Add($linkLabel1) 
 
$label4.TabIndex = 9 
$System_Drawing_Size = New-Object System.Drawing.Size 
$System_Drawing_Size.Width = 136 
$System_Drawing_Size.Height = 23 
$label4.Size = $System_Drawing_Size 
$label4.Text = "Cmdlet Help URI" 
$label4.Font = New-Object System.Drawing.Font("Microsoft Sans Serif",9,1,3,0) 
 
$System_Drawing_Point = New-Object System.Drawing.Point 
$System_Drawing_Point.X = 253 
$System_Drawing_Point.Y = 518 
$label4.Location = $System_Drawing_Point 
$label4.DataBindings.DefaultDataSourceUpdateMode = 0 
$label4.Name = "label4" 
 
$form1.Controls.Add($label4) 
 
$label3.TabIndex = 6 
$System_Drawing_Size = New-Object System.Drawing.Size 
$System_Drawing_Size.Width = 100 
$System_Drawing_Size.Height = 23 
$label3.Size = $System_Drawing_Size 
$label3.Text = "Description" 
$label3.Font = New-Object System.Drawing.Font("Microsoft Sans Serif",9,1,3,0) 
 
$System_Drawing_Point = New-Object System.Drawing.Point 
$System_Drawing_Point.X = 255 
$System_Drawing_Point.Y = 37 
$label3.Location = $System_Drawing_Point 
$label3.DataBindings.DefaultDataSourceUpdateMode = 0 
$label3.Name = "label3" 
 
$form1.Controls.Add($label3) 
 
$label2.TabIndex = 5 
$System_Drawing_Size = New-Object System.Drawing.Size 
$System_Drawing_Size.Width = 177 
$System_Drawing_Size.Height = 23 
$label2.Size = $System_Drawing_Size 
$label2.Text = "PowerShell Help Tree" 
$label2.Font = New-Object System.Drawing.Font("Microsoft Sans Serif",9,1,3,0) 
 
$System_Drawing_Point = New-Object System.Drawing.Point 
$System_Drawing_Point.X = 13 
$System_Drawing_Point.Y = 13 
$label2.Location = $System_Drawing_Point 
$label2.DataBindings.DefaultDataSourceUpdateMode = 0 
$label2.Name = "label2" 
 
$form1.Controls.Add($label2) 
 
$button1.TabIndex = 4 
$button1.Name = "button1" 
$System_Drawing_Size = New-Object System.Drawing.Size 
$System_Drawing_Size.Width = 75 
$System_Drawing_Size.Height = 23 
$button1.Size = $System_Drawing_Size 
$button1.UseVisualStyleBackColor = $True 
 
$button1.Text = "Close" 
 
$System_Drawing_Point = New-Object System.Drawing.Point 
$System_Drawing_Point.X = 253 
$System_Drawing_Point.Y = 577 
$button1.Location = $System_Drawing_Point 
$button1.DataBindings.DefaultDataSourceUpdateMode = 0 
$button1.add_Click($button1_OnClick) 
 
$form1.Controls.Add($button1) 
 
$richTextBox1.Name = "richTextBox1" 
$richTextBox1.Text = "" 
$richTextBox1.DataBindings.DefaultDataSourceUpdateMode = 0 
$System_Drawing_Point = New-Object System.Drawing.Point 
$System_Drawing_Point.X = 255 
$System_Drawing_Point.Y = 61 
$richTextBox1.Location = $System_Drawing_Point 
$System_Drawing_Size = New-Object System.Drawing.Size 
$System_Drawing_Size.Width = 562 
$System_Drawing_Size.Height = 454 
$richTextBox1.Size = $System_Drawing_Size 
$richTextBox1.TabIndex = 1 
 
$form1.Controls.Add($richTextBox1) 
 
$System_Drawing_Size = New-Object System.Drawing.Size 
$System_Drawing_Size.Width = 224 
$System_Drawing_Size.Height = 563 
$treeView1.Size = $System_Drawing_Size 
$treeView1.Name = "treeView1" 
$System_Drawing_Point = New-Object System.Drawing.Point 
$System_Drawing_Point.X = 13 
$System_Drawing_Point.Y = 37 
$treeView1.Location = $System_Drawing_Point 
$treeView1.DataBindings.DefaultDataSourceUpdateMode = 0 
$treeView1.TabIndex = 0 
 
$form1.Controls.Add($treeView1) 
 
#endregion Generated Form Code 
 
#Save the initial state of the form 
$InitialFormWindowState = $form1.WindowState 
#Init the OnLoad event to correct the initial state of the form 
$form1.add_Load($OnLoadForm_StateCorrection) 
#Show the Form 
$form1.ShowDialog()| Out-Null 
 
} #End Function 
 
#Call the Function 
GenerateForm