@echo off

C:\Windows\Sysnative\WindowsPowerShell\v1.0\powershell.exe -executionpolicy bypass -File  %init_ps1% -FS_MOUNT_PATH "%FS_MOUNT_PATH%" -DEVICE_LETTER "%DEVICE_LETTER%" -VOLUME_ID "%VOLUME_ID%"

IF %ERRORLEVEL% NEQ 0 (
  EXIT /B %ERRORLEVEL%
)

