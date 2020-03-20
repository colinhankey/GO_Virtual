#GO_Virtual Preperation script.
$fileToCheck = "$env:TEMP\IDGo800_Minidriver_64.msi"
if (Test-Path $fileToCheck -PathType leaf)
{
   write-host "files already exist in Temp, skipping"
}
else{ cp * $env:TEMP\}

Write-Host "Checking for admin"
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }


###IMPORT CERTS as ROOT CAs###
$files = Get-ChildItem $env:TEMP\*.cer
foreach ($file in $files) {
Import-Certificate -FilePath $file -CertStoreLocation Cert:\LocalMachine\CA
write-host $file
}



#Install MiniDriver
#Start-Process msiexec.exe -Wait -arg "/I .\IDGo800_Minidriver_64.msi"
(Start-Process "msiexec.exe" -ArgumentList "/i $env:TEMP\IDGo800_Minidriver_64.msi /passive" -NoNewWindow -Wait -PassThru).ExitCode
