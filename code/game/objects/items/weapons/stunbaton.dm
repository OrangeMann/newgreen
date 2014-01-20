/obj/item/weapon/melee/baton
	name = "stun baton"
	desc = "A stun baton for incapacitating people with."
	icon_state = "stunbaton"
	item_state = "baton"
	flags = FPRINT | TABLEPASS
	slot_flags = SLOT_BELT
	force = 10
	throwforce = 7
	w_class = 3
	var/charges = 10
	var/status = 0
	var/mob/foundmob = "" //Used in throwing proc.

	origin_tech = "combat=2"

	suicide_act(mob/user)
		viewers(user) << "\red <b>[user] is putting the live [src.name] in \his mouth! It looks like \he's trying to commit suicide.</b>"
		return (FIRELOSS)

/obj/item/weapon/melee/baton/update_icon()
	if(status)
		icon_state = "stunbaton_active"
	else
		icon_state = "stunbaton"

/obj/item/weapon/melee/baton/attack_self(mob/user as mob)
	if(status && (CLUMSY in user.mutations) && prob(50))
		user << "\red You grab the [src] on the wrong side."
		user.Weaken(30)
		charges--
		if(charges < 1)
			status = 0
			update_icon()
		return
	if(charges > 0)
		status = !status
		user << "<span class='notice'>\The [src] is now [status ? "on" : "off"].</span>"
		playsound(src.loc, "sparks", 75, 1, -1)
		update_icon()
	else
		status = 0
		user << "<span class='warning'>\The [src] is out of charge.</span>"
	add_fingerprint(user)

/obj/item/weapon/melee/baton/attack(mob/M as mob, mob/user as mob)
	if(status && (CLUMSY in user.mutations) && prob(50))
		user << "<span class='danger'>You accidentally hit yourself with the [src]!</span>"
		user.Weaken(30)
		charges--
		if(charges < 1)
			status = 0
			update_icon()
		return

	var/mob/living/carbon/human/H = M
	if(isrobot(M))
		..()
		return

	//Some text don't want to display text macro "\himself"
	var/gender_text =""
	if (user.gender == MALE)
		gender_text = "himself"
	else //i.e. female
		gender_text = "herself"

	if(user.a_intent == "hurt")
		if(!..()) return
		//H.apply_effect(5, WEAKEN, 0)
		if(H != user)
			H.visible_message("<span class='danger'>[M] has been beaten with the [src] by [user]!</span>")

			user.attack_log += "\[[time_stamp()]\]<font color='red'> Beat [H.name] ([H.ckey]) with [src.name]</font>"
			H.attack_log += "\[[time_stamp()]\]<font color='orange'> Beaten by [user.name] ([user.ckey]) with [src.name]</font>"

			//log_admin("ATTACK: [user] ([user.ckey]) attacked [M] ([M.ckey]) with [src].")
			message_admins("ATTACK: [user] ([user.ckey])(<A HREF='?src=%admin_ref%;adminplayerobservejump=\ref[user]'>JMP</A>) attacked [M] ([M.ckey]) with [src].", 0)
			log_attack("[user.name] ([user.ckey]) attacked [M.name] ([M.ckey]) with [src.name] (INTENT: [uppertext(user.a_intent)])")
		else
			user.visible_message("<span class='danger'>[user] has been beaten with the [src] by [gender_text]!</span>")

			user.attack_log += "\[[time_stamp()]\]<font color='red'> Beat [H.name] ([H.ckey]) with [src.name]</font>"

			//log_admin("ATTACK: [user] ([user.ckey]) attacked [M] ([M.ckey]) with [src].")
			message_admins("ATTACK: [user] ([user.ckey])(<A HREF='?src=%admin_ref%;adminplayerobservejump=\ref[user]'>JMP</A>) attacked [gender_text] with [src].", 0)
			log_attack("[user.name] ([user.ckey]) attacked [gender_text] with [src.name] (INTENT: [uppertext(user.a_intent)])")

		playsound(src.loc, "swing_hit", 50, 1, -1)
	else if(!status)
		if(H != user)
			H.visible_message("<span class='warning'>[M] has been prodded with the [src] by [user]. Luckily it was off.</span>")
		else
			user.visible_message("<span class='warning'>[user] has been prodded with the [src] by [gender_text]. Luckily it was off.</span>")
		return

	if(status)
		H.apply_effect(10, STUN, 0)
		H.apply_effect(10, WEAKEN, 0)
		H.apply_effect(10, STUTTER, 0)
		user.lastattacked = M
		H.lastattacker = user
		if(isrobot(src.loc))
			var/mob/living/silicon/robot/R = src.loc
			if(R && R.cell)
				R.cell.use(50)
		else
			charges--
		if(H != user)
			H.visible_message("<span class='danger'>[M] has been stunned with the [src] by [user]!</span>")

			user.attack_log += "\[[time_stamp()]\]<font color='red'> Stunned [H.name] ([H.ckey]) with [src.name]</font>"
			H.attack_log += "\[[time_stamp()]\]<font color='orange'> Stunned by [user.name] ([user.ckey]) with [src.name]</font>"
			message_admins("ATTACK: [user] ([user.ckey])(<A HREF='?src=%admin_ref%;adminplayerobservejump=\ref[user]'>JMP</A>) stunned [H.name] ([H.ckey]) with [src].", 0)
			log_attack("[user.name] ([user.ckey]) stunned [H.name] ([H.ckey]) with [src.name]")
		else
			user.visible_message("<span class='danger'>[user] has been stunned with the [src] by [gender_text]!</span>")

			user.attack_log += "\[[time_stamp()]\]<font color='red'> Stunned [gender_text] with [src.name]</font>"
			message_admins("ATTACK: [user] ([user.ckey])(<A HREF='?src=%admin_ref%;adminplayerobservejump=\ref[user]'>JMP</A>) stunned [gender_text] with [src].", 0)
			log_attack("[user.name] ([user.ckey]) stunned [gender_text] with [src.name]")

		playsound(src.loc, 'sound/weapons/Egloves.ogg', 50, 1, -1)
		if(charges < 1)
			status = 0
			update_icon()

	add_fingerprint(user)

/obj/item/weapon/melee/baton/throw_impact(atom/hit_atom)
	if (prob(50))
		if(istype(hit_atom, /mob/living))
			var/mob/living/carbon/human/H = hit_atom
			if(status)
				H.apply_effect(10, STUN, 0)
				H.apply_effect(10, WEAKEN, 0)
				H.apply_effect(10, STUTTER, 0)
				charges--

				for(var/mob/M in player_list) if(M.key == src.fingerprintslast)
					foundmob = M
					break

				H.visible_message("<span class='danger'>[src], thrown by [foundmob.name], strikes [H] and stuns them!</span>")

				H.attack_log += "\[[time_stamp()]\]<font color='orange'> Stunned by thrown [src.name] last touched by ([src.fingerprintslast])</font>"
				log_attack("Flying [src.name], last touched by ([src.fingerprintslast]) stunned [H.name] ([H.ckey])" )

				return
	return ..()

/obj/item/weapon/melee/baton/emp_act(severity)
	switch(severity)
		if(1)
			charges = 0
		if(2)
			charges = max(0, charges - 5)
	if(charges < 1)
		status = 0
		update_icon()
