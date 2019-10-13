<#
.SYNOPSIS
Change the IP of the network adapter when it returns an APIPA address
.DESCRIPTION
The script will check both network adapters and change the IP when it returns APIPA. (This is usable in a situation when you have two network connections, on on nat and one on hostonly (or local network))
.EXAMPLE
.\ChangeIP.ps1 
#>

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

Sleep(5)
Get-NetIPAddress -AddressFamily IPv4 | Select-Object InterfaceAlias, IPAddress