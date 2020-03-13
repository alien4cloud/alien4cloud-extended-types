param (
  [string]$FS_MOUNT_PATH,
  [string]$DEVICE_LETTER
)

# Trap is used to return an exit code when error occurs
trap {
  Write-Error $_
  [Environment]::Exit(1)
}

Import-Module -Name Storage -PassThru

# Print Parameters
$parameters = @{ "FS_MOUNT_PATH"=$FS_MOUNT_PATH; "DEVICE_LETTER"=$DEVICE_LETTER }
$parameters.GetEnumerator() | % {
  Write-Host "$($_.key) --> $($_.value)"
}

# Check parameters
if ( [string]::IsNullOrEmpty($FS_MOUNT_PATH) -Or [string]::IsNullOrEmpty($DEVICE_LETTER) ) {
  throw "At least one of the mandatory parameter is missing: FS_MOUNT_PATH, DEVICE_LETTER"
}

$DiskIndex = $FS_MOUNT_PATH

# Partition the disk if it is a new disk
$Disk = Get-Disk | Where { $_.Number -Eq $DiskIndex }
If ( $Disk.PartitionStyle -Eq "RAW" ) {
  Write-Host "Initializing disk index $DiskIndex..."
  Initialize-Disk -Number $DiskIndex -PartitionStyle MBR -PassThru
} Else {
  Write-Host "Disk index $DiskIndex has already been initialized"
}

$PartitionNumber = Get-Partition | Where DiskNumber -Eq $DiskIndex
If ( $PartitionNumber -eq $null ) {
  Write-Host "Paritionning disk index $DiskIndex..."
  New-Partition -DiskNumber $DiskIndex -UseMaximumSize
} Else {
  Write-Host "Disk index $DiskIndex has already been partitionned. Getting the disk online."
  Set-Disk -Number $DiskIndex -IsOffline $False
}

$ExistingDriveLetter = (Get-Partition -DiskNumber $DiskIndex).driveletter | ? {$_}
If ( $ExistingDriveLetter -eq $null ) {
  # Mount the datadisk if not mounted
  Write-Host "Mounting Index $DiskIndex to DriveLetter $($DEVICE_LETTER)..."
  $PartitionNumber = (Get-Partition -DiskNumber $DiskIndex | select PartitionNumber).PartitionNumber[0]
  If ( $PartitionNumber -ne $null ) {
    Write-Host "Mount DiskNumber: $($DiskIndex) DriveLetter: $($DEVICE_LETTER) PartitionNumber: $($PartitionNumber)"
    Add-PartitionAccessPath -DiskNumber $DiskIndex -PartitionNumber $PartitionNumber -AccessPath "$($DEVICE_LETTER):"
  } Else {
    # If the existing datadisk has no partition = user is using existing disk but the disk has no partition
    Throw "No partition on the disk index: $($DiskIndex)"
  }
} Else {
  Write-Host "DiskIndex $DiskIndex is already mounted on DriveLetter $($ExistingDriveLetter)"
}

# Ensure that the mounted drive letter is the expected one
$MountedDriveLetter = (Get-Partition -DiskNumber $DiskIndex).driveletter | ? {$_}
If ( $MountedDriveLetter -ne $null -And $MountedDriveLetter -ne $DEVICE_LETTER ) {
  # The existing drive letter isn't the expected one, so we update it
  Write-Host "Unexpected drive letter. Trying to update the drive letter from $MountedDriveLetter to $DEVICE_LETTER"
  Set-Partition -DriveLetter $MountedDriveLetter -NewDriveLetter $DEVICE_LETTER
}
