/obj/machinery/newComputer/pda
	name = "\improper PDA"
	desc = "A PDA."
	icon = 'icons/obj/computer2.dmi'
	icon_state = "computer"

	use_power = 0
	on = COMPUTER_OFF
/* possible vars:
#define COMPUTER_BSOD		-1
#define COMPUTER_OFF		0
#define COMPUTER_POWERINGUP 1
#define COMPUTER_BIOS	 	2
#define COMPUTER_LOADINGOS	3
#define COMPUTER_OS	 		4
*/

	max_disks = 2
	screensize = "350x450"
	window_id = "pda"

	var/obj/item/device/pda2/item

	New(loc)
		..()
		if(istype(loc, /obj/item/device/pda2))
			var/obj/item/device/pda2/P = loc
			item = P
			P.pda = src

	update_icon()
		item.update_icon()
		return

	flick_screen(var/state = null)
		return

	InstallDefault() // For changing default hardware and soft in childs
		var/obj/item/weapon/hardware/memory/hdd

		hdd = new /obj/item/weapon/hardware/memory/ssd/nano/pda(src)
		hdd.Connect(src)
		disks.Add(hdd)

		hdd = new /obj/item/weapon/hardware/memory/reader/cart(src)
		hdd.Connect(src)
		disks.Add(hdd)

		auth = new /obj/item/weapon/hardware/auth/mini(src)
		auth.Connect(src)

		connector = new /obj/item/weapon/hardware/wireless/mini/nano(src)
		connector.Connect(src)

	TurnOn()
		if(on)
			return
		on = COMPUTER_BIOS
		Bios()
		update_icon()
		updateDialog()

	TurnOff()
		LaunchOS(null)
		on = COMPUTER_OFF
		updateDialog()
		update_icon()

	LaunchOS(var/datum/file/software/os/newos = null)
		if(newos && (newos in GetSysData()))
			sys = newos
			on = COMPUTER_OS
			sys.Connect(src)
			sys.OnStart()
		else
			sys = null
			sysdisk = null
			on = COMPUTER_BIOS
		update_icon()
		updateDialog()

	attack_hand(var/mob/user as mob)
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

	updateDialog()
		if(in_use)
			var/list/nearby = viewers(1, item)
			nearby.Add(item.loc)
			var/is_in_use = 0
			for(var/mob/M in nearby)
				if ((M.client && M.machine == src))
					is_in_use = 1
					src.interact(M)
			in_use = is_in_use

	updateUsrDialog()
		updateDialog()

	attackby(obj/item/O as obj, mob/user as mob)
		if(istype(O, /obj/item/weapon/card/id))
			if(auth && auth.Insert(O))
				user << "You insert [O] into [src]."

		else if(istype(O, /obj/item/weapon/hardware))
			if(istype(O, /obj/item/weapon/hardware/memory))
				for(var/obj/item/weapon/hardware/memory/reader/R in disks)
					if(R.Insert(O))
						user << "You insert [O] into [src]."
						updateDialog()
						return
			Insert(O)

		else if(istype(O, /obj/item/weapon/screwdriver))
			for(var/obj/item/weapon/hardware/H in src)
				H.Disconnect()
				H.loc = src.loc
			TurnOff()
			connector = null
			auth = null
			item.id = null
			disks = list()
			HardwareChange()
		updateDialog()


	Topic(href, href_list)
		if(SecurityAlert())
			return
		var/remote = 0
		var/mob/M = usr
		if(issilicon(M))
			remote = 1

		if(href_list["on-close"])
			usr.unset_machine()
			usr << browse(null, "window=mainframe")

		else if(href_list["shutdown"])
			TurnOff()

		else if(href_list["reset"])
			TurnOff()
			TurnOn()
			M.set_machine(src)
			updateDialog()

		if(!remote)
			if(href_list["ejectid"])
				if(auth)
					auth.Eject()
					item.id = null

			else if(href_list["insertid"])
				if(auth)
					var/obj/item/I = M.get_active_hand()
					auth.Insert(I)
					if(auth.id == I)
						item.id = auth.id

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

			else if(sys)
				sys.Topic(href, href_list)
				return // Update will be made in soft Topic() after display changing

		updateUsrDialog()

	BSOD()
		TurnOff()

	power_change()
		return

	SecurityAlert() //Protection against non-fair using
		if(!in_range(src, usr) && !in_range(item, usr))
			return 1
		if(usr.restrained() || usr.lying || usr.stat)
			return 1
		return 0


	Insert(var/obj/item/weapon/hardware/module)
		if(!istype(module))		return 0
		if(!module.can_install)	return 0

		var/installed = 0
		if(istype(module, /obj/item/weapon/hardware/auth) && !auth)
			auth = module
			installed = 1
			if(auth.id)
				item.id = auth.id
		else if(istype(module, /obj/item/weapon/hardware/memory) && disks.len <= 5)
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
			updateDialog()
			return 1
		return 0

	proc/CartridgesHardware()
		var/list/l = list()
		for(var/obj/item/weapon/hardware/memory/reader/R in disks)
			if(istype(R.disk, /obj/item/weapon/hardware/memory/reader/cart))
				var/obj/item/weapon/hardware/memory/cart/C = R.disk
				l.Add(C.hardware)
		return l