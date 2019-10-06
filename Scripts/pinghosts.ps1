<#
.SYNOPSIS
Pings a class C ip-range and checks if a host is up or down
.DESCRIPTION
The script wil ping each address in the range that's given. Don't forget the "." at the end of the IP and the spaces between the range ;)
.EXAMPLE
.\PingHosts.ps1 [ipsubnet] [startrange] [endrange]
.\PingHosts.ps1 192.168.1. 1 254
#>
$logo = @"
 _____ _             _
|  __ (_)           (_)
| |__) | _ __   __ _ _ _ __   __ _
|  ___/ | '_ \ / _' | | '_ \ / _' |
| |   | | | | | (_| | | | | | (_| |
|_|   |_|_| |_|\__, |_|_| |_|\__, |
                __/ |         __/ |
               |___/         |___/
"@
Write-Host "$logo" -ForegroundColor Blue
$ip = $args[0]
$range1 = $args[1]
$range2 = $args[2]
foreach ($i in ($range1..$range2)){
    if (Test-Connection -ComputerName $ip$i -Count 2 -Quiet -InformationAction ignore) {
        Write-Host "$ip$i is up en running!" -ForegroundColor Green
    }
    else {
        Write-Host "$ip$i is down!" -ForegroundColor Red
    }
}