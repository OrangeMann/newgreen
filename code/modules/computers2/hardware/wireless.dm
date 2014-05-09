/////////////////////////WIRELESS CONNECTION/////////////////////////////
var/list/wireless_connectors = list()

/obj/item/weapon/hardware/wireless
	name = "wireless card"
	icon_state = "radio_mod"
	var/address = "local"
	var/visible = 1

	New()
		..()
		wireless_connectors.Add(src)

	Del()
		wireless_connectors.Remove(src)
		..()

	Connect(var/obj/machinery/newComputer/m)
		..()
		GenerateAddress()

	Disconnect()
		..()
		address = "local"

	// Remark: prevent recursive looping but im too lazy
	proc/GenerateAddress()
		address = "[rand(1000, 9999)]-[rand(1000, 9999)]"
		for(var/obj/item/weapon/hardware/wireless/con in wireless_connectors)
			if(con.address == address && con != src && con.visible && src.visible)
				GenerateAddress()
				break

	proc/SendSignal(var/datum/connectdata/reciever, var/datum/connectdata/sender, var/list/data)
		if(reciever == null)
			reciever = new /datum/connectdata()
		for(var/obj/item/weapon/hardware/wireless/con in wireless_connectors)
			if(con.address != sender.address)
				con.RecieveSignal(reciever, sender, data)

	// Change this if you want to make coolhacker tool
	proc/RecieveSignal(var/datum/connectdata/reciever, var/datum/connectdata/sender, var/list/data)
		if(reciever.address && reciever.address != src.address)
			return // Refuse Connection
		if(!M.on)
			return
		M.RecieveSignal(reciever, sender, data)

	proc/post_status(var/command, var/data1, var/data2)
		var/datum/radio_frequency/frequency = radio_controller.return_frequency(1435)
		if(!frequency) return

		var/datum/signal/status_signal = new
		status_signal.source = src
		status_signal.transmission_method = 1
		status_signal.data["command"] = command

		switch(command)
			if("message")
				src.post_status("blank")
				sleep(1)
				status_signal.data["msg1"] = data1
				status_signal.data["msg2"] = data2
			if("alert")
				status_signal.data["picture_state"] = data1
		frequency.post_signal(src, status_signal)

/datum/connectdata
	var/address = ""
	var/id = ""

	New(var/a, var/i)
		address = a
		id = i

	proc/ToString()
		return address + ":" + "[id]"



/obj/item/weapon/hardware/wireless/mini
	name = "wireless module"
	icon_state = "radio_mini"

/obj/item/weapon/hardware/wireless/mini/nano
	icon_state = "radio_nano"
	w_class = 1