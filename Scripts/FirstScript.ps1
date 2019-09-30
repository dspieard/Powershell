#If
if ($True) {
    Write-Host -ForegroundColor Green "Hello!"
}

#Else
$AutomaticFile = Get-Item D:\Powershell\temp\Automatic
if (!$AutomaticFile) {"$AutomaticFile does not exist"} else {"$AutomaticFile exists"}

if ($false){
    Write-Host -ForegroundColor Green "This is IF"
} else {
    Write-Host -ForegroundColor Green "This is Else"
}

#Elseif
if (!$true) {"If"} elseif ($true) { "Else if"} else {"What Else?"}

#Switch
$SpoolerService = Get-Service -Name "Spooler"
Switch ((Get-Service Spooler).Status){
    "Starting" { "Wait for the startup" }
    "Running" { "It's already running" }
    Default {$SpoolerService | Start-Service; Write-Host "Starting the service"}
}

#Functions

Function Dosomething {
<#
.SYNOPSIS
    What the function does
.DESCRIPTION
    All the information you need
.EXAMPLE
    An example
    Description of what the example does
#>

    "Something"
}
#Call with 
Dosomething


