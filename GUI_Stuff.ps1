﻿#===================================================================================================================================================================================

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