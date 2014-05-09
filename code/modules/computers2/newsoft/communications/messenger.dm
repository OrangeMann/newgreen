/datum/file/software/app/osnt/secure/centcomm_messenger
	name = "Centcomm Messenger"
	display_icon = "comm"
	required_access = list(access_heads)
	size = 12 // Encryption keys are big!

	var/centcomm_message_cooldown = 0
	// Temp before this var is moved to special hardware.
	// Can be easily avoided by using 2+ copies of messenger.
	var/screen = "menu"
	var/syndie_messaging = 0
	var/datum/file/centcomm_message/currmsg


/datum/file/software/app/osnt/secure/centcomm_messenger/OnStart()
	..()
	screen = "menu"

/datum/file/software/app/osnt/secure/centcomm_messenger/Display()
	var/t
	switch(screen)
		if("menu")
			t += "QuanTech Secure Messenger v4.1"
			t += "<A href='?src=\ref[src];screen=messages'>View messages</A>"
			t += "<A href='?src=\ref[src];screen=send'>Send an emergency message to Centcomm</A>"
			t += "<hr>"
		if("send")
			if(centcomm_message_cooldown)
				t += "Message transmitted.<br>"
				t += "Arrays recycling. Please stand by."
			else
				if(!syndie_messaging)
					t += "Please choose a message to transmit to Centcomm via bluespace supercrystal. "
				else
					t += "Please choose a message to transmit to \[ABNORMAL ROUTING CORDINATES\] via bluespace supercrystal. "
				t += "Be aware that this process is very expensive, and abuse will lead to... termination. "
				t += "Transmission does not guarantee a response. "
				t += "There is a delay before you may send another message, be clear, full and concise. "
				t += {"<BR>
				<form name="textfield" action="byond://" method="get">
					<input type="hidden" name="src" value="\ref[src]" />
					<textarea name="send_message" rows="6" cols="30"></textarea><BR>
					<input type="submit" value="Send"/>
				</form>
				"}
			t += "<hr><A href='?src=\ref[src];screen=menu'>Back</A>"
		if("messages")
			t += "Messages:"
			for(var/datum/file/centcomm_message/I in M.GetAllData())
				t += "<A href='?src=\ref[src];viewmessage=\ref[I]'>[I.name]</A>"
			t += "<hr><A href='?src=\ref[src];screen=menu'>Back</A>"
		if("messageview")
			if(currmsg)
				t += "<h3>[currmsg.name]</h3>[currmsg.content]"
				t += "<hr><A href='?src=\ref[src];screen=messages'>Back</A>"
			else
				screen = "messages"
				updateUsrDialog()
				return
	return t

/datum/file/software/app/osnt/secure/centcomm_messenger/Topic(href, href_list)
	if(..()) return

	if(href_list["screen"])
		screen = href_list["screen"]

	else if(href_list["viewmessage"])
		if(locate(href_list["viewmessage"]) in M.GetAllData())
			currmsg = locate(href_list["viewmessage"])
			screen = "messageview"

	else if(href_list["send_message"])
		if(centcomm_message_cooldown || !Auth())
			updateUsrDialog()
			return
		var/message = strip_html_simple(href_list["send_message"], 500)
		if(!syndie_messaging)
			Centcomm_announce(message, usr)
			log_say("[key_name(usr)] has sent a message to Centcomm: [message]")
		else
			Syndicate_announce(message, usr)
			log_say("[key_name(usr)] has sent a message to Syndicate: [message]")

		centcomm_message_cooldown = 1
		spawn(1200)//10 minute cooldown
			centcomm_message_cooldown = 0
	updateUsrDialog()


/datum/file/software/app/osnt/secure/centcomm_messenger/Copy()
	var/datum/file/software/app/osnt/secure/centcomm_messenger/C = ..()
	C.syndie_messaging = syndie_messaging
	return C

/datum/file/centcomm_message
	name = "Centcomm Message"
	size = 2
	var/content = ""

	GetName()
		return ("msg_" + copytext(name,1,5) + ".qtsm")

	Copy()
		var/datum/file/centcomm_message/S = ..()
		S.content = content
		return S

/datum/file/centcomm_message/test
	name = "Test"
	content = "HONK HONK HONK<br>HONK HONK HONK"