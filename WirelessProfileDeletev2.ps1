$ErrorActionPreference = "Stop"

$logDir = "C:\Users\jcart285\Documents"

$timeStamp = Get-Date -Format "yyyyMMddHHmm"

$logFile = "PowerShell_transcript_$($timeStamp).txt"

Start-Transcript (Join-Path $logDir $logFile)

function Get-WlanProfiles {
$wlans = netsh wlan show profiles

$wlans | Select-String '\sIDET'
$wlans | Select-String '\sQDETA-X'
}

Stop-Transcript