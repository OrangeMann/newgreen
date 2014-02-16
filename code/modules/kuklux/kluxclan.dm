/obj/item/weapon/bedsheet/attackby(obj/item/O as obj, mob/user as mob)
	if(istype(O, /obj/item/weapon/shard) || istype(O, /obj/item/weapon/kitchenknife) || istype(O, /obj/item/weapon/scalpel))
		usr << "You start cutting bedsheet..."
		if(do_after(user, 30))
			new /obj/item/clothing/head/kkc( get_turf(usr.loc), 2 )
			usr << "\blue You make a Klux Clan mask!"
			user.visible_message("\red [user] cut bedsheet into mask.")
			del(src)
		return
	..()