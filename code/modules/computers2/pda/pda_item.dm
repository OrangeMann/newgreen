// The advanced pea-green monochrome lcd of tomorrow.
/obj/item/device/pda2
	name = "\improper PDA"
	desc = "A portable microcomputer by Thinktronic Systems, LTD. Functionality determined by a preprogrammed ROM cartridge."
	icon = 'icons/obj/pda.dmi'
	icon_state = "pda"
	item_state = "electronic"
	w_class = 2
	slot_flags = SLOT_ID | SLOT_BELT

	var/obj/item/weapon/card/id/id = null
	//Making it possible to slot an ID card into the PDA so it can function as both.
	var/owner = null
	var/ownjob = null

	var/fon = 0 //Is the flashlight function on?
	var/f_lum = 2 //Luminosity for the flashlight function

	var/obj/machinery/newComputer/pda/pda

/obj/item/device/pda2/proc/toggle_flashlight()
	fon = !fon
	if(ismob(loc))
		var/mob/M = loc
		if(fon)	M.SetLuminosity(M.luminosity + f_lum)
		else	M.SetLuminosity(M.luminosity - f_lum)
	else
		if(fon)	SetLuminosity(f_lum)
		else	SetLuminosity(0)

/obj/item/device/pda2/pickup(mob/user)
	if(fon)
		SetLuminosity(0)
		user.SetLuminosity(user.luminosity + f_lum)

/obj/item/device/pda2/dropped(mob/user)
	if(fon)
		user.SetLuminosity(user.luminosity - f_lum)
		SetLuminosity(f_lum)

/obj/item/device/pda2/attack_self(user)
	return pda.attack_hand(user)

/obj/item/device/pda2/attackby(obj/item/O as obj, mob/user as mob)
	pda.attackby(O, user)

	if(pda.auth && pda.auth.id == O)
		id = O

/obj/item/device/pda2/Del()
	del pda
	..()

/obj/item/device/pda2/pc/New()
	..()
	pda = new(src)

/obj/item/device/pda2/GetAccess()
	if(pda.auth && pda.auth.id)
		return pda.auth.id.GetAccess()
	else
		return ..()

/obj/item/device/pda2/GetID()
	if(pda.auth && pda.auth.id)
		return pda.auth.id
	return null

/obj/item/device/pda2/verb/verb_remove_id()
	set category = "Object"
	set name = "Remove id"
	set src in usr

	if(issilicon(usr))
		return

	if(!pda.SecurityAlert())
		if(pda.auth && pda.auth.Eject())
			id = null
		else
			usr << "<span class='notice'>This PDA does not have an ID in it.</span>"
	else
		usr << "<span class='notice'>You cannot do this while restrained.</span>"


/obj/item/device/pda2/verb/verb_remove_pen()
	set category = "Object"
	set name = "Remove pen"
	set src in usr

	if(issilicon(usr))
		return

	if(!pda.SecurityAlert())
		var/obj/item/weapon/pen/O = locate() in src
		if(O)
			if (istype(loc, /mob))
				var/mob/M = loc
				if(M.get_active_hand() == null)
					M.put_in_hands(O)
					usr << "<span class='notice'>You remove \the [O] from \the [src].</span>"
					return
			O.loc = get_turf(src)
		else
			usr << "<span class='notice'>This PDA does not have a pen in it.</span>"
	else
		usr << "<span class='notice'>You cannot do this while restrained.</span>"