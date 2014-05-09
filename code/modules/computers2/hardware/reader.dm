/obj/item/weapon/hardware/memory/reader
	name = "reader"
	icon_state = "flopdrive"
	var/obj/item/weapon/hardware/memory/disk
	var/disk_type = /obj/item/weapon/hardware/memory
	total_memory = 0
	current_free_space = 0

	GetName()
		if(!IsReady())
			return "data disk reader (empty)"
		else
			return disk.GetName()

	IsReady()
		return disk

	proc/Insert(var/obj/item/weapon/hardware/memory/d)
		if(disk)
			return 0
		if(!istype(d, disk_type))
			return 0
		if(ismob(d.loc))
			var/mob/user = d.loc
			user.drop_item()
		d.loc = src
		disk = d
		data = disk.data
		total_memory = disk.total_memory
		current_free_space = disk.current_free_space
		if(M)
			disk.Connect(M)
			M.HardwareChange()
		return 1

	proc/Eject()
		if(!disk)
			return 0
		disk.loc = get_turf(src)
		disk.Disconnect()
		if(ishuman(usr))
			var/mob/living/carbon/human/H = usr
			H.put_in_hands(disk)
		disk = null
		data = list()
		total_memory = 0
		current_free_space = 0
		if(M)
			M.HardwareChange()
		return 1

	attack_self(mob/user as mob)
		Eject()

	ChangeMemorySize()
		return

	WriteOn(var/datum/file/software/soft, var/expand = 0)
		if(!IsReady())
			return 0
		return disk.WriteOn(soft, expand)

	Remove(var/datum/file/software/soft, var/decrease = 0)
		if(!IsReady())
			return 0
		return disk.Remove(soft, decrease)

	Space()
		if(!IsReady())
			return "No disk inserted"
		return disk.Space()

	InstallationTrouble(var/datum/file/software/soft)
		if(!IsReady())
			return 2
		return disk.InstallationTrouble(soft)

/obj/item/weapon/hardware/memory/reader/disk
	name = "data disk reader"
	icon_state = "flopdrive"
	disk_type = /obj/item/weapon/hardware/memory/disk

	examine()
		set src in view()
		..()
		if(disk)
			usr << "It has a data disk in it!"

	attackby(obj/item/O as obj, mob/user as mob)
		if(istype(O, disk_type))
			Insert(O)
			return
		..()