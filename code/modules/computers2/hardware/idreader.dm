////////////////////ID////////////////////////

/obj/item/weapon/hardware/auth //authentication
	name = "ID authentication module"
	desc = "A module allowing secure authorization of ID cards."
	icon_state = "card_mod"

	var/obj/item/weapon/card/id/id
	var/logged = 0
	var/username = "unknown"
	var/assignment = "unassigned"
	var/list/access = list()

	Disconnect()
		logged = 0
		username = "unknown"
		assignment = "unassigned"
		if(M)
			for(var/datum/file/software/soft in M.GetAllData())
				soft.LoginChange()
		..()

	proc/Login(var/inLog = 1)
		if(!Connected()) return
		if(logged)
			assignment = id.assignment
			return
		if(!id)
			return
		username = id.registered_name
		assignment = id.assignment
		access = id.access
		logged = 1
		for(var/datum/file/software/soft in M.GetAllData())
			soft.LoginChange()
		M.Log("Logged as [username]")

	proc/Logout(var/inLog = 1)
		if(!Connected()) return
		if(!logged)
			return
		username = "unknown"
		assignment = "unassigned"
		access = list()
		logged = 0
		for(var/datum/file/software/soft in M.GetAllData())
			soft.LoginChange()
		M.Log("Logged out")

	proc/Insert(var/obj/item/weapon/card/id/insertedID)
		//Separated checks is important cause player can insert an ID when auth module is removed
		if(id || !insertedID)
			return 0
		if(ismob(insertedID.loc))
			var/mob/user = insertedID.loc
			user.drop_item()
		insertedID.loc = src
		id = insertedID
		return 1

	proc/Eject()
		if(!id)
			return 0
		id.loc = get_turf(src)
		if(ishuman(usr))
			var/mob/living/carbon/human/H = usr
			H.put_in_hands(id)
		id = null
		return 1

	proc/CheckAccess(var/list/input)
		if(input.len <= 0)
			return 1
		for(var/req in input)
			if(req in access)
				return 1
		return 0

	attack_self(mob/user as mob)
		Eject()

	attackby(obj/item/O as obj, mob/user as mob)
		if(istype(O, /obj/item/weapon/card/id))
			Insert(O)
			return
		..()

	examine()
		set src in view()
		..()
		if(id)
			usr << "It has an ID card in it!"

/obj/item/weapon/hardware/auth/mini
	icon_state = "card_mini"
	w_class = 1