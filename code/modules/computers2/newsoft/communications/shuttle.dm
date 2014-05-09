/datum/file/software/app/osnt/secure/shuttle
	name = "Shuttle Control"
	display_icon = "comm"
	required_access = list(access_heads)
	size = 8
	var/confirmation = 0


/datum/file/software/app/osnt/secure/shuttle/Display()
	var/t
	if(confirmation)
		if(emergency_shuttle.location == 0)
			if(emergency_shuttle.online)
				t += "Are you sure you want to abort the shuttle launch?"
			else
				t += "Are you sure you want to launch the shuttle?"
			t += "<A href='?src=\ref[src];launch=1'>OK</A>"
			t += "<A href='?src=\ref[src];confirm=1'>Back</A>"

		else
			confirmation = 0
			updateUsrDialog()
		t += ""
		t += ""
	else
		t += "Shuttle Status<br><br>"
		t += "Location: "
		if(emergency_shuttle.location == 0)
			t += "Space"
			if(emergency_shuttle.online)
				t += "<br>ETA: [get_shuttle_timer()]"
				if(emergency_shuttle.direction != -1)
					t += "<A href='?src=\ref[src];confirm=1'>Abort</A>"
			else
				t += "<A href='?src=\ref[src];confirm=1'>Launch</A>"
		else if(emergency_shuttle.location == 1)
			t += "Station<br>"
			t += "ETD: [get_shuttle_timer()]<br>"

		else
			t += "Centcomm<br>"
		if(emergency_shuttle.online)
			t += "Destination: "
			switch(emergency_shuttle.direction)
				if(-1) t += "Centcomm"
				if(1) t += "Station"
				if(2) t += "Centcomm"
	t += "<hr>"
	return t


/datum/file/software/app/osnt/secure/shuttle/Topic(href, href_list)
	if(..()) return
	if(M.NetworkTrouble()) return

	if(href_list["confirm"])
		confirmation = !confirmation
	if(href_list["launch"])
		if(emergency_shuttle.location == 0)
			if(emergency_shuttle.online)
				cancel_call_proc(usr)
			else
				var/obj/item/weapon/hardware/wireless/connector = M.connector
				call_shuttle_proc(usr)
				if(emergency_shuttle.online)
					connector.post_status("shuttle")
		confirmation = 0

	updateUsrDialog()


/datum/file/software/app/osnt/secure/shuttle/proc/get_shuttle_timer()
	var/timeleft = emergency_shuttle.timeleft()
	if(timeleft)
		return "[add_zero(num2text((timeleft / 60) % 60),2)]:[add_zero(num2text(timeleft % 60), 2)]"
	return ""

/datum/file/software/app/osnt/secure/shuttle/Requirements()
	if(M.NetworkTrouble())	return "Error! No network controller found!"
	return ..()