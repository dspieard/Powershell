<#
.SYNOPSIS
Initial config
.DESCRIPTION
The script will check and change the netadapters and rename the server
.EXAMPLE
.\InitialConfig.ps1
#>
$logo = @"
 ___      _ _   _      _   ___                        ___           __ _                    _   _
|_ _|_ _ (_) |_(_)__ _| | / __|___ _ ___ _____ _ _   / __|___ _ _  / _(_)__ _ _  _ _ _ __ _| |_(_)___ _ _
 | || ' \| |  _| / _' | | \__ \ -_) '_\ V / -_) '_| | (__/ _ \ ' \|  _| / _' | || | '_/ _' |  _| / _ \ ' \ 
|___|_||_|_|\__|_\__,_|_| |___\___|_|  \_/\___|_|    \___\___/_||_|_| |_\__, |\_,_|_| \__,_|\__|_\___/_||_|
                                                                        |___/
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

function ChangeIP{
    $NICs = Get-NetIPAddress
    Foreach ($NIC in $NICs){
        $IP = $NIC.IPAddress
        $AddressFamily = $NIC.AddressFamily
        $InterfaceAlias = $NIC.InterfaceAlias
        $InterfaceIndex = $NIC.InterfaceIndex
        if ($AddressFamily -eq "IPv4" -and $IP -Like "169*") {
            Rename-NetAdapter -name "$InterfaceAlias" -NewName "LAN"
            New-NetIPAddress -InterfaceIndex "$InterfaceIndex" -IPAddress "192.168.1.1" -PrefixLength "24" | Out-Null
        }
        elseif($AddressFamily -eq "IPv4" -and $IP -notlike "127*"){
            Rename-NetAdapter -name "$InterfaceAlias" -NewName "Internet"
        }
    }
    Write-Output "Changing IP settings..."
    Start-Sleep(5)
    Get-NetIPAddress -AddressFamily IPv4 | Select-Object InterfaceAlias, IPAddress
    Start-Sleep(5)
    
}
#Set the correct Regkeys
function SetRegKeys{
    Set-ItemProperty $RegPath "AutoAdminLogon" -Value "1" -type String 
    Set-ItemProperty $RegPath "DefaultUsername" -Value "$AdminUsername" -type String 
    Set-ItemProperty $RegPath "DefaultPassword" -Value "$AdminPassword" -type String
    Set-ItemProperty $RegPath "AutoLogonCount" -Value "1" -type DWord
}

function RenameComputer{
    Write-Output "`nPlease wait, the server will restart in a moment"
    Start-Sleep(10)
    Rename-Computer -NewName "$ComputerName" -Force -Restart
}

SetRegKeys
ChangeIP
RenameComputer