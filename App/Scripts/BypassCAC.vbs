'******************************************************************************
'*BypassCAC.vbs
'*Author: Richard Tracy
'*Data: 2 Nov 2016
'*Description
'*Changes registry key on remote computer to allow logon without CAC card
'
'*Usage: 
'	*Prompts for computer name
'	BypassCAC.vbs
'
'	*Auto 
'	BypassCAC.vbs Computername
'
'*Changes: 11/02/2016: Prompt to state cancelled; added argument feature 
'******************************************************************************
Option Explicit

Const HKEY_LOCAL_MACHINE = &H80000002
Dim args,objReg, strComputer

Set args = Wscript.Arguments

If WScript.Arguments.Count = 1 Then
	strComputer = WScript.Arguments.Item(0)
else
	strComputer = InputBox("Computer Name or IP Address","Disable CAC Authentication")
End if

If IsEmpty(strComputer) Then
    	'cancelled
    	MsgBox "CAC Authentication cancelled"
Else
	On Error Resume Next
	Set objReg=GetObject("winmgmts:{impersonationLevel=impersonate}!\\" & strComputer & "\root\default:StdRegProv")
	objReg.SetDwordValue HKEY_LOCAL_MACHINE, "SOFTWARE\Microsoft\Windows\CurrentVersion\policies\system", "scforceoption", 0
	If Err <> 0 Then
        	MsgBox "Unable to disable CAC Authentication on " & strComputer
	Else
        	MsgBox "CAC Authentication has been disabled on " & strComputer
	End if
End if

Set objReg = Nothing