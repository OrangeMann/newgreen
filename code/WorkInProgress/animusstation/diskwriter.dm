/obj/item/weapon/disk/music
	icon = 'icons/obj/cloning.dmi'
	icon_state = "datadisk2"
	item_state = "card-id"
	w_class = 1.0

	var/datum/turntable_soundtrack/data

/obj/machinery/party/musicwriter
	name = "Music writer"
	icon = 'icons/obj/objects.dmi'
	icon_state = "off"
	var/obj/item/weapon/disk/music/disk

/obj/machinery/party/musicwriter/attackby(obj/O, mob/user)
	if(istype(O, /obj/item/weapon/disk/music))
		if(!disk)
			user.drop_item()
			O.loc = src
			disk = O

/obj/machinery/party/musicwriter/attack_hand(mob/user)
	var/dat = ""
	if(!disk)
		dat += "Please insert disk"
	else
		dat += "<A href='?src=\ref[src];eject=1'>Eject disk</A>"
		if(disk.data)
			dat += "<BR>Data: [disk.data.f_name][disk.data.name]"
		else
			dat += "<BR><A href='?src=\ref[src];write=1'>Write to disk</A>"

	user << browse(dat, "window=musicwriter;size=450x700")
	onclose(user, "onclose")
	return

/obj/machinery/party/musicwriter/Topic(href, href_list)
	if(href_list["eject"])
		if(disk)
			disk.loc = src.loc
			disk = null
	else if(href_list["write"])
		if(disk)
			icon_state = "on"
			var/sound/S = input("Your music") as sound|null
			var/N = sanitize_russian(input("Name of music") as text|null)
			var/datum/turntable_soundtrack/T = new()
			if(S && N && !disk.data)
				T.path = S
				T.sound = sound(S)
				T.f_name = copytext(N, 1, 2)
				T.name = copytext(N, 2)
				disk.data = T
				disk.name = "disk ([N])"
				var/mob/M = usr
				message_admins("[M.real_name]([M.ckey]) uploaded <A HREF='?_src_=holder;listensound=\ref[T.sound]'>sound</A>")
			icon_state = "off"
