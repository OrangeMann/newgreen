/obj/item/device/flashlight
	name = "flashlight"
	desc = "A hand-held emergency light."
	icon = 'icons/obj/lighting.dmi'
	icon_state = "flashlight"
	item_state = "flashlight"
	w_class = 2
	flags = FPRINT | TABLEPASS | CONDUCT
	slot_flags = SLOT_BELT
	m_amt = 50
	g_amt = 20
	icon_action_button = "action_flashlight"
	var/on = 0
	var/brightness_on = 4 //luminosity when on


/obj/item/device/flashlight/attackby(var/obj/B, var/mob/user)
	if (istype(B, /obj/item/weapon/storage/toolbox))
		user << "You are silly? You can't insert this massive toolbox into flashlight."
		return

/obj/item/device/flashlight/initialize()
	..()
	if (on)
		icon_state = "[initial(icon_state)]-on"
		src.ul_SetLuminosity(brightness_on, brightness_on, 0)
	else
		icon_state = initial(icon_state)
		src.ul_SetLuminosity(0)

/obj/item/device/flashlight/proc/update_brightness(var/mob/user)
	if (on)
		icon_state = "[initial(icon_state)]-on"
		if(src.loc == user)
			user.ul_SetLuminosity(user.LuminosityRed + brightness_on, user.LuminosityGreen + brightness_on, user.LuminosityBlue)
		else if (isturf(src.loc))
			ul_SetLuminosity(brightness_on, brightness_on, 0)

	else
		icon_state = initial(icon_state)
		if(src.loc == user)
			user.ul_SetLuminosity(user.LuminosityRed - brightness_on, user.LuminosityGreen - brightness_on, user.LuminosityBlue)
		else if (isturf(src.loc))
			ul_SetLuminosity(0)

/obj/item/device/flashlight/on_enter_storage()
	if(on)
		icon_state = initial(icon_state)
		usr.ul_SetLuminosity(usr.LuminosityRed - brightness_on, usr.LuminosityGreen - brightness_on, usr.LuminosityBlue)
		on = 0
	..()
	return


/obj/item/device/flashlight/attack_self(mob/user)
	if(!isturf(user.loc))
		user << "You cannot turn the light on while in this [user.loc]." //To prevent some lighting anomalities.
		return 0
	on = !on
	update_brightness(user)
	return 1

/obj/item/device/flashlight/attack(mob/M as mob, mob/user as mob)
	src.add_fingerprint(user)
	if(src.on && user.zone_sel.selecting == "eyes")

		if (!(istype(usr, /mob/living/carbon/human) || ticker) && ticker.mode.name != "monkey")//don't have dexterity
			usr.show_message("\red You don't have the dexterity to do this!",1)
			return

		var/mob/living/carbon/human/H = M//mob has protective eyewear
		if(istype(M, /mob/living/carbon/human) && ((H.head && H.head.flags & HEADCOVERSEYES) || (H.wear_mask && H.wear_mask.flags & MASKCOVERSEYES) || (H.glasses && H.glasses.flags & GLASSESCOVERSEYES)))
			user << text("\blue You're going to need to remove that [] first.", ((H.head && H.head.flags & HEADCOVERSEYES) ? "helmet" : ((H.wear_mask && H.wear_mask.flags & MASKCOVERSEYES) ? "mask": "glasses")))
			return

		for(var/mob/O in viewers(M, null))//echo message
			if ((O.client && !(O.blinded )))
				O.show_message("\blue [(O==user?"You direct":"[user] directs")] [src] to [(M==user? "your":"[M]")] eyes", 1)

		if(istype(M, /mob/living/carbon/human) || istype(M, /mob/living/carbon/monkey))//robots and aliens are unaffected
			if(M.stat > 1 || M.disabilities & 128)//mob is dead or fully blind
				if(M!=user)
					user.show_message(text("\red [] pupils does not react to the light!", M),1)
			else if(XRAY in M.mutations)//mob has X-RAY vision
				if(M!=user)
					user.show_message(text("\red [] pupils give an eerie glow!", M),1)
			else //nothing wrong
				flick("flash", M.flash)//flash the affected mob
				if(M!=user)
					user.show_message(text("\blue [] pupils narrow", M),1)
	else
		return ..()


/obj/item/device/flashlight/pickup(mob/user)
	if(on)
		user.ul_SetLuminosity(user.LuminosityRed + brightness_on, user.LuminosityGreen + brightness_on, user.LuminosityBlue)
		src.ul_SetLuminosity(0)


/obj/item/device/flashlight/dropped(mob/user)
	if(on)
		user.ul_SetLuminosity(user.LuminosityRed - brightness_on, user.LuminosityGreen - brightness_on, user.LuminosityBlue)
		src.ul_SetLuminosity(src.LuminosityRed + brightness_on, src.LuminosityGreen + brightness_on, src.LuminosityBlue)


/obj/item/device/flashlight/pen
	name = "penlight"
	desc = "A pen-sized light, used by medical staff."
	icon_state = "penlight"
	item_state = ""
	flags = FPRINT | TABLEPASS | CONDUCT
	brightness_on = 2


// the desk lamps are a bit special
/obj/item/device/flashlight/lamp
	name = "desk lamp"
	desc = "A desk lamp with an adjustable mount."
	icon_state = "lamp"
	item_state = "lamp"
	brightness_on = 5
	w_class = 4
	flags = FPRINT | TABLEPASS | CONDUCT
	m_amt = 0
	g_amt = 0
	on = 1


// green-shaded desk lamp
/obj/item/device/flashlight/lamp/green
	desc = "A classic green-shaded desk lamp."
	icon_state = "lampgreen"
	item_state = "lampgreen"
	brightness_on = 5


/obj/item/device/flashlight/lamp/verb/toggle_light()
	set name = "Toggle light"
	set category = "Object"
	set src in oview(1)

	if(!usr.stat)
		attack_self(usr)

// FLARES

/obj/item/device/flashlight/flare
	name = "flare"
	desc = "A red Nanotrasen issued flare. There are instructions on the side, it reads 'pull cord, make light'."
	w_class = 2.0
	brightness_on = 7 // Pretty bright.
	icon_state = "flare"
	item_state = "flare"
	icon_action_button = null	//just pull it manually, neckbeard.
	var/fuel = 0
	var/on_damage = 7
	var/produce_heat = 1500

/obj/item/device/flashlight/flare/New()
	fuel = rand(800, 1000) // Sorry for changing this so much but I keep under-estimating how long X number of ticks last in seconds.
	..()

/obj/item/device/flashlight/flare/process()
	var/turf/pos = get_turf(src)
	if(pos)
		pos.hotspot_expose(produce_heat, 5)
	fuel = max(fuel - 1, 0)
	if(!fuel || !on)
		turn_off()
		if(!fuel)
			src.icon_state = "[initial(icon_state)]-empty"
		processing_objects -= src

/obj/item/device/flashlight/flare/proc/turn_off()
	on = 0
	src.force = initial(src.force)
	src.damtype = initial(src.damtype)
	if(ismob(loc))
		var/mob/U = loc
		update_brightness(U)
	else
		update_brightness(null)

/obj/item/device/flashlight/flare/attack_self(mob/user)

	// Usual checks
	if(!fuel)
		user << "<span class='notice'>It's out of fuel.</span>"
		return
	if(on)
		return

	. = ..()
	// All good, turn it on.
	if(.)
		user.visible_message("<span class='notice'>[user] activates the flare.</span>", "<span class='notice'>You pull the cord on the flare, activating it!</span>")
		src.force = on_damage
		src.damtype = "fire"
		processing_objects += src