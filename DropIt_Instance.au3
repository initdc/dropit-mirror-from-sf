
; Instance funtions of DropIt

#include-once
#include "DropIt_General.au3"
#include "DropIt_Global.au3"

Func __CloseInstances()
	#cs
		Description: Close All Instances Of DropIt.
		Returns: Nothing
	#ce
	Local $cINI = __IsSettingsFile() ; Get Default Settings INI File.
	Local $cMainProcessID = WinGetProcess(@ScriptFullPath)
	Local $cMultipleInstancesINI = __IniReadSection($cINI, "MultipleInstances")
	If @error Then
		__CloseMainProcess($cMainProcessID) ; Close The Main Process If Not The Current One.
		Return 1
	EndIf

	For $A = 1 To $cMultipleInstancesINI[0][0]
		If $cMultipleInstancesINI[$A][0] == "Running" Then
			ContinueLoop
		EndIf
		IniDelete($cINI, $cMultipleInstancesINI[$A][0])
		IniDelete($cINI, "MultipleInstances", $cMultipleInstancesINI[$A][0])
		ProcessClose($cMultipleInstancesINI[$A][1])
		ProcessWaitClose($cMultipleInstancesINI[$A][1])
	Next
	__IniWriteEx($cINI, "MultipleInstances", "Running", "0")
	__CloseMainProcess($cMainProcessID) ; Close The Main Process If Not The Current One.

	Return 1
EndFunc   ;==>__CloseInstances

Func __CloseMainProcess($cProcessID)
	If @AutoItPID <> $cProcessID Then
		ProcessClose($cProcessID)
		ProcessWaitClose($cProcessID)
	EndIf
EndFunc   ;==>__CloseMainProcess

Func __GetNewInstanceNumber()
	#cs
		Description: Get The Number Of Additional DropIt Instances.
		Returns: 1
	#ce
	Local $gINI = __IsSettingsFile() ; Get Default Settings INI File.
	Local $gNumber = 1
	While 1
		If IniRead($gINI, "MultipleInstances", $gNumber & "_DropIt_MultipleInstance", "") == "" Then
			ExitLoop
		EndIf
		$gNumber += 1
	WEnd
	Return $gNumber
EndFunc   ;==>__GetNewInstanceNumber

Func __GetNumberInstances()
	#cs
		Description: Get The Number Of Running Instances.
		Returns: Number Of Running Instances
	#ce
	Local $cINI = __IsSettingsFile() ; Get Default Settings INI File.
	Local $cRunning = 0
	Local $cMainProcessID = WinGetProcess(@ScriptFullPath)
	Local $cMultipleInstancesINI = __IniReadSection($cINI, "MultipleInstances")
	If @error Then
		If ProcessExists($cMainProcessID) Then
			$cRunning += 1 ; Consider Also The Main Instance.
		EndIf
		Return SetError(1, 0, $cRunning)
	EndIf

	For $A = 1 To $cMultipleInstancesINI[0][0]
		If $cMultipleInstancesINI[$A][0] == "Running" Then
			ContinueLoop
		EndIf
		$cRunning += 1
		If ProcessExists($cMultipleInstancesINI[$A][1]) = 0 Then
			IniDelete($cINI, $cMultipleInstancesINI[$A][0])
			IniDelete($cINI, "MultipleInstances", $cMultipleInstancesINI[$A][0])
			$cRunning -= 1
		EndIf
	Next
	__IniWriteEx($cINI, "MultipleInstances", "Running", $cRunning)
	If ProcessExists($cMainProcessID) Then
		$cRunning += 1 ; Consider Also The Main Instance.
	EndIf

	Return $cRunning
EndFunc   ;==>__GetNumberInstances

Func __SetMultipleInstances($sType = "+", $sID = $G_Global_UniqueID)
	#cs
		Description: Set The Number Of Additional DropIt Instances & List The Multiple Instance Name With PID. [1_DropIt_MultipleInstance=8967]
		Returns: 1
	#ce
	Local $iRunning, $sINI
	Local $sUniqueID = __GetInstanceID($sID) ; Get ID Only As Section Name.

	$sINI = __IsSettingsFile() ; Get Default Settings INI File.
	$iRunning = IniRead($sINI, "MultipleInstances", "Running", "0")
	Switch $sType
		Case "+"
			$iRunning += 1
			__IniWriteEx($sINI, "MultipleInstances", $sUniqueID, @AutoItPID)

		Case "-"
			$iRunning -= 1
			IniDelete($sINI, $sUniqueID)
			IniDelete($sINI, "MultipleInstances", $sUniqueID)

	EndSwitch
	Return __IniWriteEx($sINI, "MultipleInstances", "Running", $iRunning)
EndFunc   ;==>__SetMultipleInstances
