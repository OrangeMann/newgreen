//Android surgery

//Panel: Lock, unlock, close, open. First step of android surgery. Almost only
var/panel_is_locked = 1
var/panel_is_closed = 0

proc/mob/living/carbon/human/android/try_to_open_panel()
	if(panel_is_closed == 1)
		usr << "\red Panel is already open."
		return
	else
		usr << "\blue You try to open the cover."
		usr.visible_message("\red [usr] tries to open panel of android!")
		sleep(75)
		if(prob(50)) //50% to unlock this fucking panel.
			usr << "\blue You open the cover!"
			panel_is_closed = 0
		else
			usr << "\red You try to open the cover, but panel is still closed."
			panel_is_locked = 1

proc/mob/living/carbon/human/android/close_panel()
		usr << "\blue You close the panel."
		panel_is_closed = 1

/obj/item/weapon/crowbar/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
		if(istype(M,/mob/living/carbon/human/android/))
				if(panel_is_locked == 1)
						usr << "\red Panel is locked!"
						return
				else
						if(panel_is_closed == 1)
								try_to_open_panel()
						else
								close_panel()
		else
				..()


proc/mob/living/carbon/human/android/try_to_unlock() // true hacker.
		usr << "\blue You try to pass the code to unlock the panel. Wait..."
		sleep(120)
		usr << "\blue You get the code of first line of security system. Wait..."
		sleep(260)
		usr << "\blue You get access to second line of security system. Wait..."
		sleep(340)
		usr << "\blue You almost unlock the panel! Wait..."
		sleep(100)
		usr << "\blue Now! You disable all security protocols./red Try to open panel!"
		panel_is_locked = 0

proc/mob/living/carbon/human/android/try_to_lock()
		usr << "\red You lock the panel."
		if(panel_is_closed == 1)
				panel_is_locked = 1
		else
				usr <<"\red Close panel first!"
				return


/obj/item/device/multitool/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
		if(istype(M,/mob/living/carbon/human/android/))
				if(panel_is_locked == 1)
						try_to_unlock()
				else
						try_to_lock()
		else
				..()


//Screw the panel of modules. Watching for modules and install it.

//Cyberheart.

//