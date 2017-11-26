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