Objects
========
### Properties en Methods
```
#Type of object with Get-Member and GetType()
$PSObject = New-Object -TypeName psobject
$PSObject | Get-Member

$PSObject.GetType()

#Properties
$Spooler = Get-Service -name Spooler
$Spooler
$Spooler | Get-Member -MemberType Property
$Spooler.StartType
$Spooler.StartType.GetType()
$Spooler.Status

#Properties describe the object (type is listed), methods  are what the object can do (more detail)
$Spooler | Get-Member -MemberType Method
$Spooler.Start()  # Haakjes niet vergeten!
```

### Strings
```
"Hello World"
$Hi = "Helo World"

#String Properties
$Hi | Get-Member -MemberType Property
$Hi.Length

#String Methods
$Hi | Get-Member -MemberType Method
#True or false, does the string contain ...
$Hi.Contains("Earth")
#Returns the index is it's in the string
$Hi.IndexOf("World") #So in this case position 5
#Inserts text
$Hi.Insert($Hi.IndexOf(" "), " There") #The output will be "Helo There World"
#Removes characters (0 = start, 5 = end)
$Hi.Remove(0, 5) #Returns World
#Replaces characters
$Hi.Replace("World", "Earth")
#Splits the line (an array of smaller strings)
$Hi.Split(" ")
```

### Credentials
```
#Asks for a name and password and stores it in the variable
$SimpleCredential = Get-Credential 

$SimpleCredential | Get-Member -MemberType Property

#TypeName: System.Management.Automation.PSCredential
#Name     MemberType Definition
#----     ---------- ----------
#Password Property   securestring Password {get;}
#UserName Property   string UserName {get;}

$SimpleCredential.Password
#System.Security.SecureString
$SimpleCredential.GetNetworkCredential()
#UserName                                           Domain
#--------                                           ------
#Daan
$SimpleCredential.GetNetworkCredential().Password
#Pass
#So it's very vulnerable....
```

### Array
```
$Array = Get-ChildItem D:\

#The output of $Array is used as an input to Get-Member.
#Why doesn't Get-Member give the properties of an array?
#Because it's more likely you want to get the properties of what's IN the array.
$Array | Get-Member

#It does have an object type of its own
$Array.GetType()
$Array.Length

#Looking at one object
$Array[0]
#Serveral objects
$Array[1..3]
#Last object
$Array[-1]

#To create an array and add processes start with an empty array
$Thisisanarray = @()
$Thisisanarray.GetType()
$Thisisanarray += Get-Process | Get-Random
$Thisisanarray

#PS D:\Powershell> $Thisisanarray
#
# NPM(K)    PM(M)      WS(M)     CPU(s)      Id  SI ProcessName
# ------    -----      -----     ------      --  -- -----------
#     17     7,18       3,79       0,55   20624   4 steamwebhelper
#
#PS D:\Powershell> $Thisisanarray += Get-Process | Get-Random
#PS D:\Powershell> $Thisisanarray
#
#NPM(K)    PM(M)      WS(M)     CPU(s)      Id  SI ProcessName
#------    -----      -----     ------      --  -- -----------
#    17     7,18       3,79       0,55   20624   4 steamwebhelper
#    10     1,81       5,07       0,00   10940   0 svchost

```

### Files
```
#Length of a file (total characters)
$Array[3].Length
#Filename
$Array[3].Name #Filename with extension
$Array[3].Directory #Directory that the file is in
$Array[3].Directory.FullName #Directory that the file is in
$Array[3].FullName #Path to the file
#Timestamps
$Array[3].CreationTime #When file was created
$Array[3].LastWriteTime #Last tim the file was saved to

#Version information
$Array[3].VersionInfo | Get-Member
```

### Scriptblocks
```
#Scriptblocks (Grouping one or more expressions together)
$Scriptblock = { Get-Process Steam, Code; Write-Host -ForegroundColor Green "Complete" }
$Scriptblock # outputs:  Get-Process Steam, Code; Write-Host -ForegroundColor Green "Complete" 
#Call the scriptblock
& $Scriptblock

#NPM(K)    PM(M)      WS(M)     CPU(s)      Id  SI ProcessName
#------    -----      -----     ------      --  -- -----------
#    21    25,89      35,74       0,19    5904   4 Code
#    34    47,40      72,24       3,28    8376   4 Code
#    42    34,54      76,17      75,28    8860   4 Code
#    61    71,59      90,70      22,06   12128   4 Code
#    73   185,65     214,70     285,69   17932   4 Code
#    16     6,23      13,34       0,14   19500   4 Code
#    53   626,43      88,16      82,48   21232   4 Code
#    88    42,28      48,66     301,34   16996   4 Steam
#Complete
```
### Comparison and  Logical Operators

#### Equal
```
1 + 2 -eq 3
True

4 -eq "four"
False

"4" -eq 4
True

```

#### Like, Contains, In 
```
PS C:\Users\Gebruiker> #Like requires a wildcard
"Hello World" -like "Hello*"
True
PS C:\Users\Gebruiker> "Hello World" -like "World*"
False
PS C:\Users\Gebruiker> "Hello World" -like "*ell*"
True
PS C:\Users\Gebruiker>
```

#### Comparison
```
PS C:\Users\Gebruiker> #Greater than
(Get-Process).Length -gt 100
1 -ge 1 #greater than or equal to
1 -lt 0 #lesser than
0 -le 1 #lesser than or equal to
True
True
False
True
```

#### Logical Operators
```
$True #Is always true
$False #Is always false

#AND - ALL of the evaluated conditions are true
$True -AND $True  #Returns true
$True -AND $True AND $False #Returns false

#OR - Any of the evaluated conditions are true
$False -OR $False #Returns false
$False -OR $True #Returns true

#NOT Returns the oposite of the condition
$True -AND $True -AND (-NOT $TRUE) #Returns false
```

### Managing Objects

#### Where-Object
```
PS C:\Users\Gebruiker> Get-Process | Where-Object {$_.Path -like "C:\Users*"}

 NPM(K)    PM(M)      WS(M)     CPU(s)      Id  SI ProcessName
 ------    -----      -----     ------      --  -- -----------
     45   388,95      84,70      47,44   14860   5 Boostnote
     55   158,62     180,35     117,98   20208   5 Boostnote
     37    34,52      62,17      30,55   20268   5 Boostnote
     34    43,06      59,28       1,86    7160   5 Code
     57    58,83      68,88       9,03    7604   5 Code
     16     6,20       5,25       0,03    8464   5 Code
     51   490,18      59,55      25,47   20892   5 Code
     40    34,59      62,23      26,50   21676   5 Code
     63   144,97     168,82      84,92   22140   5 Code
     61    24,95      46,65       0,81   14644   5 OneDrive

PS C:\Users\Gebruiker> Get-Process | Where-Object Path -like "C:\Users\*"

 NPM(K)    PM(M)      WS(M)     CPU(s)      Id  SI ProcessName
 ------    -----      -----     ------      --  -- -----------
     45   388,95      84,71      47,45   14860   5 Boostnote
     54   158,67     180,49     118,00   20208   5 Boostnote
     37    34,52      62,19      30,58   20268   5 Boostnote
     33    43,19      59,21       1,98    7160   5 Code
     57    61,86      71,82      10,05    7604   5 Code
     16     6,20       5,25       0,03    8464   5 Code
     53   544,41      58,10      27,50   20892   5 Code
     40    34,57      62,21      27,89   21676   5 Code
     64   147,44     171,42      90,97   22140   5 Code
     61    24,95      46,65       0,81   14644   5 OneDrive
```

#### Select-Object
```
#Select-Object --> include properties in your display that aren't normally there
Get-Process -Name "code"
Get-Process -Name "code" | Get-Member -Membertype Property
Get-Process -Name "code" | Select-Object Name, Path, StartTime
Get-Process -Name "code" | Select-Object Name, Path, StartTime | Get-Member
Get-Process -Id 4 | Select-object *

PS C:\Users\Gebruiker> Get-ComputerInfo | Select-Object -ExpandProperty OsHotFixes

Description     FixComments HotFixID  InstalledOn
-----------     ----------- --------  -----------
Update                      KB4514359 9/14/2019
Security Update             KB4503308 7/9/2019
Update                      KB4506472 7/9/2019
Security Update             KB4508433 8/15/2019
Security Update             KB4509096 7/9/2019
Security Update             KB4515383 9/13/2019
Security Update             KB4516115 9/14/2019
Update                      KB4515384 9/14/2019
```
#### Sort-Object
```
Get-Process | Select-Object -First 10
Get-Process | Select-Object -First 10 | Sort-Object CPU
Get-Process | Sort-Object CPU -Descending | Select-Object -First 10 # Top 10 pocesses that use the most CPU
```
#### Group-Object
```
Get-Service | Get-Member -MemberType Property
Get-Service | Group-Object StartType #Services are grouped
```

#### Measure-Object
```
Get-Process | Measure-Object #Only measures the count
Get-Process | Measure-Object WorkingSet -Average -Sum -Maximum -Minimum
Count             : 243
Average           : 22858039,8353909
Sum               : 5554503680
Maximum           : 242958336
Minimum           : 8192
StandardDeviation :
Property          : WorkingSet
```

#### Foreach-Object
```
PS C:\Users\Gebruiker> Set-Location D:\Powershell\temp
PS D:\Powershell\temp> Get-Service | Group-Object Starttype | ForEach-Object { $_.Group.DisplayName | Out-File -FilePath $_.Name}
PS D:\Powershell\temp> dir


    Directory: D:\Powershell\temp

Mode                LastWriteTime         Length Name
----                -------------         ------ ----
-a----         29-9-2019    14:58           2229 Automatic
-a----         29-9-2019    14:58            166 Disabled
-a----         29-9-2019    14:58           5455 Manual

PS D:\Powershell\temp> type .\Disabled
Net.Tcp Port Sharing Service
Routing and Remote Access
Remote Registry
Shared PC Account Manager
OpenSSH Authentication Agent
Updater van automatische tijdzone
```

### Create Powershell Object
Convert a hashtable into a Powershell object

```
#Use a semicolon to separate multiple key/value sets entered on the same line
#A hashtable is a set of key value pairs. Putting them in curly brackets with an @ sign
$Hashtable = @{Firstname = "Daan"; Lastname = "Spieard"}
$Hashtable 
$Hashtable.Lastname
#It's more like an array, let's turn this into an object
$MyObject =[PSCustomObject]$Hashtable
#Or
$OtherObject =[PSCustomObject]@{
    Firstname = "Daan"
    Lastname = "Spieard"
}

#With output

PS D:\Powershell\temp> $Hashtable = @{Firstname = "Daan"; Lastname = "Spieard"}
PS D:\Powershell\temp> $Hashtable

Name                           Value
----                           -----
Lastname                       Spieard
Firstname                      Daan

PS D:\Powershell\temp> $Hashtable.Lastname
Spieard
PS D:\Powershell\temp> $MyObject =[PSCustomObject]$Hashtable
PS D:\Powershell\temp> $MyObject

Lastname Firstname
-------- ---------
Spieard  Daan

PS D:\Powershell\temp> $OtherObject =[PSCustomObject]@{
>>     Firstname = "Daan"
>>     Lastname = "Spieard"
>> }
PS D:\Powershell\temp> $OtherObject

Firstname Lastname
--------- --------
Daan      Spieard 

PS D:\Powershell\temp> $MyObject | Select-Object Firstname

Firstname
---------
Daan  

#Adding data to an object
$MyObject | Add-member -MemberType NoteProperty -Name Initial -Value "D"
```







