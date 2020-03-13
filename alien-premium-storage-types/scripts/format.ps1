param (
  [string]$FS_TYPE,
  [string]$DEVICE_LETTER
)

# Trap is used to return an exit code when error occurs
trap {
  write-error $_
  [Environment]::Exit(1)
}

Write-Host "FS_TYPE -> "+ $FS_TYPE
Write-Host "DEVICE_LETTER -> "+ $DEVICE_LETTER

# Format the disk if it doesn't have a Filesystem
if ( (Get-PSDrive | Where Name -eq $DEVICE_LETTER | Select $_.Provider) -eq $NULL ) {
  Write-Host "Format Volume " + $DEVICE_LETTER + ": with filesystem " + $FS_TYPE
  Format-Volume -DriveLetter $DEVICE_LETTER -FileSystem $FS_TYPE -Confirm:$false
} else {
  Write-Host "disk already exist, skip format"
}