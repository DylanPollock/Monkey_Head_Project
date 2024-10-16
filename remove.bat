# Remove Remote Desktop Services and Assistance
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Remote Assistance" /v "fAllowToGetHelp" /t REG_DWORD /d 0 /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server" /v "fDenyTSConnections" /t REG_DWORD /d 1 /f

# Disable Event Logging (if not needed)
Stop-Service -Name "eventlog"
Set-Service -Name "eventlog" -StartupType Disabled

# Disable Connected Devices Platform Service (if not using Bluetooth or peripherals)
Stop-Service -Name "CDPUserSvc"
Set-Service -Name "CDPUserSvc" -StartupType Disabled

# Disable Diagnostic Tracking Service (telemetry)
Stop-Service -Name "DiagTrack"
Set-Service -Name "DiagTrack" -StartupType Disabled

# Disable Superfetch (if using SSDs)
Stop-Service -Name "SysMain"
Set-Service -Name "SysMain" -StartupType Disabled

# Disable Windows Update (manage updates manually or disable permanently)
Stop-Service -Name "wuauserv"
Set-Service -Name "wuauserv" -StartupType Disabled

# Remove unnecessary system folders (be careful with these)
# Old drivers
Remove-Item -Path "C:\Windows\System32\DriverStore\FileRepository\*" -Recurse -Force

# Unused installers (be careful, some rollback installers may be needed)
Remove-Item -Path "C:\Windows\Installer\*" -Recurse -Force

# Windows Defender folder (if using third-party antivirus)
Remove-Item -Path "C:\ProgramData\Microsoft\Windows Defender\*" -Recurse -Force

# Remove WindowsApps directory (removes all installed apps and app data)
Remove-Item -Path "C:\Program Files\WindowsApps\*" -Recurse -Force

# Disable Feedback Hub (removes telemetry-related services)
Get-AppxPackage *windowsfeedback* | Remove-AppxPackage

# Disable Feedback and Diagnostics
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d 0 /f

# Disable File History and System Restore
vssadmin delete shadows /for=C: /all
Disable-ComputerRestore "C:\"
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows NT\SystemRestore" /v "DisableSR" /t REG_DWORD /d 1 /f

# Remove old System Restore Points and backups
del /f /s /q "C:\System Volume Information\*"

# Remove Windows Store (optional, if you don't use the Store at all)
Get-AppxPackage *Microsoft.WindowsStore* | Remove-AppxPackage

# Disable Windows Store-related services
Set-Service -Name "WSService" -StartupType Disabled
Set-Service -Name "WSearch" -StartupType Disabled

# Remove unnecessary fonts (example: Korean, Japanese, Chinese fonts)
Remove-Item -Path "C:\Windows\Fonts\*jpn*" -Force
Remove-Item -Path "C:\Windows\Fonts\*kor*" -Force
Remove-Item -Path "C:\Windows\Fonts\*chs*" -Force
Remove-Item -Path "C:\Windows\Fonts\*cht*" -Force

# Disable more telemetry-related scheduled tasks
schtasks /Change /TN "\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" /Disable
schtasks /Change /TN "\Microsoft\Windows\Autochk\Proxy" /Disable
schtasks /Change /TN "\Microsoft\Windows\Customer Experience Improvement Program\Consolidator" /Disable
schtasks /Change /TN "\Microsoft\Windows\Customer Experience Improvement Program\UsbCeip" /Disable
schtasks /Change /TN "\Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector" /Disable

# Remove Delivery Optimization files and services (if not using peer-to-peer updates)
Stop-Service -Name "DoSvc"
Set-Service -Name "DoSvc" -StartupType Disabled
Remove-Item -Path "C:\Windows\SoftwareDistribution\DeliveryOptimization\*" -Recurse -Force

# Remove Windows.old (previous Windows installations)
Remove-Item -Path "C:\Windows.old" -Recurse -Force

# Disable Speech recognition, Cortana, and unnecessary voice services
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Speech" /v "AllowSpeechPlatformDataCollection" /t REG_DWORD /d 0 /f
Get-AppxPackage *cortana* | Remove-AppxPackage
Stop-Service -Name "SpeechRuntime"
Set-Service -Name "SpeechRuntime" -StartupType Disabled

# Remove Windows Media Player
Disable-WindowsOptionalFeature -Online -FeatureName "WindowsMediaPlayer"

# Remove unnecessary optional features (example: TIFF iFilter, XPS Viewer)
Disable-WindowsOptionalFeature -Online -FeatureName "Printing-XPSServices-Features"
Disable-WindowsOptionalFeature -Online -FeatureName "SearchEngine-Filter-TIFFIFilter"