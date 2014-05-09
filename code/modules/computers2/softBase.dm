//There is soft vars and methods declaration
//Use this to make new soft easy
/datum/file
	var/name = "default datafile"
	var/size = 1
	var/obj/machinery/newComputer/M

	//Connecting with main
	proc/Connect(var/obj/machinery/newComputer/m)
		M = m

	//Disconnect to prevent using programms when hdd is disconnected
	proc/Disconnect()
		M = null

	proc/Connected()
		if(M)
			return 1
		return 0

	proc/GetName()
		return name

	//Create new instance of soft
	//Return: new same type object
	proc/Copy()
		var/datum/file/F = new type()
		F.name = name
		F.size = size
		return F


/datum/file/software
	name = "default software"
	var/display_icon = "command"
	var/id = ""

	Connect(var/obj/machinery/newComputer/m)
		..()
		GenerateID()

	Disconnect()
		..()
		id = null

	proc/RecvDisk(var/obj/item/weapon/hardware/memory/disk, var/data = "")
		return

	proc/RecvFile(var/datum/file/F, var/data = "")
		return

	//Output. Used in computer
	//Return: string of display you want
	proc/Display(var/mob/user)
		return ""

	//Menu controls.
	Topic(href, href_list)
		if(!M)					return 1
		if(M.SecurityAlert())	return 1
		return

	//Network. This stuff will catch global request after processing in connector
	proc/Request(var/datum/connectdata/sender, var/list/data)
		return

	//Check of required hardware before launch
	//Return: 0 if ready or string of problem
	proc/Requirements()
		if(M && (src in M.GetAllData()))
			return 0
		return 1 // Not in PC? Shutdown!

	//Events
	proc/OnStart()
		return

	proc/OnExit()
		return

	//Called by computer every processing tick
	proc/Update()
		return

	//Called by auth so we know we have auth
	proc/LoginChange()
		if(!M) return
		if(Requirements())
			M.CloseApp()

	//Called by computer so we DON'T know we have or not any hardware
	proc/HardwareChange()
		if(!M) return
		if(Requirements())
			M.CloseApp()

	///////////////////////////////////////////
	//Don't change this stuff without necessity

	//Update window
	proc/updateUsrDialog()
		M.updateUsrDialog()

	proc/UpdateScreen()
		M.update_icon()

	//Unique local ID
	//Edit by: Editor TEH Chaos-neutral
	proc/GenerateID()
		var/idlist = list()
		for (var/datum/file/software/soft in M.GetAllData())
			if (soft != src)
				idlist += soft.id
		var/newid = rand(1000, 9999)
		while (newid in idlist)
			newid = rand(1000, 9999)
		id = newid

	//ID and IP
	proc/GlobalAddress()
		if(!M.NetworkTrouble())
			return new /datum/connectdata(M.connector.address, id)
		return new /datum/connectdata("Local", id)

	///////////////////////////////////////////

/datum/file/software/app
	var/list/required_access = list() //Not a req_one_access cause we have own auth sys
	var/required_sys = /datum/file/software/os

	proc/Exit()
		M.sys.Close()

	proc/Auth() // Access check!
		if(!M)
			return 0
		if(M.AuthTrouble())
			return 0
		return M.auth.CheckAccess(required_access)

	Copy()
		var/datum/file/software/app/A = ..()
		A.required_access = required_access.Copy()
		return A

	GetName()
		return text2programname(name + ".bin")