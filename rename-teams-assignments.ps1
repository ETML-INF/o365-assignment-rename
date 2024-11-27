#usage .\rename-teams-assignments.ps1 -in C:\...\Assignments -filter test1 -out C:\temp\copiedAndRenamedZips
param(
  [Parameter(Mandatory=$true)]
  [string]$in,

  [Parameter(Mandatory=$true)]
  [string]$filter,

  [Parameter(Mandatory=$true)]
  [string]$out
)


$students = Get-ChildItem -Path $in -Directory

Write-Debug "Found students: $students"

foreach ($subdirectory in $students) {

  Write-Debug "Analyzing $subdirectory"

  $zipFiles = Get-ChildItem -Path $subdirectory.FullName -Filter "*.zip" -Recurse -File | Where-Object { $_.FullName -like "*$filter*" }

  $version = 1
  foreach ($zipFile in $zipFiles) {
      
      $newFileName = "$subdirectory-v$($version)_$($zipFile.Basename).zip"
      $inPath = "$($zipFile.FullName)"
      $outPath = Join-Path -Path "$out" -ChildPath "$newFileName"

      Write-Debug "Found $zipFile, about to copy $inPath->$outPath"

      Copy-Item -Path "$inPath" -Destination "$outPath"

      $version++
  }
}
