##*==========================
##* Task manager code - START
##*==========================

function Build-FormProperties {
   param ($device, $anchor, $x, $y, $i, $j, $name, $txt, $ts, $ti)
   $dev = new-object System.Windows.Forms.$device
   if ($anchor -ne $null) { $dev.Anchor = $anchor }
   $dev.Text = $txt
   $dev.Name = $name
   $dev.ClientSize = new-object System.Drawing.Size($i, $j)
   $dev.TabStop = $ts
   $dev.TabIndex = $ti
   $dev.Location = new-object system.drawing.point($x, $y)
   $dev


}

function Build-TskMgrForm {
    param(
        [parameter(Mandatory=$false)]
        [string]$Remote
    )
    ### These are the different assemblies we're using for this.
    [void][system.reflection.assembly]::loadwithpartialname("System.Drawing")
    [void][system.reflection.assembly]::loadwithpartialname("System.ServiceProcess")
    [void][System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") 
    [void][system.reflection.assembly]::loadwithpartialname("System.Collections.IComparer")

    ### A bit about all these hashes. I don't remember how I figured out that hashes are global, and I'm not
    ### sure why they are. It may have something to do with $error being a hash and the need to have it
    ### available everywhere, but that's just speculation. At any rate, I had all this data that needed to be
    ### used in multiple functions, and this seemed like the easiest way at the time. I don't know what impact,
    ### if any, it has on performance. It probably could have been done passing parameters as normal, but
    ### this works well, it makes it very easy to re-initialize things to start over with a new machine, and
    ### it hasn't brought any host machine to its knees (yet).
    $keyhash = @{}
    $hash = @{}
    $pointhash = @{}
    $parms = @{}
    $beforeprocs = @{}
    $things = @{}
    #initialize-things

    ################################
    ### This is a string for the custom comparer class that I copied from a MS article
    ### at http://msdn.microsoft.com/en-us/library/ms996467.aspx. I had read that you
    ### could do this, and you can imagine my surprise at how well it works.
    $ccs = @"
using System;
using System.Collections;
using System.Windows.Forms;

public class ListViewItemComparer : IComparer {
  private int col;
  private SortOrder order;
  public ListViewItemComparer() {
      col=0;
      order = SortOrder.Ascending;
  }
  public ListViewItemComparer(int column, SortOrder order) 
  {
      col=column;
      this.order = order;
  }
  public int Compare(object x, object y) 
  {
      int returnVal= -1;
      returnVal = String.Compare(((ListViewItem)x).SubItems[col].Text, ((ListViewItem)y).SubItems[col].Text);
      if (order == SortOrder.Descending)
          returnVal *= -1;
      return returnVal;
  }
}
"@

### A similar class to use for comparing columns of integers so they don't get compared as strings.
$cci = @"
using System;
using System.Collections;
using System.Windows.Forms;

public class ListViewItemIntComparer : IComparer {
  private int col;
  private SortOrder order;
  public ListViewItemIntComparer() {
      col = 0;
      order = SortOrder.Ascending;
  }
  public ListViewItemIntComparer(int column, SortOrder order) 
  {
      col = column;
      this.order = order;
  }
  public int Compare(object x, object y) 
  {
      int returnVal = -1;
      int ix = int.Parse(((ListViewItem)x).SubItems[col].Text);
      int iy = int.Parse(((ListViewItem)y).SubItems[col].Text);
      returnVal = ix.CompareTo(iy);
      if (order == SortOrder.Descending)
         returnVal *= -1;
      return returnVal;
  }
}
"@

    ### Add the comparer class
    Add-Type $ccs -ReferencedAssemblies ('System.Windows.Forms')
    Add-Type $cci -ReferencedAssemblies ('System.Windows.Forms')

    ### Start it up.



    $tskmgr = Build-FormProperties "Form" $null 773 826 $null $null "TMgr" "TMgr" $true 0
    $server_TextBox = Build-FormProperties "TextBox" "Left, Top" 100 9 160 40 "server_TextBox" "$Remote" $true 0
    $server_Label = Build-FormProperties "Label" "Left, Top" 9 9 80 20 "Server_Label" "Server Name:" $false 0
    $Tabcntl = Build-FormProperties "TabControl" "Left, Top, Right, Bottom" 9 30 730 700 "" "" $false 1
    $Tab1 = new-object System.Windows.Forms.TabPage
    $Server_Button = Build-FormProperties "Button" "Left, Top" 265 5 100 40 "Server_Button" "Get Processes" $false 3
    $Quit_Button = Build-FormProperties "Button" "Left, Top" 638 5 100 40 "Quit_Button" "Quit" $false 4
    $Stop_Button = Build-FormProperties "Button" "Left, Top" 533 5 100 40 "Stop_Button" "Pause" $false 5
    $TB = Build-FormProperties "TrackBar" "Bottom, Left" 400 743 300 40 "tb" $null $false 0
    $TB_Label1 = Build-FormProperties "Label" "Bottom, Left" 410 783 20 23 "tb_Label1" "0" $false 0
    $TB_Label2 = Build-FormProperties "Label" "Bottom, Left" 525 783 60 23 "tb_Label2" "milliseconds" $false 0
    $TB_Label3 = Build-FormProperties "Label" "Bottom, Left" 680 783 30 23 "tb_Label3" "8000" $false 0
    $ServerTime_Label = new-object System.Windows.Forms.Label
    $Status_Label = Build-FormProperties "Label" "Bottom, Left" 9 743 $null $null "Status_Label" $null $false 0
    $Procs_Label = Build-FormProperties "Label" "Bottom, Left" 9 766 $null $null "Procs_Label" $null $false 0
    $SDG = Build-FormProperties "ListView" "Left, Top, Right, Bottom" 0 0 600 600 "" "" $true 1
    $LV= Build-FormProperties "ListView" "Left, Top, Right, Bottom" 0 0 600 600 "" "" $true 1
    $new_LB = new-object System.Windows.Forms.ListBox
    $Drawing_Panel = Build-FormProperties "PictureBox" "Left, Top, Right, Bottom" 0 0 551 683 "pictureBox" "" $false 1
    $Picture_Container = Build-FormProperties "Panel" "Left, Top, Right, Bottom" 34 40 600 600 "" "" $true 0
    $InitialFormWindowState = new-object System.Windows.Forms.FormWindowState
    $lblfont = new-object system.Drawing.Font("Verdana", 6)

    ### $tskmgr
    $tskmgr.TopMost=$true
    $tskmgr.DataBindings.DefaultDataSourceUpdateMode = 0
    #$icon = "\\nas3it06\dba\scripts\powershell\bin\icon1.ico"
    #$tskmgr.icon = $icon

    ### $Server_Label
    $Server_Label.RightToLeft = [System.Windows.Forms.RightToLeft]::Yes

    ### $ServerTime_Label
    $ServerTime_Label.name = "ServerTime_Label"

    ### $server_TextBox
    $server_TextBox.Add_KeyDown({if ($_.KeyCode -eq "Enter") { do-it-to-it }})

    ### This sets up sorting for a clicked column. The first IF determines if this is the
    ### same column that was clicked last time. If not, it sets the order to descending so
    ### that the next IF will reset it to ascending (the default for a new column click).
    $columnClick = {
   	    if ($things["LVCols"] -ne $_.Column) {
            $things["LVCols"] = $_.Column
            $LV.Sorting = [System.Windows.Forms.SortOrder]::Ascending
        }
        if ($LV.Sorting -eq [System.Windows.Forms.SortOrder]::Descending) {
            $LV.Sorting = [System.Windows.Forms.SortOrder]::Ascending
        } else {
            $LV.Sorting = [System.Windows.Forms.SortOrder]::Descending
        }
        if (($_.Column -eq 0) -OR ($_.Column -eq 2)) {
            $LV.ListViewItemSorter = new-object ListViewItemComparer($_.Column, $LV.Sorting)
        } else {
            $LV.ListViewItemSorter = new-object ListViewItemIntComparer($_.Column, $LV.Sorting)
        }
    }

    ### Same as above but for the services page.
    $SDGcol_Click = {
   	    if ($things["SDGCols"] -ne $_.Column) {
            $things["SDGCols"] = $_.Column
            $SDG.Sorting = [System.Windows.Forms.SortOrder]::Descending
        }
        if ($SDG.Sorting -eq [System.Windows.Forms.SortOrder]::Descending) {
            $SDG.Sorting = [System.Windows.Forms.SortOrder]::Ascending
        } else {
            $SDG.Sorting = [System.Windows.Forms.SortOrder]::Descending
        }
        $SDG.ListViewItemSorter = new-object ListViewItemComparer($_.Column, $SDG.Sorting)
    }

    ### This sets up the context menu for a selected item on the services page.
    $row_click = { set-context-menu }

    ### $SDG (the listview that shows the services)
    $SDG.AllowColumnReorder = "True"
    $SDG.Dock = "Fill"
    $SDG.FullRowSelect = "True"
    $SDG.View = "Details"
    $SDG.MultiSelect = $false
    $SDG.Columns.Add("Name", "Display Name", 100) | out-null
    $SDG.Columns.Add("SvcName", "Service Name", 100) | out-null
    $SDG.Columns.Add("Description", "Description", 80) | out-null
    $SDG.Columns.Add("Status", "Status", 60) | out-null
    $SDG.Columns.Add("Startup_Type", "Startup Type", 80) | out-null
    $SDG.Columns.Add("Log_On_As", "Log On As", 100) | out-null
    $SDG.Parent = $Tab3
    $SDG.FullRowSelect = $true
    $SDG.Add_ColumnClick($SDGcol_Click)
    $SDG.Add_ItemSelectionChanged($row_click)

    ### Build the context menu for the processes tab
    $svcs_CM = new-object System.Windows.Forms.ContextMenuStrip
    ### The menu options
    $svc_props = new-object System.Windows.Forms.ToolStripMenuItem -ArgumentList "Properties"
    $svcs_CM.Items.Add($svc_props) | out-null

    ### Set the actions for when each of the options is selected
    $svc_props_click = {
        $blanks = ""
        for ($i = 0; $i -lt 27; $i++) { $blanks += " " }
        foreach ($si in $SDG.SelectedItems) {
            $props = (Get-WmiObject win32_service -computer $things["machine"] -filter ("name='" + $si.subitems[1].Text + "'")).properties | select-object -property name,value | ft -auto | out-string
        }

        Display-PropertiesPopup $props
    }

    $svc_props.Add_Click($svc_props_click)

    $SDG.ContextMenuStrip = $svcs_CM

    ### $LV (the listview displaying the processes)
    $LV.AllowColumnReorder = "True"
    $LV.Dock = "Fill"
    $LV.FullRowSelect = "True"
    $LV.View = "Details"
    $LV.MultiSelect = $false
    $LV.Columns.Add("Image_Name", "Image Name", 200) | out-null
    $LV.Columns.Add("PID", "PID", 50) | out-null
    $LV.Columns.Add("User_Name", "User Name", 200) | out-null
    $LV.Columns.Add("CPU", "CPU", 50) | out-null
    $LV.Columns.Add("Mem_Usage", "Memory Usage", 100) | out-null
    $LV.Parent = $LVP
    $LV.FullRowSelect = $true
    $LV.Add_ColumnClick($columnClick)

    ### Build the context menu for the processes tab
    $procs_CM = new-object System.Windows.Forms.ContextMenuStrip

    $end_proc = new-object System.Windows.Forms.ToolStripMenuItem -ArgumentList "End Process"
    $proc_props = new-object System.Windows.Forms.ToolStripMenuItem -ArgumentList "Properties"

    $procs_CM.Items.Add($end_proc) | out-null # Add option to context menu 
    $procs_CM.Items.Add($proc_props) | out-null
    $end_proc_click = ({
        foreach ($si in $LV.SelectedItems) {
            $Status_Label.text = "Killing process " + $si.subitems[1].text + " (" + $si.subitems[0].text + ") ..."
            $thing = Get-WmiObject win32_process -computer $things["machine"] -filter ("handle='" + $si.subitems[1].Text + "'")
            $thing.terminate()
            $Status_Label.text += " Stopped"
        }
    })

    $proc_props_click = ({
        $props = ""
        foreach ($si in $LV.SelectedItems) {
            #$props = Get-WmiObject win32_process -computer $things["machine"] -filter ("handle='" + $si.subitems[1].Text + "'") | out-string
            $props = Get-WmiObject Win32_PerfFormattedData_PerfProc_Process -computer $things["machine"] -filter ("idprocess='" + $si.subitems[1].Text + "'") | out-string
        }

        Display-PropertiesPopup $props
    })

    $end_proc.Add_Click($end_proc_click) 
    $proc_props.Add_Click($proc_props_click) 

    $LV.ContextMenuStrip = $procs_CM

    $pcs = {
        if ($_.scrollorientation -eq "HorizontalScroll") {
        $Picture_Container.horizontalscroll.value = $_.newvalue
        } else {
        $Picture_Container.verticalscroll.value = $_.newvalue
        }
    }

    ### After about 15 days of screwing around, I finally figured out that in order to get this to work
    ### correctly with the picturebox, we can't set anything on AutoScrollMargin right here. We HAVE to
    ### wait until we figure out how big the bitmap will be and then set it. I don't really care how big it is
    ### just as long as it's big enough to display everything, so when we do get around to setting the size,
    ### it's actually much bigger than it needs to be. Maybe someday I'll get around to sizing it correctly,
    ### but probably not. It works, and that's what I care about.
    $Picture_Container.AutoScroll = $true
    $Picture_Container.AutoScrollPosition = new-object system.drawing.point(0, 0)
    $Picture_Container.Anchor = "Left, Top, Right, Bottom"
    $Picture_Container.BackColor = "black"
    $Picture_Container.BorderStyle = "Fixed3D"
    $Picture_Container.add_scroll($pcs)
    $Picture_Container.Controls.Add($new_LB)
    $Picture_Container.Controls.Add($Drawing_Panel)

    ### $new_LB
    ### I don't remember where I found out about this. It seems that you can't get a scrollbar to just appear
    ### on a panel device. There are only certain things that will allow a scrollbar to be added. A listbox is
    ### one of those things. This does nothing except activate the scrollbar on $Picture_Container.
    $new_LB.Location = new-object system.drawing.point(210, 203)
    $new_LB.Size = new-object System.Drawing.Size(0, 0)

    ### $Drawing_Panel
    $Drawing_Panel.BackColor = "Black"
    $Drawing_Panel.sizemode = "Autosize"

    $TB.Orientation = "Horizontal"
    $TB.smallchange = 1
    $TB.largechange = 100
    $TB.TickFrequency = 1000
    $TB.TickStyle = "BottomRight"
    $TB.SetRange(0, 8000)
    $TB.visible = $false
    $TB.add_ValueChanged({
        Stop-timer
        if ($TB.value -lt 500) { $TB.value = 500 }   ### Don't let it fire off faster than twice a second... that would just be silly
        $things["timer"].interval = $TB.value
        update-Procs_Label
        Restart-timer
    })

    $TB_Label1.font = $lblfont
    $TB_Label2.font = $lblfont
    $TB_Label3.font = $lblfont
    $TB_Label1.visible = $false
    $TB_Label2.visible = $false
    $TB_Label3.visible = $false

    ### $Tabcntl
    $Tabcntl.Controls.Add($Tab1)



    ### $Tab<x>
    $Tab1.Text = "Processes"
    $Tab1.Size = new-object System.Drawing.Size(721,670)
    $Tab1.Controls.Add($LV)

    ### $Procs_Label
    $Procs_Label.RightToLeft = [System.Windows.Forms.RightToLeft]::Yes
    $Procs_Label.AutoSize = $true

    ### $Status_Label
    $Status_Label.AutoSize = $true

    $btnfont =  new-object System.Drawing.Font("Microsoft Sans Serif", 8.25, [System.Drawing.FontStyle]::Bold)
   
    ### $Quit_Button
    $Quit_Button.Font = $btnfont
    $Quit_Button.UseVisualStyleBackColor = 1
    $Quit_Button.add_click( { Stop-stuff } )

    ### $Stop_Button
    $Stop_Button.Font = $btnfont
    $Stop_Button.UseVisualStyleBackColor = 1
    $Stop_Button.add_click( { Stop-timer } )
    ### $Server_Button
    ### This is kind of superfluous because if you type the name of the machine in $server_TextBox and hit Enter,
    ### it performs the same action, but not everyone is smart enough to figure that out.
    $Server_Button.Font = $btnfont
    $Server_Button.UseVisualStyleBackColor = 1
    $Server_Button.add_click( { do-it-to-it } )


    ### Add all the crap we just created to $tskmgr
    $tskmgr.Size = new-object System.Drawing.Size(773, 826)
    $tskmgr.Controls.Add($TB)
    $tskmgr.Controls.Add($TB_Label1)
    $tskmgr.Controls.Add($TB_Label2)
    $tskmgr.Controls.Add($TB_Label3)
    $tskmgr.Controls.Add($server_Label)
    $tskmgr.Controls.Add($server_TextBox)
    $tskmgr.Controls.Add($Server_Button)
    $tskmgr.Controls.Add($Quit_Button)
    $tskmgr.Controls.Add($Stop_Button)
    $tskmgr.Controls.Add($Status_Label)
    $tskmgr.Controls.Add($Procs_Label)
    $tskmgr.Controls.Add($Tabcntl)
    $tskmgr.ResumeLayout($false)

    ######################
    ### Save the initial state of the form, then initialize the OnLoad event to correct the initial state of the form.
    $InitialFormWindowState = $tskmgr.WindowState
    $tskmgr.add_Load($OnLoadForm_StateCorrection)
    ### Display the window
    $tskmgr.ShowDialog()| Out-Null;
    $tskmgr.Show()
    $tskmgr.TopMost = $true    ### Comment out this line if you don't want it on top all the time.
    $tskmgr.Refresh()
    $tskmgr.BringToFront()
    $tskmgr.Select()
    $server_TextBox.Select()
}

function initialize-stuff {
    ### Basically just an initialization routine for the hashes and the drawing objects.
    $server = $things["machine"]
    update-Status_Label "Initializing server information..."
    $Status_Label.update()
    #$available = load-os-info $server
    update-Status_Label "Initializing processes..."

    $ysize = 0
    $procs = return-win32_perfrawdata_perfproc_process $server
    foreach ($proc in $procs) {
        if ($proc.IDProcess -eq 0) {
            $beforeprocs[0] = $proc.percentprocessortime
        } else {
            $beforeprocs.Add($proc.IDProcess, $proc.percentprocessortime)
        }
    }

    update-Status_Label "Initializing CPU..."
    $t1 = return-win32_PerfRawData_PerfOS_processor $server
    $ch = new-object system.drawing.drawing2d.HatchBrush((gen-hatch), $things["colors"][1], $things["colors"][2])

    update-Status_Label "Initializing graphics..."
    $orderarray = @()
    foreach ($cpu in $t1) { $orderarray += $cpu.name }
    $y = 100
    $x = -550
    $counter = 0
    for ($j = 0; $j -lt $orderarray.count; $j++) {
        $t = ""
        $key = $orderarray[$j]
        foreach ($bob in $t1) { if ( $bob.Name -eq $key ) { $t = $bob } }
        if (($counter % 8) -eq 0) {
            $y = 100
            $x += 600
            $xstrpt = $x - 50
        }
        $keyhash.Add($key, @($t.percentprocessortime, $t.timestamp_sys100ns))
        $pointhash.Add($key, @())
        $ysize += 105
        $rect = new-object system.drawing.rectangle(($x + 1), ($y - 100), 500, 99)
        $point = new-object system.drawing.pointf(($x - 50), ($y - 15))
        $point2 = new-object system.drawing.pointf(($x - 50), ($y - 50))
        $parms.Add($key, @($x, $y, 0.0, $rect, $ch, $point, $point2))
        $points = @(new-object system.drawing.point($x, $y))
        $hash.Add($key, @())
        $y = $y + 100
        $counter++
    }
    $keyhash.Add("Memory", @(0.0, 0.0))
    $pointhash.Add("Memory", @())
    $hash.Add("Memory", @())
    $xsize = [int32]((($counter/8) + 1) * 575)
    if ($ysize -gt 500) { $ysize = 500 }

    #### Memory
    if ((($counter % 8) -eq 0) -OR (($y + 300) -gt 900)) {
        $y = 100
        $x += 600
        $xstrpt = $x - 50
    } else { $ysize += 300 }
    $rect = new-object system.drawing.rectangle(($x + 1), $y, 500, 199)
    $y += 200
    $ystrpt = $y - 15
    $point = new-object system.drawing.pointf(($x - 50), ($y - 15))
    $xstrpt = $x - 50
    $ystrpt = $y - 50
    $point2 = new-object system.drawing.pointf(($x - 50), ($y - 50))
    $point3 = new-object system.drawing.pointf(($x - 50), ($y - 70))
    $parms.Add("Memory", @($x, $y, 0.0, $rect, $ch, $point, $point2, 0.0, $point3))

    update-Status_Label "Updating CPU..."
    get-allCPU
    $parms.Add("Bitmap", @($xsize, $ysize))
    $Picture_Container.AutoScrollMargin = new-object System.Drawing.Size($xsize, $ysize)
    update-Status_Label ""
    $TB.visible = $true
    $TB_Label1.visible = $true
    $TB_Label2.visible = $true
    $TB_Label3.visible = $true
}

### I wanted to make sure the clock on remote machine is synced. This just lets you check with your local time.
function update-serverdatetime {
    $server = $things["machine"]
    $ServerTime_Label.Text = "Current Server Time:         " + [Management.ManagementDateTimeConverter]::ToDateTime((Get-WmiObject -Class Win32_OperatingSystem -ComputerName $server).localdatetime)
}

### Make a popup window to display properties for either a process or a service. I tried using a PropertyGrid, but
### it never displayed the services satisfactorily.
function Display-PropertiesPopup {
    param ($msg)
    $PropertiesBox = new-object System.Windows.Forms.Form
    $PB_TextBox = new-object System.Windows.Forms.TextBox
    $Cancel_Button = new-object System.Windows.Forms.Button
    $PropertiesBox.cancelbutton = $Cancel_Button

    $PB_TextBox.Anchor = "Left, Top, Right, Bottom"
    $PB_TextBox.Location = new-object system.drawing.point(0, 0)
    $PB_TextBox.font = new-object System.Drawing.Font("Courier New", 8.25, [System.Drawing.FontStyle]::Bold)
    $PB_TextBox.Name = "myMB_TextBox"
    $PB_TextBox.multiline = $true
    $PB_TextBox.Text = ""
    $PropertiesBox.Controls.Add($PB_TextBox)
    $Cancel_Button.add_click( { $PropertiesBox.close(); $PropertiesBox.dispose(); } )
    $array = $msg.split("`n")
    $count = $array.count
    $w = 0
    foreach ($line in $array) { if ($line.length -gt $w) { $w = $line.length } }
    $height = $count * 14.0
    $width = $w * 8.25
    $PropertiesBox.ClientSize = new-object System.Drawing.Size($width, $height)
    $PB_TextBox.ClientSize = new-object System.Drawing.Size($width, $height)
    $PB_TextBox.text = $msg
    $IFWS = new-object System.Windows.Forms.FormWindowState
    $IFWS = $PropertiesBox.WindowState
    $PropertiesBox.TopMost=$true
    $PropertiesBox.Refresh() 
    $PropertiesBox.BringToFront()
    $PropertiesBox.add_Load($OnLoadForm_StateCorrection)
    $PropertiesBox.ShowDialog()| Out-Null;
}

function dsize {
    param ($dsize)
    $size = ""
    if ($dsize -ge 1073741824) { $size = [Math]::round($dsize / 1gb,2).tostring() + " GB" }
    elseif ($dsize -ge 1048576) { $size = [Math]::round($dsize / 1mb,2).tostring() + " MB" }
    elseif ($dsize -ge 1024) { $size = [Math]::round($dsize / 1kb,2).tostring() + " KB" }
    else { $size = $dsize.tostring() + " B" }
    $size
}

function kbytes {
    param ($dsize)
    [Math]::round($dsize / 1kb,2)
}

### Return a formatted datetime MM/DD/YYYY hh:mm:ss
filter return-datetime {
    ([datetime] ($_.substring(4,2) + "/" + $_.substring(6,2) + "/" + $_.substring(0, 4) + " " + $_.substring(8,2) + ":" + $_.substring(10,2) + ":" + $_.substring(12,2))).tostring().trimend()
}

### This started out as a grid, but for some reason there were performance problems with that, so it was turned
### into a ListView.
function get_processes {
    param ($update)
    ### Loads and updates the $LV listview on $Tab1.
    $server = $things["machine"]
    $procs = return-win32_perfrawdata_perfproc_process $server
    $idle = $cpu = $totalcpu = $totalcpuUsed = 0
    $procs | % { if ($_.name -eq "_Total") { $totalcpu = [long]$_.percentprocessortime - [long]$beforeprocs[$_.IDProcess] } }
    if ($update -eq $false) {
        $LV.items.clear()
        $users = @{}
        Get-WmiObject win32_process -computer $server | % { $users.Add($_.ProcessID, ($_.getowner()).user) }
    }

    drop-dead-procs $procs
    if ($update -eq $false) { $LV.BeginUpdate() }
    foreach ($proc in $procs) {
        $idproc = $proc.IDProcess
        if ($proc.Name -eq "Idle") {
            $idle = kbytes $proc.WorkingSet
            if ($update -eq $false) { make_listviewitem $proc $null }
        } elseif ($proc.Name -ne "_Total") {
            if ($update -eq $false) {
            $cpu = pcnt_cpu $proc.percentprocessortime $beforeprocs[$idproc] $totalcpu
            $totalcpuUsed += $cpu
            make_listviewitem $proc $users[$idproc]
            }
            elseif ($beforeprocs[$idproc] -eq $null) {
            ### If this is a new process, create a ListViewItem for it.
            $beforeprocs.Add($idproc, $proc.percentprocessortime)
            $cpu = 0
            make_listviewitem $proc (Get-WmiObject win32_process -computer $server -filter ("ProcessID='" + $idproc + "'") | % { ($_.getowner()).user })
            } else {
            ### Otherwise, just calculate the CPU for it.
            $cpu = pcnt_cpu $proc.percentprocessortime $beforeprocs[$idproc] $totalcpu
            $totalcpuUsed += $cpu
            }
            ### Update the memory and CPU for the process in its ListView entry
            $indx = $LV.FindItemWithText($idproc).index
            $LV.Items[$indx].SubItems[3].Text = [int32]($cpu)
            $LV.Items[$indx].SubItems[4].Text = kbytes $proc.WorkingSet
        }
        $beforeprocs[$idproc] = $proc.percentprocessortime
    }
    $indx = $LV.FindItemWithText("Idle").index
    $cpu = [int32](100 - $totalcpuUsed)
    $LV.Items[$indx].SubItems[3].Text = [int32]($cpu)
    $LV.Items[$indx].SubItems[4].Text = $idle
    if ($update -eq $false) { $LV.EndUpdate() }
    $LV.refresh()
    $things["procs"] = ($procs.count - 1)
    $things["cpu"] = [int32]$totalcpuUsed
    update-Procs_Label
    update-serverdatetime $server
    if ($things["LVCols"] -ne $null) {
        if (($things["LVCols"] -eq 0) -OR ($things["LVCols"] -eq 2)) {
            $LV.ListViewItemSorter = new-object ListViewItemComparer($things["LVCols"], $LV.Sorting)
        } else {
            $LV.ListViewItemSorter = new-object ListViewItemIntComparer($things["LVCols"], $LV.Sorting)
        }
    }

    }

function make_listviewitem {
    param ($proc, $user)
    $idproc = $proc.IDProcess
    $lvi = new-object system.windows.forms.ListViewItem($proc.Name)
    $lvi.SubItems.Add($idproc)
    if ($user -eq $null) { $user = "SYSTEM" }
    $lvi.SubItems.Add($user)
    $lvi.SubItems.Add(0)
    $mem = kbytes $proc.WorkingSet
    $lvi.SubItems.Add($mem)
    $LV.Items.Add($lvi)
    }

    ### Figure out which processes are no longer running and remove them from the ListView.
function drop-dead-procs {
    param ($procs)
    $temp = @{}
    foreach ($idproc in $beforeprocs.Keys) {
        $found = $false
        foreach ($proc in $procs) { if ($proc.IDProcess -eq $idproc) { $found = $true } }
        if ($found -eq $false) { $temp.Add($idproc, 0) }
    }
    foreach ($procid in $temp.Keys) {
            $indx = $LV.FindItemWithText($procid).index
            $LV.Items[$indx].Remove()
            $beforeprocs.Remove($procid)
    }
    }

    ### CPU percentage calculation. I picked this up from an article on SQL server long ago. It seems to be the
    ### same one used for the OS.
function pcnt_cpu {
    (([long]$args[0] - [long]$args[1]) / [system.double]$args[2]) * 100
    }

    ### These two functions get their data depending on how new the OS is. In the most recent version of Task Manager,
    ### it uses WorkingSetPrivate (that's the default) for the memory, but that isn't a property on older versions.
    ### Whether it's available or not is determined during initialization.
function return-Win32_PerfFormattedData_PerfProc_Process {
    param ($server)
    if ($things["wsp"]) {
        Get-WmiObject -query "select idprocess, name, workingsetprivate, percentprocessortime from Win32_PerfFormattedData_PerfProc_Process" -computer $server |
            select-object -property idprocess, name, @{expression={$_.workingsetprivate};name="workingset"}, percentprocessortime
    } else {
        Get-WmiObject -query "select idprocess, name, workingset, percentprocessortime from Win32_PerfFormattedData_PerfProc_Process" -computer $server
    }
    }

function return-win32_perfrawdata_perfproc_process {
    param ($server)
    if ($things["wsp"]) {
        Get-WmiObject -query "select idprocess, name, workingsetprivate, percentprocessortime from win32_perfrawdata_perfproc_process" -computer $server |
            select-object -property idprocess, name, @{expression={$_.workingsetprivate};name="workingset"}, percentprocessortime
    } else {
        Get-WmiObject -query "select idprocess, name, workingset, percentprocessortime from win32_perfrawdata_perfproc_process" -computer $server
    }
    }

function return-win32_Service {
    Get-WmiObject -query "select name, displayname, description, state, startmode, startname from win32_Service" -computer $things["machine"] | Sort-Object -property displayname
    }

function return-win32_PerfRawData_PerfOS_processor {
    Get-WmiObject -query "select name, percentprocessortime, timestamp_sys100ns from win32_PerfRawData_PerfOS_processor" -computer $things["machine"]
    }

function get-allCPU {
    ### This calculates the CPU for the individual processors and adds them into $hash.
    $server = $things["machine"]
    $p2 = return-win32_PerfRawData_PerfOS_processor $server
    for ($i = 0; $i -lt $p2.length; $i++) {
        $key = $p2[$i].Name
        $cpu = 100.0  - (pcnt_cpu $p2[$i].percentprocessortime $keyhash[$key][0] ([system.double]$p2[$i].timestamp_sys100ns - [system.double]$keyhash[$key][1]))
        $count = $hash[$key].count
        if ($cpu -lt 0.0) { $cpu = 0.0 }
        $x = ($count*5)+$parms[$key][0]
        $y = $parms[$key][1] - $cpu
        $parms[$key][2] = $cpu
        $point = new-object system.drawing.point($x, $y)
        $pointhash[$key] += $y
        $hash[$key] += $point
        $keyhash[$key] = @([system.double]$p2[$i].percentprocessortime, [system.double]$p2[$i].timestamp_sys100ns)
    }
   
    ##### Memory
    $tpm = (get-wmiobject win32_computersystem -computer $server).totalphysicalmemory
    $avb = (gwmi Win32_PerfRawData_PerfOS_Memory -computer $server).availablebytes
    $newy = (1 - ( [system.double]$avb / [system.double]$tpm )) * 200
    $count = $hash["Memory"].count
    $x = ($count*5) + $parms["Memory"][0]
    $y = $parms["Memory"][1] - $newy
    $parms["Memory"][2] = $newy / 2
    $parms["Memory"][7] = [system.double]$tpm - [system.double]$avb
    $point = new-object system.drawing.point($x, $y)
    $pointhash["Memory"] += $y
    $hash["Memory"] += $point
    }

function Plot {
    ### Draw the pretty pictures of CPU and Memory usage
    param ($old_btmp)
    if ($old_btmp -ne $null) { $old_btmp.Dispose() }
    $btmp = new-object system.drawing.bitmap($parms["Bitmap"][0], $parms["Bitmap"][1])
    $grfx = [system.drawing.graphics]::fromimage($btmp)

    ### Coordinates drawing the graphs for the CPU and memory.
    $orderarray = build-order
    $pen =  new-object system.Drawing.pen((new-object system.Drawing.SolidBrush($things["colors"][3])))
    $pen.Width=1
    build-axes $grfx
    for ($i = 0; $i -lt $orderarray.count; $i++) {
        $key = $orderarray[$i]
        $grfx.DrawLines($pen, $hash[$key])
    }
    $Drawing_Panel.image = $btmp
    $grfx.Dispose()
    $pointhash = shift-arrays $pointhash
    reload-points
    $error.clear()
    $btmp
    }

function reload-points {
    ### This may seem like a lot of trouble for nothing, but if you go ahead and turn everything into drawing points and
    ### store them in an array to pass into DrawLines, it works much more smoothly than passing the coordinates into
    ### DrawLine one at a time and having it do the conversion. Take my word for it, watching it draw a bunch of line
    ### segments one at a time is entertaining as hell, but this gives better performance.
    $pts = @{}
    foreach ($key in $keyhash.Keys) { $points = @(new-object system.drawing.point($parms[$key][0], $pointhash[$key][0])); $pts.Add($key, $points) }
    for ($i = 1; $i -lt $pointhash["_Total"].count; $i++) {
        $x = ($i*5)
        foreach ($key in $keyhash.Keys) {
            $pts[$key] += new-object system.drawing.point(($x+$parms[$key][0]), $pointhash[$key][$i])
        }
    }
    foreach ($key in $keyhash.Keys) { $hash[$key] = $pts[$key] }
    $pts = $null
    }

    ### We only maintain 100 sets of data for each CPU and the memory. When the array gets to 100, we
    ### pop off the top one and the new one gets added to the end.
function shift-arrays ($myhash) {
    if ($myhash["_Total"].length -ge 100) {
        foreach ($key in $keyhash.Keys) {
            $null, $myhash[$key] = $myhash[$key]
        }
    }
    $myhash
    }

    ### Generate the hatch for each CPU and the memory.
function gen-hatch {
    $hatch = new-object system.drawing.drawing2d.hatchstyle
    $hatch = "max"
    $hatch
    }

    ### Probably not needed, but I want to make sure that the CPUs are ordered numerically. It just makes things neater.
function build-order {
    $count = $keyhash.count
    $count = $count - 1
    $orderarray = @(0..$count)
    for ($i = 0; $i -lt $count-1; $i++) { $orderarray[$i] = [system.string]$i }
    $orderarray[$count-1] = "_Total"
    $orderarray[$count] = "Memory"
    $orderarray
    }

function build-axes {
    param ($grfx)
    ### The various drawing surfaces for each processor and memory are stored in the $parms hash. That
    ### way we don't have to keep recalculating them for each refresh.
    $orderarray = build-order
    $mypen =  new-object system.Drawing.pen((new-object system.Drawing.SolidBrush($things["colors"][0])))
    $mypen.Width = 2
    $font = new-object system.Drawing.Font("Verdana", 8)
    $brush = new-object system.drawing.solidbrush($things["colors"][0])
    $y = $add = 100
    $x = -550
    $xstrpt = $x - 50
    for ($i = 0; $i -lt $orderarray.count; $i++) {
        $key = $orderarray[$i]
        $x = $parms[$key][0]
        $y = $parms[$key][1]
        if ($key -eq "Memory") { $add = 200 }
        $grfx.FillRectangle($parms[$key][4], $parms[$key][3])
        $grfx.Drawline($mypen, $x, $y, $x, $y - $add)
        $grfx.Drawline($mypen, $x, $y, $x + 500, $y)
        $grfx.DrawString($key, $font, $brush, $parms[$key][5])
        $pct = "{0:#.##}%" -f $parms[$key][2]
        $grfx.DrawString($pct, $font, $brush, $parms[$key][6])
    }
    $newgb = "{0:#.##}GB" -f ($parms["Memory"][7] / 1gb)
    $grfx.DrawString($newgb, $font, $brush, $parms["Memory"][8])

    }

    ### Update and append the $Status_Label.
function append-Status_Label {
    $Status_Label.text += $args[0]
    $Status_Label.update()
    }

function update-Status_Label {
    $Status_Label.Text = $args[0]
    $Status_Label.update()
    }

function update-Procs_Label {
    $Procs_Label.Text = "Updating every " + $things["timer"].interval.ToString() + " ms -- Processes: " + ($things["procs"]).ToString() + "  |  CPU Usage: " + ($things["cpu"]).ToString() + "%"
    }

    ### Called when the "Pause"/"Restart" button is pushed.
function Restart-timer {
    $Stop_Button.Text = "Pause"
    $Stop_Button.add_click( { Stop-timer } )
    $things["timer"].Enabled = $true
    $things["timer"].Start()
    }

function Stop-timer {
    $things["timer"].Enabled = $false
    $things["timer"].Stop()
    $Stop_Button.Text = "Restart"
    $Stop_Button.add_click( { Restart-timer } )
    }

    ### Try to shut down in an orderly fashion. Called when the "Quit" button is pressed.
function Stop-stuff {
    Stop-timer
    $things["timer"].Dispose()
    $tskmgr.close()
    #[environment]::exit(0)
    #[System.Windows.Forms.Application]::Exit($tskmgr)
    }


function GetStatus {
    param ($service, $check_status)
    ### This is supposed to sit and wait until a service has been stopped or started. It tests the
    ### service status until it matches what we want it to be. If it hasn't done what we requested
    ### after 30 seconds, we flag an error and go on.
    $server = $things["machine"]
    $counter = 0
    $results = 1
    $test_status = (get-wmiobject -query ("select * from win32_service where name = '" + $service + "'") -computer $server).State
    ### The thinking behind this is that if it can't kill the service withing 30 seconds, it isn't going to die. So
    ### we won't leave ourself hanging out in here. We'll just flag an error and go on with this tedium we call life.
    while (($check_status -ne $test_status) -AND ($counter -lt 60)) {
        start-sleep -m 500
        $test_status = (get-wmiobject -query ("select * from win32_service where name = '" + $service + "'") -computer $server).State
        $counter++
        waitingtodie $counter "-"
        if ($counter -eq 60) { $results = 0 }
    }
    $results
    }

    ### As we attempt to stop/start a service, it may take a while. This tries to let the user know that we're still working.
function waitingtodie {
    if (($args[0] % 5) -eq 0) { append-Status_Label $args[1] }
    }

function initialize-the-hashes {
    $things["timer"].Dispose()
    $keyhash.clear()
    $hash.clear()
    $pointhash.clear()
    $parms.clear()
    $beforeprocs.clear()
    $things.clear()
    initialize-things
    }

function initialize-things {
    $things.add("wsp", $false)
    $things.add("adsi", $true)
    $things.add("LVCols", $null)
    $things.add("SDGCols", $null)
    $things.add("colors", (.{$args} red darkgreen black lightgreen))
    $things.add("timer", (new-object System.Windows.Forms.timer))
    $things.add("machine", $server_TextBox.text)
    $things.add("procs", 0)
    $things.add("cpu", 0)
    }

function do-it-to-it {
    ### Test the status of the telephony service on the remote machine. We don't really care what the status
    ### is, we just want to know that we can get to it. Through playing around with some of this stuff, I've
    ### found that this is a way to test that a server is available without generating a bunch of errors.
    $tskmgr.Cursor = [System.Windows.Forms.Cursors]::WaitCursor
    update-Status_Label "Contacting remote machine..."
    initialize-the-hashes
    $server = $things["machine"]
    if ((new-object system.serviceprocess.servicecontroller("telephony", $server)).status -eq $null) {
        $rtrn = [system.windows.forms.messagebox]::Show("Cannot find the $server machine. Make sure it exists and you have permissions to it.")
        $tskmgr.Cursor = [System.Windows.Forms.Cursors]::Default
        return
    }

    ### Test if active directory is being used.
    try { [System.DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain() } catch { $things["adsi"] = $false }

    ### A little something new I ran into. We have some machines that are evidently protected in some way from making remote WMI calls to them.
    ### Also, there's a difference in what the real Task Manager program displays on an older version of Windows compared to a newer one. The
    ### default for the memory displayed for each process on newer versions comes from WorkingSetPrivate in the (I think this is correct, but not sure)
    ### win32_perfrawdata_perfproc_process class. However, that property doesn't exist on older versions and Task Manager uses WorkingSet for
    ### them. So, this section makes a decision of whether or not we can query the machine and if we'll be displaying WorkingSet or WorkingSetPrivate.
    try {
        $props = gwmi win32_perfrawdata_perfproc_process -computer $server
        if ($props[0].__property_count -gt 36) { $things["wsp"] = $true }
    } catch {
        $rtrn = [system.windows.forms.messagebox]::Show("It looks as though the $server machine does not allow remote WMI calls. We won't be able to monitor it.")
        $tskmgr.Cursor = [System.Windows.Forms.Cursors]::Default
        update-Status_Label ""
        return
    }

    ### Start initializing things.
    #initialize-stuff
    #get-services

    update-Status_Label "Initializing graphics..."
    #get-allCPU
    #$btmp = new-object system.drawing.bitmap($parms["Bitmap"][0], $parms["Bitmap"][1])
    get_processes $false
    #$btmp = Plot $btmp

    ### The $handler is a list of what to do when the timer fires off.
    $handler = {
    #   get-allCPU
        get_processes $true
    #   $btmp = Plot $btmp
    }

    ### This is how I've implemented the update interval. The regular TaskManager refreshes about once a
    ### second, but this can run into problems if you try that, particularly if you're going for a machine that
    ### is pretty busy. If things are pegged on a machine, it may not have the resources to get back to you every
    ### second, so after we've initialized everything, we take a reading of how long it takes to run through the
    ### three things it's going to have to do each time the timer fires off. It may take a long time to
    ### get through with the initial stuff, but seems to work pretty well after that. To be honest, I haven't run
    ### into many cases where the machine resources have slowed things down. It seems mostly limited by
    ### the network. You can probably hardcode this to run once a second and it will do great 99 times out of
    ### a 100, but that one time when you really need it will be the one that messes up.
    update-Status_Label "Initializing timer..."
    $et = [System.Diagnostics.Stopwatch]::StartNew()
    invoke-command -scriptblock $handler
    $et.Stop()
    $intrvl = [Math]::round($et.Elapsed.TotalMilliseconds, 0)
    if ($intrvl -lt 1000) { $intrvl = 1000 }
    $tskmgr.Cursor = [System.Windows.Forms.Cursors]::Default

    $things["timer"].interval = $intrvl
    $TB.value = $intrvl
    $things["timer"].add_tick($handler)
    update-Status_Label ""
    $things["timer"].Start()
}

##*========================
##* Task manager code - END
##*========================


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
    $Ping = $(if ($ping) { 'Yes' } else { 'No' })

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
        $data.'WMI Data Collected' = 'No (no ping reply and -IgnorePing not specified)'
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