;===============================================================================
;
; Description:      Return JPEG, TIFF, BMP, PNG and GIF image common info:
;                   Size, Color Depth, Resolution etc. For JPEG files retreive
;                   additional information from exif tag (if exists).
; Parameter(s):     File name
; Requirement(s):   Autoit 3.3.0.0
; Return Value(s):  On Success - string in format:
;                   ParamName=ParamValue
;                   Pairs are separated by LF char. For getting data can be used
;                   function _ImageGetParam($sData, $sParam), where
;                      $sData - string, returned by  _ImageGetInfo
;                      $sParam - param name, for ex. Width
;                   On Failure sets @ERROR:
;                       1 - Can't open image
;                   Return string become empty if no info found
; Author(s):        Dmitry Yudin (Lazycat)
; Version:          2.8
; Date:             08.10.2010
;
;===============================================================================
Func _ImageGetInfo($sFile)
	Local $sInfo = "", $nClr, $t
	Local $ret = DllCall("kernel32.dll", "int", "CreateFile", "str", $sFile, "int", 0x80000000, "int", 0, "ptr", 0, "int", 3, "int", 0x80, "ptr", 0)

	If @error Or Not $ret[0] Then
		SetError(1)
		Return ""
	EndIf
	Local $hFile = $ret[0]
	Local $p = _FileReadToStruct("ubyte[54]", $hFile, 0)
	Local $asIdent[8] = [7, Chr(0xFF) & Chr(0xD8), "BM", Chr(0x89) & "PNG" & Chr(0x0D) & Chr(0x0A) & Chr(0x1A) & Chr(0x0A), "GIF89", "GIF87", "II", "MM"]
	For $A = 1 To $asIdent[0]
		If _DllStructArrayAsString($p, 1, StringLen($asIdent[$A])) = $asIdent[$A] Then
			Select
				Case $A = 1 ; JPEG
					$sInfo = _ImageGetInfoJPG($hFile, FileGetSize($sFile))
					ExitLoop
				Case $A = 2 ; BMP
					$t = DllStructCreate("int;int;short;short;dword;dword;dword;dword", DllStructGetPtr($p, 1) + 18)
					_Add($sInfo, "Width",  DllStructGetData($t, 1))
					_Add($sInfo, "Height", DllStructGetData($t, 2))
					_Add($sInfo, "ColorDepth", DllStructGetData($t, 4))
					_Add($sInfo, "XResolution", Round(DllStructGetData($t, 7)/39.37))
					_Add($sInfo, "YResolution", Round(DllStructGetData($t, 8)/39.37))
					_Add($sInfo, "ResolutionUnit", "Inch")
					ExitLoop
				Case $A = 3 ; PNG
					$sInfo = _ImageGetInfoPNG($hFile, FileGetSize($sFile))
					ExitLoop
				Case ($A = 4) Or ($A = 5) ; GIF
					$t = DllStructCreate("short;short;ubyte", DllStructGetPtr($p, 1) + 6)
					_Add($sInfo, "Width",  DllStructGetData($t, 1))
					_Add($sInfo, "Height", DllStructGetData($t, 2))
					$nClr = DllStructGetData($t, 3)
					_Add($sInfo, "ColorDepth", _IsBitSet($nClr, 0) + _IsBitSet($nClr, 1) * 2 + _IsBitSet($nClr, 2) * 4 + 1)
					ExitLoop
				Case $A = 6 ; TIFF II
					$sInfo = _ImageGetInfoTIFF($hFile, 0)
					ExitLoop
				Case $A = 7 ; TIFF MM
					$sInfo = _ImageGetInfoTIFF($hFile, 1)
					ExitLoop
			EndSelect
		EndIf
	Next
	DllCall("kernel32.dll", "int", "CloseHandle", "int", $hFile)
	$p = 0
	Return($sInfo)
EndFunc

;===============================================================================
; PNG Parser
;===============================================================================
Func _ImageGetInfoPNG($hFile, $nFileSize)
	Local $sInfo = "", $nNextOffset = 8, $nBlockSize, $nID = 0
	Local $nBPP, $nCol, $sAlpha, $nXRes, $nYRes, $sKeyword, $nKWLen, $t
	Local $pBlockID = DllStructCreate("ulong;ulong")
	While $nID <> 0x49454E44 ; IEND
		$pBlockID = _FileReadToStruct($pBlockID, $hFile, $nNextOffset)
		$nBlockSize = _IntR(DllStructGetData($pBlockID, 1))
		If $nBlockSize > $nFileSize Then Return SetError(1, 0, $sInfo)
		$nID = _IntR(DllStructGetData($pBlockID, 2))
		Select
			Case $nID = 0x49484452 ; IHDR
				$t = _FileReadToStruct("ulong;ulong;byte;byte;byte;byte;byte", $hFile, $nNextOffset + 8)
				_Add($sInfo, "Width",  _IntR(DllStructGetData($t, 1)))
				_Add($sInfo, "Height", _IntR(DllStructGetData($t, 2)))
				$nBPP = DllStructGetData($t, 3)
				$nCol = DllStructGetData($t, 4)
				$sAlpha = ""
				If $nCol > 3 Then
					$nCol = $nCol - 4
					$sAlpha = " + alpha"
				EndIf
				If $nCol < 3 Then $nBPP = ($nCol + 1) * $nBPP
				_Add($sInfo, "ColorDepth", $nBPP & $sAlpha)
				_Add($sInfo, "Interlace", DllStructGetData($t, 7))
			Case $nID = 0x70485973 ; pHYs
				$t = _FileReadToStruct("ulong;ulong;ubyte", $hFile, $nNextOffset + 8)
				$nXRes = _IntR(DllStructGetData($t, 1))
				$nYRes = _IntR(DllStructGetData($t, 2))
				If DllStructGetData($t, 3) = 1 Then
					$nXRes = Round($nXRes/39.37)
					$nYRes = Round($nYRes/39.37)
				EndIf
				_Add($sInfo, "XResolution", $nXRes)
				_Add($sInfo, "YResolution", $nYRes)
				_Add($sInfo, "ResolutionUnit", "Inch")
			Case $nID = 0x74455874 ; tEXt
				$t = _FileReadToStruct("char[80]", $hFile, $nNextOffset + 8)
				$sKeyword = DllStructGetData($t, 1)
				$nKWLen = StringLen($sKeyword) + 1
				$t = _FileReadToStruct("char[" & $nBlockSize - $nKWLen & "]", $hFile, $nNextOffset + 8 + $nKWLen)
				_Add($sInfo, $sKeyword, DllStructGetData($t, 1))
			Case $nID = 0x74494D45 ; tIME
				$t = _FileReadToStruct("ushort,ubyte,ubyte,ubyte,ubyte,ubyte", $hFile, $nNextOffset + 8)
				_Add($sInfo, "DateTime", StringFormat("%4d:%02d:%02d %02d:%02d:%02d", DllStructGetData($t, 1), DllStructGetData($t, 2), DllStructGetData($t, 3), DllStructGetData($t, 4), DllStructGetData($t, 5), DllStructGetData($t, 6)))
		EndSelect
		$nNextOffset = $nNextOffset + 12 + $nBlockSize ; 12 = data size + data header + crc32 size
		$t = 0
	Wend
	Return $sInfo
EndFunc

;===============================================================================
; JPEG Parser
;===============================================================================
Func _ImageGetInfoJPG($hFile, $nFileSize)
	Local $nPos = 2, $sInfo = ""
	Local $sUnit = "Pixel", $nMarker = 0, $nComLen, $t, $nUnit
	Local $p = DllStructCreate("ubyte;ubyte;ushort;byte[128]")
	While ($nMarker <> 0xDA) and ($nPos < $nFileSize)
		$p = _FileReadToStruct($p, $hFile, $nPos)
		If DllStructGetData($p, 1) = 0xFF Then ; Valid segment start
			$nMarker = DllStructGetData($p, 2)
			Select
				Case ($nMarker = 0xC0) Or ($nMarker = 0xC1) Or ($nMarker = 0xC2) Or ($nMarker = 0xC3) Or ($nMarker = 0xC5) Or ($nMarker = 0xC6) Or ($nMarker = 0xC7) Or ($nMarker = 0xCB) Or ($nMarker = 0xCD) Or ($nMarker = 0xCE) Or ($nMarker = 0xCF)
					$t = DllStructCreate("align 1;byte;ushort;ushort", DllStructGetPtr($p, 4))
					_Add($sInfo, "Width",  _IntR(DllStructGetData($t, 3)))
					_Add($sInfo, "Height", _IntR(DllStructGetData($t, 2)))
				Case $nMarker = 0xE0 ; JFIF header
					$t = DllStructCreate("byte[5];byte;byte;ubyte;ushort;ushort", DllStructGetPtr($p, 4))
					$nUnit = _IntR(DllStructGetData($t, 4))
					If $nUnit = 1 Then
						$sUnit = "Inch"
					ElseIf $nUnit = 2 Then
						$sUnit = "Cm"
					EndIf
					_Add($sInfo, "XResolution", _IntR(DllStructGetData($t, 5)))
					_Add($sInfo, "YResolution", _IntR(DllStructGetData($t, 6)))
					_Add($sInfo, "ResolutionUnit", $sUnit)
				Case $nMarker = 0xE1 ; EXIF segment
					$sInfo = $sInfo & ParseExif($hFile, $nPos)
				Case $nMarker = 0xFE ; Comment segment
					$nComLen = _IntR(DllStructGetData($p, 3)) - 2
					$t = _FileReadToStruct("byte[" & $nComLen & "]", $hFile, $nPos + 4)
					_Add($sInfo, "Comment", _DllStructArrayAsString($t, 1, $nComLen))
					$t = 0
				Case Else
			EndSelect
			$nPos= $nPos + _IntR(DllStructGetData($p, 3)) + 2
		Else
			ExitLoop
		EndIf
	Wend
	$p = 0
	Return($sInfo)
EndFunc

;===============================================================================
; TIFF Parser
;===============================================================================
Func _ImageGetInfoTIFF($hFile, $nByteOrder)
	Local $pHdr, $nTagsOffset, $pCount, $nFieldCount, $pTag, $ID, $t
	Local $sInfo = "", $aTag[1][2]

	_AddPair($aTag, 0x0100, "Width")
	_AddPair($aTag, 0x0101, "Height")
	_AddPair($aTag, 0x011A, "XResolution")
	_AddPair($aTag, 0x011B, "YResolution")
	_AddPair($aTag, 0x0132, "DateTime")
	_AddPair($aTag, 0x0131, "Software")
	_AddPair($aTag, 0x8298, "Copyright")

	$pHdr = _FileReadToStruct("short;short;dword", $hFile, 0)
	$nTagsOffset = _IntR(DllStructGetData($pHdr, 3), $nByteOrder)
	$pCount = _FileReadToStruct("ushort", $hFile, $nTagsOffset)
	$nFieldCount = _IntR(DllStructGetData($pCount, 1), $nByteOrder)
	$pTag = DllStructCreate("ushort;ushort;ulong;ulong")
	For $A = 0 To $nFieldCount - 1
		$pTag = _FileReadToStruct($pTag, $hFile, $nTagsOffset + 2 + 12 * $A)
		$ID = _IntR(DllStructGetData($pTag, 1), $nByteOrder)
		For $B = 1 To $aTag[0][0]
			If $aTag[$B][0] = $ID Then
				_Add($sInfo, $aTag[$B][1], _ReadTag($hFile, $pTag, 0, $nByteOrder)) ; Tiff header at 0 offset
				ExitLoop
			EndIf
		Next
		If $ID = 0x0102 Then
			If _IntR(DllStructGetData($pTag, 3), $nByteOrder) = 3 Then
				$t = _FileReadToStruct("short;short;short", $hFile, _IntR(DllStructGetData($pTag, 4), $nByteOrder))
				_Add($sInfo, "ColorDepth", _IntR(DllStructGetData($t, 1), $nByteOrder) + _IntR(DllStructGetData($t, 2), $nByteOrder) + _IntR(DllStructGetData($t, 3), $nByteOrder))
				$t = 0
			Else
				_Add($sInfo, "ColorDepth", _IntR(DllStructGetData($pTag, 4), $nByteOrder))
			EndIf
		EndIf
		If $ID = 0x0128 Then _AddSpecial($sInfo, $ID, _ReadTag($hFile, $pTag, 0, $nByteOrder))
	Next
	Return($sInfo)
EndFunc

;===============================================================================
; EXIF Parser
;===============================================================================
Func ParseExif($hFile, $exif_offset)
	Local $nTiffHdrOffset, $pHdr, $nIFDOffset, $pCnt, $nIFDCount, $pTag, $nCnt, $ID, $nEIFDCount
	Local $ByteOrder = 0, $sInfo = ""
	Local $nEIFDOffset, $aTag[1][2]
	Local $sSpecialTags = "0112,8822,9208,9207,9209,9101,0128,A217,A403,A402,A406,A408,A409,A40A"

	_AddPair($aTag, 0x0100, "ExifWidth")
	_AddPair($aTag, 0x0101, "ExifHeight")
	_AddPair($aTag, 0x011A, "XResolution")
	_AddPair($aTag, 0x011B, "YResolution")
	_AddPair($aTag, 0x0102, "Colordepth")
	_AddPair($aTag, 0x0132, "DateTime")
	_AddPair($aTag, 0x9003, "DateTimeOriginal")
	_AddPair($aTag, 0x9004, "DateTimeDigitized")
	_AddPair($aTag, 0x9102, "CompressedBitsPerPixel")
	_AddPair($aTag, 0x9000, "ExifVersion")
	_AddPair($aTag, 0x9204, "ExposureBiasValue")
	_AddPair($aTag, 0x829A, "ExposureTime")
	_AddPair($aTag, 0x829D, "FNumber")
	_AddPair($aTag, 0x920A, "FocalLength")
	_AddPair($aTag, 0x8827, "ISO")
	_AddPair($aTag, 0x010F, "Make")
	_AddPair($aTag, 0x9202, "ApertureValue")
	_AddPair($aTag, 0x9205, "MaxApertureValue")
	_AddPair($aTag, 0x0110, "Model")
	_AddPair($aTag, 0x0131, "Software")
	_AddPair($aTag, 0x010E, "ImageDescription")
	_AddPair($aTag, 0x013B, "Artist")
	_AddPair($aTag, 0x8298, "Copyright")
	_AddPair($aTag, 0xA420, "ImageUniqueID")
	_AddPair($aTag, 0x9286, "UserComments")
	_AddPair($aTag, 0x9201, "ShutterSpeedValue")
	_AddPair($aTag, 0x9202, "ApertureValue")
	_AddPair($aTag, 0x9203, "BrightnessValue")
	_AddPair($aTag, 0x9206, "SubjectDistance")
	_AddPair($aTag, 0xA404, "DigitalZoomRatio")

	$nTiffHdrOffset = $exif_offset + 10 ; Start of TIFF header

	$pHdr = _FileReadToStruct("short;short;dword", $hFile, $nTiffHdrOffset)
	If DllStructGetData($pHdr, 1) = 0x4D4D Then $ByteOrder = 1
	$nIFDOffset = _IntR(DllStructGetData($pHdr, 3), $ByteOrder)
	$pCnt = _FileReadToStruct("ushort", $hFile, $nTiffHdrOffset + $nIFDOffset) ; Tags count
	$nIFDCount = _IntR(DllStructGetData($pCnt, 1), $ByteOrder)

	$pTag = DllStructCreate("ushort;ushort;ulong;ulong")
	For $nCnt = 0 To $nIFDCount - 1
		$pTag = _FileReadToStruct($pTag, $hFile, $nTiffHdrOffset + $nIFDOffset + 2 + $nCnt * 12)
		$ID = DllStructGetData($pTag, 1)
		$ID = _IntR($ID, $ByteOrder)
		For $A = 1 To $aTag[0][0]
			If $aTag[$A][0] = $ID Then
				_Add($sInfo, $aTag[$A][1], _ReadTag($hFile, $pTag, $nTiffHdrOffset, $ByteOrder))
				ExitLoop
			EndIf
		Next
		If StringInStr($sSpecialTags, Hex($ID, 4)) Then _AddSpecial($sInfo, $ID, _ReadTag($hFile, $pTag, $nTiffHdrOffset, $ByteOrder))
		If $ID = 0x8769 Then ; Exif IFD Offset
		   $nEIFDOffset = _ReadTag($hFile, $pTag, $nTiffHdrOffset, $ByteOrder)
		   $pCnt = _FileReadToStruct($pCnt, $hFile, $nTiffHdrOffset + $nEIFDOffset)
		   $nEIFDCount = _IntR(DllStructGetData($pCnt, 1), $ByteOrder)
		EndIf
	Next

	If Not ($nEIFDOffset > 0) Then Return($sInfo)

	For $nCnt = 0 To $nEIFDCount - 1
		$pTag = _FileReadToStruct($pTag, $hFile, $nTiffHdrOffset + $nEIFDOffset + 2 + $nCnt * 12)
		$ID = DllStructGetData($pTag, 1)
		$ID = _IntR($ID, $ByteOrder)
		For $A = 1 To $aTag[0][0]
			If $aTag[$A][0] = $ID Then
				_Add($sInfo, $aTag[$A][1], _ReadTag($hFile, $pTag, $nTiffHdrOffset, $ByteOrder))
				ExitLoop
			EndIf
		Next
		If StringInStr($sSpecialTags, Hex($ID, 4)) Then _AddSpecial($sInfo, $ID, _ReadTag($hFile, $pTag, $nTiffHdrOffset, $ByteOrder))
	Next
	$pHdr = 0
	$pCnt = 0
	$pTag = 0

	Return($sInfo)
EndFunc

;===============================================================================
; Return multi-choice values for some tags
;===============================================================================
Func _AddSpecial(ByRef $sInfo, $ID, $nValue)
	Local $nIndex = $nValue, $sLabel, $aData, $sFired, $sMode, $sRed, $nModeState
	Select
		Case $ID = 0xA402
			$sLabel = "ExposureMode"
			$aData = StringSplit("Auto,Manual,Auto bracket,Undefined", ",")
			If $nValue > 2 Then $nIndex = 3
		Case $ID = 0xA403
			$sLabel = "WhiteBalance"
			$aData = StringSplit("Auto,Manual,Undefined", ",")
			If $nValue > 1 Then $nIndex = 2
		Case $ID = 0xA406
			$sLabel = "SceneCaptureType"
			$aData = StringSplit("Standard,Landscape,Portrait,Night scene,Undefined", ",")
			If $nValue > 3 Then $nIndex = 4
		Case $ID = 0xA408
			$sLabel = "Contrast"
			$aData = StringSplit("Normal,Soft,Hard,Undefined", ",")
			If $nValue > 2 Then $nIndex = 3
		Case $ID = 0xA409
			$sLabel = "Saturation"
			$aData = StringSplit("Normal,Low,High,Undefined", ",")
			If $nValue > 2 Then $nIndex = 3
		Case $ID = 0xA40A
			$sLabel = "Sharpness"
			$aData = StringSplit("Normal,Soft,Hard,Undefined", ",")
			If $nValue > 2 Then $nIndex = 3
		Case $ID = 0xA217
			$sLabel = "SensingMethod"
			$aData = StringSplit("Undefined,Undefined,OneChipColorArea,TwoChipColorArea,ThreeChipColorArea,ColorSequentialArea,Undefined,Trilinear,ColorSequentialLinear", ",")
			If $nValue > 8 Then $nIndex = 0
		Case $ID = 0x9101
			$sLabel = "ComponentsConfiguration"
			$aData = StringSplit("YCbCr,RGB", ",")
			$nIndex = 0
			If StringLeft($nValue, 1) = 0x34 Then $nIndex = 1
		Case $ID = 0x0128
			$sLabel = "ResolutionUnit"
			$aData = StringSplit("Undefined,Undefined,Inch,Sentimeter", ",")
			If $nValue < 2 or $nValue > 3 Then $nIndex = 0
		Case $ID = 0x0112
			$sLabel = "Orientation"
			$aData = StringSplit("Undefined,Normal,Mirrored,180°,180° and mirrored,90° left and mirrored,90° right,90° right and mirrored,90° left", ",")
			If $nValue > 8 Then $nIndex = 0
		Case $ID = 0x8822
			$sLabel = "ExposureProgram"
			$aData = StringSplit("Unknown,Manual Control,Normal,Aperture Priority,Shutter Priority,Creative (slow program),Action (high-speed),Portrait mode,Landscape mode", ",")
			If $nValue > 8 Then $nIndex = 0
		Case $ID = 0x9207
			$sLabel = "MeteringMode"
			$aData = StringSplit("Unknown,Average,Center Weighted Average,Spot,MultiSpot,MultiSegment,Partial,Other", ",")
			If $nValue > 7 Then $nIndex = 7
		Case $ID = 0x9208
			$sLabel = "LightSource"
			$aData = StringSplit("Unknown,Daylight,Fluorescent,Tungsten,Flash,Standard light A,Standard light B,Standard light C,D55,D65,D75,Other", ",")
			Select
				Case $nValue < 4
					$nIndex = $nValue
				Case $nValue = 10
					$nIndex = 4
				Case $nValue > 16 And $nValue < 23
					$nIndex = 5 + $nValue - 17
				Case $nValue = 255
					$nIndex = 11
				Case Else
					$nIndex = 0
			EndSelect
		Case $ID = 0x9209
			$sFired = "Not fired, "
			If _IsBitSet($nValue, 0) Then $sFired = "Fired, "
			$sMode = ""
			$nModeState = _IsBitSet($nValue, 4) * 2 + _IsBitSet($nValue, 3)
			If $nModeState = 1 Then
				$sMode = "Forced ON, "
			ElseIf $nModeState = 2 Then
				$sMode = "Forced OFF, "
			ElseIf $nModeState = 3 Then
				$sMode = "Auto, "
			EndIf
			$sRed = ""
			If _IsBitSet($nValue, 6) Then $sRed = "Red-eye reduction, "
			$sInfo = $sInfo & StringTrimRight("Flash=" & $sFired & $sMode & $sRed, 2) & @LF
			Return
	EndSelect
	$sInfo = $sInfo & $sLabel & "=" & $aData[$nIndex + 1] & @LF
EndFunc

;===============================================================================
; Parser for TIFF tags (not fully support multi-values tags)
;===============================================================================
Func _ReadTag($hFile, $pTag, $nHdrOffset, $ByteOrder)
	Local $nType   = _IntR(DllStructGetData($pTag, 2), $ByteOrder)
	Local $nCount  = _IntR(DllStructGetData($pTag, 3), $ByteOrder)
	Local $nOffset = _IntR(DllStructGetData($pTag, 4), $ByteOrder)
	Local $p, $vData = ""
	Select
		Case $nType = 2 ; ASCII String
			$p = _FileReadToStruct("char[" & $nCount & "]", $hFile, $nHdrOffset + $nOffset)
			$vData = DllStructGetData($p, 1)
		Case $nType = 1 Or $nType = 3 Or $nType = 4 ; Byte, short or long (unsigned)
			$vData = _IntR(DllStructGetData($pTag, 4), $ByteOrder)
		Case $nType = 5 ; Rational (unsigned long/long)
			$p = _FileReadToStruct("ulong;ulong", $hFile, $nHdrOffset + $nOffset)
			$vData = _IntR(DllStructGetData($p, 1), $ByteOrder) / _IntR(DllStructGetData($p, 2), $ByteOrder)
		Case $nType = 7 ; Undefined (byte * count)
			$p = _FileReadToStruct("char[" & $nCount & "]", $hFile, $nHdrOffset + $nOffset)
			$vData = _DllStructArrayAsString($p, 1, $nCount)
		Case $nType = 9 ; Signed long
			$p = _IntR(DllStructGetData($pTag, 4), $ByteOrder)
			$vData = _DllStructArrayAsString($p, 1, $nCount)
		Case $nType = 10 ; Rational (signed long/long)
			$p = _FileReadToStruct("dword;dword", $hFile, $nHdrOffset + $nOffset)
			$vData = _IntR(DllStructGetData($p, 1), $ByteOrder) / _IntR(DllStructGetData($p, 2), $ByteOrder)
	EndSelect
	$p = 0
	Return $vData
EndFunc

;===============================================================================
; Get param by name from function result
;===============================================================================
Func _ImageGetParam($sData, $sParam)
	Local $nParamPos = StringInStr(@LF & $sData,@LF & $sParam & "=")
	If $nParamPos Then
		$sData = StringTrimLeft($sData, $nParamPos + StringLen($sParam))
		Return StringLeft($sData, StringInStr($sData, @LF) - 1)
	EndIf
	Return ""
EndFunc

;===============================================================================
; Checks if bit in the number is set
;===============================================================================
Func _IsBitSet($nNum, $nBit)
	Return BitAND(BitShift($nNum, $nBit), 1)
EndFunc

;===============================================================================
; Add pair of values ID - Label to array
;===============================================================================
Func _AddPair(ByRef $aTag, $nID, $sLabel)
	Local $nBound = UBound($aTag)
	ReDim $aTag[$nBound + 1][2]
	$aTag[$nBound][0] = $nID
	$aTag[$nBound][1] = $sLabel
	$aTag[0][0] = $nBound
EndFunc

;===============================================================================
; Wrapper to add string
;===============================================================================
Func _Add(ByRef $sInfo, $sLabel, $nValue)
	$sInfo = $sInfo & $sLabel & "=" & $nValue & @LF
EndFunc

;===============================================================================
; Convert Intel numbers into Motorola in case $nOrder = 1
;===============================================================================
Func _IntR($nInt, $nOrder = 1)
	If Not $nOrder Then Return $nInt
	Local $nRet = 0, $nIntSize = 3, $curbyte
	If BitShift($nInt, 16) = 0 Then $nIntSize = 1
	For $A = 0 To $nIntSize
		$curbyte = BitAND(BitShift($nInt, 8 * ($nIntSize - $A)), 0xFF)
		$nRet = $nRet + BitShift($curbyte, -8 * $A)
	Next
	Return($nRet)
EndFunc

;===============================================================================
; Read data to struct given by string or pointer
;===============================================================================
Func _FileReadToStruct($vStruct, $hFile, $nOffset)
	If Not DllStructGetSize($vStruct) Then $vStruct = DllStructCreate($vStruct)
	Local $nLen = DllStructGetSize($vStruct)
	DllCall("kernel32.dll", "int", "SetFilePointer", "int", $hFile, "int", $nOffset, "int", 0, "int", 0) ; FILE_BEGIN
	Local $pRead = DllStructCreate("dword")
	DllCall("kernel32.dll", "int", "ReadFile", "int", $hFile, "ptr", DllStructGetPtr($vStruct), "int", $nLen, "ptr", DllStructGetPtr($pRead), "ptr", 0)
	Local $nRead = DllStructGetData($pRead, 1)
	$pRead = 0
	SetExtended($nRead)
	If Not ($nRead = $nLen) Then SetError(2)
	Return $vStruct
EndFunc

;===============================================================================
; Read string data, avoid situation when string is not null-terminated
;===============================================================================
Func _DllStructArrayAsString($p, $index, $size, $start = 1)
	Local $sTemp = "", $char
	For $A = $start To $size
		$char = DllStructGetData($p, $index, $A)
		If $char = 0 Then Return $sTemp
		$sTemp &= Chr($char)
	Next
	Return $sTemp
EndFunc
