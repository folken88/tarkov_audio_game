@echo off
REM Tarkov Weapon Folder Setup
REM This batch file calls the PowerShell script to set up all weapon folders

echo ========================================
echo Tarkov Weapon Folder Setup
echo ========================================
echo This will create weapon folders for ALL weapons in weapons.js
echo Each folder will have: image, close/, medium/, far/
echo.

cd /d "%~dp0"

REM Call the PowerShell script
powershell -ExecutionPolicy Bypass -File "%~dp0setup_all_weapon_folders.ps1"

pause
