/obj/item/weapon/reagent_containers/backpack
	icon = 'icons/obj/storage.dmi'

	slot_flags = SLOT_BACK
	w_class = 4
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(1, 5, 10, 25, 50, 100)
	volume = 500


/obj/item/weapon/reagent_containers/backpack/weld
	name = "welding kit"
	desc = "A heavy-duty portable welding fuel carrier."
	icon_state = "welderpack"

/obj/item/weapon/reagent_containers/weldpack/New()
	..()
	reagents.add_reagent("fuel", volume)

/obj/item/weapon/reagent_containers/weldpack/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/weldingtool))
		var/obj/item/weapon/weldingtool/T = W
		if(T.welding)
			message_admins("[key_name_admin(user)] triggered a welding kit explosion.")
			log_game("[key_name(user)] triggered a welding kit explosion.")
			user << "\red That was stupid of you."
			explosion(get_turf(src),-1,0,2)
			if(src)
				del(src)
			return
		else
			src.reagents.trans_to(W, T.max_fuel)
			user << "\blue Welder refilled!"
			playsound(src.loc, 'refill.ogg', 50, 1, -6)
			return
	..()