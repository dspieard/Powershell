<#
.SYNOPSIS
Renaming a stand-alone server
.DESCRIPTION
The script will rename the serve and execute a ps1 script after restarting
.EXAMPLE
.\RenameServer.ps1 
#>
$logo = @"
  ___                            ___                     _
 | _ \___ _ _  __ _ _ __  ___   / __|___ _ __  _ __ _  _| |_ ___ _ _
 |   / -_) ' \/ _' | '  \/ -_) | (__/ _ \ '  \| '_ \ || |  _/ -_) '_|
 |_|_\___|_||_\__,_|_|_|_\___|  \___\___/_|_|_| .__/\_,_|\__\___|_|  
                                              |_|
"@
Write-Host "$logo" -ForegroundColor Green

#Grab variables from script
$AdminUsername = Read-Host -Prompt 'Enter the Admin username'
$AdminPasswordSecure = Read-Host -Prompt  'Enter the Admin password' -AsSecureString
$ComputerName = Read-Host -Prompt 'Enter the new computername'
$BinaryString = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($AdminPasswordSecure)
$AdminPassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BinaryString)

#Registry path declaration
$RegPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"
$RegROPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce"

#Set the correct Regkeys
function SetRegKeys{
    Set-ItemProperty $RegPath "AutoAdminLogon" -Value "1" -type String 
    Set-ItemProperty $RegPath "DefaultUsername" -Value "$AdminUsername" -type String 
    Set-ItemProperty $RegPath "DefaultPassword" -Value "$AdminPassword" -type String
    Set-ItemProperty $RegPath "AutoLogonCount" -Value "1" -type DWord
    New-ItemProperty -Path $RegROPath -Name "Run Script" `
    -Value "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -File C:\Users\Administrator\Documents\Serverconfigscripts\Uitvoer.ps1" #Change this!
}

SetRegKeys
Rename-Computer -NewName "$ComputerName" -Force -Restart