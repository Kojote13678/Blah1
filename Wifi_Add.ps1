#=========================================================================================================================================================================================

#Wifi Add/Delete scripting Starts Here

#=========================================================================================================================================================================================

Function Get-WlanProfiles {
    $wlans = netsh wlan show profiles

    $wlans | Select-String '\siDET'
    $wlans | Select-String '\sQDETA-X'

	Write-Host ""
	Write-Host ""
	Write-Host ""
}

Function Delete-WlanProfiles {
	$wlans = netsh wlan show profiles
	if ($wlans | Select-String '\siDET') {
		netsh wlan delete profile name = "iDET"
	} else {
		Write-Output 'iDET does not exist or has already been deleted'
	}

	if ($wlans | Select-String '\sQDETA-X') {
		netsh wlan delete profile name = "QDETA-X"
	} else {
		Write-Output 'QDETA-X does not exist or has already been deleted'
	}

	$wlans | Write-Host

	Write-Host ""
	Write-Host ""
	Write-Host ""
}

Function Add-WlanProfiles {
	$wlans = netsh wlan show profiles

	if (-not($wlans | Select-String '\siDET')) {
		netsh wlan add profile filename="C:\Users\jcart285\OneDrive - Department of Education and Training\Powershell BYOX\WirelessProfileDelete\iDET.xml" user=Current
	} else {
		Write-Output 'iDET Exists, Delete-WlanProfiles did not run correctly.'
		Break
	}

	if (-not($wlans | Select-String '\sQDETA-X')) {
		netsh wlan add profile filename="C:\Users\jcart285\OneDrive - Department of Education and Training\Powershell BYOX\WirelessProfileDelete\QDETA-X.xml" user=Current
	}

	$wlans | Write-Host

	Write-Host ""
	Write-Host ""
	Write-Host ""
}

Function Connect-WlanProfiles {
	$wlans = netsh wlan show profiles

	try {
		netsh wlan connect name=iDET
	}
	catch {
		Write-Output "Could not connect to iDET"
		netsh wlan connect name=QDETA-X
	}

}

Function Connect-FullWlan {
		Get-WlanProfiles
		Delete-WlanProfiles
		Add-WlanProfiles
		Connect-WlanProfiles
}