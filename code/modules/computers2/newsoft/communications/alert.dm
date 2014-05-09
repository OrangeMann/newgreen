/datum/file/software/app/osnt/secure/alert
	name = "Security Level Control"
	display_icon = "comm"
	required_access = list(access_heads)
	size = 4

/datum/file/software/app/osnt/secure/alert/Display()
	var/t ="<div style='padding: 3px 22px 3px 8px;' class='block' align='center'>"
	t += "Current Security Level:<br>"
	switch(security_level)
		if(SEC_LEVEL_GREEN)
			t += "<font color='green'>Code Green</font><br>[config.alert_desc_green]</font>"
			t += "<A href='?src=\ref[src];alert=[SEC_LEVEL_BLUE]'>Declare Code Blue</A>"
		if(SEC_LEVEL_BLUE)
			t += "<font color='blue'>Code Blue</font><br>[config.alert_desc_blue_upto]</font>"
			t += "<A href='?src=\ref[src];alert=[SEC_LEVEL_GREEN]'>Declare Code Green</A>"
		if(SEC_LEVEL_RED)
			t += "<font color='red'>Code Red</font><br>[config.alert_desc_red_upto]</font>"
			t += "<A href='?src=\ref[src];alert=[SEC_LEVEL_BLUE]'>Declare Code Blue</A>"
			t += "<A href='?src=\ref[src];alert=[SEC_LEVEL_GREEN]'>Declare Code Green</A>"
		if(SEC_LEVEL_DELTA)
			t += "<font color='red'><b>Code Delta</b><br>[config.alert_desc_delta]</font>"
	t += "</div>"
	return t

/datum/file/software/app/osnt/secure/alert/Topic(href, href_list)
	if(..()) return

	if(href_list["alert"])
		var/new_level = text2num(href_list["alert"])
		if((new_level == SEC_LEVEL_DELTA) || (security_level == SEC_LEVEL_DELTA) || (new_level == security_level))
			return
		set_security_level(new_level)
		log_game("[key_name(usr)] has changed the security level to [get_security_level()].")
		message_admins("[key_name_admin(usr)] has changed the security level to [get_security_level()].")
		switch(security_level)
			if(SEC_LEVEL_GREEN)
				feedback_inc("alert_comms_green",1)
			if(SEC_LEVEL_BLUE)
				feedback_inc("alert_comms_blue",1)

	updateUsrDialog()