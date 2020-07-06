@echo off
SET OUT_DIR=Exports
if not exist "%OUT_DIR%" mkdir %OUT_DIR% || exit /b

:: Create new CBPro project file: 
:: Si5345-Original-Project.slabtimeproj  + edits in Si5345-Edits.txt = Si5345-Edited-Project.slabtimeproj
CBProProjectEdit.exe --in-project Si5345-Original-Project.slabtimeproj --edit-file Si5345-Edits.txt --out-project Si5345-Edited-Project.slabtimeproj || exit /b

:: Create an export for both original and new project file, saved to OUT_DIR
CBProMultiProjectExport.exe --c-register-scripts --out-folder %OUT_DIR% Si5345-Original-Project.slabtimeproj Si5345-Edited-Project.slabtimeproj || exit /b