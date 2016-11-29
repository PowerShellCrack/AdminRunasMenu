<#
.NAME
    Get-PasswordGenerator.ps1

.DESCRIPTION
    Creates random passwords of varying complexity from ASCII table of characters 
    or phrases from random words selected from on posts on Reddit
    
    Ref: http://www.asciitable.com/ & http://www.reddit.com

.OPTIONS
     - Copies password to clipboard
     - Masks (hides) the password on the form
     - Exports generated passwords to a text file
        NB. This feature useful for bulk transfer of passwords to another application. 
        !! Please do NOT keep saved passwords in a text file for any period of time !!
     
.USAGE
     - Run script via powershell
        .\Get-PasswordGenerator.ps1
     
     - Run scripot via deskktop shortcut
        %SystemRoot%\system32\WindowsPowerShell\v1.0\powershell.exe -noexit ".'"c:\scripts\Get-PasswordGenerator.ps1'"
        
     - Requires Powwershell v3

.AUTHOR
    The Agreeable Cow   August 2014
    theagreeablecow.com
    
.VERSIONS
    1.0 TAC     August 2014     Original Build
    1.1 TAC     August 2014     Phrases - Added web proxy settings option
    1.2 TAC     August 2014     Phrases - Updated page redirect settings to cater for r/random.json delays
    1.3 TAC     August 2014     Phrases - Added filters for small words, duplicates and common words
 
#>

#------------------------
#       FUNCTIONS       #
#------------------------

# Close Powershell Window
Function Close-Powershell{
	Get-Process | Where-Object {$_.processname -eq "powershell"} | stop-process
}

#Set proxy server settings (if required)
Function SetWebProxy(){
    if(Test-Connection proxy1.mydomain.com -Count 1 -Quiet){
        $global:PSDefaultParameterValues = @{
            'Invoke-RestMethod:Proxy'='http://proxy1.mydomain.com:8080'
            'Invoke-WebRequest:Proxy'='http://proxy1.mydomain.com:8080'
            '*:ProxyUseDefaultCredentials'=$true
        }
    }
}

#Show a message box
function Show-MessageBox{ 
    Param([Parameter(Position=1,Mandatory=$true)][string]$Message,  
          [string]$Title="",  
          [ValidateSet('Ok','OkCancel','AbortRetryIgnore','YesNoCancel','YesNo','RetryCancel')][string]$Type='Ok',  
          [ValidateSet('None','Stop','Question','Warning','Information')][string]$Icon='None') 
    Add-Type -AssemblyName System.Windows.Forms 
    [System.Windows.Forms.MessageBox]::Show($Message, $Title, $Type, $Icon) 
}

#Generate Password or Phrase
Function GeneratePassword{
    [string] $Password = ""
    $txtResults.Text = "<Generating Phrase...>"
    
    #Generate Passwords
    If ($rdChar.checked -eq $True){
    
        #Define default variables
        [bool] $IncludeLower = $False
        [bool] $IncludeUpper = $False
        [bool] $IncludeNumbers = $False
        [bool] $IncludeSpecial = $False
        
        #Update complexity based on form
        $Length = $numericUpDown1.Value
        If ($cbLower.checked -eq $True){$IncludeLower = $True}
        If ($cbUpper.checked -eq $True){$IncludeUpper = $True}
        If ($cbNumbers.checked -eq $True){$IncludeNumbers = $True}
        If ($cbSpecial.checked -eq $True){$IncludeSpecial = $True}
            
        #Load ASCII Characters
        $Lowercase = [char[]](97..122)
        $Upercase = [char[]](65..90)
        $Numbers = [char[]](48..57)
        $Special = [char[]](33..47) + [char[]](58..64) + [char[]](91..96) + [char[]](123..126)

        #Build Password Set
        if ($IncludeLower -eq $True){$PasswordSet += $Lowercase}
        if ($IncludeUpper -eq $True){$PasswordSet += $Upercase}
        if ($IncludeNumbers -eq $True){$PasswordSet += $Numbers}
        if ($IncludeSpecial -eq $True){$PasswordSet += $Special}

        #Generate Random Password
        $randomObj = New-Object System.Random
        1..$Length | ForEach {$Password += ($PasswordSet | Get-Random)}
    }
    #Generate Phrases
    elseif($rdWord.checked -eq $True){
        #Define default variables
        $Words =@()
        $UncommonWords =@()
        $Length = $numericUpDown2.Value
        $Subreddit = $txtSource.Text
        $ScriptPath = Split-Path -parent $PSCommandPath

        #Launch web request to collect 25x Post Titles from Reddit
        try{
            SetWebProxy   #  <-- Run this function to connect via a proxy server
            $URI = "http://www.reddit.com/$Subreddit"
            
            #If Subreddit is 'Random', select the redirected .json page
            If ($URI -eq "http://www.reddit.com/r/random"){
                $Request = Invoke-WebRequest -Uri $uri -MaximumRedirection 0 -ErrorAction Ignore
                if($Request.StatusDescription -eq 'found'){
                   $URI = $Request.Headers.Location
                }
                $URI = $URI.Substring(0,$URI.Length-1)
                $Redirect = $URI+".json"
                write-host "Word source: $URI"
                $URI = Invoke-WebRequest -Uri $Redirect
            }
            #Otherwise, just select the original .json page
            Else{
                $Original = $URI+".json"
                write-host "Word source: $URI"
                $URI = Invoke-WebRequest -Uri $Original
            }
            $obj = ConvertFrom-Json ($URI.Content)
            $Data = $obj.Data.Children.Data | Select Title
        }
        Catch{
            $txtResults.Text = "Failed connection or unknown URL. Please try again"
            break;
        }
        
        #Break down titles into words
        $Titles = $Data.title 
        $Words = $Titles.split(' ')
        
        #Filter out common redit text, special characters and numbers
		$RedditText = @("r/","u/")
        $Punctuation = @('"',"~","!","@","#","$","%","^","&","*","(",")","-","_","=","+","[","]","{","}","\","|",";",":","'",",","<",".",">","/","?")
        $Numbers = @("0","1","2","3","4","5","6","7","8","9")
        $Characters = $RedditText + $Punctuation + $Numbers
        foreach ($character in $Characters){
            $Words = $Words.Replace($character,"")
        }
        
        #Filter out small words and duplicates
        $Words = $Words | where-object {$_.length -ge 4}
        $Words = $Words | select -uniq
        
        #Filter out common words
        $ExcludedWordFile = "$ScriptPath\ExcludedCommonWords.txt"
        IF ((TEST-PATH $ExcludedWordFile)) {
            $ExcludedWords = Get-Content $ExcludedWordFile
            ForEach ($Word in $Words){
                if ($ExcludedWords -notContains $Word){
                    $UncommonWords += $Word
                }
            }
            #Check for a decent sized Word pool and create Phrase out of uncommon words only
            $Count = $UncommonWords.count
            if ($Count -lt 50){
                write-warning "The generated word list was not very large ($Count), which may result in limited word selection. Suggest you try another Subreddit."
            }
            1..$Length | ForEach {$Password += ($UncommonWords | Get-Random)}
        }
        Else{
            #Warn about ExcludedWordList file missing, check for a decent sized Word pool and create Phrase out of all available words
            write-warning "The generated phrase may contain very common words. Please add the 'Excluded Common Words' file $ExcludedWordFile and try again."
            $Count = $Words.count
            if ($Count -lt 50){
                write-warning "The generated word list was not very large ($Count), which may result in limited word selection. Suggest you try another Subreddit."
            }
            1..$Length | ForEach {$Password += ($Words | Get-Random)}
        }
        
        #Remove all remaining non a-z or A-Z characters and test length of final phrase
        $Password = [System.Text.RegularExpressions.Regex]::Replace($Password,"[^a-zA-Z]","");
        if ($Password.length -lt 16){
            write-warning "Phrase is not very long. Suggest you try again."
        }
    }
    
    #Copy to Clipboard
    If ($cbClipboard.checked -eq $True){
        $Password | CLIP
    }
     
    #Update Text display on form
    If ($cbMask.checked -eq $True){
        1..$Length | ForEach {$Stars += "*"}
        $txtResults.Text = $Stars
    }
    else{
        $txtResults.Text = $Password
    }
    
    #Export to text file
    If ($cbFile.checked -eq $True){
        If ($cbFile.Text -eq "Export to File"){
            if($savefiledialog1.ShowDialog() -eq 'OK'){
                $Password | Out-File $savefiledialog1.FileName
            }
        }
        Else{
            $Password | Out-File $savefiledialog1.FileName -append
        }
        $cbFile.Text = "Appending..."
    }
}


#------------------------
#          FORM         #
#------------------------

function GenerateForm {

#region Import the Assemblies
[reflection.assembly]::loadwithpartialname("System.Drawing") | Out-Null
[reflection.assembly]::loadwithpartialname("System.Windows.Forms") | Out-Null

#region Generated Form Objects
$form1 = New-Object System.Windows.Forms.Form
$label1 = New-Object System.Windows.Forms.Label
$groupBox2 = New-Object System.Windows.Forms.GroupBox
$cbFile = New-Object System.Windows.Forms.CheckBox
$cbMask = New-Object System.Windows.Forms.CheckBox
$cbClipboard = New-Object System.Windows.Forms.CheckBox
$groupBox1 = New-Object System.Windows.Forms.GroupBox
$btnHelp = New-Object System.Windows.Forms.Button
$txtSource = New-Object System.Windows.Forms.TextBox
$label2 = New-Object System.Windows.Forms.Label
$numericUpDown2 = New-Object System.Windows.Forms.NumericUpDown
$rdWord = New-Object System.Windows.Forms.RadioButton
$rdChar = New-Object System.Windows.Forms.RadioButton
$numericUpDown1 = New-Object System.Windows.Forms.NumericUpDown
$cbLower = New-Object System.Windows.Forms.CheckBox
$cbUpper = New-Object System.Windows.Forms.CheckBox
$cbNumbers = New-Object System.Windows.Forms.CheckBox
$cbSpecial = New-Object System.Windows.Forms.CheckBox
$txtResults = New-Object System.Windows.Forms.TextBox
$btnCancel = New-Object System.Windows.Forms.Button
$btnGenerate = New-Object System.Windows.Forms.Button
$saveFileDialog1 = New-Object System.Windows.Forms.SaveFileDialog
$InitialFormWindowState = New-Object System.Windows.Forms.FormWindowState

#Event Script Blocks
$handler_btnGenerate_Click={
    GeneratePassword
}

$handler_btnCancel_Click={
    $form1.close()
    Close-Powershell
}

$OnLoadForm_StateCorrection={
	$form1.WindowState = $InitialFormWindowState
    [int] $RunCount = 0
    GeneratePassword
}


$btnHelp_OnClick={  
    Show-MessageBox 'An effective word array is dynamic and random. These words are randomly sourced in real time, from titles of posts on http://www.reddit.com' -Type OK -Icon Information
}


#----------------------------------------------
#region Generated Form Code
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 346
$System_Drawing_Size.Width = 605
$form1.ClientSize = $System_Drawing_Size
$form1.DataBindings.DefaultDataSourceUpdateMode = 0
$form1.Name = "form1"
$form1.StartPosition = 1
$form1.Text = "TAC Password and Phrase Generator"

#Logo Label
$label1.DataBindings.DefaultDataSourceUpdateMode = 0
$label1.Font = New-Object System.Drawing.Font("Courier New",6.75,1,3,0)
$label1.ForeColor = [System.Drawing.Color]::FromArgb(255,0,0,0)

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 470
$System_Drawing_Point.Y = 200
$label1.Location = $System_Drawing_Point
$label1.Name = "label1"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 80
$System_Drawing_Size.Width = 110
$label1.Size = $System_Drawing_Size
$label1.TabIndex = 13
$label1.Text = "
         (__)
         (oo)  ok
   /------\/  /
  / |    ||
 *  /\---/\ 
    ^^   ^^   v1.3"

$form1.Controls.Add($label1)

#Options Group Box
$groupBox2.DataBindings.DefaultDataSourceUpdateMode = 0
$groupBox2.Font = New-Object System.Drawing.Font("Microsoft Sans Serif",9.75,0,3,1)
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 12
$System_Drawing_Point.Y = 207
$groupBox2.Location = $System_Drawing_Point
$groupBox2.Name = "groupBox2"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 60
$System_Drawing_Size.Width = 407
$groupBox2.Size = $System_Drawing_Size
$groupBox2.TabIndex = 12
$groupBox2.TabStop = $False
$groupBox2.Text = "Options"

$form1.Controls.Add($groupBox2)

# Export to File checkbox 
$cbFile.DataBindings.DefaultDataSourceUpdateMode = 0
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 281
$System_Drawing_Point.Y = 22
$cbFile.Location = $System_Drawing_Point
$cbFile.Name = "cbFile"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 24
$System_Drawing_Size.Width = 104
$cbFile.Size = $System_Drawing_Size
$cbFile.TabIndex = 2
$cbFile.Text = "Export to File"
$cbFile.UseVisualStyleBackColor = $True

$groupBox2.Controls.Add($cbFile)

# Mask checkbox
$cbMask.DataBindings.DefaultDataSourceUpdateMode = 0
$cbMask.Font = New-Object System.Drawing.Font("Microsoft Sans Serif",9.75,0,3,1)
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 199
$System_Drawing_Point.Y = 22
$cbMask.Location = $System_Drawing_Point
$cbMask.Name = "cbMask"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 24
$System_Drawing_Size.Width = 104
$cbMask.Size = $System_Drawing_Size
$cbMask.TabIndex = 1
$cbMask.Text = "Mask"
$cbMask.UseVisualStyleBackColor = $True

$groupBox2.Controls.Add($cbMask)

# Copy to clipboard checkbox
$cbClipboard.Checked = $True
$cbClipboard.CheckState = 1
$cbClipboard.DataBindings.DefaultDataSourceUpdateMode = 0
$cbClipboard.Font = New-Object System.Drawing.Font("Microsoft Sans Serif",9.75,0,3,1)
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 40
$System_Drawing_Point.Y = 22
$cbClipboard.Location = $System_Drawing_Point
$cbClipboard.Name = "cbClipboard"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 24
$System_Drawing_Size.Width = 137
$cbClipboard.Size = $System_Drawing_Size
$cbClipboard.TabIndex = 0
$cbClipboard.Text = "Copy to Clipboard"
$cbClipboard.UseVisualStyleBackColor = $True

$groupBox2.Controls.Add($cbClipboard)

#Random Group box
$groupBox1.DataBindings.DefaultDataSourceUpdateMode = 0
$groupBox1.Font = New-Object System.Drawing.Font("Microsoft Sans Serif",9.75,0,3,1)
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 12
$System_Drawing_Point.Y = 55
$groupBox1.Location = $System_Drawing_Point
$groupBox1.Name = "groupBox1"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 129
$System_Drawing_Size.Width = 582
$groupBox1.Size = $System_Drawing_Size
$groupBox1.TabIndex = 11
$groupBox1.TabStop = $False
$groupBox1.Text = "Random"

$form1.Controls.Add($groupBox1)

# Help button
$btnHelp.DataBindings.DefaultDataSourceUpdateMode = 0
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 545
$System_Drawing_Point.Y = 83
$btnHelp.Location = $System_Drawing_Point
$btnHelp.Name = "btnHelp"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 23
$System_Drawing_Size.Width = 20
$btnHelp.Size = $System_Drawing_Size
$btnHelp.TabIndex = 13
$btnHelp.Text = "?"
$btnHelp.UseVisualStyleBackColor = $True
$btnHelp.add_Click($btnHelp_OnClick)

$groupBox1.Controls.Add($btnHelp)

#URL source text box
$txtSource.BackColor = [System.Drawing.Color]::FromArgb(255,255,255,255)
$txtSource.DataBindings.DefaultDataSourceUpdateMode = 0
$txtSource.Font = New-Object System.Drawing.Font("Microsoft Sans Serif",9.75,0,3,0)
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 402
$System_Drawing_Point.Y = 83
$txtSource.Location = $System_Drawing_Point
$txtSource.Name = "txtSource"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 22
$System_Drawing_Size.Width = 131
$txtSource.Size = $System_Drawing_Size
$txtSource.TabIndex = 12
$txtSource.Text = "r/random"

$groupBox1.Controls.Add($txtSource)

#Words Label
$label2.DataBindings.DefaultDataSourceUpdateMode = 0
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 215
$System_Drawing_Point.Y = 83
$label2.Location = $System_Drawing_Point
$label2.Name = "label2"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 23
$System_Drawing_Size.Width = 192
$label2.Size = $System_Drawing_Size
$label2.TabIndex = 11
$label2.Text = "Source: http://www.reddit.com/"
$label2.TextAlign = 16
$label2.add_Click($handler_label2_Click)

$groupBox1.Controls.Add($label2)

#Words numeric up/down
$numericUpDown2.DataBindings.DefaultDataSourceUpdateMode = 0
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 140
$System_Drawing_Point.Y = 83
$numericUpDown2.Location = $System_Drawing_Point
$numericUpDown2.Maximum = 30
$numericUpDown2.Minimum = 3
$numericUpDown2.Name = "numericUpDown2"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 22
$System_Drawing_Size.Width = 47
$numericUpDown2.Size = $System_Drawing_Size
$numericUpDown2.TabIndex = 10
$numericUpDown2.TextAlign = 2
$numericUpDown2.Value = 4

$groupBox1.Controls.Add($numericUpDown2)

# Words radio button
$rdWord.DataBindings.DefaultDataSourceUpdateMode = 0
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 20
$System_Drawing_Point.Y = 82
$rdWord.Location = $System_Drawing_Point
$rdWord.Name = "rdWord"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 24
$System_Drawing_Size.Width = 104
$rdWord.Size = $System_Drawing_Size
$rdWord.TabIndex = 9
$rdWord.TabStop = $True
$rdWord.Text = "Words"
$rdWord.UseVisualStyleBackColor = $True

$groupBox1.Controls.Add($rdWord)

#Characters radio button
$rdChar.Checked = $True
$rdChar.DataBindings.DefaultDataSourceUpdateMode = 0
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 20
$System_Drawing_Point.Y = 30
$rdChar.Location = $System_Drawing_Point
$rdChar.Name = "rdChar"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 24
$System_Drawing_Size.Width = 104
$rdChar.Size = $System_Drawing_Size
$rdChar.TabIndex = 8
$rdChar.TabStop = $True
$rdChar.Text = "Characters"
$rdChar.UseVisualStyleBackColor = $True

$groupBox1.Controls.Add($rdChar)

#Characters numeric up/down
$numericUpDown1.DataBindings.DefaultDataSourceUpdateMode = 0
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 140
$System_Drawing_Point.Y = 31
$numericUpDown1.Location = $System_Drawing_Point
$numericUpDown1.Maximum = 127
$numericUpDown1.Minimum = 6
$numericUpDown1.Name = "numericUpDown1"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 22
$System_Drawing_Size.Width = 47
$numericUpDown1.Size = $System_Drawing_Size
$numericUpDown1.TabIndex = 5
$numericUpDown1.TextAlign = 2
$numericUpDown1.Value = 12

$groupBox1.Controls.Add($numericUpDown1)

#Lowercase letters checkbox
$cbLower.Checked = $True
$cbLower.CheckState = 1
$cbLower.DataBindings.DefaultDataSourceUpdateMode = 0
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 235
$System_Drawing_Point.Y = 30
$cbLower.Location = $System_Drawing_Point
$cbLower.Name = "cbLower"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 24
$System_Drawing_Size.Width = 52
$cbLower.Size = $System_Drawing_Size
$cbLower.TabIndex = 3
$cbLower.Text = "abc"
$cbLower.UseVisualStyleBackColor = $True

$groupBox1.Controls.Add($cbLower)

#Uppercase letters checkbox
$cbUpper.Checked = $True
$cbUpper.CheckState = 1
$cbUpper.DataBindings.DefaultDataSourceUpdateMode = 0
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 328
$System_Drawing_Point.Y = 30
$cbUpper.Location = $System_Drawing_Point
$cbUpper.Name = "cbUpper"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 24
$System_Drawing_Size.Width = 57
$cbUpper.Size = $System_Drawing_Size
$cbUpper.TabIndex = 4
$cbUpper.Text = "ABC"
$cbUpper.UseVisualStyleBackColor = $True

$groupBox1.Controls.Add($cbUpper)

#Numbers checkbox
$cbNumbers.Checked = $True
$cbNumbers.CheckState = 1
$cbNumbers.DataBindings.DefaultDataSourceUpdateMode = 0
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 422
$System_Drawing_Point.Y = 30
$cbNumbers.Location = $System_Drawing_Point
$cbNumbers.Name = "cbNumbers"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 24
$System_Drawing_Size.Width = 52
$cbNumbers.Size = $System_Drawing_Size
$cbNumbers.TabIndex = 6
$cbNumbers.Text = "123"
$cbNumbers.UseVisualStyleBackColor = $True

$groupBox1.Controls.Add($cbNumbers)

#Special Characters Checkbox
$cbSpecial.Checked = $True
$cbSpecial.CheckState = 1
$cbSpecial.DataBindings.DefaultDataSourceUpdateMode = 0
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 516
$System_Drawing_Point.Y = 30
$cbSpecial.Location = $System_Drawing_Point
$cbSpecial.Name = "cbSpecial"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 24
$System_Drawing_Size.Width = 60
$cbSpecial.Size = $System_Drawing_Size
$cbSpecial.TabIndex = 7
$cbSpecial.Text = "%$#"
$cbSpecial.UseVisualStyleBackColor = $True

$groupBox1.Controls.Add($cbSpecial)

#Results Text box
$txtResults.DataBindings.DefaultDataSourceUpdateMode = 0
$txtResults.Font = New-Object System.Drawing.Font("Courier New",12,0,3,1)
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 11
$System_Drawing_Point.Y = 17
$txtResults.Location = $System_Drawing_Point
$txtResults.Name = "txtResults"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 26
$System_Drawing_Size.Width = 583
$txtResults.Size = $System_Drawing_Size
$txtResults.TabIndex = 2
$txtResults.TextAlign = 2
$txtResults.add_TextChanged($handler_txtResults_TextChanged)

$form1.Controls.Add($txtResults)

#Close button
$btnCancel.DataBindings.DefaultDataSourceUpdateMode = 0
$btnCancel.Font = New-Object System.Drawing.Font("Microsoft Sans Serif",12.25,0,3,0)
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 358
$System_Drawing_Point.Y = 291
$btnCancel.Location = $System_Drawing_Point
$btnCancel.Name = "btnCancel"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 45
$System_Drawing_Size.Width = 110
$btnCancel.Size = $System_Drawing_Size
$btnCancel.TabIndex = 1
$btnCancel.Text = "Close"
$btnCancel.UseVisualStyleBackColor = $True
$btnCancel.add_Click($handler_btnCancel_Click)

$form1.Controls.Add($btnCancel)

#Generate buton
$btnGenerate.DataBindings.DefaultDataSourceUpdateMode = 0
$btnGenerate.Font = New-Object System.Drawing.Font("Microsoft Sans Serif",12.25,0,3,0)
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 138
$System_Drawing_Point.Y = 291
$btnGenerate.Location = $System_Drawing_Point
$btnGenerate.Name = "btnGenerate"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 45
$System_Drawing_Size.Width = 115
$btnGenerate.Size = $System_Drawing_Size
$btnGenerate.TabIndex = 0
$btnGenerate.Text = "Generate"
$btnGenerate.UseVisualStyleBackColor = $True
$btnGenerate.add_Click($handler_btnGenerate_Click)

$form1.Controls.Add($btnGenerate)

#Save Export File dialog
$saveFileDialog1.CreatePrompt = $True
$saveFileDialog1.FileName = "Generated PW List.txt"
$saveFileDialog1.InitialDirectory = "c:"
$saveFileDialog1.ShowHelp = $True
$saveFileDialog1.Title = "Save to File"


#Save the initial state of the form
$InitialFormWindowState = $form1.WindowState
#Init the OnLoad event to correct the initial state of the form
$form1.add_Load($OnLoadForm_StateCorrection)
#Show the Form
$form1.ShowDialog()| Out-Null

}

#Call the Form
GenerateForm