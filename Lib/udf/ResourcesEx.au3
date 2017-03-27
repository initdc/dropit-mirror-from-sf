#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
; #Tidy_Parameters=/sort_funcs /reel
#include-once

#include <Array.au3>
#include <ButtonConstants.au3>
#include <GDIPlus.au3>
#include <Memory.au3>
#include <StaticConstants.au3>
#include <WinAPIMisc.au3>
#include <WinAPIRes.au3>

; Call once the script has ended to tidy up the used resources.
OnAutoItExitRegister(_GDIPlus_Shutdown)
OnAutoItExitRegister(_Resource_DestroyAll)

_GDIPlus_Startup()

#Region ResourcesEx.au3 - Header
; #INDEX# =======================================================================================================================
; Title .........: ResourcesEx
; AutoIt Version : 3.3.12.0+
; Language ......: English
; Description ...:
; Author ........: Zedna
; Modified ......: guinness. Thanks to  Melba23, Larry, ProgAndy and UEZ.
; Dll ...........:
; ===============================================================================================================================

#cs
	This is currently what has been done to this UDF.
	Re-worked:
	_Resource_GetAsRaw()
	_Resource_GetAsBitmap()
	_Resource_GetAsBytes()
	_Resource_GetAsImage()
	_Resource_GetAsString()
	_Resource_PlaySound()
	_Resource_SaveToFile()
	_Resource_SetBitmapToCtrlID()
	_Resource_SetToCtrlID()
	_Resource_Shudown()

	SciTE calltips and userudfs file.

	Todo:
	Bug testing by the AutoIt community.
	http://www.autoitscript.com/forum/topic/162499-resourcesex-udf/
	http://pastebin.com/5ru8H0cN
	http://www.autoitscript.com/forum/topic/74565-extracticontofile-with-simple-gui-example/page-2#entry670142

	Changelog:
	2014/07/07:
	Added: _Resource_Destroy() and _Resource_Destroy() to destroy a particular resource name or all resources.
	Added: Checking if the resource name of id value is empty.
	Added: Descriptions, though could do with a little tweaking.
	Changed: _Resource_Get() to _Resource_GetAsRaw().
	Changed: Internal workings of __Resource_Storage().
	Changed: Re-size the storage array when destroyed or on shutdown.
	Fixed: _Resource_GetAsString() with default encoding of ANSI.
	Fixed: Calltips API referencing Resources.au3 and not ResourcesEx.au3.
	Removed: _Resource_Shudown() due to the addition of _Resource_Destroy() and _Resource_DestroyAll()

	2014/07/06:
	Added: _Resource_Shudown() to free up those resources which aren't loaded using _WinAPI_LockResource(). UnlockResource is obsolete.
	Added: Support for using $RT_STRING.
	Changed: _Resource_GetAsString() now works correctly for most encodings. (Thanks Jos)
	Changed: _Resource_GetAsString() will now load as a string if the resource type requested is $RT_STRING.

	2014/07/04:
	Added: #Regions. (Thanks mLipok)
	Added: #Tidy_Parameters=/sort_funcs /reel (Thanks mLipok)
	Added: All optional params now accept the default keyword.
	Added: Link to this thread. (Thanks mLipok)
	Added: Main header. (Thanks mLipok)
	Changed:  $f.... >> $b..... (Thanks mLipok)

	2014/07/03:
	Initial release.
#ce
#EndRegion ResourcesEx.au3 - Header

#Region ResourcesEx.au3 - #VARIABLES#
; #VARIABLES# ===================================================================================================================
; Error enumeration flags.
Global Enum $RESOURCE_ERROR_NONE, _
		$RESOURCE_ERROR_FINDRESOURCE, _
		$RESOURCE_ERROR_INVALIDCONTROLID, _
		$RESOURCE_ERROR_INVALIDCLASS, _
		$RESOURCE_ERROR_INVALIDRESOURCENAME, _
		$RESOURCE_ERROR_LOCKRESOURCE, _
		$RESOURCE_ERROR_LOADIMAGE, _
		$RESOURCE_ERROR_LOADLIBRARY, _
		$RESOURCE_ERROR_LOADSTRING, _
		$RESOURCE_ERROR_SETIMAGE

Global Enum $RESOURCE_STORAGE, $RESOURCE_STORAGE_FIRSTINDEX
Global Enum $RESOURCE_STORAGE_ID, $RESOURCE_STORAGE_INDEX, $RESOURCE_STORAGE_RESETCOUNT, $RESOURCE_STORAGE_UBOUND
Global Const $RESOURCE_STORAGE_GUID = 'CA37F1E6-04D1-11E4-B340-4B0AE3E253B6'
Global Enum $RESOURCE_STORAGE_PTR, $RESOURCE_STORAGE_RESLANG, $RESOURCE_STORAGE_RESNAMEORID, $RESOURCE_STORAGE_RESTYPE, $RESOURCE_STORAGE_MAX, _
		$RESOURCE_STORAGE_ADD, $RESOURCE_STORAGE_DESTROY, $RESOURCE_STORAGE_DESTROYALL

; ===============================================================================================================================
#EndRegion ResourcesEx.au3 - #VARIABLES#

#Region ResourcesEx.au3 - #FUNCTION#
; #FUNCTION# ====================================================================================================================
; Name ..........: _Resource_Destroy
; Description ...: Destroy a resource name or id value.
; Syntax ........: _Resource_Destroy($sResNameOrID[, $iResType = $RT_RCDATA])
; Parameters ....: $sResNameOrID        - A resource name or id value.
;                  $iResType            - [optional] Resource type. $RT_* constants located in APIResConstants.au3 Default is $RT_RCDATA.$RT_RCDATA.
; Return values .: Success - True
;				   Failure - False
; Author ........: guinness
; Modified ......:
; Remarks .......: Destroys the open $RT_BITMAP handles etc...of a resource name or id value.
; Related .......:
; Link ..........:
; ===============================================================================================================================
Func _Resource_Destroy($sResNameOrID, $iResType = $RT_RCDATA)
	If $iResType = Default Then $iResType = $RT_RCDATA
	Return __Resource_Storage($RESOURCE_STORAGE_DESTROY, Null, $sResNameOrID, $iResType, Null)
EndFunc   ;==>_Resource_Destroy

; #FUNCTION# ====================================================================================================================
; Name ..........: _Resource_DestroyAll
; Description ...:  Destroy all resources/
; Syntax ........: _Resource_DestroyAll()
; Parameters ....: None
; Return values .: Success - True
;				   Failure - False
; Author ........: guinness
; Modified ......:
; Remarks .......: Destroys all open $RT_BITMAP handles etc...of a resource name or id value.
; Related .......:
; Link ..........:
; ===============================================================================================================================
Func _Resource_DestroyAll()
	Return __Resource_Storage($RESOURCE_STORAGE_DESTROYALL, Null, Null, Null, Null)
EndFunc   ;==>_Resource_DestroyAll

; #FUNCTION# ====================================================================================================================
; Name ..........: _Resource_GetAsBitmap
; Description ...: Get an image from the resources as hBitmap type.
; Syntax ........: _Resource_GetAsBitmap($sResNameOrID[, $iResType = $RT_RCDATA[, $sDLL = Default]])
; Parameters ....: $sResNameOrID        - A resource name or id value.
;                  $iResType            - [optional] Resource type. $RT_* constants located in APIResConstants.au3 Default is $RT_RCDATA.
;                  $sDLL                - [optional] A filepath to an external DLL. Default is 0.
; Return values .: Success - Image handle
;				   Failure - Zero and sets @error to non-zero
; Author ........: Zedna
; Modified ......: guinness
; Remarks .......: The size of the resource is stored in @extended.
; Related .......:
; Link ..........:
; ===============================================================================================================================
Func _Resource_GetAsBitmap($sResNameOrID, $iResType = $RT_RCDATA, $sDLL = Default)
	Local $hImage = _Resource_GetAsImage($sResNameOrID, $iResType, $sDLL)
	Local $iError = @error
	Local $iLength = @extended
	Return SetError($iError, $iLength, (($iError = $RESOURCE_ERROR_NONE) ? _GDIPlus_BitmapCreateHBITMAPFromBitmap($hImage) : 0)) ; HBITMAP type.
EndFunc   ;==>_Resource_GetAsBitmap

; #FUNCTION# ====================================================================================================================
; Name ..........: _Resource_GetAsBytes
; Description ...: Get data from the resources as bytes.
; Syntax ........: _Resource_GetAsBytes($sResNameOrID[, $iResType = $RT_RCDATA[, $iResLang = Default[, $sDLL = Default]]])
; Parameters ....: $sResNameOrID        - A resource name or id value.
;                  $iResType            - [optional] Resource type. $RT_* constants located in APIResConstants.au3 Default is $RT_RCDATA.
;                  $iResLang            - [optional] A language identifier. Default is 0.
;                  $sDLL                - [optional] A filepath to an external DLL. Default is 0.
; Return values .: Success - String of bytes
;				   Failure - Empty byte string and sets @error to non-zero
; Author ........: Zedna
; Modified ......: guinness
; Remarks .......: The size of the resource is stored in @extended.Doesn't work for RT_BITMAP type because _Resource_GetAsRaw() returns HBITMAP instead of memory pointer.
; Related .......:
; Link ..........:
; ===============================================================================================================================
Func _Resource_GetAsBytes($sResNameOrID, $iResType = $RT_RCDATA, $iResLang = Default, $sDLL = Default)
	Local $vResource = _Resource_GetAsRaw($sResNameOrID, $iResType, $iResLang, $sDLL)
	Local $iError = @error
	Local $iLength = @extended
	Local $dBytes = Binary(Null)
	If $iError = $RESOURCE_ERROR_NONE And $iLength > 0 Then
		Local $tBuffer = DllStructCreate('byte array[' & $iLength & ']', $vResource)
		$dBytes = DllStructGetData($tBuffer, 'array')
	EndIf
	Return SetError($iError, $iLength, $dBytes)
EndFunc   ;==>_Resource_GetAsBytes

; #FUNCTION# ====================================================================================================================
; Name ..........: _Resource_GetAsImage
; Description ...: Get a picture from the resources as hImage type.
; Syntax ........: _Resource_GetAsImage($sResNameOrID[, $iResType = $RT_RCDATA[, $sDLL = Default]])
; Parameters ....: $sResNameOrID        - A resource name or id value.
;                  $iResType            - [optional] Resource type. $RT_* constants located in APIResConstants.au3 Default is $RT_RCDATA.
;                  $sDLL                - [optional] A filepath to an external DLL. Default is 0.
; Return values .: Success - Image handle
;				   Failure - Zero and sets @error to non-zero
; Author ........: Zedna
; Modified ......: guinness. Thanks to ProgAndy and UEZ.
; Remarks .......: The size of the resource is stored in @extended.
; Related .......:
; Link ..........:
; ===============================================================================================================================
Func _Resource_GetAsImage($sResNameOrID, $iResType = $RT_RCDATA, $sDLL = Default)
	If $iResType = Default Then $iResType = $RT_RCDATA
	Local $vResource = _Resource_GetAsRaw($sResNameOrID, $iResType, 0, $sDLL)
	Local $iError = @error
	Local $iLength = @extended

	Local $hImage = 0
	If $iError = $RESOURCE_ERROR_NONE And $iLength > 0 Then
		Switch $iResType
			Case $RT_BITMAP
				; $vResource is HBITMAP type.
				$hImage = _GDIPlus_BitmapCreateFromHBITMAP($vResource)
			Case Else
				; $vResource is memory pointer.
				Local $hData = _MemGlobalAlloc($iLength, $GMEM_MOVEABLE)
				Local $pData = _MemGlobalLock($hData)
				_MemMoveMemory($vResource, $pData, $iLength)
				_MemGlobalUnlock($hData)
				Local $pStream = _WinAPI_CreateStreamOnHGlobal($hData)
				$hImage = _GDIPlus_BitmapCreateFromStream($pStream) ; hImage type
				_WinAPI_ReleaseStream($pStream)
		EndSwitch
	EndIf
	Return SetError($iError, $iLength, $hImage)
EndFunc   ;==>_Resource_GetAsImage

; #FUNCTION# ====================================================================================================================
; Name ..........: _Resource_GetAsRaw
; Description ...: Get data from the resources.
; Syntax ........: _Resource_GetAsRaw($sResNameOrID[, $iResType = $RT_RCDATA[, $iResLang = Default[, $sDLL = Default]]])
; Parameters ....: $sResNameOrID        - A resource name or id value.
;                  $iResType            - [optional] Resource type. $RT_* constants located in APIResConstants.au3 Default is $RT_RCDATA.
;                  $iResLang            - [optional] A language identifier. Default is 0.
;                  $sDLL                - [optional] A filepath to an external DLL. Default is 0.
; Return values .: Success - Image handle
;				   Failure - Null and sets @error to non-zero
; Author ........: Zedna
; Modified ......: guinness
; Remarks .......: The size of the resource is stored in @extended.
; Related .......:
; Link ..........:
; ===============================================================================================================================
Func _Resource_GetAsRaw($sResNameOrID, $iResType = $RT_RCDATA, $iResLang = Default, $sDLL = Default)
	If StringStripWS($sResNameOrID, $STR_STRIPALL) = '' Then Return SetError($RESOURCE_ERROR_INVALIDRESOURCENAME, 0, Null) ; If the resource name or id value is empty.
	Local $bIsInternal = ($sDLL = Default Or $sDLL = -1)

	Local $hInstance = ($bIsInternal ? _WinAPI_GetModuleHandle(Null) : _WinAPI_LoadLibraryEx($sDLL, $LOAD_LIBRARY_AS_DATAFILE))
	If Not $hInstance Then Return SetError($RESOURCE_ERROR_LOADLIBRARY, 0, 0) ; Return an error as an issue occurred and there is no point in continuing.

	Local $iError = $RESOURCE_ERROR_NONE, $iLength = 0, _
			$vResource = Null

	If $iResLang = Default Then $iResLang = 0
	If $iResType = Default Then $iResType = $RT_RCDATA
	Local $hResource = (($iResLang <> 0) ? _WinAPI_FindResourceEx($hInstance, $iResType, $sResNameOrID, $iResLang) : _WinAPI_FindResource($hInstance, $iResType, $sResNameOrID))
	$iError = ((@error <> $RESOURCE_ERROR_NONE) ? $RESOURCE_ERROR_FINDRESOURCE : $RESOURCE_ERROR_NONE)

	If $iError = $RESOURCE_ERROR_NONE And $hResource Then
		$iLength = _WinAPI_SizeOfResource($hInstance, $hResource)
		Switch $iResType
			Case $RT_BITMAP
				$vResource = _WinAPI_LoadImage($hInstance, $sResNameOrID, $IMAGE_BITMAP, 0, 0, 0)
				$iError = ((@error <> $RESOURCE_ERROR_NONE) ? $RESOURCE_ERROR_LOADIMAGE : $RESOURCE_ERROR_NONE)
			Case $RT_STRING
				$vResource = _WinAPI_LoadString($hInstance, $sResNameOrID)
				$iError = ((@error <> $RESOURCE_ERROR_NONE) ? $RESOURCE_ERROR_LOADSTRING : $RESOURCE_ERROR_NONE)
				$iLength = @extended
			Case Else
				Local $hData = _WinAPI_LoadResource($hInstance, $hResource)
				$vResource = _WinAPI_LockResource($hData)
				$iError = (($vResource = 0) ? $RESOURCE_ERROR_LOCKRESOURCE : $RESOURCE_ERROR_NONE)
		EndSwitch
		If $iError <> $RESOURCE_ERROR_NONE Then $vResource = Null
	EndIf
	__Resource_Storage($RESOURCE_STORAGE_ADD, $vResource, $sResNameOrID, $iResType, $iResLang)

	If $bIsInternal Then _WinAPI_FreeLibrary($hInstance)
	Return SetError($iError, $iLength, $vResource)
EndFunc   ;==>_Resource_GetAsRaw

; #FUNCTION# ====================================================================================================================
; Name ..........: _Resource_GetAsString
; Description ...: Get a string from the resources.
; Syntax ........: _Resource_GetAsString($sResNameOrID[, $iResType = $RT_RCDATA[, $iResLang = Default[, $sDLL = Default]]])
; Parameters ....: $sResNameOrID        - A resource name or id value.
;                  $iResType            - [optional] Resource type. $RT_* constants located in APIResConstants.au3 Default is $RT_RCDATA.
;                  $iResLang            - [optional] A language identifier. Default is 0.
;                  $sDLL                - [optional] A filepath to an external DLL. Default is 0.
; Return values .: Success - String
;				   Failure - Empty string and sets @error to non-zero
; Author ........: Zedna
; Modified ......: guinness. Thanks to Jos.
; Remarks .......: The size of the resource is stored in @extended.
; Related .......:
; Link ..........:
; ===============================================================================================================================
Func _Resource_GetAsString($sResNameOrID, $iResType = $RT_RCDATA, $iResLang = Default, $sDLL = Default)
	Local $iError = 0, _
			$iLength = 0, _
			$sString = ''

	If $iResType = $RT_STRING Then
		$sString = _Resource_GetAsRaw($sResNameOrID, $iResType, $iResLang, $sDLL)
		$iError = @error
		$iLength = @extended
	Else
		Local $dBytes = _Resource_GetAsBytes($sResNameOrID, $iResType, $iResLang, $sDLL)
		$iError = @error
		$iLength = @extended

		; http://www.autoitscript.com/forum/topic/72182-byte-order-marker-bom-check-for-unicode/
		Local Enum $BINARYTOSTRING_NONE, $BINARYTOSTRING_ANSI, $BINARYTOSTRING_UTF16LE, $BINARYTOSTRING_UTF16BE, $BINARYTOSTRING_UTF8
		Local $iStart = $BINARYTOSTRING_NONE, $iUTFEncoding = $BINARYTOSTRING_ANSI
		Local Const $sUTF8 = '0xEFBBBF', _
				$sUTF16BE = '0xFEFF', $sUTF16LE = '0xFFFE', _
				$sUTF32BE = '0x0000FEFF', $sUTF32LE = '0xFFFE0000'
		Local $iUTF8 = BinaryLen($sUTF8), _
				$iUTF16BE = BinaryLen($sUTF16BE), $iUTF16LE = BinaryLen($sUTF16LE), _
				$iUTF32BE = BinaryLen($sUTF32BE), $iUTF32LE = BinaryLen($sUTF32LE)
		Select
			Case BinaryMid($dBytes, 1, $iUTF32BE) = $sUTF32BE
				$iStart = $iUTF32BE
				$iUTFEncoding = $BINARYTOSTRING_ANSI
			Case BinaryMid($dBytes, 1, $iUTF32LE) = $sUTF32LE
				$iStart = $iUTF32LE
				$iUTFEncoding = $BINARYTOSTRING_ANSI
			Case BinaryMid($dBytes, 1, $iUTF16BE) = $sUTF16BE
				$iStart = $iUTF16BE
				$iUTFEncoding = $BINARYTOSTRING_UTF16BE
			Case BinaryMid($dBytes, 1, $iUTF16LE) = $sUTF16LE
				$iStart = $iUTF16LE
				$iUTFEncoding = $BINARYTOSTRING_UTF16LE
			Case BinaryMid($dBytes, 1, $iUTF8) = $sUTF8
				$iStart = $iUTF8
				$iUTFEncoding = $BINARYTOSTRING_UTF8
		EndSelect
		$iStart += 1 ; Increase by 1 to strip the byte order mark.
		$iLength = $iLength + 1 - $iStart
		$sString = BinaryToString(BinaryMid($dBytes, $iStart), $iUTFEncoding)
	EndIf
	Return SetError($iError, $iLength, $sString)
EndFunc   ;==>_Resource_GetAsString

; #FUNCTION# ====================================================================================================================
; Name ..........: _Resource_PlaySound
; Description ...: Play sound from the resources (only wav).
; Syntax ........: _Resource_PlaySound($sResNameOrID[, $iFlags = $SND_SYNC[, $sDLL = Default]])
; Parameters ....: $sResNameOrID        - A resource name or id value.
;                  $iFlags              - [optional] See $iFlags for the $SND_* constants in _WinAPI_PlaySound(). Default is $SND_SYNC.
;                  $sDLL                - [optional] A filepath to an external DLL. Default is 0.
; Return values .: Success - True
;				   Failure - False
; Author ........: Zedna
; Modified ......: guinness. Thanks to Larry, ProgAndy, guinness
; Remarks .......:
; Related .......:
; Link ..........: http://msdn2.microsoft.com/en-us/library/ms712879.aspx
; ===============================================================================================================================
Func _Resource_PlaySound($sResNameOrID, $iFlags = $SND_SYNC, $sDLL = Default) ; Returns no @error, just True or False.
	Local $bIsInternal = ($sDLL = Default Or $sDLL = -1)
	Local $hInstance = ($bIsInternal ? 0 : _WinAPI_LoadLibraryEx($sDLL, $LOAD_LIBRARY_AS_DATAFILE))
	If $iFlags = Default Then $iFlags = $SND_SYNC
	Local $bReturn = _WinAPI_PlaySound($sResNameOrID, BitOR($SND_RESOURCE, $iFlags), $hInstance)
	If Not $bIsInternal Then _WinAPI_FreeLibrary($hInstance)
	Return $bReturn
EndFunc   ;==>_Resource_PlaySound

; #FUNCTION# ====================================================================================================================
; Name ..........: _Resource_SaveToFile
; Description ...: Save a resource to a file.
; Syntax ........: _Resource_SaveToFile($sFilePath, $sResNameOrID[, $iResType = $RT_RCDATA[, $iResLang = Default[, $bCreatePath = Default[,
;                  $sDLL = Default]]]])
; Parameters ....: $sFilePath           - The filepath to save the resource to.
;                  $sResNameOrID        - A resource name or id value.
;                  $iResType            - [optional] Resource type. $RT_* constants located in APIResConstants.au3 Default is $RT_RCDATA.
;                  $iResLang            - [optional] A language identifier. Default is 0.
;                  $bCreatePath         - [optional] Create the path if it doesn't exist. Default is False.
;                  $sDLL                - [optional] A filepath to an external DLL. Default is 0.
; Return values .: Success - True
;				   Failure - False and sets @error to non-zero.
; Author ........: Zedna
; Modified ......: guinness
; Remarks .......: The size of the resource is stored in @extended.
; Related .......:
; Link ..........:
; ===============================================================================================================================
Func _Resource_SaveToFile($sFilePath, $sResNameOrID, $iResType = $RT_RCDATA, $iResLang = Default, $bCreatePath = Default, $sDLL = Default)
	Local $bReturn = False, _
			$iCreatePath = (IsBool($bCreatePath) And $bCreatePath ? $FO_CREATEPATH : 0), $iError = $RESOURCE_ERROR_NONE, $iLength = 0
	If $iResType = Default Then $iResType = $RT_RCDATA
	If $iResType = $RT_BITMAP Then
		; Workaround: for RT_BITMAP _Resource_GetAsBytes() doesn't work so use _Resource_GetAsImage() instead.
		Local $hImage = _Resource_GetAsImage($sResNameOrID, $iResType)
		$iError = @error
		$iLength = @extended

		If $iError = $RESOURCE_ERROR_NONE And $iLength > 0 Then
			FileClose(FileOpen($sFilePath, BitOR($FO_OVERWRITE, $FO_BINARY, $iCreatePath))) ; Create the filepath.
			$bReturn = _GDIPlus_ImageSaveToFile($hImage, $sFilePath)
			_GDIPlus_ImageDispose($hImage)
		EndIf
	Else
		Local $dBytes = _Resource_GetAsBytes($sResNameOrID, $iResType, $iResLang, $sDLL)
		$iError = @error
		$iLength = @extended

		If $iError = $RESOURCE_ERROR_NONE And $iLength > 0 Then
			Local $hFileOpen = FileOpen($sFilePath, BitOR($FO_OVERWRITE, $FO_BINARY, $iCreatePath))
			If $hFileOpen > -1 Then
				$bReturn = True
				FileWrite($hFileOpen, $dBytes)
				FileClose($hFileOpen)
			EndIf
		EndIf
	EndIf

	Return SetError($iError, $iLength, $bReturn)
EndFunc   ;==>_Resource_SaveToFile

; #FUNCTION# ====================================================================================================================
; Name ..........: _Resource_SetBitmapToCtrlID
; Description ...: Set  bitmap image to controlid.
; Syntax ........: _Resource_SetBitmapToCtrlID($iCtrlID, $hBitmap)
; Parameters ....: $iCtrlID             - A valid controlid.
;                  $hBitmap             - A bitmap image handle
; Return values .: Success - True
;				   Failure - False and sets @error to non-zero
; Author ........: Zedna
; Modified ......: guinness. Thanks to Melba23.
; Remarks .......:
; Related .......:
; Link ..........:
; ===============================================================================================================================
Func _Resource_SetBitmapToCtrlID($iCtrlID, $hBitmap)
	If $iCtrlID = Default Or $iCtrlID <= 0 Or Not IsInt($iCtrlID) Then $iCtrlID = -1 ; Set to -1 if $iCtrlID is Default, less than zero or not an integer.
	Local $hWnd = GUICtrlGetHandle($iCtrlID) ; Get the handle of the controlid.
	If $hWnd And $iCtrlID = -1 Then ; Get the controlid if $iCtrlID is -1.
		$iCtrlID = _WinAPI_GetDlgCtrlID($hWnd) ; Support for $iCtrlID = Default or $iCtrlID = -1
	EndIf

	Local $bReturn = False, _
			$iError = $RESOURCE_ERROR_INVALIDCONTROLID ; No controlid or handle.
	If $hWnd And $iCtrlID Then
		$bReturn = True
		$iError = $RESOURCE_ERROR_NONE

		Local $iCtrlID_BITMAP = 0, $iCtrlID_SETIMAGE = 0 ; $iCtrlID_GETIMAGE = 0
		; Determine the control class and adjust the values accordingly.
		Switch _WinAPI_GetClassName($iCtrlID)
			Case 'Button' ; button, checkbox, radiobutton, groupbox.
				$iCtrlID_BITMAP = $BS_BITMAP
				; $iCtrlID_GETIMAGE = $BM_GETIMAGE
				$iCtrlID_SETIMAGE = $BM_SETIMAGE
			Case 'Static' ; picture, icon, labe
				$iCtrlID_BITMAP = $SS_BITMAP
				; $iCtrlID_GETIMAGE = 0x0173 ; $STM_GETIMAGE
				$iCtrlID_SETIMAGE = 0x0172 ; $STM_SETIMAGE
			Case Else
				$bReturn = False
				$iError = $RESOURCE_ERROR_INVALIDCLASS
		EndSwitch

		If $bReturn Then
			; Set SS_BITMAP/BS_BITMAP style to the control.
			_WinAPI_SetWindowLong($hWnd, $GWL_STYLE, BitOR(_WinAPI_GetWindowLong($hWnd, $GWL_STYLE), $iCtrlID_BITMAP))

			; Set the image to the control and delete the previous image handle.
			Local $hImage = _SendMessage($hWnd, $iCtrlID_SETIMAGE, $IMAGE_BITMAP, $hBitmap)
			If Not @error And $hImage Then
				_WinAPI_DeleteObject($hImage)
			Else
				$bReturn = False
				$iError = $RESOURCE_ERROR_SETIMAGE
			EndIf
		EndIf
	EndIf
	Return SetError($iError, 0, $bReturn)
EndFunc   ;==>_Resource_SetBitmapToCtrlID

; #FUNCTION# ====================================================================================================================
; Name ..........: _Resource_SetToCtrlID
; Description ...: Set am image from resources to controlid.
; Syntax ........: _Resource_SetToCtrlID($iCtrlID, $sResNameOrID[, $iResType = $RT_RCDATA[, $sDLL = Default]])
; Parameters ....: $iCtrlID             - A valid controlid.
;                  $sResNameOrID        - A resource name or id value.
;                  $iResType            - [optional] Resource type. $RT_* constants located in APIResConstants.au3 Default is $RT_RCDATA.
;                  $sDLL                - [optional] A filepath to an external DLL. Default is 0.
; Return values .: Success - True (on XP it returns the image handle to be then destroyed by _WinAPI_DeleteObject() when no longer needed.
;				   Failure - False and sets @error to non-zero
; Author ........: Zedna
; Modified ......: guinness. Thanks to ProgAndy and UEZ.
; Remarks .......: The size of the resource is stored in @extended.
; Related .......:
; Link ..........:
; ===============================================================================================================================
Func _Resource_SetToCtrlID($iCtrlID, $sResNameOrID, $iResType = $RT_RCDATA, $sDLL = Default)
	If $iResType = Default Then $iResType = $RT_RCDATA
	Local $vResource = _Resource_GetAsRaw($sResNameOrID, $iResType, 0, $sDLL)
	Local $iError = @error
	Local $iLength = @extended

	Local $vReturn = False
	If $iError = $RESOURCE_ERROR_NONE And $iLength > 0 Then
		If $iResType = $RT_BITMAP Then
			$vReturn = _Resource_SetBitmapToCtrlID($iCtrlID, $vResource)
			$iError = @error
		Else
			; For other types than BITMAP use GDI+ for converting to bitmap first
			Local $hData = _MemGlobalAlloc($iLength, $GMEM_MOVEABLE)
			Local $pData = _MemGlobalLock($hData)
			_MemMoveMemory($vResource, $pData, $iLength)
			_MemGlobalUnlock($hData)
			Local $pStream = _WinAPI_CreateStreamOnHGlobal($hData)
			Local $pBitmap = _GDIPlus_BitmapCreateFromStream($pStream)
			Local $hBitmap = _GDIPlus_BitmapCreateHBITMAPFromBitmap($pBitmap)
			$vReturn = _Resource_SetBitmapToCtrlID($iCtrlID, $hBitmap)
			$iError = @error
			_GDIPlus_BitmapDispose($pBitmap)
			If $__WINVER >= 0x0600 Then
				_WinAPI_DeleteObject($hBitmap) ; Delete if Vista and above.
			Else
				$vReturn = $hBitmap
				__Resource_Storage($RESOURCE_STORAGE_ADD, $hBitmap, $sResNameOrID, $iResType, Null)
			EndIf
			_WinAPI_DeleteObject($pStream)
			_MemGlobalFree($hData)
		EndIf
	EndIf
	Return SetError($iError, $iLength, $vReturn) ; If XP then $vReturn is $hBitmap that should be destroyed with _WinAPI_DeleteObject() when not used.
EndFunc   ;==>_Resource_SetToCtrlID

Func __Resource_Destroy(ByRef $aStorage, $iIndex)
	Local $bReturn = False
	If Not ($aStorage[$iIndex][$RESOURCE_STORAGE_PTR] = Null) Then
		Switch $aStorage[$iIndex][$RESOURCE_STORAGE_RESTYPE]
			Case $RT_BITMAP
				$bReturn = _WinAPI_DeleteObject($aStorage[$iIndex][$RESOURCE_STORAGE_PTR])
			Case $RT_STRING
				; No action required.
				$bReturn = True
			Case Else
				; No action required.
				$bReturn = True
		EndSwitch
		If $bReturn Then
			; Destroy the internal array contents.
			$aStorage[$iIndex][$RESOURCE_STORAGE_PTR] = Null
			$aStorage[$iIndex][$RESOURCE_STORAGE_RESLANG] = Null
			$aStorage[$iIndex][$RESOURCE_STORAGE_RESNAMEORID] = Null
			$aStorage[$iIndex][$RESOURCE_STORAGE_RESTYPE] = Null
		EndIf
	EndIf
	Return $bReturn
EndFunc   ;==>__Resource_Destroy

Func __Resource_Storage($iAction, $vResource, $sResNameOrID, $iResType, $iResLang)
	If StringStripWS($sResNameOrID, $STR_STRIPALL) = '' Then Return SetError($RESOURCE_ERROR_INVALIDRESOURCENAME, 0, False) ; If the resource name or id value is empty.
	Local Static $aStorage[$RESOURCE_STORAGE_FIRSTINDEX][$RESOURCE_STORAGE_MAX] ; Internal storage.

	Local $bReturn = False
	Switch $iAction
		Case $RESOURCE_STORAGE_ADD
			If Not ($aStorage[$RESOURCE_STORAGE][$RESOURCE_STORAGE_ID] = $RESOURCE_STORAGE_GUID) Then
				$aStorage[$RESOURCE_STORAGE][$RESOURCE_STORAGE_ID] = $RESOURCE_STORAGE_GUID
				$aStorage[$RESOURCE_STORAGE][$RESOURCE_STORAGE_INDEX] = 0
				$aStorage[$RESOURCE_STORAGE][$RESOURCE_STORAGE_RESETCOUNT] = 0
				$aStorage[$RESOURCE_STORAGE][$RESOURCE_STORAGE_UBOUND] = $RESOURCE_STORAGE_FIRSTINDEX
			EndIf

			If Not ($vResource = Null) Then ; If the resource pointer is not Null.
				$bReturn = True
				$aStorage[$RESOURCE_STORAGE][$RESOURCE_STORAGE_INDEX] += 1
				If $aStorage[$RESOURCE_STORAGE][$RESOURCE_STORAGE_INDEX] >= $aStorage[$RESOURCE_STORAGE][$RESOURCE_STORAGE_UBOUND] Then ; Re-sze the internal storage if required.
					$aStorage[$RESOURCE_STORAGE][$RESOURCE_STORAGE_UBOUND] = Ceiling($aStorage[$RESOURCE_STORAGE][$RESOURCE_STORAGE_INDEX] * 1.3)
					ReDim $aStorage[$aStorage[$RESOURCE_STORAGE][$RESOURCE_STORAGE_UBOUND]][$RESOURCE_STORAGE_MAX]
				EndIf
				$aStorage[$aStorage[$RESOURCE_STORAGE][$RESOURCE_STORAGE_INDEX]][$RESOURCE_STORAGE_PTR] = $vResource
				$aStorage[$aStorage[$RESOURCE_STORAGE][$RESOURCE_STORAGE_INDEX]][$RESOURCE_STORAGE_RESLANG] = $iResLang
				$aStorage[$aStorage[$RESOURCE_STORAGE][$RESOURCE_STORAGE_INDEX]][$RESOURCE_STORAGE_RESNAMEORID] = $sResNameOrID
				$aStorage[$aStorage[$RESOURCE_STORAGE][$RESOURCE_STORAGE_INDEX]][$RESOURCE_STORAGE_RESTYPE] = $iResType
			EndIf

		Case $RESOURCE_STORAGE_DESTROY ; http://msdn.microsoft.com/en-us/library/windows/desktop/ms648044(v=vs.85).aspx
			Local $iDestoryCount = 0, $iDestoryed = 0
			; Delete a resource name or id value handle.
			For $i = $RESOURCE_STORAGE_FIRSTINDEX To $aStorage[$RESOURCE_STORAGE][$RESOURCE_STORAGE_INDEX]
				If $aStorage[$i][$RESOURCE_STORAGE_RESNAMEORID] = $sResNameOrID And $aStorage[$i][$RESOURCE_STORAGE_RESTYPE] = $iResType Then
					$bReturn = __Resource_Destroy($aStorage, $i)
					If $bReturn Then
						$iDestoryed += 1
						$aStorage[$RESOURCE_STORAGE][$RESOURCE_STORAGE_RESETCOUNT] += 1 ; Increase the reset count.
					EndIf
					$iDestoryCount += 1
				EndIf
			Next
			$bReturn = $iDestoryCount = $iDestoryed ; If the destroyed count equals the actual destroyed values.

			; Delete Null entries and tidy the internal storage if 20 or more items have been destroyed.
			If $aStorage[$RESOURCE_STORAGE][$RESOURCE_STORAGE_RESETCOUNT] >= 20 Then
				Local $iIndex = 0
				For $i = $RESOURCE_STORAGE_FIRSTINDEX To $aStorage[$RESOURCE_STORAGE][$RESOURCE_STORAGE_INDEX]
					If Not ($aStorage[$i][$RESOURCE_STORAGE_PTR] = Null) Then
						$iIndex += 1
						For $j = 0 To $RESOURCE_STORAGE_MAX - 1
							$aStorage[$iIndex][$j] = $aStorage[$i][$j]
						Next
					EndIf
				Next
				$aStorage[$RESOURCE_STORAGE][$RESOURCE_STORAGE_INDEX] = $iIndex ; Last index added.
				$aStorage[$RESOURCE_STORAGE][$RESOURCE_STORAGE_RESETCOUNT] = 0 ; Reset the reset count.
				$aStorage[$RESOURCE_STORAGE][$RESOURCE_STORAGE_UBOUND] = $iIndex + $RESOURCE_STORAGE_FIRSTINDEX ; Last index plus the first index position.
				ReDim $aStorage[$aStorage[$RESOURCE_STORAGE][$RESOURCE_STORAGE_UBOUND]][$RESOURCE_STORAGE_MAX]
			EndIf

		Case $RESOURCE_STORAGE_DESTROYALL
			$bReturn = True
			For $i = $RESOURCE_STORAGE_FIRSTINDEX To $aStorage[$RESOURCE_STORAGE][$RESOURCE_STORAGE_INDEX]
				__Resource_Destroy($aStorage, $i)
			Next
			$aStorage[$RESOURCE_STORAGE][$RESOURCE_STORAGE_INDEX] = 0 ; Reset the index count.
			$aStorage[$RESOURCE_STORAGE][$RESOURCE_STORAGE_RESETCOUNT] = 0 ; Reset the reset count.
			$aStorage[$RESOURCE_STORAGE][$RESOURCE_STORAGE_UBOUND] = $RESOURCE_STORAGE_FIRSTINDEX ; Reset the length count.
			ReDim $aStorage[$aStorage[$RESOURCE_STORAGE][$RESOURCE_STORAGE_UBOUND]][$RESOURCE_STORAGE_MAX]

	EndSwitch
	Return $bReturn
EndFunc   ;==>__Resource_Storage
#EndRegion ResourcesEx.au3 - #FUNCTION#
