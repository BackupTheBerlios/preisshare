; PreisShare.nsi
;
; This script is based on example1.nsi, but it remember the directory, 
; has uninstall support and (optionally) installs start menu shortcuts.
;
; It will install makensisw.exe into a directory that the user selects,

;--------------------------------

; The name of the installer
Name "PreisShare (Professional Edition)"

; The file to write
OutFile "PreisShare_Setup.exe"
Icon "yi-box_install.ico"

; The default installation directory
InstallDir $PROGRAMFILES\PreisShare

; Registry key to check for directory (so if you install again, it will
; overwrite the old one automatically)
InstallDirRegKey HKLM SOFTWARE\PreisShare "Install_Dir"

LicenseText "Please read our license agreement."
LicenseData "sla.txt"

; The text to prompt the user to enter a directory
ComponentText "This will install the PreisShare on your computer. Select which optional things you want installed."

; The text to prompt the user to enter a directory
DirText "Choose a directory to install in to:"

ShowInstDetails show

;--------------------------------

; The stuff to install
Section "Common (required)"

  SectionIn RO

  ; Set output path to the installation directory.
  SetOutPath $INSTDIR

  ; Put file there
  File "PreisShare.chm"
  File "..\db\Supplier Product Database.mdb"

  ; Create a program file shortcuts
  CreateDirectory "$SMPROGRAMS\PreisShare"
  CreateShortCut "$SMPROGRAMS\PreisShare\PreisShareHelp.lnk" "$INSTDIR\PreisShare.chm" "" "$INSTDIR\PreisShare.chm" 0
  CreateShortCut "$SMPROGRAMS\PreisShare\Supplier Product Database.lnk" "$INSTDIR\Supplier Product Database.mdb" "" "$INSTDIR\Supplier Product Database.mdb" 0

  ; Write the installation path into the registry
  WriteRegStr HKLM "SOFTWARE\PreisShare\TradeDesk" "Install_Dir" "$INSTDIR"

  ; Write the uninstall keys for Windows
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\PreisShare" "DisplayName" "PreisShare (remove only)"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\PreisShare" "UninstallString" '"$INSTDIR\uninstall.exe"'
  WriteUninstaller "uninstall.exe"

  ; Language support directories
  CreateDirectory "$INSTDIR\locale"

  ; German Support
  CreateDirectory "$INSTDIR\locale\DE"
  CreateDirectory "$INSTDIR\locale\DE\LC_MESSAGES"
  SetOutPath $INSTDIR\locale\DE\LC_MESSAGES
  File "locale\DE\LC_MESSAGES\default.MO"
  SetOutPath $INSTDIR

SectionEnd

Section "Product Search"
  File "plgSearch.exe"
  CreateShortCut "$DESKTOP\Supplier Product Database Search.lnk" "$INSTDIR\plgSearch.exe" "" "$INSTDIR\plgSearch.exe" 0
  CreateShortCut "$SMPROGRAMS\PreisShare\Supplier Product Search.lnk" "$INSTDIR\plgSearch.exe" "" "$INSTDIR\plgSearch.exe" 0
SectionEnd

Section "Merchant Program (PriceSharer)"
  File "PriceSharer.exe"
  CreateShortCut "$SMPROGRAMS\PreisShare\PriceSharer.lnk" "$INSTDIR\PriceSharer.exe" "" "$INSTDIR\PriceSharer.exe" 0
  CreateShortCut "$SMSTARTUP\Price Sharer.lnk" "$INSTDIR\PriceSharer.exe" "/TRAY" "$INSTDIR\PriceSharer.exe" 0
SectionEnd

Section "TradeDesk (ERP GUI)"
  SetOutPath $INSTDIR
  File "TradeDesk.exe"
  CreateShortCut "$SMPROGRAMS\PreisShare\TradeDesk.lnk" "$INSTDIR\TradeDesk.exe" "" "$INSTDIR\TradeDesk.exe" 0
  CreateShortCut "$DESKTOP\TradeDesk.lnk" "$INSTDIR\TradeDesk.exe" "" "$INSTDIR\TradeDesk.exe" 0
SectionEnd

Section "ADO Browser"
  SetOutPath $INSTDIR
  File "Browser.exe"
  CreateShortCut "$SMPROGRAMS\PreisShare\Browser.lnk" "$INSTDIR\Browser.exe" "" "$INSTDIR\Browser.exe" 0
SectionEnd

; Section "Email Kiosk"
;  SetOutPath $INSTDIR
;  File "EmailKiosk.exe"
;  CreateShortCut "$SMPROGRAMS\PreisShare\EmailKiosk.lnk" "$INSTDIR\EmailKiosk.exe" "" "$INSTDIR\EmailKiosk.exe" 0
;  CreateShortCut "$DESKTOP\EmailKiosk.lnk" "$INSTDIR\EmailKiosk.exe" "" "$INSTDIR\EmailKiosk.exe" 0
; SectionEnd

;Section "Computer Industry Sample Data"
;  SectionIn RO  SetOutPath $INSTDIR
;SectionEnd

; optional section (can be disabled by the user)
;Section "Desktop Shortcuts"
;SectionEnd

;Section "BDEInst"
;  SetOutPath $INSTDIR
;  File "BDEINST.DLL"
;  RegDLL $INSTDIR\BDEINST.dll
;SectionEnd

Section "BDE (Borland Database Engine)"

  SectionIn RO

  ; A registry key to determine the type of database
  ClearErrors
  ReadRegStr $R0 HKLM "SOFTWARE\PreisShare\General" "Database_Driver"
  IfErrors lbl_BDE2
  Goto lbl_BDE3
lbl_BDE2:
  WriteRegStr HKLM "SOFTWARE\PreisShare\General" "Database_Driver" "BDE"
lbl_BDE3:

  ; Check if the BDE is installed
  DetailPrint "Checking for Borland Database Engine"
  ClearErrors
  ReadRegStr $R0 HKLM "SOFTWARE\Borland\Database Engine" "DLLPATH"
  IfErrors lbl_BDE1
  DetailPrint "Borland Database Engine already installed"
  Goto EndBDEInst
lbl_BDE1:

  DetailPrint "Installing Borland Database Engine"

  ;
  ; SetOutPath $INSTDIR
  ; RegDLL $INSTDIR\bdeinst.dll

  ; Specifies where the DLLs go
  WriteRegStr HKLM "SOFTWARE\Borland\Database Engine" "DLLPATH" "C:\Program Files\Common Files\Borland Shared\BDE"
  WriteRegStr HKLM "SOFTWARE\Borland\Database Engine" "CONFIGFILE01" "C:\Program Files\Common Files\Borland Shared\BDE\IDAPI32.CFG"
  WriteRegStr HKLM "SOFTWARE\Borland\Database Engine" "SaveConfig" "WIN32"

  SetOutPath "C:\Program Files\Common Files\Borland Shared\BDE"

;  File "BDE_Redist\IDAPINST.DLL"
  FILE "BDE_Redist\IDAPI.CNF"
  FILE "BDE_Redist\IDAPI32.CFG"

  ; Files for the BDE
  File "BDE_Redist\IDAPI32.DLL"	; Primary BDE DLL.
  File "BDE_Redist\BLW32.DLL"	; International Language Driver support functions.
  File "BDE_Redist\IDBAT32.DLL"	; Contains the batch operations.
  File "BDE_Redist\IDSQL32.DLL"	; SQL Query Engine.
  File "BDE_Redist\IDASCI32.DLL"	; ASCII Text driver.
  File "BDE_Redist\IDPDX32.DLL"	; Paradox Driver.
  File "BDE_Redist\IDDBAS32.DLL"	; dBASE driver.
  File "BDE_Redist\IDODBC32.DLL"	; ODBC Socket Driver (allows the use of any ODBC 3.0 driver).
  File "BDE_Redist\IDR20009.DLL"	; Resource file for error messages.
  File "BDE_Redist\IDDAO32.DLL"	; Access Driver for Access 95 and Jet Engine 3.0.

  File "BDE_Redist\IDDA3532.DLL"	; Access Driver for Access 97 and Jet Engine 3.5.
  File "BDE_Redist\IDDR32.DLL"	; Data Repository.
  File "BDE_Redist\BANTAM.DLL"	; 

  File "BDE_Redist\BDEADMIN.EXE"	; BDE Administrator utility for managing configuration information stored in the Windows Registry and aliases in the IDAPI.CFG.
  File "BDE_Redist\BDEADMIN.HLP"	; Help file for BDE Administrator.
  File "BDE_Redist\BDEADMIN.CNT"	; Table of contents file for BDEADMIN.HLP. This must remain in same directory with BDEADMIN.HLP.
  File "BDE_Redist\BDE32.HLP"	; The online reference for 32-bit BDE.
  File "BDE_Redist\BDE32.CNT"	; Table of contents file for BDE32.HLP. This should remain in same directory with BDE32.HLP.

  File "BDE_Redist\IDAPI.CFG"	; File containing application-specific BDE configuration information, primarily database aliases.
  File "BDE_Redist\CHARSET.CVB"	; Character set conversion.

  File "BDE_Redist\ceeurope.btl"
  File "BDE_Redist\europe.btl"
  File "BDE_Redist\fareast.btl"
  File "BDE_Redist\japan.btl"
  File "BDE_Redist\other.btl"
  File "BDE_Redist\usa.btl"

;  File "BDE_Redist\IDQBE32.DLL"	; QBE Query Engine.
;  File "*.BTL"	; 	Ctype information (casing, soundex, etc.).
  
EndBDEInst:

SectionEnd

; optional section (can be disabled by the user)
Section "Paradox Data"

  ; The program will pick up this directory to use the database
  WriteRegStr HKLM "SOFTWARE\PreisShare\General" "BDE_Directory" "$INSTDIR\DataPX"
  WriteRegStr HKLM "SOFTWARE\PreisShare\General" "GTD_REG_DATABASE_DRIVER" "BDE"

  ; Set output path to the installation directory.
  SetOutPath $INSTDIR\DataPX
  File "DataPX\Job.db"
  File "DataPX\Job.MB"
  File "DataPX\Job.PX"
  File "DataPX\Job_Documents.db"
  File "DataPX\Job_Documents.PX"
  File "DataPX\Product_Brands.db"
  File "DataPX\Product_Brands.PX"
  File "DataPX\Product_Library.DB"
  File "DataPX\Product_Library.PX"
  File "DataPX\Product_Library.VAL"
  File "DataPX\Product_Library.MB"
  File "DataPX\Product_Updates.DB"
  File "DataPX\Product_Updates.MB"
  File "DataPX\Product_Updates.PX"
  File "DataPX\Product_Updates.XG0"
  File "DataPX\Product_Updates.YG0"
  File "DataPX\SysVals.MB"
  File "DataPX\SysVals.DB"
  File "DataPX\SysVals.PX"
  File "DataPX\System_User.DB"
  File "DataPX\System_User.PX"
  File "DataPX\System_User.YG0"
  File "DataPX\System_User.XG0"
  File "DataPX\Trader_Documents.MB"
  File "DataPX\Trader_Documents.db"
  File "DataPX\Trader_Documents.PX"
  File "DataPX\Trader.DB"
  File "DataPX\Trader.PX"
  File "DataPX\Trader.MB"
  File "DataPX\Product_Types.db"
  File "DataPX\Product_Types.PX"
  File "DataPX\Product_Types.VAL"
  File "DataPX\Trader_AuditTrail.DB"
  File "DataPX\Trader_AuditTrail.MB"
  File "DataPX\Trader_AuditTrail.PX"
  File "DataPX\Trader_AuditTrail.VAL"
  File "DataPX\Trader_AuditTrail.XG0"
  File "DataPX\Trader_AuditTrail.XG1"
  File "DataPX\Trader_AuditTrail.YG0"
  File "DataPX\Trader_AuditTrail.YG1"
  File "DataPX\Trader_Categories.DB"
  File "DataPX\Trader_Categories.PX"
  File "DataPX\Trader_Connections.DB"
  File "DataPX\Trader_Connections.MB"
  File "DataPX\Trader_Connections.PX"
  File "DataPX\Trader_Connections.XG0"
  File "DataPX\Trader_Connections.YG0"
  File "DataPX\Trader_Images.DB"
  File "DataPX\Trader_Images.PX"
  File "DataPX\Trader_Images.XG0"
  File "DataPX\Trader_Images.YG0"
  File "DataPX\Trader_Images.MB"
  File "DataPX\Trader_Keys.DB"
  File "DataPX\Trader_Keys.PX"
SectionEnd

;--------------------------------

; Uninstaller

UninstallText "This will uninstall PreisShare. Hit next to continue."
UninstallIcon "yi-box_uninstall.ico"

; Uninstall section

Section "Uninstall"

  ; remove registry keys
  DeleteRegKey HKLM "SOFTWARE\PreisShare\General\BDE_Alias"
  DeleteRegKey HKLM "SOFTWARE\PreisShare\General\BDE_Directory"
  DeleteRegKey HKLM "SOFTWARE\PreisShare\General\Database_Driver"

  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\PreisShare"
  DeleteRegKey HKLM "SOFTWARE\PreisShare\PreisShare"

  ; remove files and uninstaller
  Delete $INSTDIR\locale\DE\LC_MESSAGES\*.*

  Delete $INSTDIR\TradeDesk.exe
  Delete $INSTDIR\PriceSharer.exe
  Delete $INSTDIR\plgSearch.exe
  Delete $INSTDIR\Browser.exe
  Delete $INSTDIR\PreisShare.chm
  Delete "$INSTDIR\Supplier Product Database.mdb"
  Delete $INSTDIR\DataPX\*.*
  Delete $INSTDIR\uninstall.exe

  ; remove shortcuts, if any
  Delete "$SMPROGRAMS\PreisShare\*.*"
  CreateShortCut "$DESKTOP\Supplier Product Database Search.lnk" "$INSTDIR\plgSearch.exe" "" "$INSTDIR\plgSearch.exe" 0
  CreateShortCut "$SMSTARTUP\Price Sharer.lnk" "$INSTDIR\PriceSharer.exe" "/TRAY" "$INSTDIR\PriceSharer.exe" 0
  CreateShortCut "$DESKTOP\TradeDesk.lnk" "$INSTDIR\TradeDesk.exe" "" "$INSTDIR\TradeDesk.exe" 0

  ; remove directories used
  RMDir "$SMPROGRAMS\PreisShare"
  RMDir "$INSTDIR\locale\DE\LC_MESSAGES"
  RMDir "$INSTDIR\locale\DE"
  RMDir "$INSTDIR\locale"
  RMDir "$INSTDIR\DataPX"
  RMDir "$INSTDIR"

SectionEnd

; AddSharedDLL
 ;
 ; Increments a shared DLLs reference count.
 ; Use by passing one item on the stack (the full path of the DLL).
 ;
 ; Usage:
 ;   Push $SYSDIR\myDll.dll
 ;   Call AddSharedDLL
 ;

 Function AddSharedDLL
   Exch $R1
   Push $R0
   ReadRegDword $R0 HKLM Software\Microsoft\Windows\CurrentVersion\SharedDLLs $R1
   IntOp $R0 $R0 + 1
   WriteRegDWORD HKLM Software\Microsoft\Windows\CurrentVersion\SharedDLLs $R1 $R0
   Pop $R0
   Pop $R1
 FunctionEnd
