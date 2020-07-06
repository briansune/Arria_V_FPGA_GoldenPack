@echo off
SET OUT_DIR=Exports
if not exist "%OUT_DIR%" mkdir %OUT_DIR% || exit /b

::
:: Create 2 new CBPro project files
::

:: Si5347-Original-Project.slabtimeproj + edits in Si5347-Edits1.txt = Si5347-Edited-Project1.slabtimeproj 
CBProProjectEdit.exe --in-project Si5347-Original-Project.slabtimeproj --edit-file Si5347-Edits1.txt --out-project Si5347-Edited-Project1.slabtimeproj || exit /b

:: Si5347-Original-Project.slabtimeproj + edits in Si5347-Edits2.txt = Si5347-Edited-Project2.slabtimeproj 
CBProProjectEdit.exe --in-project Si5347-Original-Project.slabtimeproj --edit-file Si5347-Edits2.txt --out-project Si5347-Edited-Project2.slabtimeproj || exit /b

:: Create an export for both original and new projects file, saved to OUT_DIR
CBProMultiProjectExport.exe --out-folder %OUT_DIR% Si5347-Original-Project.slabtimeproj Si5347-Edited-Project1.slabtimeproj Si5347-Edited-Project2.slabtimeproj || exit /b