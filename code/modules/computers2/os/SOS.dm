/datum/file/software/os/sos // Standard/Station Operation System by KawaiiDesu
	name = "SOS"
	size = 10
	display_icon = "ai-fixer"
	var/current_state = "mainscreen"
	var/sysmessage = ""
	var/datum/file/software/app/current_prog

	Display(var/mob/user)
		var/t = Header()
		if(current_prog)
			t +=  current_prog.Display()
		else
			switch(current_state)
				if("mainscreen")
					t += "Welcome to Standard Operation System (SOS)<BR>"
					t += "<A href='?src=\ref[src];setstate=filemanager'>Launch filemanager</A><BR>"
					t += "------<BR>"
					for(var/datum/file/software/app/app in M.GetAllData())
						t += "<A href='?src=\ref[src];runapp=\ref[app]'>[app.GetName()]</A><BR>"
				if("filemanager")
					var/rstate = M.ReaderTrouble()

					t += "Welcome to SOS File Manager."// <A href='?src=\ref[src];setstate=mainscreen'>Return to main menu</A><BR>"
					t += "You have [M.hdd.Space()] memory.<BR>"
					t += "Installed programs is:<BR>"
					for(var/datum/file/software/os/soft in M.Data())
						t += "[soft.GetName()]<BR>"
					t += "------<BR>"
					for(var/datum/file/software/app/soft in M.Data())
						if(!rstate && !M.reader.disk.InstallationTrouble(soft))
							t += "<A href='?src=\ref[M];diskwriteon=\ref[soft]'>(C)</A>"
						else
							t += "(C)"
						t += "<A href='?src=\ref[M];hddremove=\ref[soft]'>(R)</A>"
						t += "[soft.GetName()]<BR>"
					t += "------<BR>"

					//Disk
					if(rstate == 1)
						t += "Datadriver is not found<BR>"
					else if(rstate == 2)
						t += "Please insert disk<BR>"
					else if(!rstate)
						t += "Disk have [M.reader.disk.Space()] memory<BR>"
						t += "Files on disk<BR>"
						for(var/datum/file/software/soft in M.reader.disk.data)
							if(!M.hdd.InstallationTrouble(soft))
								t += "<A href='?src=\ref[M];hddwriteon=\ref[soft]'>(C)</A>"
							else
								t += "(C)"
							t += "<A href='?src=\ref[M];diskremove=\ref[soft]'>(R)</A>"
							t += "[soft.name]<BR>"
				/*if("sharescreen") MADNESS! NEVER UNCOMMENT THAT!
					if(connections.len > 0)
						for(var/datum/netconnection/con in connections)
							t += "SHARED SCREEN! <BR>"
							t += con.node.soft.Display(user)
							break
					else
						t += "<A href='?src=\ref[src];testsignal=1'>TEST</A><BR>"*/

		return t + Footer()

	Topic(href, href_list)
		if(href_list["setstate"])
			current_state = href_list["setstate"]

		else if(href_list["runapp"])
			var/s = locate(href_list["runapp"])
			if(istype(s, /datum/file/software/app) && (s in M.GetAllData()))
				Run(s)

		else if(href_list["closeapp"])
			Close()

		updateUsrDialog()



		//<script language="javascript">
		//function send(type, value)
		//{
		//	window.location="byond://?src=\ref[src]&"type"="value";
		//}
		//</script>

	proc/Header()
		var/text = {"
		<html><head>
		<style type='text/css'>
		html{overflow: hidden;}
		.prog{width:[M.screen.width -220]px;heigth:[M.screen.heigth -20]px;float:left;}
		.sys{width:200px;height:[M.screen.heigth -20]px;float:right;background:#ccc;position:absolute;top:0px;left:[M.screen.width - 220]px;}
		</style>
		</head><body><div class='prog'>
		"}
		return text

	proc/Footer()
		var/text = "</div><div class='sys'>"
		if(M.auth)
			if(M.auth.logged)
				text += {"
				Logged in as [M.User()]<BR>
				[M.Assignment()]<BR>
				<A href='?src=\ref[M];logout=1'>Logout</A><BR>
				"}
			else
				text += "Please <A href='?src=\ref[M];login=1'>login</A><BR>"
			if(M.auth.id)
				text += "<A href='?src=\ref[M];ejectid=1'>Eject ID</A><BR>"
/*		if(!M.ReaderTrouble())
			text += "<A href='?src=\ref[M];ejectdisk=1'>Eject Disk</A><BR>"*/
		if(current_prog || current_state != "mainscreen")
			text += "<A href='?src=\ref[src];closeapp=1'>Exit to main menu</A><BR>"
		text += "------<BR>"
		for(var/i = 1; i <= 5; i++)
			text += lastlogs[i] + "<BR>"
		text += "</div></body></html>"
		return text

	GetIconName()
		if(current_prog)
			return current_prog.display_icon
		return display_icon

	Request(var/datum/connectdata/sender, var/list/data)
		..()

	Run(var/datum/file/software/app/soft)
		Close()
		if(soft.Requirements()) return
		if(soft.required_sys && !istype(src, soft.required_sys)) return
		current_prog = soft
		current_prog.OnStart()
		M.update_icon()

	Close()
		if(!current_prog)
			current_state = "mainscreen"
		else
			current_prog.OnExit()
			current_prog = null
			M.update_icon()