/datum/file/software/app/osnt/secure/announcer
	name = "Station Announcer"
	display_icon = "comm"
	required_access = list(access_captain)
	size = 8
	var/message_cooldown = 0

/datum/file/software/app/osnt/secure/announcer/Display()
	var/t = "Station Announcer"
	t += {"
	<form name="textfield" action="byond://" method="get">
		<input type="hidden" name="src" value="\ref[src]" />
		<input type="text" name="announce"/>
		<input type="submit" value="Make An Announcement"/>
	</form>
	<hr>"}
	return t

/datum/file/software/app/osnt/secure/announcer/Topic(href, href_list)
	if(..()) return

	if(href_list["announce"] && !message_cooldown)
		var/input = strip_html_simple(href_list["announce"], MAX_MESSAGE_LEN)
		captain_announce(input)
		log_say("[key_name(usr)] has made a captain announcement: [input]")
		message_admins("[key_name_admin(usr)] has made a captain announcement.", 1)
		message_cooldown = 1
		spawn(600) // One minute cooldown
			message_cooldown = 0