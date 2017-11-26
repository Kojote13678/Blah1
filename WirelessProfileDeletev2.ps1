﻿$ErrorActionPreference = "Stop"

$logDir = "C:\Users\jcart285\OneDrive - Department of Education and Training\Powershell BYOX\Logs"

$timeStamp = Get-Date -Format "yyyyMMddHHmm"

$logFile = "PowerShell_transcript_$($timeStamp).txt"

Start-Transcript (Join-Path $logDir $logFile)

$IsAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
if (-not($IsAdmin)){
        throw "Current User has no administrative rights. Restart scripts as Administrator."
}

function Get-WlanProfiles {
    $wlans = netsh wlan show profiles | Write-Host

    $wlans | Select-String '\siDET'
    $wlans | Select-String '\sQDETA-X'

    Write-Host ""
    Write-Host ""
    Write-Host ""
}

function Delete-WlanProfiles {
    $wlans = netsh wlan show profiles
    if ($wlans | Select-String '\siDET') {
        netsh wlan delete profile name = "iDET" 
    } else {
        Write-Output 'iDET does not exist'
    }

    if ($wlans | Select-String '\sQDETA-X') {
        netsh wlan delete profile name = "QDETA-X"
    } else {
        Write-Output 'QDETA-X does not exist'
    }

    $wlans | Write-Host
    
    Write-Host ""
    Write-Host ""
    Write-Host ""
}

function Add-WlanProfiles {
    $wlans = netsh wlan show profiles

    if (-not($wlans | Select-String '\siDET')) {
        netsh wlan add profile filename="C:\Users\jcart285\OneDrive - Department of Education and Training\Powershell BYOX\iDET.xml" user=Current
    } else {
        Write-Output 'iDET exists, Delete_WlanProfiles did not run correctly.'
        Break
        Start-Sleep -Seconds 5
    }
    
    if (-not($wlans | Select-String '\sQDETA-X')) {
        netsh wlan add profile filename="C:\Users\jcart285\OneDrive - Department of Education and Training\Powershell BYOX\QDETA-X.xml" user=Current
    } else {
        Write-Output 'QDETA-X exists, Delete_WlanProfiles did not run correctly.'
        Break
        Start-Sleep -Seconds 5
    } 

    Write-Host ""
    Write-Host ""
}

Get-WlanProfiles
Start-Sleep -Seconds 3

Delete-WlanProfiles
Start-Sleep -Seconds 3

Add-WlanProfiles
Start-Sleep -Seconds 3

netsh wlan show profiles

Stop-Transcript