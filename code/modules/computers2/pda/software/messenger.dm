// Messenger
/datum/file/software/app/messenger
	name = "Messenger"
	size = 2
	display_icon = "solar"

	var/page = "main"
	var/list/clients = list()
	var/visible = 1
	var/ringer = "beep"
	var/ringer_on = 1
	var/datum/connectdata/target

	var/list/logs = list()
	var/log = ""

	OnStart()
		..()
		page = "main"

	Display()
		var/t = "<h4>SpaceMessenger v4.2.1</h4>"
		t += "<div class='block'>"
		switch(page)
			if("main")
				t += "<A href='?src=\ref[src];log=1'>View message logs</A>"
				t += "<br>Send message to:"
				UpdateClients()
				for(var/i in clients)
					t += "<A href='?src=\ref[src];setmessage=\ref[clients[i]]'>[i]</A>"
				t += "<br>"
			if("msg")
				t += "<b>Send message to: </b>"
				var/name
				for(var/i in clients)
					if(clients[i] == target)
						name = i
						break
				t += name ? name : "#unkn"
				t += {"
				<form name="input" action="byond://" method="get">
					<input type="hidden" name="src" value="\ref[src]" />
					<input type="text" name="new_message" size="15" />
					<input type="submit" value="Send"/>
				</form>
				"}
				t += "<A href='?src=\ref[src];back=1'>Back</A>"
			if("log")
				if(log && logs[log])
					t += "<b>Message log: [log]</b><br>"
					t += logs[log]
				else
					t += "<b>Message logs:</b>"
					for(var/i in logs)
						t += "<A href='?src=\ref[src];log=[i]'>[i]</A>"
				t += "<br>"
				t += "<A href='?src=\ref[src];back=1'>Back</A>"
		t += "</div>"
		return t

	Request(var/datum/connectdata/sender, var/list/data)
		if(data["soft_type"] != src.type)	 	return
		if(M.AuthTrouble() || !M.auth.logged)	return

		if(data["add"])
			clients[data["name"]] = sender

		if(visible)
			if(data["ping"])
				var/list/resp = list(name = Username(), soft_type = type, add = 1)
				M.connector.SendSignal(sender, GlobalAddress(), resp)

			if(data["message"] && data["name"])
				GetMessage(strip_html(data["message"]), strip_html(data["name"]))

	Topic(href, href_list)
		if(..()) return
		if(href_list["setmessage"])
			page = "msg"
			target = locate(href_list["setmessage"])

		if(href_list["log"])
			page = "log"
			if(logs[href_list["log"]])
				log = href_list["log"]

		if(href_list["back"])
			if(page == "log" && log && logs[log])
				log = ""
			else
				page = "main"

		if(href_list["ringer_on"])
			ringer_on = !ringer_on

		if(href_list["visible"])
			visible = !visible

		if(href_list["new_message"])
			var/list/req = list()
			req["message"] = strip_html(href_list["new_message"])
			req["soft_type"] = type
			req["name"] = Username()
			M.connector.SendSignal(target, GlobalAddress(), req)
			SendMessage(req["message"])
			page = "main"

		updateUsrDialog()

	Requirements()
		if(M.AuthTrouble() || !M.auth.logged)
			return "Access denied. Please log in."
		if(!M.connector)
			return "Failed to connect station network!"
		return 0

	proc/UpdateClients()
		clients = list()
		M.connector.SendSignal(null, GlobalAddress(), list(ping = 1, soft_type = type))

	proc/Username()
		return "[M.User()] ([M.Assignment()])"

	proc/GetMessage(var/text, var/user)
		var/text2 = "<b>[user] &gt; [Username()]:</b>"
		text2 += "<br>"
		text2 += text
		WriteLog(text2, user)

	proc/SendMessage(var/text)
		var/user
		for(var/i in clients)
			if(clients[i] == target)
				user = i
				break
		user = user ? user : "#unkn"
		var/text2 = "<b>[Username()] &gt; [user]:</b>"
		text2 += "<br>"
		text2 += text
		WriteLog(text2, user)

	proc/WriteLog(var/text, var/user)
		text = text + "<br><br>"

		if(logs[user])
			text = text + logs[user]
			logs.Remove(user)

		var/list/logs2 = list()
		logs2[user] = text
		logs2.Add(logs)
		logs = logs2