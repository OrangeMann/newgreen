// TO DO: DO SOMETHING WITH INSTALLING/REMOVING HARDWARE

/obj/machinery/newComputer
	name = "computer"
	desc = "A computer workstation."
	icon = 'icons/obj/computer2.dmi'
	icon_state = "computer"
	density = 1
	anchored = 1

	use_power = 1
	idle_power_usage = 1
	active_power_usage = 8

	var/on = COMPUTER_OFF
/* possible vars:
#define COMPUTER_BSOD		-1
#define COMPUTER_OFF		0
#define COMPUTER_POWERINGUP 1
#define COMPUTER_BIOS	 	2
#define COMPUTER_LOADINGOS	3
#define COMPUTER_OS	 		4
*/

	var/opened = 0
	var/datum/file/software/os/sys = null
	var/obj/item/weapon/hardware/memory/sysdisk
	// OS disk. Set in BIOS disk selection menu.

	var/obj/item/weapon/hardware/auth/auth
	var/obj/item/weapon/hardware/wireless/connector

	var/list/disks = list()
	var/max_disks = 5
	var/screensize = "600x400"
	var/window_id = "mainframe"

	var/obj/effect/overlay/screenhack // HAAACK!

	New()
		..()
		InstallDefault()

	Del()
		del(screenhack)
		..()

	process()
		if(on)
			if(sys)
				for(var/datum/file/software/soft in GetAllData())
					soft.Update()

			else if(on == COMPUTER_OS)
				BSOD()
		..()

	update_icon()
		overlays.Cut()
		if(opened)
			overlays.Add("open")

		if(sys && sys.GetIconName() && on == COMPUTER_OS)
			overlays.Add(sys.GetIconName())
		else switch(on)
			if(COMPUTER_BSOD)		overlays.Add("bsod")
			if(COMPUTER_BIOS)		overlays.Add("bios")

	proc/flick_screen(var/state = null)
	// Hack! This is because BYOND has no overlays flicking and animated overlays are glitchy.
		if(state)
			screenhack = new(src.loc, state)
		else
			del(screenhack)


	proc/InstallDefault() // For changing default hardware and soft in childs
		var/obj/item/weapon/hardware/memory/hdd

		hdd = new /obj/item/weapon/hardware/memory/hdd/big/captain(src)
		hdd.Connect(src)
		disks.Add(hdd)

		hdd = new /obj/item/weapon/hardware/memory/reader/disk(src)
		hdd.Connect(src)
		disks.Add(hdd)

		auth = new /obj/item/weapon/hardware/auth(src)
		auth.Connect(src)

		connector = new /obj/item/weapon/hardware/wireless(src)
		connector.Connect(src)

	proc/TurnOn()
		if((stat & NOPOWER) || on)
			return
		use_power = 2
		on = COMPUTER_POWERINGUP
		flick_screen("startup")
		spawn(50)
			if(on == COMPUTER_POWERINGUP)
				on = COMPUTER_BIOS
			Bios()
			flick_screen(null)
			update_icon()
			updateDialog()

	proc/TurnOff()
		use_power = 1
		LaunchOS(null)
		on = COMPUTER_OFF
		updateDialog()
		flick_screen(null)
		update_icon()

	proc/LaunchOS(var/datum/file/software/os/newos = null)
		if(newos && (newos in GetSysData()))
			sys = newos
			on = COMPUTER_LOADINGOS
			flick_screen("load")
			spawn(35)
				if(on == COMPUTER_LOADINGOS)
					on = COMPUTER_OS
				flick_screen(null)
				sys.Connect(src)
				sys.OnStart()
				update_icon()
				updateDialog()
		else
			sys = null
			sysdisk = null
			on = COMPUTER_BIOS
			if(auth.logged)
				auth.Logout(0)
		update_icon()
		updateDialog()

	attack_hand(var/mob/user as mob)
		if(stat & NOPOWER)
			return
		if(SecurityAlert())
			usr.unset_machine()
			usr << browse(null, "window=[window_id]")
			return
		if(!on)
			usr << "You turn [src] on."
			TurnOn()
			if(!on) // Hardware troubles?
				return
		interact(user)

	attack_ai(var/mob/user as mob)
		return interact(user)

	attack_paw(var/mob/user as mob)
		return
		//world << "Creature interact doesn't work right now"

	interact(var/mob/user as mob)
		if(!on)
			user.unset_machine()
			user << browse(null, "window=[window_id]")
			return
		var/t = ""
		if(on == COMPUTER_POWERINGUP || on == COMPUTER_LOADINGOS)
			t = ComputerHtml("Loading...")
		else if(on == COMPUTER_BSOD)
			t = HtmlBSOD()
		else if(sys)
			t = sys.Display(user)
		else
			t = Bios()
		user.set_machine(src)
		user << browse(t, "window=[window_id];size=[screensize];can_resize=0")
		onclose(user,"[window_id]")

	attackby(obj/item/O as obj, mob/user as mob)
		if(istype(O, /obj/item/weapon/screwdriver))
			opened = !opened
			user << "You [opened ? "open" : "close"] the maintenance hatch of [src]."
			update_icon()

		else if(opened)
			if(istype(O, /obj/item/weapon/hardware))
				Insert(O)
			else if(istype(O, /obj/item/weapon/crowbar))
				for(var/obj/item/weapon/hardware/H in src)
					H.Disconnect()
					H.loc = src.loc
					if(on && prob(5)) // Dissasembling PC without powering it down?
						H.crit_fail = 1
				TurnOff()
				connector = null
				auth = null
				disks = list()
				HardwareChange()
		else
			if(istype(O, /obj/item/weapon/card/id))
				if(auth && auth.Insert(O))
					user << "You insert [O] into [auth]."

			else if(istype(O, /obj/item/weapon/hardware/memory))
				for(var/obj/item/weapon/hardware/memory/reader/R in disks)
					if(R.Insert(O))
						user << "You insert [O] into [R]."
						break
		updateDialog()


	Topic(href, href_list)
		if(..())
			return
		var/remote = 0
		var/mob/M = usr
		if(issilicon(M))
			remote = 1

		if(href_list["on-close"])
			usr.unset_machine()
			usr << browse(null, "window=[window_id]")

		else if(href_list["shutdown"])
			TurnOff()

		else if(href_list["reset"])
			TurnOff()
			TurnOn()
			M.set_machine(src)
			updateDialog()

		if(!remote)
			if(href_list["ejectid"])
				if(auth) auth.Eject()

			else if(href_list["insertid"])
				if(auth) auth.Insert(M.get_active_hand())

			else if(href_list["eject"])
				var/obj/item/weapon/hardware/memory/reader/R = LocateDisk(href_list["disk"])
				if(!istype(R))
					updateUsrDialog()
					return
				R.Eject()

			else if(href_list["insert"])
				var/obj/item/weapon/hardware/memory/reader/R = LocateDisk(href_list["disk"], 0)
				if(!istype(R))
					updateUsrDialog()
					return
				var/obj/item/weapon/hardware/memory/D = M.get_active_hand()
				if(istype(D))
					R.Insert(D)

		if(on == COMPUTER_BIOS || on == COMPUTER_OS)
			if(href_list["choose_sysdisk"] && !sysdisk)
				var/obj/item/weapon/hardware/memory/MM = LocateDisk(href_list["choose_sysdisk"])
				if(MM)	sysdisk = MM

			else if(href_list["OS"] && !sys)
				var/datum/file/software/os = locate(href_list["OS"])
				if(os && (os in sysdisk.data))
					LaunchOS(os)

			else if(href_list["write"] || href_list["remove"])
				var/obj/item/weapon/hardware/memory/MM = LocateDisk(href_list["disk"])
				if(!MM)
					updateUsrDialog()
					return

				if(href_list["write"])
					MM.WriteOn(locate(href_list["write"]))
				else if(href_list["remove"])
					MM.Remove(locate(href_list["remove"]))
					if(on == COMPUTER_OS && !sys)
						BSOD() // Whoops!

			else if(href_list["login"])
				if(auth) auth.Login()

			else if(href_list["logout"])
				if(auth) auth.Logout()

			else if(sys)
				sys.Topic(href, href_list)
				return // Update will be made in soft Topic() after display changing

		updateUsrDialog()

	// Hardware trouble checks
	proc/CheckAccess(var/list/access)
		if(!auth)
			return 1
		if(!auth.logged)
			return 2
		if(!auth.CheckAccess(access))
			return 3
		return 0

	proc/AuthTrouble()
		if(!auth)
			return 1
		if(!auth.logged)
			return 2
		return 0

	proc/NetworkTrouble()
		if(!connector)
			return 1
		return 0

	// Send a PC into a BSOD. For BSOD html generation, see html.dm
	proc/BSOD()
		on = COMPUTER_BSOD
		updateDialog()
		update_icon()

	//Net stuff
	proc/RecieveSignal(var/datum/connectdata/reciever, var/datum/connectdata/sender, var/list/data)
		if(!on)			return
		if(!sysdisk)	return
		if(!sys)		return
		if(!reciever.id)
			for(var/datum/file/software/soft in GetAllData())
				soft.Request(sender, data)
		else
			for(var/datum/file/software/soft in GetAllData())
				if(reciever.id == soft.id)
					soft.Request(sender, data)

	power_change()
		..()
		if((stat & NOPOWER) && on)
			TurnOff()

	proc/SecurityAlert() //Protection against non-fair using
		if(!in_range(src, usr) && !istype(usr, /mob/living/silicon))
			//world << "Security Alert in ([x], [y], [z]). Try to avoid any message like this."
			return 1
		if(stat & (NOPOWER|BROKEN))
			return 1
		if(usr.restrained() || usr.lying || usr.stat)
			return 1
		return 0


	//Hardware stuff
	proc/HardwareChange()
		for(var/datum/file/software/soft in GetAllData())
			soft.HardwareChange()
		if(sys && !(sys in GetAllData()))
			BSOD()

	proc/Insert(var/obj/item/weapon/hardware/module)
		if(!istype(module))		return 0
		if(!module.can_install)	return 0

		var/installed = 0
		if(istype(module, /obj/item/weapon/hardware/auth) && !auth)
			auth = module
			installed = 1
		else if(istype(module, /obj/item/weapon/hardware/memory) && disks.len <= max_disks)
			disks.Add(module)
			installed = 1
		else if(istype(module, /obj/item/weapon/hardware/wireless) && !connector)
			connector = module
			installed = 1

		if(installed)
			if(istype(module.loc, /mob))
				usr.unEquip(module)
			module.loc = src
			module.Connect(src)
			usr << "You insert [module] into [src]."
			HardwareChange()
			return 1
		return 0

	//Helpers
	proc/GetSysData()
		if(!sysdisk)
			return list()
		return sysdisk.data

	proc/Log(var/text)
		if(sys)
			sys.AddLogs(text)

	proc/User()
		if(AuthTrouble()) return "unknown"
		return auth.username

	proc/Assignment()
		if(AuthTrouble()) return "unassigned"
		return auth.assignment

	proc/CloseApp()
		if(sys)
			sys.Close()

	proc/GetActiveDisks()
		var/list/activedisks = list()
		for(var/obj/item/weapon/hardware/memory/M in disks)
			if(M.IsReady())
				activedisks.Add(M)
		return activedisks

	proc/GetAllData()
		var/list/activedisks = GetActiveDisks()
		var/list/alldata = list()
		for(var/obj/item/weapon/hardware/memory/M in activedisks)
			for(var/datum/file/F in M.data)
				alldata.Add(F)
		return alldata

	proc/LocateDisk(var/obj/item/weapon/hardware/memory/M, var/active = 1)
		if(!istype(M))
			M = locate(M)
			if(!istype(M))
				return null
		if(active)
			if(M in GetActiveDisks())
				return M
		else
			if(M in disks)
				return M
		return null


/obj/effect/overlay // HAAAAAACK!
	name = "" // No displaying in right click menu
	icon = 'icons/obj/computer2.dmi'
	icon_state = "screen"
	mouse_opacity = 0 // No click catching
	anchored = 1

	New(loc, state)
		..()
		flick(state, src)


proc/text2programname(var/text)
	text = lowertext(text)
	var/index = findtext(text, " ")
	while(index)
		text = copytext(text, 1, index) + "_" + copytext(text, index+1)
		index = findtext(text, " ")
	return text