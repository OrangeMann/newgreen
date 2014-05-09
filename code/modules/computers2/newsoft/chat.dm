/////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////// Chat /////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////
/datum/file/software/app/chat
	name = "Station Chat"
	size = 2
	display_icon = "solar"
	var/saved_text = ""
	var/datum/address/host = null

	OnStart()
		var/list/req = list()
		var/datum/connectdata/self = GlobalAddress()
		req["message"] = self.ToString() + " connected as [M.User()] ([M.Assignment()])"
		req["user"] = "System"
		req["soft_type"] = type
		M.connector.SendSignal(null, self, req)

	Display()
		var/t = "Station Chat"
		t += "<textarea rows='10' readonly>" + saved_text + "</textarea>"
		t += {"
		<form name="ChatInput" action="byond://" method="get">
			<input type="hidden" name="src" value="\ref[src]" />
			<input type="text" name="new_message" size="15" />
			<input type="submit" value="Send"/>
		</form>
		"}
		return t

	Request(var/datum/connectdata/sender, var/list/data)
		if(data["message"] && data["user"])
			if(data["soft_type"] != src.type) return
			if(data["user"] == "unknown") return
			NewMessage(data["message"], data["user"])

	Topic(href, href_list)
		if(..()) return
		if(href_list["new_message"])
			if(M.User() == "unknown")
				NewMessage("Access denied. Please login", "System")
			else
				NewMessage(href_list["new_message"], M.auth.username)
				var/list/req = list()
				req["message"] = href_list["new_message"]
				req["soft_type"] = type
				req["user"] = M.User()
				M.connector.SendSignal(null, GlobalAddress(), req)
		updateUsrDialog()

	Requirements()
		if(M.AuthTrouble() || !M.auth.logged)
			return "Access denied. Please log in."
		if(!M.connector)
			return "Failed to connect station network!"
		return 0

	proc/NewMessage(var/text, var/user)
		saved_text += "\n<" + user + "> " + text