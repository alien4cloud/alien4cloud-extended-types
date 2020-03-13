param (
  [string]$Index = 0
)

# Trap is used to return an exit code when error occurs
trap {
  write-error $_
  [Environment]::Exit(1)
}

Import-Module -Name Storage -PassThru

if( ($Index -eq 0) -Or [String]::IsNullOrEmpty($Index) ) {
  throw "Cannot unmount system disk"
}

$DriveLetter = (Get-Partition -DiskNumber $Index).driveletter | ? {$_}

if ( $DriveLetter -ne $null ) {
  $PartitionNumber = (Get-Partition -DiskNumber $Index | Where-Object {$_.DriveLetter -eq $DriveLetter} | Select PartitionNumber).PartitionNumber
  Write-Host Unmount DiskNumber: $Index DriveLetter: $DriveLetter PartitionNumber: $PartitionNumber
  $FullDriveLetter = -join($DriveLetter,":")
  Remove-PartitionAccessPath -DiskNumber $Index -PartitionNumber $PartitionNumber -AccessPath $FullDriveLetter
  #Write-Host Unmounted DiskNumber: $Index DriveLetter:$DriveLetter PartitionNumber: $PartitionNumber
} else {
  Write-Host No datadisk to unmounted on index=$Index
}
