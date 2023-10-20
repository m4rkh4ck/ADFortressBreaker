<h1 align=center> ADFortressBreaker </h1>

![Default_fortress_breaker_logo_microsoft_windows_cybersecurity_1_b2db1a2f-aaee-41f3-85a0-d73527e5ce6e_0](https://github.com/m4rkh4ck/ADFortressBreaker/assets/92309458/08f54524-3a96-41a0-b294-da0514c611fd)

<h1 align=center><br><img src= https://img.shields.io/badge/Language-Powershell-blue> <img src= https://img.shields.io/badge/Version-v1.0-green> <a href= "https://www.linkedin.com/in/%F0%9F%92%BE-diego-marcaccio-06431970/"><img src= https://img.shields.io/badge/Follow-m4rkh4ck-black> <a href= "https://www.linkedin.com/in/antonio-migliuolo-723598207/"><img src= https://img.shields.io/badge/Follow-synackid-white></h1>

## About ADFortressBreaker
The script has been written to help Ethical Hackers to execute the most common command in a Penetration Test in Active Directory environment without write any line of code.
It's written to leave as few traces as possible, so all the module will be loaded directly in memory to avoid defender interception.

## Usage
Import module and then launch it with Invoke-ADFortressBreaker.<br>
Before launching AdFortressBreaker it is necessary to bypass the AMSI control and powershell execution policy. After that user need to start a web server on port 8000 on his machine

![Screenshot_2023-10-17_113632](https://github.com/m4rkh4ck/ADFortressBreaker/assets/92309458/dd2e644b-48ed-45bb-9555-af8be53b35e5)

In the main menu the user can choose the activity to do simply by typing the corresponding number and pressing enter.

## Credits
To implement ADFortressBreaker we used the following tools: <br>
<a href= "https://github.com/PowerShellMafia/PowerSploit/blob/master/Recon/PowerView.ps1"> - Powerview.ps1</a> <br>
<a href= "https://github.com/PowerShellMafia/PowerSploit/blob/master/Privesc/PowerUp.ps1">- PowerUp.ps1</a> <br>
<a href= "https://github.com/BloodHoundAD/BloodHound/blob/master/Collectors/SharpHound.ps1">- SharpHound.ps1</a><br> 
<a href= "https://github.com/HarmJ0y/ASREPRoast/blob/master/ASREPRoast.ps1"> - ASREPRoast.ps1</a><br>
<a href= "https://github.com/PowerShellMafia/PowerSploit/blob/master/Exfiltration/Invoke-Mimikatz.ps1">- Invoke-Mimikatz.ps1</a><br> 
