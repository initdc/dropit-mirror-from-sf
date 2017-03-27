
; Instance funtions of DropIt

#include-once
#include <DropIt_General.au3>
#include <DropIt_Global.au3>

Func __CheckMultipleInstances()
	#cs
		Description: Check All Multiple Instances In The INI File Are Currently Running.
		Returns: Number Of Multiple Instances Running
	#ce
	Local $cINI = __IsSettingsFile() ; Get Default Settings INI File.

	Local $cMultipleInstancesINI = __IniReadSection($cINI, "MultipleInstances")
	If @error Then
		Return SetError(1, 0, 0)
	EndIf
	Local $cRunning = 0
	For $A = 1 To $cMultipleInstancesINI[0][0]
		If $cMultipleInstancesINI[$A][0] = "Running" Then
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
	Return $cRunning
EndFunc   ;==>__CheckMultipleInstances

Func __CloseInstances()
	#cs
		Description: Close All Instances Of DropIt.
		Returns: Nothing
	#ce
	If __CheckMultipleInstances() > 0 Then
		Local $aArray = __GetMultipleInstancesRunning()
		For $A = 1 To $aArray[0][0]
			ProcessClose($aArray[$A][2])
			$G_Global_UniqueID = $aArray[$A][0]
			__SetMultipleInstances("-")
		Next
		__IniWriteEx(__IsSettingsFile(), "General", "SwitchCommand", "True")
	EndIf
	Exit
EndFunc   ;==>__CloseInstances

Func __GetMultipleInstances()
	#cs
		Description: Get The Number Of Additional DropIt Instances.
		Returns: 1
	#ce
	Local $gINI = __IsSettingsFile() ; Get Default Settings INI File.
	Return IniRead($gINI, "MultipleInstances", "Running", "0")
EndFunc   ;==>__GetMultipleInstances

Func __GetMultipleInstancesRunning()
	#cs
		Description: Provide Details Of The Multiple Instances Running.
		Returns: @error Or $Array[?] - Array Contains Unlimited Number Of Items.
		[0][0] - Number Of Rows [?]
		[0][1] - Number Of Colums [3]

		[A][0] - Multiple Instance Name [1_DropIt_MultipleInstance]
		[A][1] - Multiple Instance Handle [0x123456]
		[A][2] - Multiple Instance PID [1234]
	#ce
	Local $gReturn[2][3] = [[0, 3]]
	Local $gWinList = WinList()
	For $A = 1 To $gWinList[0][0]
		If $gWinList[$A][0] <> "" And StringInStr($gWinList[$A][0], "_DropIt_MultipleInstance") Then
			If UBound($gReturn, 1) <= $gReturn[0][0] + 1 Then
				ReDim $gReturn[UBound($gReturn, 1) * 2][$gReturn[0][1]] ; ReDim $gReturn If More Items Are Required.
			EndIf
			Local $ghWndProcess = WinGetProcess($gWinList[$A][0])
			$gReturn[0][0] += 1
			$gReturn[$gReturn[0][0]][0] = $gWinList[$A][0] ; Multiple Instance Name.
			$gReturn[$gReturn[0][0]][1] = WinGetHandle($gWinList[$A][0]) ; Multiple Instance Handle.
			$gReturn[$gReturn[0][0]][2] = $ghWndProcess ; PID Of Multiple Instance (Useful If You Want To End The Process.)
		EndIf
	Next
	ReDim $gReturn[$gReturn[0][0] + 1][$gReturn[0][1]] ; Delete Empty Spaces.
	If $gReturn[0][0] = 0 Then
		Return SetError(1, 0, 0)
	EndIf
	Return $gReturn
EndFunc   ;==>__GetMultipleInstancesRunning

Func __SetMultipleInstances($sType = "+")
	#cs
		Description: Set The Number Of Additional DropIt Instances & List The Multiple Instance Name With PID. [1_DropIt_MultipleInstance=8967]
		Returns: 1
	#ce
	Local $iRunning, $sINI
	Local $sUniqueID = $G_Global_UniqueID

	$iRunning = __GetMultipleInstances()
	$sINI = __IsSettingsFile() ; Get Default Settings INI File.
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
