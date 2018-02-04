
; Global constants and variables of DropIt

#include-once

Global $G_Global_CurrentVersion = "8.5.1"

Global $G_Global_EncryptionKey = "profiles-password-fake" ; Key For Profiles Encryption.
Global $G_Global_PasswordKey = "archives-password-fake" ; Key For Archives Encryption.
Global $G_Global_SectionsID = "C40179A9D7DAD484" ; Additional ID For Profile Section Names.
Global $G_Global_GeneralSection = "General-" & $G_Global_SectionsID, $G_Global_TargetSection = "Target-" & $G_Global_SectionsID ; Profile Section Names.
Global $G_Global_ImageList, $G_Global_SortingGUI ; Handles.
Global $G_Global_AbortSorting = 0, $G_Global_PauseSorting = 0 ; Sorting GUI.
Global $G_Global_DuplicateMode ; Duplicates.
Global $G_Global_UserInput ; Abbreviations.
Global $G_Global_SortingCurrentSize, $G_Global_SortingTotalSize ; Sorting Size.
Global $G_Global_IsMultipleInstance = 0 ; Multiple Instances.
Global $G_Global_StateEnabled = "Enabled", $G_Global_StateDisabled = "Disabled" ; Association States.
Global $G_Global_UniqueID = @ScriptFullPath ; WM_COPYDATA (Do Not Modify).
Global $G_Global_7ZipPath = @ScriptDir & "\Lib\7z\7z.exe"
Global $G_Global_GuidePath = @ScriptDir & "\Guide.pdf"
Global $G_Global_LicensePath = @ScriptDir & "\License.txt"
Global $G_Global_ReadmePath = @ScriptDir & "\Readme.txt"
Global $G_Global_TempDir = @TempDir & "\DropIt"
Global $G_Global_TempName = '~TempDropIt'

Global Const $STATIC_CRYPT_FILE_EXT = ".fcrt"
Global Const $STATIC_CRYPT_FOLDER_EXT = ".zcrt"
Global Const $STATIC_TEMP_ZIP_EXT = ".dropit.zip"
Global Const $STATIC_MODIFIER_ESCAPE_CHAR = "#"
Global Const $STATIC_ABBREVIATION_ESCAPE_CHAR = "%"
Global Const $STATIC_FILTERS_DIVIDER = "|"
Global Const $STATIC_FILTERS_NUMBER = 11
Global Const $STATIC_COMPACT_END = 0x4000
Global Const $STATIC_COMPACT_PATH = 0x8000