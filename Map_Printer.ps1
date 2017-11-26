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