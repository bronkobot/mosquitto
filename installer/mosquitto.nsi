; NSIS installer script for mosquitto

!include "MUI2.nsh"
!include "nsDialogs.nsh"
!include "LogicLib.nsh"

; For environment variable code
!include "WinMessages.nsh"
!define env_hklm 'HKLM "SYSTEM\CurrentControlSet\Control\Session Manager\Environment"'

Name "Eclipse Mosquitto"
!define VERSION 2.0.22
OutFile "mosquitto-${VERSION}-install-windows-x86.exe"

InstallDir "$PROGRAMFILES\mosquitto"

;--------------------------------
; Installer pages
!insertmacro MUI_PAGE_WELCOME

!insertmacro MUI_PAGE_COMPONENTS
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH


;--------------------------------
; Uninstaller pages
!insertmacro MUI_UNPAGE_WELCOME
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES
!insertmacro MUI_UNPAGE_FINISH

;--------------------------------
; Languages
!insertmacro MUI_LANGUAGE "English"

;--------------------------------
; Installer sections

Section "Files" SecInstall
	SectionIn RO

	ExecWait 'sc stop mosquitto'
	Sleep 1000

	SetOutPath "$INSTDIR"
	File "..\logo\mosquitto.ico"
	File "..\build\src\Release\mosquitto.exe"
	File "..\build\apps\mosquitto_ctrl\Release\mosquitto_ctrl.exe"
	File "..\build\apps\mosquitto_passwd\Release\mosquitto_passwd.exe"
	File "..\build\client\Release\mosquitto_pub.exe"
	File "..\build\client\Release\mosquitto_sub.exe"
	File "..\build\client\Release\mosquitto_rr.exe"
	File "..\build\lib\Release\mosquitto.dll"
	File "..\build\lib\cpp\Release\mosquittopp.dll"
	File "..\build\plugins\dynamic-security\Release\mosquitto_dynamic_security.dll"
	File "..\aclfile.example"
	File "..\ChangeLog.txt"
	File "..\mosquitto.conf"
	File "..\NOTICE.md"
	File "..\pwfile.example"
	File "..\README.md"
	File "..\README-windows.txt"
	File "..\README-letsencrypt.md"
	File "..\SECURITY.md"
	File "..\edl-v10"
	File "..\epl-v20"

	File "..\build\vcpkg_installed\x86-windows\bin\cjson.dll"
	File "..\build\vcpkg_installed\x86-windows\bin\libcrypto-3.dll"
	File "..\build\vcpkg_installed\x86-windows\bin\libssl-3.dll"
	File "..\build\vcpkg_installed\x86-windows\bin\pthreadVC3.dll"
	File "..\build\vcpkg_installed\x86-windows\bin\uv.dll"
	File "..\build\vcpkg_installed\x86-windows\bin\websockets.dll"
	File "..\build\vcpkg_installed\x86-windows\bin\zlib1.dll"

	SetOutPath "$INSTDIR\devel"
	File /oname=mosquitto_broker.lib "..\build\src\Release\mosquitto.lib"
	File "..\build\lib\Release\mosquitto.lib"
	File "..\build\lib\cpp\Release\mosquittopp.lib"
	File "..\include\mosquitto.h"
	File "..\include\mosquitto_broker.h"
	File "..\include\mosquitto_plugin.h"
	File "..\include\mqtt_protocol.h"
	File "..\lib\cpp\mosquittopp.h"

	WriteUninstaller "$INSTDIR\Uninstall.exe"
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Mosquitto" "DisplayName" "Eclipse Mosquitto MQTT broker"
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Mosquitto" "DisplayIcon" "$INSTDIR\mosquitto.ico"
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Mosquitto" "UninstallString" "$\"$INSTDIR\Uninstall.exe$\""
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Mosquitto" "QuietUninstallString" "$\"$INSTDIR\Uninstall.exe$\" /S"
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Mosquitto" "HelpLink" "https://mosquitto.org/"
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Mosquitto" "URLInfoAbout" "https://mosquitto.org/"
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Mosquitto" "DisplayVersion" "${VERSION}"
	WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Mosquitto" "NoModify" "1"
	WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Mosquitto" "NoRepair" "1"

	WriteRegExpandStr ${env_hklm} MOSQUITTO_DIR $INSTDIR
	SendMessage ${HWND_BROADCAST} ${WM_WININICHANGE} 0 "STR:Environment" /TIMEOUT=5000
SectionEnd

Section "Visual Studio Runtime"
  SetOutPath "$INSTDIR"
  File "VC_redist.x86.exe"
  ExecWait '"$INSTDIR\VC_redist.x86.exe" /quiet /norestart'
  Delete "$INSTDIR\VC_redist.x86.exe"
SectionEnd

Section "Service" SecService
	ExecWait '"$INSTDIR\mosquitto.exe" install'
	ExecWait 'sc start mosquitto'
SectionEnd

Section "Uninstall"
	ExecWait 'sc stop mosquitto'
	Sleep 1000
	ExecWait '"$INSTDIR\mosquitto.exe" uninstall'
	Sleep 1000

	Delete "$INSTDIR\mosquitto.dll"
	Delete "$INSTDIR\mosquitto.exe"
	Delete "$INSTDIR\mosquitto_ctrl.exe"
	Delete "$INSTDIR\mosquitto_passwd.exe"
	Delete "$INSTDIR\mosquitto_pub.exe"
	Delete "$INSTDIR\mosquitto_rr.exe"
	Delete "$INSTDIR\mosquitto_sub.exe"
	Delete "$INSTDIR\mosquittopp.dll"
	Delete "$INSTDIR\mosquitto_dynamic_security.dll"
	Delete "$INSTDIR\aclfile.example"
	Delete "$INSTDIR\ChangeLog.txt"
	Delete "$INSTDIR\mosquitto.conf"
	Delete "$INSTDIR\pwfile.example"
	Delete "$INSTDIR\NOTICE.md"
	Delete "$INSTDIR\README.md"
	Delete "$INSTDIR\README-windows.txt"
	Delete "$INSTDIR\README-letsencrypt.md"
	Delete "$INSTDIR\SECURITY.md"
	Delete "$INSTDIR\edl-v10"
	Delete "$INSTDIR\epl-v20"
	Delete "$INSTDIR\mosquitto.ico"

	Delete "$INSTDIR\cjson.dll"
	Delete "$INSTDIR\libcrypto-3.dll"
	Delete "$INSTDIR\libssl-3.dll"
	Delete "$INSTDIR\pthreadVC3.dll"
	Delete "$INSTDIR\uv.dll"
	Delete "$INSTDIR\websockets.dll"

	Delete "$INSTDIR\devel\mosquitto.h"
	Delete "$INSTDIR\devel\mosquitto_broker.h"
	Delete "$INSTDIR\devel\mosquitto_plugin.h"
	Delete "$INSTDIR\devel\mosquittopp.h"
	Delete "$INSTDIR\devel\mqtt_protocol.h"
	RMDir "$INSTDIR\devel\mosquitto"
	RMDir "$INSTDIR\devel"

	Delete "$INSTDIR\Uninstall.exe"
	RMDir "$INSTDIR"
	DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Mosquitto"

	DeleteRegValue ${env_hklm} MOSQUITTO_DIR
	SendMessage ${HWND_BROADCAST} ${WM_WININICHANGE} 0 "STR:Environment" /TIMEOUT=5000
SectionEnd

LangString DESC_SecInstall ${LANG_ENGLISH} "The main installation."
LangString DESC_SecService ${LANG_ENGLISH} "Install mosquitto as a Windows service?"

!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
	!insertmacro MUI_DESCRIPTION_TEXT ${SecInstall} $(DESC_SecInstall)
	!insertmacro MUI_DESCRIPTION_TEXT ${SecService} $(DESC_SecService)
!insertmacro MUI_FUNCTION_DESCRIPTION_END
