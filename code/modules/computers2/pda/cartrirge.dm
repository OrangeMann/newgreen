/obj/item/weapon/hardware/memory/cart
	name = "generic cartridge"
	desc = "A data cartridge for portable Thinktronic microcomputers."
	var/cart_name = "Thinktronic TK12"
	var/list/hardware = list()
	icon = 'icons/obj/pda.dmi'
	icon_state = "cart"
	item_state = "electronic"
	w_class = 1

	total_memory = 10
	current_free_space = 10
	can_install = 0

	GetName()
		return cart_name

/obj/item/weapon/hardware/memory/reader/cart
	name = "cartridge connector"
	icon_state = "cart_connector"
	disk_type = /obj/item/weapon/hardware/memory/cart
	w_class = 1

	GetName()
		if(!IsReady())
			return "--------"
		else
			return disk.GetName()

	Disconnect()
		..()
		Eject()