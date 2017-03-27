
; File funtions collected for DropIt

Func __Playlist_WriteM3U($aArray, $sPlaylistPath, $iUnicode = 0)
	#cs
		Description: Write An Array To M3U Or M3U8 Playlist.
		Returns: 1
	#ce
	Local $iFileOpen, $sString

	If $iUnicode <> 0 Then
		$iUnicode = 128 ; UTF-8 For M3U8 Playlists.
	EndIf
	For $A = 1 To $aArray[0]
		$sString &= $aArray[$A] & @CRLF
	Next

	$iFileOpen = FileOpen($sPlaylistPath, 2 + 8 + $iUnicode)
	FileWrite($iFileOpen, $sString)
	FileClose($iFileOpen)

	If @error Then
		Return SetError(1, 0, 0)
	EndIf
	Return 1
EndFunc   ;==>__Playlist_WriteM3U

Func __Playlist_WritePLS($aArray, $sPlaylistPath)
	#cs
		Description: Write An Array To PLS Playlist.
		Returns: 1
	#ce
	Local $iFileOpen, $sString

	$sString = '[playlist]' & @CRLF
	For $A = 1 To $aArray[0]
		$sString &= 'File' & $A & '=' & $aArray[$A] & @CRLF & 'Length' & $A & '=-1' & @CRLF
	Next
	$sString &= 'NumberOfEntries=' & $aArray[0] & @CRLF & 'Version=2' & @CRLF

	$iFileOpen = FileOpen($sPlaylistPath, 2 + 8)
	FileWrite($iFileOpen, $sString)
	FileClose($iFileOpen)

	If @error Then
		Return SetError(1, 0, 0)
	EndIf
	Return 1
EndFunc   ;==>__Playlist_WritePLS

Func __Playlist_WriteWPL($aArray, $sPlaylistPath)
	#cs
		Description: Write An Array To WPL Playlist.
		Returns: 1
	#ce
	Local $iFileOpen, $sString

	$sString = '<?wpl version="1.0"?>' & @CRLF & _
			'<smil>' & @CRLF & _
			@TAB & '<head>' & @CRLF & _
			@TAB & @TAB & '<meta name="Generator" content="DropIt"/>' & @CRLF & _
			@TAB & @TAB & '<meta name="ItemCount" content="' & $aArray[0] & '"/>' & @CRLF & _
			@TAB & @TAB & '<author />' & @CRLF & _
			@TAB & @TAB & '<title />' & @CRLF & _
			@TAB & '</head>' & @CRLF & _
			@TAB & '<body>' & @CRLF & _
			@TAB & @TAB & '<seq>' & @CRLF

	For $A = 1 To $aArray[0]
		$sString &= @TAB & @TAB & @TAB & '<media src="' & $aArray[$A] & '"/>' & @CRLF
	Next

	$sString &= @TAB & @TAB & '</seq>' & @CRLF & _
			@TAB & '</body>' & @CRLF & _
			'</smil>'

	$iFileOpen = FileOpen($sPlaylistPath, 2 + 8)
	FileWrite($iFileOpen, $sString)
	FileClose($iFileOpen)

	If @error Then
		Return SetError(1, 0, 0)
	EndIf
	Return 1
EndFunc   ;==>__Playlist_WriteWPL
