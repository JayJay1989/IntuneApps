$AppName = "LocalAdmin"
$File = "C:\intune\localadm.txt"

Write-Host "Custom script based detection : $AppName"

if (Test-Path $File) {

    $lastModifiedDate = (Get-ChildItem $File).LastWriteTime
    $TimeToCheck = (Get-date)
    $CheckedTime = ($TimeToCheck-$lastModifiedDate).TotalMinutes

    if($CheckedTime -lt 2.0){

        Write-Host "File found!"
        Exit 0

    }else{

        Write-Host "File $file found. But its old"
        Exit 1

    }

}else{

    Write-Host "File $file not found. Application not installed"
    Exit 1

}