//Jarlocode here.
/obj/item/weapon/gun/table
	name = "table launcher"
	icon = 'icons/obj/craft.dmi'
	icon_state = "t1"
	w_class = 4.0
	throw_speed = 2
	throw_range = 10
	force = 5.0
	var/list/tables = new/list()
	var/max_tables = 3
	var/started = 0
	var/busy = 0 //Starting shit
	var/max_fuel = 100
	proc/get_fuel()
		return reagents.get_reagent_amount("fuel")
	examine()
		set src in view()
		..()
		if (!(usr in view(2)) && usr!=src.loc) return
		usr << "\icon [src] Table launcher:"
		usr << "\blue [tables.len] / [max_tables] Tables."
		usr << "\blue [get_fuel()] / [max_fuel] units of fuel."


	New()
		var/datum/reagents/R = new/datum/reagents(max_fuel)
		reagents = R
		R.my_atom = src
		R.add_reagent("fuel", max_fuel)
		return


	attackby(obj/item/I as obj, mob/user as mob)
		if((istype(I, /obj/item/weapon/table_parts/)) || (istype(I, /obj/item/weapon/table_parts/reinforced)) || (istype(I, /obj/item/weapon/table_parts/wood)))
			if(tables.len < max_tables)
				user.drop_item()
				I.loc = src
				tables += I
				user << "\blue You put the [I.name] in the grenade launcher."
				user << "\blue [tables.len] / [max_tables] Tables."
			else
				usr << "\red The table launcher cannot hold more tables."


	proc/remove_fuel()	//HELL YEAH!
		sleep(40)
		if (started == 0) return
		if(get_fuel() > 4)
			reagents.remove_reagent("fuel", 5)
			remove_fuel()
		else
			for(var/mob/O in viewers(world.view, usr))
				O.show_message(text("\red Table launcher shut downs."), 1)
				started = 0
				icon_state = "t1"

	attack_self(mob/user as mob,var/shutdown = 0)
		if (busy == 1) return
		busy = 1
		if (started == 0)
			var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread	//EFFECTS!
			s.set_up(5, 1, src)
			s.start()
			flick("t2", src)
			if(do_after(user,15))
				usr << "<b>Wrrrrrum</b>"
			var/fail = rand(1,3)
			if (fail == 1)
				icon_state = "t3"
				started = 1
				for(var/mob/O in viewers(world.view, user))
					O.show_message(text("\blue [] starts a table launcher.", user), 1)								//YAY!
				if(get_fuel() > 4)
					sleep(15)	//Don't shut down when u start it.
					busy = 0
					remove_fuel()
				else
					for(var/mob/O in viewers(world.view, user))
						O.show_message(text("\red ... But its hasn't fuel."), 1)
					started = 0
					icon_state = "t1"
					busy = 0
			else
				for(var/mob/O in viewers(world.view, user))
					O.show_message(text("\red [] failed to start a table launcher.", user), 1)	//FAIL!
					busy = 0
		else
			sleep(3)
			for(var/mob/O in viewers(world.view, user))
				O.show_message(text("\blue [] shut down a table launcher.", user), 1)
				started = 0
				icon_state = "t1"
		busy = 0


	afterattack(obj/target, mob/user , flag)

		if (istype(target, /obj/structure/reagent_dispensers/fueltank) && get_dist(src,target) <= 1)
			if (src.started == 1)
				usr << "\red Shut down your launcher first."
				return
			else
				target.reagents.trans_to(src, max_fuel)
				user << "\blue Launcher refueled."
				playsound(src.loc, 'sound/effects/refill.ogg', 50, 1, -6)
				return

		if (istype(target, /obj/item/weapon/storage/backpack ))
			return

		else if (locate (/obj/structure/table, src.loc))

			return

		else if(target == user)
			return

		if(tables.len)
			if (started == 0) return
			if(get_fuel() > 15)
				reagents.remove_reagent("fuel", 15)
			else
				usr << "\red The table launcher hasn't fuel!"
				return
			spawn(0) fire_table(target,user)
		else
			usr << "\red The table launcher is empty."

	proc
		fire_table(atom/target, mob/user)
			for(var/mob/O in viewers(world.view, user))
				O.show_message(text("\red [] fired a table!", user), 1)
			user << "\red You fire the table launcher!"
			var/obj/item/weapon/table_parts/F = tables[1]
			tables -= F
			F.loc = user.loc
			F.throw_at(target, 30, 2)
			log_game("[key_name_admin(user)] used a table ([src.name]).")
			playsound(user.loc, 'sound/weapons/Gunshot.ogg', 50, 1)
			for (var/mob/living/carbon/human/H in F.loc)
				H.Stun(3)
				H.Weaken(3)
				H.apply_damage(10, BRUTE)
			sleep(5)
			F.icon_state = 0
			switch(F.tabletype)
				if (1)
					new /obj/structure/table/( get_turf(F.loc), 2 )
				if (2)
					new /obj/structure/table/reinforced( get_turf(F.loc), 2 )
				if (3)
					new /obj/structure/table/woodentable( get_turf(F.loc), 2 )
			del(F)

/obj/item/weapon/table_parts/			//Bug'fix
	var/tabletype = 1
/obj/item/weapon/table_parts/reinforced/
	tabletype = 2
/obj/item/weapon/table_parts/wood/
	tabletype = 3