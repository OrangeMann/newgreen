/datum/file/software/os
	name = "Default OS"
	size = 10
	display_icon = "ai-fixer"
	var/obj/item/weapon/hardware/memory/current_disk
	var/list/lastlogs[5]
	var/list/logs = list()
	var/corrupted = 0 // prob of falling into BSOD

	OnStart()
		..()
		if(prob(corrupted))
			M.BSOD()

	Connect(var/obj/machinery/newComputer/M)
		..()
		for(var/i = 1; i <= 5; i++)
			lastlogs[i] = ""

		current_disk = M.sysdisk

	Copy()
		var/datum/file/software/os/O = ..()
		O.corrupted = corrupted
		O.lastlogs = lastlogs.Copy()
		O.logs = logs.Copy()

		return O

	proc/AddLogs(var/text)
		for(var/i = 5; i >= 2; i--)
			lastlogs[i] = lastlogs[i - 1]
		lastlogs[1] = text
		logs += text

	proc/GetIconName()
		return display_icon

	proc/Run(var/datum/file/software/soft)
		return

	proc/Close()
		return