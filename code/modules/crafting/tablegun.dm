//uncommited, yep.
/obj/item/weapon/gun/table
	name = "table launcher"
	icon = 'icons/obj/gun.dmi'
	icon_state = "riotgun"
	item_state = "riotgun"
	w_class = 4.0
	throw_speed = 2
	throw_range = 10
	force = 5.0
	var/list/tables = new/list()
	var/max_tables = 3

	examine()
		set src in view()
		..()
		if (!(usr in view(2)) && usr!=src.loc) return
		usr << "\icon [src] Table launcher:"
		usr << "\blue [tables.len] / [max_tables] Tables."

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

	afterattack(obj/target, mob/user , flag)

		if (istype(target, /obj/item/weapon/storage/backpack ))
			return

		else if (locate (/obj/structure/table, src.loc))
			return

		else if(target == user)
			return

		if(tables.len)
			spawn(0) fire_table(target,user)
		else
			usr << "\red The table launcher is empty."

	proc
		fire_table(atom/target, mob/user)
			for(var/mob/O in viewers(world.view, user))
				O.show_message(text("\red [] fired a table!", user), 1)
			user << "\red You fire the table launcher!"
			var/obj/item/weapon/table_parts/F = tables[1] //Now with less copypasta!
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
			if((istype(F, /obj/item/weapon/table_parts/)))
				new /obj/structure/table/( get_turf(F.loc), 2 )
			if((istype(F, /obj/item/weapon/table_parts/reinforced/)))
				new /obj/structure/table/reinforced( get_turf(F.loc), 2 )
			if((istype(F, /obj/item/weapon/table_parts/wood/)))
				new /obj/structure/table/woodentable( get_turf(F.loc), 2 )

			del(F)