#cs
    Thanks to the following for helping in the past ...
    KaFu for the idea from _EnforceSingleInstance().
    Yashied for x64 support.
#ce

#include <WinAPI.au3>
#include <WindowsConstants.au3>

Global $G_Global_WM_COPY = 0 ; ADDED TO WORK WITH DROPIT.
Global Enum $__hInterCommunicationGUI, $__iInterCommunicationControlID, $__sInterCommunicationIDString, $__sInterCommunicationData, $__iInterCommunicationMax
Global $__vInterCommunicationAPI[$__iInterCommunicationMax] ; Internal array for the WM_COPYDATA functions.

Func _WM_COPYDATA($hWnd, $iMsg, $wParam, $lParam)
    #forceref $hWnd, $iMsg, $wParam
    Local Const $tagCOPYDATASTRUCT = 'ulong_ptr;dword;ptr'
    Local $tParam = DllStructCreate($tagCOPYDATASTRUCT, $lParam)
    Local $tData = DllStructCreate('wchar[' & DllStructGetData($tParam, 2) / 2 & ']', DllStructGetData($tParam, 3))
    $__vInterCommunicationAPI[$__sInterCommunicationData] = DllStructGetData($tData, 1)
    GUICtrlSendToDummy($__vInterCommunicationAPI[$__iInterCommunicationControlID])
	$G_Global_WM_COPY = 1 ; ADDED TO WORK WITH DROPIT.
EndFunc   ;==>_WM_COPYDATA

Func _WM_COPYDATA_GetData()
    Local $sReturn = $__vInterCommunicationAPI[$__sInterCommunicationData]
    $__vInterCommunicationAPI[$__sInterCommunicationData] = ''
    Return $sReturn
EndFunc   ;==>_WM_COPYDATA_GetData

Func _WM_COPYDATA_GetGUI()
    Return $__vInterCommunicationAPI[$__hInterCommunicationGUI]
EndFunc   ;==>_WM_COPYDATA_GetGUI

Func _WM_COPYDATA_GetID()
    Return $__vInterCommunicationAPI[$__sInterCommunicationIDString]
EndFunc   ;==>_WM_COPYDATA_GetID

Func _WM_COPYDATA_Send($sString)
    If _WM_COPYDATA_GetGUI() = -1 Then
        Return SetError(1, 0, 0)
    EndIf

    If StringStripWS($sString, 8) = '' Then
        Return SetError(2, 0, 0)
    EndIf

    If _WM_COPYDATA_GetGUI() Then
        Local $tData = DllStructCreate('wchar[' & StringLen($sString) + 1 & ']')
        DllStructSetData($tData, 1, $sString)

        Local Const $tagCOPYDATASTRUCT = 'ulong_ptr;dword;ptr'
        Local $tCOPYDATASTRUCT = DllStructCreate($tagCOPYDATASTRUCT)
        DllStructSetData($tCOPYDATASTRUCT, 1, 0)
        DllStructSetData($tCOPYDATASTRUCT, 2, DllStructGetSize($tData))
        DllStructSetData($tCOPYDATASTRUCT, 3, DllStructGetPtr($tData))
        _SendMessage(_WM_COPYDATA_GetGUI(), $WM_COPYDATA, 0, DllStructGetPtr($tCOPYDATASTRUCT))
        Return Number(Not @error)
    EndIf
EndFunc   ;==>_WM_COPYDATA_Send

Func _WM_COPYDATA_SetGUI($vGUI)
    $__vInterCommunicationAPI[$__hInterCommunicationGUI] = $vGUI
EndFunc   ;==>_WM_COPYDATA_SetGUI

Func _WM_COPYDATA_SetID($sIDString)
    $__vInterCommunicationAPI[$__sInterCommunicationIDString] = $sIDString
    Return $sIDString
EndFunc   ;==>_WM_COPYDATA_SetID

Func _WM_COPYDATA_Shutdown()
    Local $hHandle = WinGetHandle(AutoItWinGetTitle())
    GUIRegisterMsg($WM_COPYDATA, '')
    GUIDelete(_WM_COPYDATA_GetGUI())
    ControlSetText($hHandle, '', ControlGetHandle($hHandle, '', 'Edit1'), '')
EndFunc   ;==>_WM_COPYDATA_Shutdown

Func _WM_COPYDATA_Start($hGUI, $fCheckOnly = Default)
    Local $hHandle = WinGetHandle(_WM_COPYDATA_GetID())
    If @error Then
        If $fCheckOnly Then
            Return 0
        EndIf
        AutoItWinSetTitle(_WM_COPYDATA_GetID())
        $hHandle = WinGetHandle(_WM_COPYDATA_GetID())

        If IsHWnd($hGUI) = 0 Or $hGUI = Default Then
            $hGUI = GUICreate('', 0, 0, -99, -99, '', $WS_EX_TOOLWINDOW)
            GUISetState(@SW_SHOW, $hGUI)
        EndIf
        ControlSetText($hHandle, '', ControlGetHandle($hHandle, '', 'Edit1'), $hGUI)
        GUIRegisterMsg($WM_COPYDATA, '_WM_COPYDATA')
        _WM_COPYDATA_SetGUI(-1)
        $__vInterCommunicationAPI[$__iInterCommunicationControlID] = GUICtrlCreateDummy()
        Return $__vInterCommunicationAPI[$__iInterCommunicationControlID]
    Else
        $hHandle = HWnd(ControlGetText($hHandle, '', ControlGetHandle($hHandle, '', 'Edit1')))
        _WM_COPYDATA_SetGUI($hHandle)
        Return SetError(1, 0, $hHandle)
    EndIf
EndFunc   ;==>_WM_COPYDATA_Start