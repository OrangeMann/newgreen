/////////////////////////MEMORY/////////////////////

/obj/item/weapon/hardware/memory
	name = "memory"
	var/total_memory = 25
	var/current_free_space = 25
	var/list/datum/file/data = list()
	var/protected = 0
	var/list/default_soft = list()

	New()
		..()
		for(var/soft in default_soft)
			WriteOn(new soft())

	Connect(var/obj/machinery/newComputer/m)
		..()
		for(var/datum/file/soft in data)
			soft.Connect(m)

	Disconnect()
		..()
		for(var/datum/file/soft in data)
			soft.Disconnect()

	proc/GetName()
		return "BadminStore #[serial] [total_memory]GB data storage"

	proc/GetFiles(var/filetype = /datum/file)
		var/list/files = list()
		for(var/datum/file/F in data)
			if(istype(F, filetype))
				files.Add(F)

		return files

	proc/IsReady()
		return 1

	proc/ChangeMemorySize(var/value)
		total_memory = value
		current_free_space = value
		data = list()

	proc/WriteOn(var/datum/file/soft, var/expand = 0)
		if(protected)
			return 0
		if(!soft)
			return 0
		soft = soft.Copy()
		if(soft.size > current_free_space)
			return 0
		data.Add(soft)
		if(M) soft.Connect(M)
		if(expand)
			total_memory += soft.size
		else
			current_free_space -= soft.size
		return 1

	proc/Remove(var/datum/file/soft, var/decrease = 0)
		if(protected)
			return 0
		if(!(soft in data))
			return 0
		data.Remove(soft)
		if(decrease)
			total_memory -= soft.size
		else
			current_free_space = min(total_memory, current_free_space + soft.size)
		del soft

	proc/Space()
		return "[total_memory - current_free_space]/[total_memory] GB"

	proc/InstallationTrouble(var/datum/file/soft)
		//for(var/datum/file/software/app in data)
		//	if(app.name == soft.name)
		//		return 1
		if(soft.size > current_free_space)
			return 2
		if(protected)
			return 2
		return 0

/obj/item/weapon/hardware/memory/hdd
	name = "storage drive"
	icon_state = "harddisk_m"
	total_memory = 50
	current_free_space = 50

	GetName()
		return "ComStor #[serial] [total_memory]GB HDD"

	examine()
		set src in view()
		..()
		usr << GetName()

/obj/item/weapon/hardware/memory/ssd
	name = "solid state drive"
	icon_state = "ssd"
	total_memory = 30
	current_free_space = 30

	GetName()
		return "DataTec #[serial] [total_memory]GB SSD"

	examine()
		set src in view()
		..()
		usr << GetName()

/obj/item/weapon/hardware/memory/ssd/nano
	name = "memory module"
	icon_state = "ssd_nano"
	total_memory = 15
	current_free_space = 15
	w_class = 1


/obj/item/weapon/hardware/memory/hdd/big
	icon_state = "harddisk"
	total_memory = 150
	current_free_space = 150
	w_class = 3

/obj/item/weapon/hardware/memory/disk
	name = "data disk"
	icon_state = "datadisk0"
	item_state = "card-id"
	can_install = 0

	GetName()
		return "[name] #[serial]"

	New()
		..()
		icon_state = "datadisk[rand(0,6)]"

	attack_self(mob/user as mob)
		protected = !protected
		user << "You flip the write-protect tab to [protected ? "" : "un"]protected."

	examine()
		set src in view()
		..()
		usr << GetName()
		usr << "The write-protect tab is set to [protected ? "" : "un"]protected."