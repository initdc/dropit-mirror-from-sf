
; SMTP Mailer: http://www.autoitscript.com/forum/topic/23860-smtp-mailer-that-supports-html-and-attachments/

#include-once
#Include <File.au3>

Global $_INetSmtpMailCom_oMyRet[2]
Global $_INetSmtpMailCom_oMyError = ObjEvent("AutoIt.Error", "__INetSmtpMailCom_Error")

Func __INetSmtpMailCom($s_SmtpServer, $s_FromName, $s_FromAddress, $s_ToAddress, $s_Subject = "", $as_Body = "", $s_AttachFiles = "", $s_CcAddress = "", $s_BccAddress = "", $s_Importance="Normal", $s_Username = "", $s_Password = "", $IPPort = 25, $ssl = 0)
	Local $objEmail = ObjCreate("CDO.Message")
	$objEmail.From = '"' & $s_FromName & '" <' & StringStripWS($s_FromAddress, 8) & '>'
	$objEmail.To = StringStripWS($s_ToAddress, 8)
	If $s_CcAddress <> "" Then
		$objEmail.Cc = StringStripWS($s_CcAddress, 8)
	EndIf
	If $s_BccAddress <> "" Then
		$objEmail.Bcc = StringStripWS($s_BccAddress, 8)
	EndIf
	$objEmail.Subject = $s_Subject
	If StringInStr($as_Body, "<") And StringInStr($as_Body, ">") Then
		$objEmail.HTMLBody = $as_Body
	Else
		$objEmail.Textbody = $as_Body & @CRLF
	EndIf
	If $s_AttachFiles <> "" Then
		Local $S_Files2Attach = StringSplit($s_AttachFiles, ";")
		For $x = 1 To $S_Files2Attach[0]
			$S_Files2Attach[$x] = _PathFull($S_Files2Attach[$x])
			If FileExists($S_Files2Attach[$x]) Then
				ConsoleWrite('+> File attachment added: ' & $S_Files2Attach[$x] & @LF)
				$objEmail.AddAttachment ($S_Files2Attach[$x])
			Else
				ConsoleWrite('!> File not found to attach: ' & $S_Files2Attach[$x] & @LF)
				Return SetError(1, 0, 0)
			EndIf
		Next
	EndIf
	$objEmail.Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/sendusing") = 2
	$objEmail.Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/smtpserver") = $s_SmtpServer
	If Number($IPPort) = 0 Then
		$IPPort = 25
	EndIf
	$objEmail.Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/smtpserverport") = $IPPort

	; Authenticated SMTP
	If $s_Username <> "" Then
		$objEmail.Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/smtpauthenticate") = 1
		$objEmail.Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/sendusername") = $s_Username
		$objEmail.Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/sendpassword") = $s_Password
	EndIf
	If $ssl Then
		$objEmail.Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/smtpusessl") = True
	EndIf

	; Update Settings
	$objEmail.Configuration.Fields.Update

	; Set Email Importance
	Switch $s_Importance
		Case "High"
			$objEmail.Fields.Item ("urn:schemas:mailheader:Importance") = "High"
		Case "Normal"
			$objEmail.Fields.Item ("urn:schemas:mailheader:Importance") = "Normal"
		Case "Low"
			$objEmail.Fields.Item ("urn:schemas:mailheader:Importance") = "Low"
	EndSwitch
	$objEmail.Fields.Update

	; Sent The Message
	$objEmail.Send
	If @error Then
		SetError(2)
	EndIf
	$objEmail = ""
	Return SetError(@error, 0, 0)
EndFunc   ;==>__INetSmtpMailCom

Func __INetSmtpMailCom_Error()
	Local $HexNumber = Hex($_INetSmtpMailCom_oMyError.number, 8)
	$_INetSmtpMailCom_oMyRet[0] = $HexNumber
	$_INetSmtpMailCom_oMyRet[1] = StringStripWS($_INetSmtpMailCom_oMyError.description, 3)
	ConsoleWrite("### COM Error !  Number: " & $HexNumber & "   ScriptLine: " & $_INetSmtpMailCom_oMyError.scriptline & "   Description:" & $_INetSmtpMailCom_oMyRet[1] & @LF)
	Return SetError(1, 0, 0)
EndFunc   ;==>__INetSmtpMailCom_Error