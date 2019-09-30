if ($True) {
    Write-Host -ForegroundColor Green "Hello!"
}


$AutomaticFile = Get-Item D:\Powershell\temp\Automatic
if (!$AutomaticFile) {"$AutomaticFile does not exist"} else {"$AutomaticFile exists"}