
; Playlist funtions of DropIt

#include-once
#include <DropIt_General.au3>
#include "Lib\udf\DropIt_LibFiles.au3"
#include "Lib\udf\DropIt_LibVarious.au3"

Func __Playlist_WriteM3U($pSubArray, $pPlaylistPath, $pUnicode = 0)
	#cs
		Description: Write An Array To M3U Or M3U8 Playlist.
		Returns: 1
	#ce
	Local $pFileOpen, $pString

	If $pUnicode <> 0 Then
		$pUnicode = 128 ; UTF-8 For M3U8 Playlists.
	EndIf
	For $A = 1 To $pSubArray[0]
		$pString &= $pSubArray[$A] & @CRLF
	Next

	$pFileOpen = FileOpen($pPlaylistPath, 2 + 8 + $pUnicode)
	FileWrite($pFileOpen, $pString)
	FileClose($pFileOpen)

	If @error Then
		Return SetError(1, 0, 0)
	EndIf
	Return 1
EndFunc   ;==>__Playlist_WriteM3U

Func __Playlist_WritePLS($pSubArray, $pPlaylistPath)
	#cs
		Description: Write An Array To PLS Playlist.
		Returns: 1
	#ce
	Local $pFileOpen, $pString

	$pString = '[playlist]' & @CRLF
	For $A = 1 To $pSubArray[0]
		$pString &= 'File' & $A & '=' & $pSubArray[$A] & @CRLF & 'Length' & $A & '=-1' & @CRLF
	Next
	$pString &= 'NumberOfEntries=' & $pSubArray[0] & @CRLF & 'Version=2' & @CRLF

	$pFileOpen = FileOpen($pPlaylistPath, 2 + 8)
	FileWrite($pFileOpen, $pString)
	FileClose($pFileOpen)

	If @error Then
		Return SetError(1, 0, 0)
	EndIf
	Return 1
EndFunc   ;==>__Playlist_WritePLS

Func __Playlist_WriteWPL($pSubArray, $pPlaylistPath)
	#cs
		Description: Write An Array To WPL Playlist.
		Returns: 1
	#ce
	Local $pFileOpen, $pString

	$pString = '<?wpl version="1.0"?>' & @CRLF & _
			'<smil>' & @CRLF & _
			@TAB & '<head>' & @CRLF & _
			@TAB & @TAB & '<meta name="Generator" content="DropIt"/>' & @CRLF & _
			@TAB & @TAB & '<meta name="ItemCount" content="' & $pSubArray[0] & '"/>' & @CRLF & _
			@TAB & @TAB & '<author />' & @CRLF & _
			@TAB & @TAB & '<title />' & @CRLF & _
			@TAB & '</head>' & @CRLF & _
			@TAB & '<body>' & @CRLF & _
			@TAB & @TAB & '<seq>' & @CRLF

	For $A = 1 To $pSubArray[0]
		$pString &= @TAB & @TAB & @TAB & '<media src="' & $pSubArray[$A] & '"/>' & @CRLF
	Next

	$pString &= @TAB & @TAB & '</seq>' & @CRLF & _
			@TAB & '</body>' & @CRLF & _
			'</smil>'

	$pFileOpen = FileOpen($pPlaylistPath, 2 + 8)
	FileWrite($pFileOpen, $pString)
	FileClose($pFileOpen)

	If @error Then
		Return SetError(1, 0, 0)
	EndIf
	Return 1
EndFunc   ;==>__Playlist_WriteWPL
