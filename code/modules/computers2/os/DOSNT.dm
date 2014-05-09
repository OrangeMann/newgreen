/datum/file/software/os/osnt // OS NT by ACCount12
	name = "OS NT"
	size = 14
	display_icon = "command"
	var/current_state = "fileman"
	var/datum/file/software/app/current_prog
	var/datum/file/current_file
	var/waiting_file = null
	var/waiting_file_type = /datum/file
	var/waiting_disk = null
	var/datum/file/software/app/autorun = null

	var/password = ""
	var/message = ""

	Connect(var/obj/machinery/newComputer/M)
		..()

	HardwareChange()
		..()
		if(current_prog && !(current_prog in M.GetAllData()))
			Close()
		if(current_file && !(current_file in M.GetAllData()))
			current_file = null

	OnStart()
		..()
		if(password)
			current_state = "password"
		else
			current_state = "fileman"
		if(message)
			message = ""
		if(autorun)
			Run(autorun)

	Display(var/mob/user)
		if(!current_disk)
			current_disk = M.sysdisk
		if(!current_disk)
			M.BSOD()

		var/specialcss = GetStyle()
		var/t = Header()

		if(message)
			t += "<hr>"
			t += message
		else if(waiting_disk)
			t += DiskList(waiting_disk)
		else if(waiting_file)
			t += FileList(waiting_file)
		else if(current_prog)
			t += "<hr>"
			t += current_prog.Display()
			t += "<A href='?src=\ref[src];closeapp=1'>Close</A>"
		else switch(current_state)
			if("fileman")
				t += "<hr>"
				t += FileList()
			if("disks")
				t += "<hr>"
				t += DiskList()
			if("password")
				t += "Enter Password:"
				t += {"
				<form name="textfield" action="byond://" method="get">
					<input type="hidden" name="src" value="\ref[src]"/>
					<input type="password" name="password" value=""/>
					<input type="submit" value="Enter"/>
				</form>"}
			/*if("sharescreen") MADNESS! NEVER UNCOMMENT THAT!
				if(connections.len > 0)
					for(var/datum/netconnection/con in connections)
						t += "SHARED SCREEN! <BR>"
						t += con.node.soft.Display(user)
						break
				else
					t += "<A href='?src=\ref[src];testsignal=1'>TEST</A><BR>"*/

		return M.ComputerHtml("OS NT", t, 1, specialcss)

	Topic(href, href_list)
		if(!M)	return

		if(href_list["messagehide"])
			message = ""

		if(href_list["password"])
			if(href_list["password"] == password)
				current_state = "fileman"

		else if(href_list["setstate"])
			current_state = href_list["setstate"]

		else if(href_list["file"] && href_list["sendto"] && current_prog)
			var/datum/file/F = locate(href_list["file"])
			if(F in M.GetAllData())
				current_prog.RecvFile(F, href_list["sendto"])

			waiting_file = ""
			waiting_file_type = /datum/file

		else if(href_list["disk"])
			var/obj/item/weapon/hardware/memory/MM = M.LocateDisk(href_list["disk"])
			if(MM)
				if(href_list["sendto"] == "copy" && current_file)
					MM.WriteOn(current_file)
					current_file = null
					waiting_disk = ""

				else if(href_list["sendto"] && current_prog)
					current_prog.RecvDisk(MM, href_list["sendto"])
					waiting_disk = ""
				else
					current_disk = MM
					current_state = "fileman"

		else if(href_list["runapp"] && !current_prog)
			Run(locate(href_list["runapp"]))

		else if(href_list["closeapp"])
			Close()

		else if(href_list["copy"])
			if(locate(href_list["file"]) in M.GetAllData())
				current_file = locate(href_list["file"])
				waiting_disk = "copy"

		updateUsrDialog()

	proc/GetStyle()
		var/css = {".file{display: inline-block; width: 55%; float:left; border: 1px solid #000000; padding: 1px 6px 1px 6px;}
.fileOff{display: inline-block; width: 55%; float:left; border: 1px solid #000000; padding: 1px 6px 1px 6px;}
.mini{display: inline-block; width: 22px; float:left; border: 1px solid #000000; padding: 1px 6px 1px 6px;}
.miniOff{display: inline-block; width: 22px; float:left; border: 1px solid #000000; width: 20%; padding: 1px 6px 1px 6px;}
.miniOff:hover, .fileOff:hover{border: 1px solid #B3B3B3; background: #000000; color: #B3B3B3;}
"}
		return css

	proc/Header()
		var/text
		if(M.auth)
			if(M.auth.logged)
				text += "<A href='?src=\ref[M];logout=1'>Logged in as: [M.User()] ([M.Assignment()])</A>"
			else
				text += "<A href='?src=\ref[M];login=1'>Not logged in</A>"
		if(password)
			text += "<A href='?src=\ref[src];lockpass=1'>Lock computer</A>"

		return text

	proc/FileList(var/sendtoapp = null)
		var/t = "Current disk: [current_disk.GetName()], [current_disk.Space()]"
		t += "<A href='?src=\ref[src];setstate=disks'>Change</A>"
		t += "<br>"
		t += "Contents:"
		for(var/datum/file/F in current_disk.data)
			t += "<div class='block'>"
			if(sendtoapp && istype(F, waiting_file_type))
				t += "<A class='file' href='?src=\ref[src];file=\ref[F];sendto=[sendtoapp]'>[F.GetName()]</A>"
			else
				if(istype(F, /datum/file/software/app) && istype(src, F:required_sys))
					t += "<A class='file' href='?src=\ref[src];runapp=\ref[F]'>[F.GetName()]</A>"
				else
					t += "<div class='fileOff'>[F.GetName()]</div>"
				t += "<A class='mini' href='?src=\ref[src];file=\ref[F];copy=1'>CPY</A>"
				t += "<A class='mini' href='?src=\ref[M];remove=\ref[F];disk=\ref[current_disk]'>DEL</A>"
			t += "<div class='miniOff'>[F.size] GB</div>"
			t += "</div>"
		return t

	proc/DiskList(var/sendtoapp = null)
		var/t = "Current disk: [current_disk.GetName()], [current_disk.Space()]"
		t += "<br>"
		t += "Disks:"
		for(var/obj/item/weapon/hardware/memory/D in M.GetActiveDisks())
			t += "<div class='block'>"
			if(sendtoapp)
				t += "<A class='file' href='?src=\ref[src];disk=\ref[D];sendto=[sendtoapp]'>[D.GetName()]</A>"
			else
				t += "<A class='file' href='?src=\ref[src];disk=\ref[D]'>[D.GetName()]</A>"
			t += "<div class='miniOff'>[D.Space()]</div>"
			t += "</div>"
		return t

	GetIconName()
		if(current_prog)
			return current_prog.display_icon
		return display_icon

	Request(var/datum/connectdata/sender, var/list/data)
		..()

	Run(var/datum/file/software/app/soft)
		Close()
		if(!(soft in M.GetAllData()))
			return 0
		if(!istype(soft))
			return 0
		if(soft.Requirements())
			message += soft.Requirements()
			message += "<A href='?src=\ref[M];messagehide=1'>Close</A>"
			return 0
		if(soft.required_sys && !istype(src, soft.required_sys))
			message += "[soft] is damaged or incompatible with OS NT"
			message += "<A href='?src=\ref[M];messagehide=1'>Close</A>"
			return 0
		current_prog = soft
		current_prog.OnStart()
		M.update_icon()
		return 1

	Close()
		if(!current_prog)
			current_state = "fileman"
		else
			current_prog.OnExit()
			current_prog = null
			M.update_icon()

	Copy()
		var/datum/file/software/os/osnt/O = ..()
		O.autorun = autorun
		O.password = password
		return O

/datum/file/software/app/osnt
	required_sys = /datum/file/software/os/osnt

	GetName()
		return text2programname(name + ".exe")

/datum/file/software/app/osnt/secure/Requirements()
	if(!Auth())	return "Access denied"
	return ..()