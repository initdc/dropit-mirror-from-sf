
; Playlist funtions collected for DropIt

#include-once
#include "APIConstants.au3"
#include "WinAPIEx.au3"

Func __Playlist_Write($pFilePath, $pPlaylistPath)
	#cs
		Description: Write A File In A Defined Playlist.
		Returns: 1
	#ce
	Local $pListType = StringTrimLeft(_WinAPI_PathFindExtension($pFilePath), 1)

	Switch $pListType
		Case "m3u"
			__Playlist_WriteM3U($pFilePath, $pPlaylistPath)
		Case "m3u8"
			__Playlist_WriteM3U($pFilePath, $pPlaylistPath, 1)
		Case "pls"
			__Playlist_WritePLS($pFilePath, $pPlaylistPath)
		Case "wpl"
			__Playlist_WriteWPL($pFilePath, $pPlaylistPath)
		Case Else
			Return SetError(1, 0, 0)
	EndSwitch

	If @error Then
		Return SetError(1, 0, 0)
	EndIf
	Return 1
EndFunc   ;==>__Playlist_Write

Func __Playlist_WriteM3U($pFilePath, $pPlaylistPath, $pUnicode = 0)
	#cs
		Description: Write A File In A M3U Or M3U8 Playlist.
		Returns: 1
	#ce
	Local $pFileOpen

	If $pUnicode <> 0 Then
		$pUnicode = 128 ; UTF-8 For M3U8 Playlists.
	EndIf
	$pFileOpen = FileOpen($pPlaylistPath, 1 + 8 + $pUnicode)
	FileWrite($pFileOpen, $pFilePath & @CRLF)
	FileClose($pFileOpen)

	If @error Then
		Return SetError(1, 0, 0)
	EndIf
	Return 1
EndFunc   ;==>__Playlist_WriteM3U

Func __Playlist_WritePLS($pFilePath, $pPlaylistPath)
	#cs
		Description: Write A File In A PLS Playlist.
		Returns: 1
	#ce
	Local $pFileOpen, $pFileRead, $pNumber, $pNewFile

	If FileExists($pPlaylistPath) Then
		$pFileRead = FileRead($pPlaylistPath)
	Else
		$pFileRead = '[playlist]' & @CRLF & 'NumberOfEntries=0' & @CRLF & 'Version=2' & @CRLF
	EndIf
	$pNumber = StringRegExp($pFileRead, 'NumberOfEntries=(.*?)' & @CRLF, 3)
	$pNewFile = 'File' & $pNumber[0] + 1 & '=' & $pFilePath & @CRLF & 'Length' & $pNumber[0] + 1 & '=-1' & @CRLF
	$pFileRead = StringReplace($pFileRead, 'NumberOfEntries=' & $pNumber[0], $pNewFile & 'NumberOfEntries=' & $pNumber[0] + 1, 0, 1)

	$pFileOpen = FileOpen($pPlaylistPath, 2 + 8)
	FileWrite($pFileOpen, $pFileRead)
	FileClose($pFileOpen)

	If @error Then
		Return SetError(1, 0, 0)
	EndIf
	Return 1
EndFunc   ;==>__Playlist_WritePLS

Func __Playlist_WriteWPL($pFilePath, $pPlaylistPath)
	#cs
		Description: Write A File In A WPL Playlist.
		Returns: 1
	#ce
	Local $pFileOpen, $pFileRead, $pNumber, $pNewFile

	If FileExists($pPlaylistPath) Then
		$pFileRead = FileRead($pPlaylistPath)
	Else
		$pFileRead = '<?wpl version="1.0"?>' & @CRLF & _
				'<smil>' & @CRLF & _
				@TAB & '<head>' & @CRLF & _
				@TAB & @TAB & '<meta name="Generator" content="DropIt"/>' & @CRLF & _
				@TAB & @TAB & '<meta name="ItemCount" content="0"/>' & @CRLF & _
				@TAB & @TAB & '<author />' & @CRLF & _
				@TAB & @TAB & '<title />' & @CRLF & _
				@TAB & '</head>' & @CRLF & _
				@TAB & '<body>' & @CRLF & _
				@TAB & @TAB & '<seq>' & @CRLF & _
				@TAB & @TAB & '</seq>' & @CRLF & _
				@TAB & '</body>' & @CRLF & _
				'</smil>'
	EndIf
	$pNumber = StringRegExp($pFileRead, 'name="ItemCount" content="(.*?)"', 3)
	$pFileRead = StringReplace($pFileRead, 'name="ItemCount" content="' & $pNumber[0] & '"', 'name="ItemCount" content="' & $pNumber[0] + 1 & '"', 0, 1)
	$pNewFile = @TAB & @TAB & @TAB & '<media src="' & $pFilePath & '"/>' & @CRLF
	$pFileRead = StringReplace($pFileRead, @TAB & @TAB & '</seq>', $pNewFile & @TAB & @TAB & '</seq>', 0, 1)

	$pFileOpen = FileOpen($pPlaylistPath, 2 + 8)
	FileWrite($pFileOpen, $pFileRead)
	FileClose($pFileOpen)

	If @error Then
		Return SetError(1, 0, 0)
	EndIf
	Return 1
EndFunc   ;==>__Playlist_WriteWPL
