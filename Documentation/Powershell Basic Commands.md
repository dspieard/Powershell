Powershell Basic Commands
==========


### Check processes
```
Get-Process | Get-Member
Get-Process | Select-Object StartTime, Name, FileVersion, Path
```

### Parameters
##### Whatif, Confirm, Verbose
```
New-Item C:\temp.older.txt -Force -ItemType File
New-Item C:\temp.old.txt -Force -ItemType File
New-Item C:\temp.new.txt -Force -ItemType File

# How to keep the newest file and delete the older files

# Een simpele fout, niet in de juiste volgorde sorteren
Get-ChildItem C:\Temp | Sort-Object CreationTime | Select-Object -Skip 1 | Remove-Item Whatif

#Whatif parameter bestaat in elk commando. Het voert het niet uit, maar geeft een "What if" scenario

# Decending zorgt voor de juiste sortering
Get-ChildItem C:\Temp | Sort-Object CreationTime -Descending | Select-Object -Skip 1 | Remove-Item Whatif

# Confirm gebruiken voor delete acties
Get-ChildItem C:\Temp | Sort-Object CreationTime | Select-Object -Skip 1 | Remove-Item -Confirm

#Confirm vraagt of de actie echt uitgevoerd moet worden.

# Meer informatie over wat uitgevoerd wordt, gebruik verbose
Get-ChildItem C:\Temp | Sort-Object CreationTime | Select-Object -Skip 1 | Remove-Item -Verbose
```

### Reading and writing to host

#### Get-Host
```
PS C:\Users\Gebruiker> Get-Command -Noun "Host"

CommandType     Name                                               Version    Source
-----------     ----                                               -------    ------
Function        Clear-Host
Cmdlet          Get-Host                                           6.1.0.0    Microsoft.PowerShell.Utility
Cmdlet          Out-Host                                           6.2.3.0    Microsoft.PowerShell.Core   
Cmdlet          Read-Host                                          6.1.0.0    Microsoft.PowerShell.Utility
Cmdlet          Write-Host                                         6.1.0.0    Microsoft.PowerShell.Utility

PS C:\Users\Gebruiker> Get-Host

Name             : ConsoleHost
Version          : 6.2.3
InstanceId       : a8dd39c5-70fb-487b-afad-7610327c1e0d
UI               : System.Management.Automation.Internal.Host.InternalHostUserInterface
CurrentCulture   : nl-NL
CurrentUICulture : nl-NL
PrivateData      : Microsoft.PowerShell.ConsoleHost+ConsoleColorProxy
DebuggerEnabled  : True
IsRunspacePushed : False
Runspace         : System.Management.Automation.Runspaces.LocalRunspace
```

#### Read-Host
```
# Get input van de Host, wachten op userinput
# Voor wachtwoorden gebruik -AsSecureString
# Een bericht wat wordt verwacht kan met -Prompt

PS C:\Users\Gebruiker> Read-Host
test
test
PS C:\Users\Gebruiker> 

PS C:\Users\Gebruiker> Read-Host -prompt "Geef je wachtwoord!" -AsSecureString
Geef je wachtwoord!: *******************
System.Security.SecureString
```

#### Write-Host
```
Write-Host "Hallo Wereld" -NoNewLine 
Write-Host "Hallo Wereld" -ForegroundColor Yellow
```

#### String formatting
```
"Pi is {0}" -f [Math]::PI
"Pi id {0:n2} (close enough)" -f [Math]::PI
"Pi id {0:n2} (close enough ({1:p})) " -f [Math]::PI, 0.99

PS C:\Users\Gebruiker> "Pi is {0}" -f [Math]::PI
"Pi id {0:n2} (close enough)" -f [Math]::PI
"Pi id {0:n2} (close enough ({1:p})) " -f [Math]::PI, 0.99
Pi is 3,14159265358979
Pi id 3,14 (close enough)
Pi id 3,14 (close enough (99,00%))
```

### Pipeline & $_Variable

### Get-Content | Select-String
```
PS D:\Powershell> Get-Host > test.txt
PS D:\Powershell> dir


    Directory: D:\Powershell

Mode                LastWriteTime         Length Name
----                -------------         ------ ----
d-----         27-9-2019    09:19                temp
-a----         27-9-2019    09:09             90 Basic Commands.ps1
-a----         21-9-2019    09:15              0 test.ps1
-a----         27-9-2019    09:19            496 test.txt


PS D:\Powershell> Get-Content test.txt

Name             : Visual Studio Code Host
Version          : 2019.9.0
InstanceId       : f30b59ba-d0c5-4dfa-bf59-d4b09273677e
UI               : System.Management.Automation.Internal.Host.InternalHostUserInterface      
CurrentCulture   : nl-NL
CurrentUICulture : nl-NL
PrivateData      : Microsoft.PowerShell.EditorServices.EditorServicesPSHost+ConsoleColorProxy
DebuggerEnabled  : True
IsRunspacePushed : False
Runspace         : System.Management.Automation.Runspaces.LocalRunspace


PS D:\Powershell> Get-Content test.txt | Select-String "Co"

Name             : Visual Studio Code Host
PrivateData      : Microsoft.PowerShell.EditorServices.EditorServicesPSHost+ConsoleColorProxy

PS D:\Powershell>
```

### List services
```
PS D:\Powershell> Get-Service | Where-Object Status -eq "Running" | Out-File RunningServices.txt 
PS D:\Powershell> Get-Content .\RunningServices.txt

Status   Name               DisplayName
------   ----               -----------
Running  AdobeUpdateService AdobeUpdateService
Running  AGMService         Adobe Genuine Monitor Service
Running  AGSService         Adobe Genuine Software Integrity Serv…
Running  Appinfo            Application Information
Running  asComSvc           ASUS Com Service
Running  asHmComSvc         ASUS HM Com Service

PS D:\Powershell> Get-Service | Where-Object Name -match "Steam" | Out-File RunningServices.txt   
PS D:\Powershell> Get-Content .\RunningServices.txt

Status   Name               DisplayName
------   ----               -----------
Running  Steam Client Serv… Steam Client Service
```

Get-SomeObject | Filter-TheObjects | Perform SomeOperation

```
PS D:\Powershell> Get-Service | Where-Object {$_.Name -match "Steam"}                               

Status   Name               DisplayName
------   ----               -----------
Running  Steam Client Serv… Steam Client Service
```









