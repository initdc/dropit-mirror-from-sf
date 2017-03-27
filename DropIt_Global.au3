
; Global constants and variables of DropIt

#include-once

Global $G_Global_CurrentVersion = "4.7"
Global $G_Global_EncryptionKey = "profiles-password-fake" ; Key For Profiles Encryption.
Global $G_Global_PasswordKey = "archives-password-fake" ; Key For Archives Encryption.
Global $G_Global_NumberFields = 6 ; Fields Of The Profile INI.
Global $G_Global_ImageList, $G_Global_SortingGUI ; Handles.
Global $G_Global_AbortSorting = 0, $G_Global_PauseSorting = 0 ; Sorting GUI.
Global $G_Global_DuplicateMode ; Duplicates.
Global $G_Global_SortingCurrentSize, $G_Global_SortingTotalSize ; Sorting Size.
Global $G_Global_IsMultipleInstance = 0 ; Multiple Instances.
Global $G_Global_UniqueID = @ScriptFullPath ; WM_COPYDATA.

Global Const $STATIC_MODIFIER_ESCAPE_CHAR = "#"
Global Const $STATIC_ABBREVIATION_ESCAPE_CHAR = "%"
