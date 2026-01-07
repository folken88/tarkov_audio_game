@echo off
echo Downloading weapon images from Tarkov Wiki...
echo.
powershell -ExecutionPolicy Bypass -File "%~dp0download_weapon_images.ps1"
pause


