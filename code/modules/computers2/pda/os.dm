/datum/file/software/os/pda // OS for PDAs by ACCount12
	name = "rom_v217_release.bin"
	size = 4
	var/current_state = "menu"
	var/datum/file/software/app/current_prog
	var/message = ""

	HardwareChange()
		if(current_prog && !(current_prog in M.GetAllData()))
			Close()
		..()

	OnStart()
		..()
		if(!istype(M, /obj/machinery/newComputer/pda))
			M.BSOD()
			return
		current_state = "menu"
		message = ""

	Display(var/mob/user)
		var/header = "PERSONAL DATA ASSISTANT v2.1"
		var/t = ""

		header += "<A class='title' href='?src=\ref[M];login=1'>"
		if(M.auth)
			if(!M.AuthTrouble())
				header += "Owner: [M.User()], [M.Assignment()]</A>"
			else
				header += "Warning: No owner information entered</A>"

		if(message)
			t += message
		else if(current_prog)
			t += "<div class='block'>"
			t += current_prog.Display()
			t += "<A href='?src=\ref[src];closeapp=1'>Close</A>"
			t += "</div>"
		else switch(current_state)
			if("menu")
				var/list/software = list()
				for(var/datum/file/software/app/A in M.GetAllData())
					if(istype(src, A.required_sys))
						software.Add(A)
				if(software.len)
					t += "<h4>General Functions</h4>"
					t += "<div class='block'>"
					for(var/datum/file/software/app/A in software)
						t += "<A href='?src=\ref[src];runapp=\ref[A]'>[A.name]</A>"
					t += "</div>"

					t += "<br><h4>Utilities</h4>"
					t += "<div class='block'>"
					t += "<A href='?src=\ref[src];setstate=atmoscan'>Atmospheric Scan</A>"
					var/obj/machinery/newComputer/pda/M2 = M
					if(!istype(M))
						M.BSOD()
						updateUsrDialog()
						return
					if(M2.item.fon)
						t += "<A href='?src=\ref[src];light=1'>Disable Flashlight</A>"
					else
						t += "<A href='?src=\ref[src];light=1'>Enable Flashlight</A>"
					t += "</div>"
			if("atmoscan")
				t += "<h4>Atmospheric Readings</h4>"
				t += "<div class='block'>"
				var/turf/T = get_turf(user.loc)
				if (isnull(T))
					t += "Unable to obtain a reading."
				else
					var/datum/gas_mixture/environment = T.return_air()
					var/pressure = environment.return_pressure()
					var/total_moles = environment.total_moles()
					t += "Air Pressure: [round(pressure,0.1)] kPa<br>"

					if (total_moles)
						var/o2_level = environment.oxygen/total_moles
						var/n2_level = environment.nitrogen/total_moles
						var/co2_level = environment.carbon_dioxide/total_moles
						var/plasma_level = environment.toxins/total_moles
						var/unknown_level =  1-(o2_level+n2_level+co2_level+plasma_level)
						t += "Nitrogen: [round(n2_level*100)]%<br>"
						t += "Oxygen: [round(o2_level*100)]%<br>"
						t += "Carbon Dioxide: [round(co2_level*100)]%<br>"
						t += "Plasma: [round(plasma_level*100)]%<br>"
						if(unknown_level > 0.01)
							t += "OTHER: [round(unknown_level)]%<br>"
					t += "Temperature: [round(environment.temperature-T0C)]&deg;C<br>"
				t += "</div>"
				t += "<A href='?src=\ref[src];setstate=menu'>Back</A>"

		return M.ComputerHtml(header, t)

	Topic(href, href_list)
		if(!M)	return

		if(href_list["close"])
			message = ""

		if(href_list["setstate"])
			current_state = href_list["setstate"]

		else if(href_list["runapp"] && !current_prog)
			Run(locate(href_list["runapp"]))

		else if(href_list["closeapp"])
			Close()

		else if(href_list["light"])
			var/obj/machinery/newComputer/pda/M2 = M
			if(!istype(M))
				M.BSOD()
				updateUsrDialog()
				return
			M2.item.toggle_flashlight()

		updateUsrDialog()


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
			message += "<A href='?src=\ref[M];close=1'>Close</A>"
			return 0
		if(soft.required_sys && !istype(src, soft.required_sys))
			message += "[soft] is damaged"
			message += "<A href='?src=\ref[M];close=1'>Close</A>"
			return 0
		current_prog = soft
		current_prog.OnStart()
		M.update_icon()
		return 1

	Close()
		if(!current_prog)
			current_state = "menu"
		else
			current_prog.OnExit()
			current_prog = null
			M.update_icon()

/datum/file/software/app/pda
	required_sys = /datum/file/software/os/pda