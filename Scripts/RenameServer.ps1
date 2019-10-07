<#
.SYNOPSIS
Renaming a stand-alone server
.DESCRIPTION
The script will rename the server
.EXAMPLE
.\RenameServer.ps1 mynewcomputername
#>

$name = $args[0]

Rename-Computer -NewName "$name" -LocalCredential Administrator -Force -Restart

#If you want to continue with another script after booting uncomment the next two lines and create a script to execute (for example "scriptuitvoer.ps1)
#New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce -Name "Run Script" `
#-Value "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -File C:\Users\Administrator\Documents\scriptuitvoer.ps1"