@echo off
SET OUT_DIR=Exports
if not exist "%OUT_DIR%" mkdir %OUT_DIR% || exit /b

:: Create register write script
CBProProjectRegistersExport.exe --project Si5345-Project.slabtimeproj --include-load-writes --format csv --outfile %OUT_DIR%/Si5345-Config-Script.txt || exit /b
CBProProjectRegistersExport.exe --project Si5345-Project.slabtimeproj --include-load-writes --format cheader --outfile %OUT_DIR%/Si5345-Config-Script.c || exit /b

:: Dump configuration named settings associated with this config  
CBProProjectSettingsExport.exe --project Si5345-Project.slabtimeproj --outfile %OUT_DIR%/Si5345-Settings.txt || exit /b

:: Generate regmap files for the
CBProRegmapExport.exe --project Si5345-Project.slabtimeproj --out-folder Exports
