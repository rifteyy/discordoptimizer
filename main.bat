@echo off
title Discord Optimizer
set "keepLanguage=en-US"
chcp 65001>nul
setlocal enabledelayedexpansion
for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do (
  set ESC=%%b
)
cd /d "!appdata!"
set /a startver=0
call :logo
echo:
echo                             Please choose a version to optimize:
echo:
for /f "delims=" %%a in ('dir /b "Discord*"') do (
	set /a startver+=1
	set "version[!startver!]=%%a"
	echo                             !ESC![38;2;114;137;218m[!ESC![0m !startver! !ESC![38;2;114;137;218m]!ESC![0m %%a
) 
echo.
set /p "vernum=!ESC![30m                     !ESC![0mNumber: !ESC![38;2;114;137;218m"
<nul set /p="!ESC![0m"
goto :menu

:menu
set "dir=!localappdata!\!version[%vernum%]!"
title Optimizing version: !version[%vernum%]!
cls
call :logo
echo.
echo.
echo                   !ESC![38;2;114;137;218m[!ESC![0m 1 !ESC![38;2;114;137;218m]!ESC![0m Debloat                                             !ESC![38;2;114;137;218m[!ESC![0m 2 !ESC![38;2;114;137;218m]!ESC![0m Clear unused languages
echo.
echo                   !ESC![38;2;114;137;218m[!ESC![0m 3 !ESC![38;2;114;137;218m]!ESC![0m Clear log, old installations, crash reports         !ESC![38;2;114;137;218m[!ESC![0m 4 !ESC![38;2;114;137;218m]!ESC![0m Optimize priority
echo.
echo                   !ESC![38;2;114;137;218m[!ESC![0m 5 !ESC![38;2;114;137;218m]!ESC![0m Clear old application versions                      !ESC![38;2;114;137;218m[!ESC![0m 6 !ESC![38;2;114;137;218m]!ESC![0m Clear cache
echo.
echo                   !ESC![38;2;114;137;218m[!ESC![0m 7 !ESC![38;2;114;137;218m]!ESC![0m Disable Start-Up run                                !ESC![38;2;114;137;218m[!ESC![0m 8 !ESC![38;2;114;137;218m]!ESC![0m Restart !version[%vernum%]!
echo.
echo.
set /p "num=!ESC![30m                     !ESC![0mNumber: !ESC![38;2;114;137;218m"
if "!num!"=="1" call :debloat !version[%vernum%]!
if "!num!"=="2" call :languages !version[%vernum%]!
if "!num!"=="3" call :log !version[%vernum%]!
if "!num!"=="4" goto :optpriority
if "!num!"=="5" call :oldapp !version[%vernum%]!
if "!num!"=="6" call :cache !version[%vernum%]!
if "!num!"=="7" (
	reg.exe delete "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "!version[%vernum%]!" /f 2>nul >nul
)
if "!num!"=="8" (
	taskkill /F /IM "!version[%vernum%]!.exe" 2>nul >nul
	"!localappdata!\!version[%vernum%]!\Update.exe" --processStart !version[%vernum%]!.exe
)
goto :menu


:::::::::::::::::::
:debloat
2>nul >nul taskkill.exe /F /IM "%~1.exe"
cd /d "!dir!"
for /f "delims=" %%a in ('dir /b "!dir!\app-*"') do (
	call :clearver "%%~a"
)
exit /b 0

:clearver
set "appnum=%~1"
if exist "!dir!\!appnum!\modules" (
	cd /d "!dir!\!appnum!\modules"
	for /f "delims=" %%a in ('dir /b') do (
		echo(%%a|findstr "discord_desktop_core-*" 2>nul >nul || (
			echo(%%a|findstr "discord_modules-*" 2>nul >nul || (
				echo(%%a|findstr "discord_utils-*" 2>nul >nul || (
					echo(%%a|findstr "discord_voice-*" 2>nul >nul || (
						del /f /s /q "%%a" 2>nul >nul
						ROBOCOPY.EXE %%a %%a /S /MOVE 2>nul >nul
					) 
				)  
			 ) 
		) 
	)
)
exit /b 0
:::::::::::::::::::::::::


:::::::::::::::::::::::::
:languages
for /f "delims=" %%a in ('dir /b "!dir!\app-*"') do (
	call :clearlang "%%~a"
)
:clearlang
cd "!dir!\%~1\locales"
for /f "delims=" %%a in ('dir /b') do (
	if not "%%a"=="!keepLanguage!.pak" (
		2>nul >nul del /f /q "%%a"
	)
)
exit /b 0
:::::::::::::::::::::::::


:::::::::::::::::::::::::
:log
(
del /f /q /s "!dir!\*.log"
del /f /q "!dir!\packages\*.nupkg"
del /f /s /q "!appdata!\%~1\*.log"
del /f /s /q "!appdata!\%~1\crashpad\reports\*.dmp"
) 2>nul >nul
exit /b 0
:::::::::::::::::::::::::


:::::::::::::::::::::::::
:priority
reg.exe add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\%~1.exe\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d 3 /f
exit /b 0
:::::::::::::::::::::::::


:::::::::::::::::::::::::
:oldapp
if /i not "%~1"=="discord" (
	echo ERROR: This optimalization can not be used with %~1.
	pause
	exit /b 1
)
set "dir=!localappdata!\%~1"
cd /d "!dir!"
for /f "delims=" %%a in ('dir /b "!dir!\app-*"') do (
	for /f "delims=app- tokens=1,3,4" %%A in ("%%a") do (
		for /f "delims=. tokens=1,2,3" %%B in ("%%A") do (
			if not %%B equ 1 (
				2>nul >nul del /f /s /q "%%a"
				ROBOCOPY.EXE %%a %%a /S /MOVE 2>nul >nul
			)
		)
	)
)
exit /b 0
:::::::::::::::::::::::::


:::::::::::::::::::::::::
:cache
cd "!appdata!\%~1"
2>nul >nul taskkill.exe /F /IM "%~1.exe"
for %%a in ("Cache" "GPUCache") do (
	2>nul >nul del /f /s /q "%%a\*"
)
2>nul >nul del /f /s /q "Code Cache\*"
exit /b 0
:::::::::::::::::::::::::


:logo
echo !ESC![0m                                              github.com/rifteyy
echo.
for %%a in (
"   ▓█████▄  ██▓  ██████  ▄████▄   ▒█████   ██▀███  ▓█████▄ "   
"   ▒██▀ ██▌▓██▒▒██    ▒ ▒██▀ ▀█  ▒██▒  ██▒▓██ ▒ ██▒▒██▀ ██▌"   
"   ░██   █▌▒██▒░ ▓██▄   ▒▓█    ▄ ▒██░  ██▒▓██ ░▄█ ▒░██   █▌"   
"   ░▓█▄   ▌░██░  ▒   ██▒▒▓▓▄ ▄██▒▒██   ██░▒██▀▀█▄  ░▓█▄   ▌"   
"   ░▒████▓ ░██░▒██████▒▒▒ ▓███▀ ░░ ████▓▒░░██▓ ▒██▒░▒████▓ "   
"    ▒▒▓  ▒ ░▓  ▒ ▒▓▒ ▒ ░░ ░▒ ▒  ░░ ▒░▒░▒░ ░ ▒▓ ░▒▓░ ▒▒▓  ▒ "   
"    ░ ▒  ▒  ▒ ░░ ░▒  ░ ░  ░  ▒     ░ ▒ ▒░   ░▒ ░ ▒░ ░ ▒  ▒ "   
"    ░ ░  ░  ▒ ░░  ░  ░  ░        ░ ░ ░ ▒    ░░   ░  ░ ░  ░ "   
"      ░     ░        ░  ░ ░          ░ ░     ░        ░    "   
"    ░                   ░                           ░      "   
) do echo                           !ESC![38;2;114;137;218m%%~a!ESC![0m
echo(                                                                           optimizer
echo.
exit /b 0


:optpriority
cls
call :logo
echo.
echo.
tasklist /fi "ImageName eq !version[%vernum%]!.exe" /fo csv 2>NUL | find /I "!version[%vernum%]!.exe">NUL
if "%ERRORLEVEL%"=="1" (
	echo ERROR: Please launch !version[%vernum%]! to tweak priority.
	pause
	goto :menu
)
echo                   !ESC![38;2;114;137;218m[!ESC![0m 1 !ESC![38;2;114;137;218m]!ESC![0m Lower Discord Usage ^(Ideal for gaming with Discord in background^)
echo.
echo                   !ESC![38;2;114;137;218m[!ESC![0m 2 !ESC![38;2;114;137;218m]!ESC![0m Higher Discord usage ^(Ideal for calling, better voice, faster response^) 
echo.     
echo                   !ESC![38;2;114;137;218m[!ESC![0m 3 !ESC![38;2;114;137;218m]!ESC![0m Reset usage to normal
echo.
echo                   !ESC![38;2;114;137;218m[!ESC![0m 4 !ESC![38;2;114;137;218m]!ESC![0m Back to menu
echo.
echo.
set /p "num=!ESC![30m                     !ESC![0mNumber: !ESC![38;2;114;137;218m"
if "!num!"=="1" (
	reg.exe add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\!version[%vernum%]!.exe\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d 1 /f
	wmic process where name="!version[%vernum%]!.exe" CALL setpriority "64"
)
if "!num!"=="2" (
	reg.exe add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\!version[%vernum%]!.exe\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d 3 /f
	wmic process where name="!version[%vernum%]!.exe" CALL setpriority "128"
)
if "!num!"=="3" (
	reg.exe add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\!version[%vernum%]!.exe\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d 2 /f
	wmic process where name="!version[%vernum%]!.exe" CALL setpriority "32"
)
if "!num!"=="4" (
	goto :menu
) 
goto :optpriority






