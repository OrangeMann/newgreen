/obj/screen
	name = ""
	icon = 'icons/mob/screen1.dmi'
	layer = 20.0
	unacidable = 1
	var/id = 0.0
	var/obj/master
	var/gun_click_time = -100 //I'm lazy.

/obj/screen/text
	icon = null
	icon_state = null
	mouse_opacity = 0
	screen_loc = "CENTER-7,CENTER-7"
	maptext_height = 480
	maptext_width = 480

/obj/screen/inventory
	var/slot_id

/obj/screen/close
	name = "close"
	master = null

/obj/screen/close/DblClick()
	if (src.master)
		src.master:close(usr)
	return

/obj/screen/item_action
	var/obj/item/owner

/obj/screen/item_action/DblClick()
	if(!usr || !owner)
		return

	if(usr.stat || usr.restrained() || usr.stunned || usr.lying)
		return

	if(!(owner in usr))
		return

	spawn()
		owner.ui_action_click()
		switch(owner.icon_action_button)
			if("action_hardhat", "action_welding")
				usr.update_inv_head()
			if("action_welding_g")
				usr.update_inv_glasses()
			if("action_jetpack")
				usr.update_inv_back()

//This is the proc used to update all the action buttons. It just returns for all mob types except humans.
/mob/proc/update_action_buttons()
	return

/obj/screen/grab
	name = "grab"
	master = null

/obj/screen/storage
	name = "storage"
	master = null

/obj/screen/storage/attack_hand(mob/user)
	if(master)
		var/obj/item/I = user.get_active_hand()
		if(I)
			master.attackby(I, user)
		else
			master.attack_hand(user)

/obj/screen/zone_sel
	name = "Damage Zone"
	icon = 'icons/mob/screen1.dmi'
	icon_state = "zone_sel"
	var/selecting = "chest"
	screen_loc = ui_zonesel
/*
/obj/screen/gun
	name = "gun"
	icon = 0
	master = null
	dir = 2
	icon_state = 0

	move
		name = "Allow Walking"
//		icon_state = "no_walk0"
		screen_loc = ui_gun2

	run
		name = "Allow Running"
//		icon_state = "no_run0"
		screen_loc = ui_gun3

	item
		name = "Allow Item Use"
//		icon_state = "no_item0"
		screen_loc = ui_gun1

	mode
		name = "Toggle Gun Mode"
		icon_state = 0
		screen_loc = ui_gun_select
		//dir = 1
*/

/obj/screen/zone_sel/MouseDown(location, control,params)
	// Changes because of 4.0
	var/list/PL = params2list(params)
	var/icon_x = text2num(PL["icon-x"])
	var/icon_y = text2num(PL["icon-y"])

	if (icon_y < 2)
		return
	else if (icon_y < 5)
		if ((icon_x > 9 && icon_x < 23))
			if (icon_x < 16)
				selecting = "r_foot"
			else
				selecting = "l_foot"
	else if (icon_y < 11)
		if ((icon_x > 11 && icon_x < 21))
			if (icon_x < 16)
				selecting = "r_leg"
			else
				selecting = "l_leg"
	else if (icon_y < 12)
		if ((icon_x > 11 && icon_x < 21))
			if (icon_x < 14)
				selecting = "r_leg"
			else if (icon_x < 19)
				selecting = "groin"
			else
				selecting = "l_leg"
		else
			return
	else if (icon_y < 13)
		if ((icon_x > 7 && icon_x < 25))
			if (icon_x < 12)
				selecting = "r_hand"
			else if (icon_x < 13)
				selecting = "r_leg"
			else if (icon_x < 20)
				selecting = "groin"
			else if (icon_x < 21)
				selecting = "l_leg"
			else
				selecting = "l_hand"
		else
			return
	else if (icon_y < 14)
		if ((icon_x > 7 && icon_x < 25))
			if (icon_x < 12)
				selecting = "r_hand"
			else if (icon_x < 21)
				selecting = "groin"
			else
				selecting = "l_hand"
		else
			return
	else if (icon_y < 16)
		if ((icon_x > 7 && icon_x < 25))
			if (icon_x < 13)
				selecting = "r_hand"
			else if (icon_x < 20)
				selecting = "chest"
			else
				selecting = "l_hand"
		else
			return
	else if (icon_y < 23)
		if ((icon_x > 7 && icon_x < 25))
			if (icon_x < 12)
				selecting = "r_arm"
			else if (icon_x < 21)
				selecting = "chest"
			else
				selecting = "l_arm"
		else
			return
	else if (icon_y < 24)
		if ((icon_x > 11 && icon_x < 21))
			selecting = "chest"
		else
			return
	else if (icon_y < 25)
		if ((icon_x > 11 && icon_x < 21))
			if (icon_x < 16)
				selecting = "head"
			else if (icon_x < 17)
				selecting = "mouth"
			else
				selecting = "head"
		else
			return
	else if (icon_y < 26)
		if ((icon_x > 11 && icon_x < 21))
			if (icon_x < 15)
				selecting = "head"
			else if (icon_x < 18)
				selecting = "mouth"
			else
				selecting = "head"
		else
			return
	else if (icon_y < 27)
		if ((icon_x > 11 && icon_x < 21))
			if (icon_x < 15)
				selecting = "head"
			else if (icon_x < 16)
				selecting = "eyes"
			else if (icon_x < 17)
				selecting = "mouth"
			else if (icon_x < 18)
				selecting = "eyes"
			else
				selecting = "head"
		else
			return
	else if (icon_y < 28)
		if ((icon_x > 11 && icon_x < 21))
			if (icon_x < 14)
				selecting = "head"
			else if (icon_x < 19)
				selecting = "eyes"
			else
				selecting = "head"
		else
			return
	else if (icon_y < 29)
		if ((icon_x > 11 && icon_x < 21))
			if (icon_x < 15)
				selecting = "head"
			else if (icon_x < 16)
				selecting = "eyes"
			else if (icon_x < 17)
				selecting = "head"
			else if (icon_x < 18)
				selecting = "eyes"
			else
				selecting = "head"
		else
			return
	else if (icon_y < 31)
		if ((icon_x > 11 && icon_x < 21))
			selecting = "head"
		else
			return
	else
		return

	overlays.Cut()
	overlays += image('icons/mob/zone_sel.dmi', "[selecting]")

	return

/obj/screen/grab/Click()
	master:s_click(src)
	return

/obj/screen/grab/DblClick()
	master:s_dbclick(src)
	return

/obj/screen/grab/attack_hand()
	return

/obj/screen/grab/attackby()
	return

/*
/obj/screen/MouseEntered(object,location,control,params)
	if(!ishuman(usr) && !istype(usr,/mob/living/carbon/alien/humanoid) && !islarva(usr) && !ismonkey(usr))
		return
	switch(name)
		if("act_intent")
			if(ishuman(usr) || istype(usr,/mob/living/carbon/alien/humanoid) || islarva(usr))
				usr.hud_used.action_intent.icon_state = "intent_[usr.a_intent]"

/obj/screen/MouseExited(object,location,control,params)
	if(!ishuman(usr) && !istype(usr,/mob/living/carbon/alien/humanoid) && !islarva(usr) && !ismonkey(usr))
		return
	switch(name)
		if("act_intent")
			if(ishuman(usr) || istype(usr,/mob/living/carbon/alien/humanoid) || islarva(usr))
				var/intent = usr.a_intent
				if(intent == "hurt")
					intent = "harm"	//hurt and harm have different sprite names for some reason.
				usr.hud_used.action_intent.icon_state = "[intent]"
*/

/obj/screen/Click(location, control, params)
	if(!usr)	return
	switch(name)
		if("map")
			usr.clearmap()

		if("other")
			if (usr.hud_used.inventory_shown)
				usr.hud_used.inventory_shown = 0
				usr.client.screen -= usr.hud_used.other
			else
				usr.hud_used.inventory_shown = 1
				usr.client.screen += usr.hud_used.other

			usr.hud_used.hidden_inventory_update()

		if("equip")
			usr.quick_equip()

		if("resist")
			if(isliving(usr))
				var/mob/living/L = usr
				L.resist()

		if("maprefresh")
			var/obj/machinery/computer/security/seccomp = usr.machine

			if(seccomp!=null)
				seccomp.drawmap(usr)
			else
				usr.clearmap()

		if("mov_intent")
			if(iscarbon(usr))
				var/mob/living/carbon/C = usr
				if(C.legcuffed)
					C << "\red You are legcuffed! You cannot run until you get your cuffs removed!"
					C.m_intent = "walk"	//Just incase
					C.hud_used.move_intent.icon_state = "walking"
					return
				switch(usr.m_intent)
					if("run")
						usr.m_intent = "walk"
						usr.hud_used.move_intent.icon_state = "walking"
					if("walk")
						usr.m_intent = "run"
						usr.hud_used.move_intent.icon_state = "running"
				if(istype(usr,/mob/living/carbon/alien/humanoid))	usr.update_icons()
		if("m_intent")
			if (!( usr.m_int ))
				switch(usr.m_intent)
					if("run")
						usr.m_int = "13,14"
					if("walk")
						usr.m_int = "14,14"
					if("face")
						usr.m_int = "15,14"
			else
				usr.m_int = null
		if("walk")
			usr.m_intent = "walk"
			usr.m_int = "14,14"
		if("face")
			usr.m_intent = "face"
			usr.m_int = "15,14"
		if("run")
			usr.m_intent = "run"
			usr.m_int = "13,14"
		if("Reset Machine")
			usr.unset_machine()
		if("internal")
			if (( !usr.stat && !usr.stunned && !usr.paralysis && !usr.restrained() ))
				if (usr.internal)
					usr.internal = null
					usr << "\blue No longer running on internals."
					if (usr.internals)
						usr.internals.icon_state = "internal0"
				else
					if(ishuman(usr))
						if (!( istype(usr.wear_mask, /obj/item/clothing/mask) ))
							usr << "\red You are not wearing a mask"
							return
						else
							if (ishuman(usr) && istype(usr:s_store, /obj/item/weapon/tank))
								usr << "\blue You are now running on internals from [usr:s_store] on your [usr:wear_suit]."
								usr.internal = usr:s_store
							else if (ishuman(usr) && istype(usr:belt, /obj/item/weapon/tank))
								usr << "\blue You are now running on internals from [usr:belt] on your belt."
								usr.internal = usr:belt
							else if (istype(usr:l_store, /obj/item/weapon/tank))
								usr << "\blue You are now running on internals from [usr:l_store] in your left pocket."
								usr.internal = usr:l_store
							else if (istype(usr:r_store, /obj/item/weapon/tank))
								usr << "\blue You are now running on internals from [usr:r_store] in your right pocket."
								usr.internal = usr:r_store
							else if (istype(usr.back, /obj/item/weapon/tank))
								usr << "\blue You are now running on internals from [usr.back] on your back."
								usr.internal = usr.back
							else if (istype(usr.l_hand, /obj/item/weapon/tank))
								usr << "\blue You are now running on internals from [usr.l_hand] on your left hand."
								usr.internal = usr.l_hand
							else if (istype(usr.r_hand, /obj/item/weapon/tank))
								usr << "\blue You are now running on internals from [usr.r_hand] on your right hand."
								usr.internal = usr.r_hand
							if (usr.internal)
								//for(var/mob/M in viewers(usr, 1))
								//	M.show_message(text("[] is now running on internals.", usr), 1)
								if (usr.internals)
									usr.internals.icon_state = "internal1"
							else
								usr << "\blue You don't have an oxygen tank."
		if("act_intent")
			if(issilicon(usr))
				if(usr.a_intent == "help")
					usr.a_intent = "hurt"
					usr.hud_used.action_intent.icon_state = "harm"
				else
					usr.a_intent = "help"
					usr.hud_used.action_intent.icon_state = "help"
			else
				usr.a_intent_change("right")
		if("help")
			usr.a_intent = "help"
			usr.hud_used.action_intent.icon_state = "intent_help"
		if("harm")
			usr.a_intent = "hurt"
			usr.hud_used.action_intent.icon_state = "intent_hurt"
		if("grab")
			usr.a_intent = "grab"
			usr.hud_used.action_intent.icon_state = "intent_grab"
		if("disarm")
			usr.a_intent = "disarm"
			usr.hud_used.action_intent.icon_state = "intent_disarm"
		if("pull")
			usr.stop_pulling()
		if("throw")
			if (!usr.stat && isturf(usr.loc) && !usr.restrained())
				usr:toggle_throw_mode()
		if("drop")
			usr.drop_item_v()
		if("swap")
			usr:swap_hand()
		if("hand")
			usr:swap_hand()
		if("r_hand")
			if(iscarbon(usr))
				var/mob/living/carbon/C = usr
				C.activate_hand("r")
		if("l_hand")
			if(iscarbon(usr))
				var/mob/living/carbon/C = usr
				C.activate_hand("l")
		if("module")
			if(issilicon(usr))
				if(usr:module)
					return
				usr:pick_module()

		if("radio")
			if(issilicon(usr))
				usr:radio_menu()
		if("panel")
			if(issilicon(usr))
				usr:installed_modules()

		if("store")
			if(issilicon(usr))
				usr:uneq_active()

		if("module1")
			if(usr:module_state_1)
				if(usr:module_active != usr:module_state_1)
					usr:inv1.icon_state = "inv1 +a"
					usr:inv2.icon_state = "inv2"
					usr:inv3.icon_state = "inv3"
					usr:module_active = usr:module_state_1
				else
					usr:inv1.icon_state = "inv1"
					usr:module_active = null

		if("module2")
			if(usr:module_state_2)
				if(usr:module_active != usr:module_state_2)
					usr:inv1.icon_state = "inv1"
					usr:inv2.icon_state = "inv2 +a"
					usr:inv3.icon_state = "inv3"
					usr:module_active = usr:module_state_2
				else
					usr:inv2.icon_state = "inv2"
					usr:module_active = null

		if("module3")
			if(usr:module_state_3)
				if(usr:module_active != usr:module_state_3)
					usr:inv1.icon_state = "inv1"
					usr:inv2.icon_state = "inv2"
					usr:inv3.icon_state = "inv3 +a"
					usr:module_active = usr:module_state_3
				else
					usr:inv3.icon_state = "inv3"
					usr:module_active = null

//		if("radar")
//			usr:close_radar()

//		if("radar closed")
//			usr:start_radar()

/*		if("Allow Walking")
			if(gun_click_time > world.time - 30)	//give them 3 seconds between mode changes.
				return
			if(!istype(usr.equipped(),/obj/item/weapon/gun))
				usr << "You need your gun in your active hand to do that!"
				return
			usr.client.AllowTargetMove()
			gun_click_time = world.time

		if("Disallow Walking")
			if(gun_click_time > world.time - 30)	//give them 3 seconds between mode changes.
				return
			if(!istype(usr.equipped(),/obj/item/weapon/gun))
				usr << "You need your gun in your active hand to do that!"
				return
			usr.client.AllowTargetMove()
			gun_click_time = world.time

		if("Allow Running")
			if(gun_click_time > world.time - 30)	//give them 3 seconds between mode changes.
				return
			if(!istype(usr.equipped(),/obj/item/weapon/gun))
				usr << "You need your gun in your active hand to do that!"
				return
			usr.client.AllowTargetRun()
			gun_click_time = world.time

		if("Disallow Running")
			if(gun_click_time > world.time - 30)	//give them 3 seconds between mode changes.
				return
			if(!istype(usr.equipped(),/obj/item/weapon/gun))
				usr << "You need your gun in your active hand to do that!"
				return
			usr.client.AllowTargetRun()
			gun_click_time = world.time

		if("Allow Item Use")
			if(gun_click_time > world.time - 30)	//give them 3 seconds between mode changes.
				return
			if(!istype(usr.equipped(),/obj/item/weapon/gun))
				usr << "You need your gun in your active hand to do that!"
				return
			usr.client.AllowTargetClick()
			gun_click_time = world.time


		if("Disallow Item Use")
			if(gun_click_time > world.time - 30)	//give them 3 seconds between mode changes.
				return
			if(!istype(usr.equipped(),/obj/item/weapon/gun))
				usr << "You need your gun in your active hand to do that!"
				return
			usr.client.AllowTargetClick()
			gun_click_time = world.time

		if("Toggle Gun Mode")
			usr.client.ToggleGunMode()*/

		else
			DblClick()
	return

/obj/screen/inventory/attack_hand(mob/user as mob)
	user.attack_ui(slot_id)
	user.update_inv_l_hand(0)
	user.update_inv_r_hand()
	return

/obj/screen/inventory/attack_paw(mob/user as mob)
	user.attack_ui(slot_id)
	user.update_inv_l_hand(0)
	user.update_inv_r_hand()
	return


/mob/living/carbon/verb/mob_sleep()
	set name = "Sleep"
	set category = "IC"

	if(usr.sleeping)
		usr << "\red You are already sleeping"
		return
	else
		if(alert(src,"You sure you want to sleep for a while?","Sleep","Yes","No") == "Yes")
			usr.sleeping = 20 //Short nap

/mob/living/verb/lay_down()
	set name = "Rest"
	set category = "IC"

	resting = !resting
	src << "\blue You are now [resting ? "resting" : "getting up"]"

/mob/verb/quick_equip()
	set name = "quick-equip"
	set hidden = 1
	var/obj/item/I = usr.get_active_hand()
	if(!I)
		usr << "\blue You are not holding anything to equip."
		return
	if(ishuman(usr))
		var/mob/living/carbon/human/H = usr
		H.equip_to_appropriate_slot(I)
		H.update_inv_l_hand(0)
		H.update_inv_r_hand()