/obj/item/weapon/hardware
	name = "hardware"
	icon = 'icons/obj/module.dmi'
	w_class = 2

	var/obj/machinery/newComputer/M
	var/serial = 10000
	var/can_install = 1

	New()
		..()
		serial = rand(10000, 99999)
		pixel_x = rand(-8, 8)
		pixel_y = rand(-8, 8)

	proc/Connect(var/obj/machinery/newComputer/m)
		M = m

	proc/Disconnect()
		M = null

	proc/Connected()
		if(M)
			return 1
		return 0