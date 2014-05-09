/datum/file/software/app/statusscreen
	name = "Status Screen Control"
	var/msg1 = ""
	var/msg2 = ""
	size = 2

/datum/file/software/app/statusscreen/Display()
	var/t = "Set Status Screens:"
	t += "<A href='?src=\ref[src];statdisp=blank'>Clear</A>"
	t += "<A href='?src=\ref[src];statdisp=shuttle'>Shuttle ETA</A>"
	t += "<A href='?src=\ref[src];statdisp=alert;alert=default'>NT logo</A>"
	t += "<A href='?src=\ref[src];statdisp=alert;alert=redalert'>Red Alert</A>"
	t += "<A href='?src=\ref[src];statdisp=alert;alert=lockdown'>Lockdown</A>"
	t += "<A href='?src=\ref[src];statdisp=alert;alert=biohazard'>Biohazard</A>"
	t += {"
	<form name="textfield" action="byond://" method="get">
		<input type="hidden" name="src" value="\ref[src]"/>
		<input type="hidden" name="statdisp" value="message"/>
		<input type="text" name="msg1" value="[msg1]"/>
		<input type="text" name="msg2" value="[msg2]"/>
		<input type="submit" value="Message"/>
	</form>
	"}
	t += "<hr>"
	return t

/datum/file/software/app/statusscreen/Topic(href, href_list)
	if(..()) return
	if(M.NetworkTrouble()) return
	var/obj/item/weapon/hardware/wireless/connector = M.connector

	switch(href_list["statdisp"])
		if("message")
			msg1 = href_list["msg1"]
			msg2 = href_list["msg2"]
			connector.post_status("message", msg1, msg2)
		if("alert")
			connector.post_status("alert", href_list["alert"])
		else
			connector.post_status(href_list["statdisp"])

/datum/file/software/app/statusscreen/Requirements()
	if(M.NetworkTrouble())	return "Error! No network controller found!"
	return ..()