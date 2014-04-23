/datum/admins/proc/BDB_unban(var/banfolder)//Byond DataBase
	if(!check_rights(R_BAN))	return

	Banlist.cd = "/base/[banfolder]"
	var/key = Banlist["key"]
	if(alert(usr, "Are you sure you want to unban [key]?", "Confirmation", "Yes", "No") == "Yes")
		if(!RemoveBan(banfolder))
			alert(usr, "This ban has already been lifted / does not exist.", "Error", "Ok")
		unbanpanel()

/datum/admins/proc/BDB_ban_edit(var/banfolder)
	if(!check_rights(R_BAN))	return
	UpdateTime()

	Banlist.cd = "/base/[banfolder]"

	var/reason2 = Banlist["reason"]
	var/temp = Banlist["temp"]
	var/minutes = Banlist["minutes"]
	var/banned_key = Banlist["key"]

	var/reason
	var/duration

	switch(alert("Temporary Ban?",,"Yes","No"))
		if("Yes")
			temp = 1
			var/mins = 0
			if(minutes > CMinutes)
				mins = minutes - CMinutes
			mins = input(usr,"How long (in minutes)? (Default: 1440)","Ban time",mins ? mins : 1440) as num|null
			if(!mins)	return
			mins = min(525599,mins)
			minutes = CMinutes + mins
			duration = GetExp(minutes)
			reason = input(usr,"Reason?","reason",reason2) as text|null
			if(!reason)	return
		if("No")
			temp = 0
			duration = "Perma"
			reason = input(usr,"Reason?","reason",reason2) as text|null
			if(!reason)	return

	log_admin("[key_name(usr)] edited [banned_key]'s ban. Reason: [reason] Duration: [duration]")
	ban_unban_log_save("[key_name(usr)] edited [banned_key]'s ban. Reason: [reason] Duration: [duration]")
	message_admins("\blue [key_name_admin(usr)] edited [banned_key]'s ban. Reason: [reason] Duration: [duration]", 1)
	Banlist.cd = "/base/[banfolder]"
	Banlist["reason"] << reason
	Banlist["temp"] << temp
	Banlist["minutes"] << minutes
	Banlist["bannedby"] << usr.ckey
	Banlist.cd = "/base"
	feedback_inc("ban_edit",1)
	unbanpanel()

/datum/admins/proc/jobban_from(var/mob/M, var/list/jobs)
	switch(alert("Temporary Ban?",,"Yes","No", "Cancel"))
		if("Yes")
			var/mins = input(usr,"How long (in minutes)?","Ban time",1440) as num|null
			if(!mins)
				return
			var/reason = sanitize(input(usr,"Reason?","Please State Reason","") as text|null)
			if(!reason)
				return

			var/msg
			for(var/job in jobs)
				ban_unban_log_save("[key_name(usr)] temp-jobbanned [key_name(M)] from [job] for [mins] minutes. reason: [reason]")
				log_admin("[key_name(usr)] temp-jobbanned [key_name(M)] from [job] for [mins] minutes")
				feedback_inc("ban_job_tmp",1)
				DB_ban_record(BANTYPE_JOB_TEMP, M, mins, reason, job)
				feedback_add_details("ban_job_tmp","- [job]")
				jobban_fullban(M, job, "[reason]; By [usr.ckey] on [time2text(world.realtime)]") //Legacy banning does not support temporary jobbans.
				if(!msg)
					msg = job
				else
					msg += ", [job]"
			notes_add(M.ckey, "Banned  from [msg] - [reason]")
			message_admins("\blue [key_name_admin(usr)] banned [key_name_admin(M)] from [msg] for [mins] minutes", 1)
			M << "\red<BIG><B>You have been jobbanned by [usr.client.ckey] from: [msg].</B></BIG>"
			M << "\red <B>The reason is: [reason]</B>"
			M << "\red This jobban will be lifted in [mins] minutes."
		if("No")
			var/reason = sanitize(input(usr,"Reason?","Please State Reason","") as text|null)
			if(!reason)
				return

			var/msg
			for(var/job in jobs)
				ban_unban_log_save("[key_name(usr)] perma-jobbanned [key_name(M)] from [job]. reason: [reason]")
				log_admin("[key_name(usr)] perma-banned [key_name(M)] from [job]")
				feedback_inc("ban_job",1)
				DB_ban_record(BANTYPE_JOB_PERMA, M, -1, reason, job)
				feedback_add_details("ban_job","- [job]")
				jobban_fullban(M, job, "[reason]; By [usr.ckey] on [time2text(world.realtime)]")
				if(!msg)	msg = job
				else		msg += ", [job]"
			notes_add(M.ckey, "Banned  from [msg] - [reason]")
			message_admins("\blue [key_name_admin(usr)] banned [key_name_admin(M)] from [msg]", 1)
			M << "\red<BIG><B>You have been jobbanned by [usr.client.ckey] from: [msg].</B></BIG>"
			M << "\red <B>The reason is: [reason]</B>"
			M << "\red Jobban can be lifted only upon request."
		if("Cancel")
			jobban_panel(M)

/datum/admins/proc/unjobban_from(var/mob/M, var/list/jobs)
	var/msg
	for(var/job in jobs)
		var/reason = jobban_isbanned(M, job)
		if(!reason) continue //skip if it isn't jobbanned anyway
		switch(alert("Job: '[job]' Reason: '[reason]' Un-jobban?","Please Confirm","Yes","No"))
			if("Yes")
				ban_unban_log_save("[key_name(usr)] unjobbanned [key_name(M)] from [job]")
				log_admin("[key_name(usr)] unbanned [key_name(M)] from [job]")
				DB_ban_unban(M.ckey, BANTYPE_JOB_PERMA, job)
				feedback_inc("ban_job_unban",1)
				feedback_add_details("ban_job_unban","- [job]")
				jobban_unban(M, job)
				if(!msg)	msg = job
				else		msg += ", [job]"
			else
				continue
	if(msg)
		message_admins("\blue [key_name_admin(usr)] unbanned [key_name_admin(M)] from [msg]", 1)
		M << "\red<BIG><B>You have been un-jobbanned by [usr.client.ckey] from [msg].</B></BIG>"
	jobban_panel(M)

/datum/admins/proc/create_jobban(var/mob/M, var/job_id)
	if(!ismob(M))
		usr << "This can only be used on instances of type /mob"
		return

	if(!job_master)
		usr << "Job Master has not been setup!"
		return

	//get jobs for department if specified, otherwise just returnt he one job in a list.
	var/list/joblist = list()
	switch(job_id)
		if("commanddept")
			for(var/jobPos in command_positions)
				if(!jobPos)	continue
				var/datum/job/temp = job_master.GetJob(jobPos)
				if(!temp) continue
				joblist += temp.title
		if("securitydept")
			for(var/jobPos in security_positions)
				if(!jobPos)	continue
				var/datum/job/temp = job_master.GetJob(jobPos)
				if(!temp) continue
				joblist += temp.title
		if("engineeringdept")
			for(var/jobPos in engineering_positions)
				if(!jobPos)	continue
				var/datum/job/temp = job_master.GetJob(jobPos)
				if(!temp) continue
				joblist += temp.title
		if("medicaldept")
			for(var/jobPos in medical_positions)
				if(!jobPos)	continue
				var/datum/job/temp = job_master.GetJob(jobPos)
				if(!temp) continue
				joblist += temp.title
		if("sciencedept")
			for(var/jobPos in science_positions)
				if(!jobPos)	continue
				var/datum/job/temp = job_master.GetJob(jobPos)
				if(!temp) continue
				joblist += temp.title
		if("civiliandept")
			for(var/jobPos in civilian_positions)
				if(!jobPos)	continue
				var/datum/job/temp = job_master.GetJob(jobPos)
				if(!temp) continue
				joblist += temp.title
		if("nonhumandept")
			joblist += "pAI"
			for(var/jobPos in nonhuman_positions)
				if(!jobPos)	continue
				var/datum/job/temp = job_master.GetJob(jobPos)
				if(!temp) continue
				joblist += temp.title
		else
			joblist += job_id

	var/list/notbannedlist = list()
	for(var/job in joblist)
		if(!jobban_isbanned(M, job))
			notbannedlist += job

	if(notbannedlist.len)
		jobban_from(M, notbannedlist)

	if(joblist.len)
		unjobban_from(M, joblist - notbannedlist)

/datum/admins/proc/jobban_panel(var/mob/M) //Поменять на ДБ
	if(!check_rights(R_BAN))	return

	if(!ismob(M))
		usr << "This can only be used on mob"
		return
	if(!M.ckey)	//sanity
		usr << "This mob has no ckey"
		return
	if(!job_master)
		usr << "Job Master has not been setup!"
		return

	var/dat = ""
	var/header = "<head><title>Job-Ban Panel: [M.name]</title></head>"
	var/body
	var/jobs = ""
	var/counter = 0

//Regular jobs
//Command (Blue)
	jobs += "<table cellpadding='1' cellspacing='0' width='100%'>"
	jobs += "<tr align='center' bgcolor='ccccff'><th colspan='[length(command_positions)]'><a href='?src=\ref[src];jobban=commanddept;jobban_mob=\ref[M]'>Command Positions</a></th></tr><tr align='center'>"
	for(var/jobPos in command_positions)
		if(!jobPos)	continue
		var/datum/job/job = job_master.GetJob(jobPos)
		if(!job) continue

		if(jobban_isbanned(M, job.title))
			jobs += "<td width='20%'><a href='?src=\ref[src];jobban=[job.title];jobban_mob=\ref[M]'><font color=red>[replacetext(job.title, " ", "&nbsp")]</font></a></td>"
			counter++
		else
			jobs += "<td width='20%'><a href='?src=\ref[src];jobban=[job.title];jobban_mob=\ref[M]'>[replacetext(job.title, " ", "&nbsp")]</a></td>"
			counter++

		if(counter >= 6) //So things dont get squiiiiished!
			jobs += "</tr><tr>"
			counter = 0
	jobs += "</tr></table>"

//Security (Red)
	counter = 0
	jobs += "<table cellpadding='1' cellspacing='0' width='100%'>"
	jobs += "<tr bgcolor='ffddf0'><th colspan='[length(security_positions)]'><a href='?src=\ref[src];jobban=securitydept;jobban_mob=\ref[M]'>Security Positions</a></th></tr><tr align='center'>"
	for(var/jobPos in security_positions)
		if(!jobPos)	continue
		var/datum/job/job = job_master.GetJob(jobPos)
		if(!job) continue

		if(jobban_isbanned(M, job.title))
			jobs += "<td width='20%'><a href='?src=\ref[src];jobban=[job.title];jobban_mob=\ref[M]'><font color=red>[replacetext(job.title, " ", "&nbsp")]</font></a></td>"
			counter++
		else
			jobs += "<td width='20%'><a href='?src=\ref[src];jobban=[job.title];jobban_mob=\ref[M]'>[replacetext(job.title, " ", "&nbsp")]</a></td>"
			counter++

		if(counter >= 5) //So things dont get squiiiiished!
			jobs += "</tr><tr align='center'>"
			counter = 0
	jobs += "</tr></table>"

//Engineering (Yellow)
	counter = 0
	jobs += "<table cellpadding='1' cellspacing='0' width='100%'>"
	jobs += "<tr bgcolor='fff5cc'><th colspan='[length(engineering_positions)]'><a href='?src=\ref[src];jobban=engineeringdept;jobban_mob=\ref[M]'>Engineering Positions</a></th></tr><tr align='center'>"
	for(var/jobPos in engineering_positions)
		if(!jobPos)	continue
		var/datum/job/job = job_master.GetJob(jobPos)
		if(!job) continue

		if(jobban_isbanned(M, job.title))
			jobs += "<td width='20%'><a href='?src=\ref[src];jobban=[job.title];jobban_mob=\ref[M]'><font color=red>[replacetext(job.title, " ", "&nbsp")]</font></a></td>"
			counter++
		else
			jobs += "<td width='20%'><a href='?src=\ref[src];jobban=[job.title];jobban_mob=\ref[M]'>[replacetext(job.title, " ", "&nbsp")]</a></td>"
			counter++

		if(counter >= 5) //So things dont get squiiiiished!
			jobs += "</tr><tr align='center'>"
			counter = 0
	jobs += "</tr></table>"

//Medical (White)
	counter = 0
	jobs += "<table cellpadding='1' cellspacing='0' width='100%'>"
	jobs += "<tr bgcolor='ffeef0'><th colspan='[length(medical_positions)]'><a href='?src=\ref[src];jobban=medicaldept;jobban_mob=\ref[M]'>Medical Positions</a></th></tr><tr align='center'>"
	for(var/jobPos in medical_positions)
		if(!jobPos)	continue
		var/datum/job/job = job_master.GetJob(jobPos)
		if(!job) continue

		if(jobban_isbanned(M, job.title))
			jobs += "<td width='20%'><a href='?src=\ref[src];jobban=[job.title];jobban_mob=\ref[M]'><font color=red>[replacetext(job.title, " ", "&nbsp")]</font></a></td>"
			counter++
		else
			jobs += "<td width='20%'><a href='?src=\ref[src];jobban=[job.title];jobban_mob=\ref[M]'>[replacetext(job.title, " ", "&nbsp")]</a></td>"
			counter++

		if(counter >= 5) //So things dont get squiiiiished!
			jobs += "</tr><tr align='center'>"
			counter = 0
	jobs += "</tr></table>"

//Science (Purple)
	counter = 0
	jobs += "<table cellpadding='1' cellspacing='0' width='100%'>"
	jobs += "<tr bgcolor='e79fff'><th colspan='[length(science_positions)]'><a href='?src=\ref[src];jobban=sciencedept;jobban_mob=\ref[M]'>Science Positions</a></th></tr><tr align='center'>"
	for(var/jobPos in science_positions)
		if(!jobPos)	continue
		var/datum/job/job = job_master.GetJob(jobPos)
		if(!job) continue

		if(jobban_isbanned(M, job.title))
			jobs += "<td width='20%'><a href='?src=\ref[src];jobban=[job.title];jobban_mob=\ref[M]'><font color=red>[replacetext(job.title, " ", "&nbsp")]</font></a></td>"
			counter++
		else
			jobs += "<td width='20%'><a href='?src=\ref[src];jobban=[job.title];jobban_mob=\ref[M]'>[replacetext(job.title, " ", "&nbsp")]</a></td>"
			counter++

		if(counter >= 5) //So things dont get squiiiiished!
			jobs += "</tr><tr align='center'>"
			counter = 0
	jobs += "</tr></table>"

//Civilian (Grey)
	counter = 0
	jobs += "<table cellpadding='1' cellspacing='0' width='100%'>"
	jobs += "<tr bgcolor='dddddd'><th colspan='[length(civilian_positions)]'><a href='?src=\ref[src];jobban=civiliandept;jobban_mob=\ref[M]'>Civilian Positions</a></th></tr><tr align='center'>"
	for(var/jobPos in civilian_positions)
		if(!jobPos)	continue
		var/datum/job/job = job_master.GetJob(jobPos)
		if(!job) continue

		if(jobban_isbanned(M, job.title))
			jobs += "<td width='20%'><a href='?src=\ref[src];jobban=[job.title];jobban_mob=\ref[M]'><font color=red>[replacetext(job.title, " ", "&nbsp")]</font></a></td>"
			counter++
		else
			jobs += "<td width='20%'><a href='?src=\ref[src];jobban=[job.title];jobban_mob=\ref[M]'>[replacetext(job.title, " ", "&nbsp")]</a></td>"
			counter++

		if(counter >= 5) //So things dont get squiiiiished!
			jobs += "</tr><tr align='center'>"
			counter = 0
	jobs += "</tr></table>"

//Non-Human (Green)
	counter = 0
	jobs += "<table cellpadding='1' cellspacing='0' width='100%'>"
	jobs += "<tr bgcolor='ccffcc'><th colspan='[length(nonhuman_positions)]'><a href='?src=\ref[src];jobban=nonhumandept;jobban_mob=\ref[M]'>Non-human Positions</a></th></tr><tr align='center'>"
	for(var/jobPos in nonhuman_positions)
		if(!jobPos)	continue
		var/datum/job/job = job_master.GetJob(jobPos)
		if(!job) continue

		if(jobban_isbanned(M, job.title))
			jobs += "<td width='20%'><a href='?src=\ref[src];jobban=[job.title];jobban_mob=\ref[M]'><font color=red>[replacetext(job.title, " ", "&nbsp")]</font></a></td>"
			counter++
		else
			jobs += "<td width='20%'><a href='?src=\ref[src];jobban=[job.title];jobban_mob=\ref[M]'>[replacetext(job.title, " ", "&nbsp")]</a></td>"
			counter++

		if(counter >= 5) //So things dont get squiiiiished!
			jobs += "</tr><tr align='center'>"
			counter = 0

	//pAI isn't technically a job, but it goes in here.
	if(jobban_isbanned(M, "pAI"))
		jobs += "<td width='20%'><a href='?src=\ref[src];jobban=pAI;jobban_mob=\ref[M]'><font color=red>pAI</font></a></td>"
	else
		jobs += "<td width='20%'><a href='?src=\ref[src];jobban=pAI;jobban_mob=\ref[M]'>pAI</a></td>"

	jobs += "</tr></table>"

//Antagonist (Orange)
	var/isbanned_dept = jobban_isbanned(M, "Syndicate")
	jobs += "<table cellpadding='1' cellspacing='0' width='100%'>"
	jobs += "<tr bgcolor='ffeeaa'><th colspan='10'><a href='?src=\ref[src];jobban=Syndicate;jobban_mob=\ref[M]'>Antagonist Positions</a></th></tr><tr align='center'>"

	//Traitor
	if(jobban_isbanned(M, "traitor") || isbanned_dept)
		jobs += "<td width='20%'><a href='?src=\ref[src];jobban=traitor;jobban_mob=\ref[M]'><font color=red>[replacetext("Traitor", " ", "&nbsp")]</font></a></td>"
	else
		jobs += "<td width='20%'><a href='?src=\ref[src];jobban=traitor;jobban_mob=\ref[M]'>[replacetext("Traitor", " ", "&nbsp")]</a></td>"

	//Changeling
	if(jobban_isbanned(M, "changeling") || isbanned_dept)
		jobs += "<td width='20%'><a href='?src=\ref[src];jobban=changeling;jobban_mob=\ref[M]'><font color=red>[replacetext("Changeling", " ", "&nbsp")]</font></a></td>"
	else
		jobs += "<td width='20%'><a href='?src=\ref[src];jobban=changeling;jobban_mob=\ref[M]'>[replacetext("Changeling", " ", "&nbsp")]</a></td>"

	//Nuke Operative
	if(jobban_isbanned(M, "operative") || isbanned_dept)
		jobs += "<td width='20%'><a href='?src=\ref[src];jobban=operative;jobban_mob=\ref[M]'><font color=red>[replacetext("Nuke Operative", " ", "&nbsp")]</font></a></td>"
	else
		jobs += "<td width='20%'><a href='?src=\ref[src];jobban=operative;jobban_mob=\ref[M]'>[replacetext("Nuke Operative", " ", "&nbsp")]</a></td>"

	//Revolutionary
	if(jobban_isbanned(M, "revolutionary") || isbanned_dept)
		jobs += "<td width='20%'><a href='?src=\ref[src];jobban=revolutionary;jobban_mob=\ref[M]'><font color=red>[replacetext("Revolutionary", " ", "&nbsp")]</font></a></td>"
	else
		jobs += "<td width='20%'><a href='?src=\ref[src];jobban=revolutionary;jobban_mob=\ref[M]'>[replacetext("Revolutionary", " ", "&nbsp")]</a></td>"

	jobs += "</tr><tr align='center'>" //Breaking it up so it fits nicer on the screen every 5 entries

	//Cultist
	if(jobban_isbanned(M, "cultist") || isbanned_dept)
		jobs += "<td width='20%'><a href='?src=\ref[src];jobban=cultist;jobban_mob=\ref[M]'><font color=red>[replacetext("Cultist", " ", "&nbsp")]</font></a></td>"
	else
		jobs += "<td width='20%'><a href='?src=\ref[src];jobban=cultist;jobban_mob=\ref[M]'>[replacetext("Cultist", " ", "&nbsp")]</a></td>"

	//Wizard
	if(jobban_isbanned(M, "wizard") || isbanned_dept)
		jobs += "<td width='20%'><a href='?src=\ref[src];jobban=wizard;jobban_mob=\ref[M]'><font color=red>[replacetext("Wizard", " ", "&nbsp")]</font></a></td>"
	else
		jobs += "<td width='20%'><a href='?src=\ref[src];jobban=wizard;jobban_mob=\ref[M]'>[replacetext("Wizard", " ", "&nbsp")]</a></td>"

	//Meme
	if(jobban_isbanned(M, "meme") || isbanned_dept)
		jobs += "<td width='20%'><a href='?src=\ref[src];jobban=meme;jobban_mob=\ref[M]'><font color=red>[replacetext("Meme", " ", "&nbsp")]</font></a></td>"
	else
		jobs += "<td width='20%'><a href='?src=\ref[src];jobban=meme;jobban_mob=\ref[M]'>[replacetext("Meme", " ", "&nbsp")]</a></td>"

	jobs += "</tr></table>"

	body = "<body>[jobs]</body>"
	dat = "<tt>[header][body]</tt>"
	usr << browse(dat, "window=jobban_panel;size=800x450")
	return
