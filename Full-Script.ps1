#This controls logging

$ErrorActionPreference = "Stop"

$logDir = "C:\Users\jcart285\OneDrive - Department of Education and Training\Powershell BYOX\Logs"

$timeStamp = Get-Date -Format "yyyyMMddHHmm"

$logFile = "PowerShell_transcript_$($timeStamp).txt"

Start-Transcript (Join-Path $logDir $logFile)

Add-Type -AssemblyName PresentationFramework

#==========================================================================================================================================================================================

#XAML to Powershell objects starts here

#==========================================================================================================================================================================================
 
$xaml = [xml] @"
<Window x:Name="Mainwindow"
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="BYOXWindow" Height="350" Width="525">
    <Grid x:Name="inner_window">
        <Image Name="ACSHS_Badge" Height="104" VerticalAlignment="Top" Margin="0,0,385,0" Source="C:\Users\jcart285\OneDrive - Department of Education and Training\Powershell BYOX\ACSHS_Badge.png"/>
        <TextBlock Name="Title" HorizontalAlignment="Left" Height="17" Margin="137,10,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="349" Text="Albany Creek State High School BYO Joiner" FontFamily="Arial" FontSize="16" FontWeight="Bold"/>
        <TextBlock Name="agreement" HorizontalAlignment="Left" Height="149" Margin="178,126,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="329" FontFamily="Arial" FontSize="8"><Run Text="BYOX Agreement"/><LineBreak/><Run/><LineBreak/><Run Text="All damages, breakages, loss and theft are the responsibility of the owner of the device."/><LineBreak/><Run/><LineBreak/><Run Text="Teachers can, at their discretion, temporarily confiscate the device from students"/><LineBreak/><Run/><LineBreak/><Run Text="The Principal, DP or HOD of IT may apply an extended ban or PERMANENT ban to the use of the device at the school"/><LineBreak/><Run/><LineBreak/><Run Text="IF the device has cellular capabilities, PARENTS retain responsibility for how the device is used."/><LineBreak/><Run/><LineBreak/><Run Text="Parents/Carers and students MUST present the BYO device passwords to the Principal, DP, HOD of IT when instructed to facilitate any investigation on the alleged or otherwise misuse of the BYO device."/><LineBreak/><Run/></TextBlock>
        <CheckBox Name="agreement_checkbox" Content="You agree to the T &amp; C's" HorizontalAlignment="Left" Height="20" Margin="178,280,0,0" VerticalAlignment="Top" Width="159" FontFamily="Arial" FontSize="8" VerticalContentAlignment="Center"/>
        <Label Name="username" Content="Username:" HorizontalAlignment="Left" Height="22" Margin="137,46,0,0" VerticalAlignment="Top" Width="69" FontFamily="Arial"/>
        <TextBox Name="username_enter" HorizontalAlignment="Left" Height="18" Margin="211,50,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="102" FontFamily="Arial"/>
        <Label Name="password" Content="Password:" HorizontalAlignment="Left" Height="25" Margin="137,73,0,0" VerticalAlignment="Top" Width="69" FontFamily="Arial"/>
        <PasswordBox Name="password_field" HorizontalAlignment="Left" Height="18" Margin="211,73,0,0" VerticalAlignment="Top" Width="102"/>
        <CheckBox Name="map_all_drive" Content="Map All Drives" HorizontalAlignment="Left" Height="17" Margin="24,155,0,0" VerticalAlignment="Top" Width="97" FontFamily="Arial" IsChecked="False"/>
        <Label Name="drive_label" Content="Drives to be Mapped:" HorizontalAlignment="Left" Height="24" Margin="10,126,0,0" VerticalAlignment="Top" Width="180" FontFamily="Arial"/>
        <CheckBox Name="g_drive" Content="G Drive" HorizontalAlignment="Left" Height="17" Margin="45,177,0,0" VerticalAlignment="Top" Width="97" FontFamily="Arial"/>
        <CheckBox Name="h_drive" Content="H Drive" HorizontalAlignment="Left" Height="17" Margin="45,194,0,0" VerticalAlignment="Top" Width="97" FontFamily="Arial"/>
        <CheckBox Name="install_drive" Content="Install Drive" HorizontalAlignment="Left" Height="17" Margin="45,211,0,0" VerticalAlignment="Top" Width="97" FontFamily="Arial"/>
        <CheckBox Name="submission_drive" Content="Submission Drive" HorizontalAlignment="Left" Height="17" Margin="45,228,0,0" VerticalAlignment="Top" Width="119" FontFamily="Arial"/>
        <Label Name="printing_label" Content="Install Printing (PaperCut)" HorizontalAlignment="Left" Height="30" Margin="10,245,0,0" VerticalAlignment="Top" Width="154" FontFamily="Arial"/>
        <CheckBox Name="printing_checkbox" Content="PaperCut" HorizontalAlignment="Left" Height="17" Margin="24,270,0,0" VerticalAlignment="Top" Width="97" FontFamily="Arial"/>
        <Button Name="continue_button" Content="JOIN!" HorizontalAlignment="Left" Height="45" Margin="370,46,0,0" VerticalAlignment="Top" Width="93" FontSize="16" FontFamily="Arial" FontWeight="Bold"/>

    </Grid>
</Window>
"@
 
$reader = New-Object System.Xml.XmlNodeReader $xaml
$form = [Windows.Markup.XamlReader]::Load($reader)
 
$xaml.SelectNodes("//*[@Name]") | %{Set-Variable -Name "WPF$($_.Name)" -Value $Form.FindName($_.Name)}
 
Function Get-FormVariables{
    if ($global:ReadmeDisplay -ne $true){Write-host "If you need to reference this display again, run Get-FormVariables" -ForegroundColor Yellow;$global:ReadmeDisplay=$true}
    write-host "Found the following interactable elements from our form" -ForegroundColor Cyan
    get-variable WPF*
}
 
Get-FormVariables

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

#===================================================================================================================================================================================

#Map Network Drive Scripting

#===================================================================================================================================================================================

Function Connect-Drives {
	$user = $WPFusername_enter.Text
	$pass = $WPFpassword_field.Password

	$WPFmap_all_drive.Add_Checked({
		NET USE H: \\10.56.12.3\$user /USER:GBN\$user $pass /persistent:yes
		NET USE G: \\10.56.12.1\Data\Curriculum /USER:GBN\$user $pass /persistent:yes
		NET USE X: \\10.56.12.3\SHARED /USER:GBN\$user $pass /persistent:yes
		NET USE I: \\10.56.12.3\Data\Curriculum\Common /USER:GBN\$user $pass /persistent:yes
	})

	$WPFg_drive.Add_Checked({
		NET USE G: \\10.56.12.1\Data\Curriculum /USER:GBN\$user $pass /persistent:yes
	})

	$WPFh_drive.Add_Checked({
		NET USE H: \\10.56.12.3\$user /USER:GBN\$user $pass /persistent:yes
	})

	$WPFinstall_drive.Add_Checled({
		NET USE I: \\10.56.12.3\Data\Curriculum\Common /USER:GBN\$user $pass /persistent:yes
	})

	$WPFsubmission_drive.Add_Checked({
		NET USE X: \\10.56.12.3\SHARED /USER:GBN\$user $pass /persistent:yes
	})
}

#===================================================================================================================================================================================

#Printer Stuff

#===================================================================================================================================================================================

Function Connect-Printer {
	$user = $WPFusername_enter.Text
	$pass = $WPFpassword_field.Password

	$WPFprinting_checkbox.Add_Checked({
	NET USE \\10.56.12.2\Follow-You /USER:$user $pass
	Start-Process -FilePath \\10.56.12.2\Follow-You
	Start-Process -FilePath \\10.56.12.2\PCClient\win\client-local-install.exe --silent
	})
}

#===================================================================================================================================================================================

#GUI Stuff

#===================================================================================================================================================================================

$WPFagreement_checkbox.Add_Checked({
	$WPFcontinue_button.Add_Click({
		Connect-FullWlan
		Connect-Drives
		Connect-Printer
	})
})

#===================================================================================================================================================================================

#Displays The GUI

#===================================================================================================================================================================================

$Form.WindowStartupLocation = "CenterScreen"
$Form.ShowDialog() | out-null



Stop-Transcript
