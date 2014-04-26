/sound/turntable/test
	file = 'sound/misc/TestLoop1.ogg'
	falloff = 2
	repeat = 1

/mob/var/music = 0

var/list/turntable_soundtracks = list()

proc/add_turntable_soundtracks()
	turntable_soundtracks = list()
	for(var/i in typesof(/datum/turntable_soundtrack))
		var/datum/turntable_soundtrack/D = new i()
		if(D.path)
			turntable_soundtracks.Add(D)

/datum/turntable_soundtrack
	var/f_name
	var/name
	var/path

/obj/machinery/party/turntable
	name = "Turntable"
	desc = "A jukebox is a partially automated music-playing device, usually a coin-operated machine, that will play a patron's selection from self-contained media."
	icon = 'icons/effects/lasers2.dmi'
	icon_state = "Jukebox7"
	var/playing = 0
	var/sound/track = null
	var/volume = 100
	anchored = 1
	density = 1

/obj/machinery/party/mixer
	name = "mixer"
	desc = "A mixing board for mixing music"
	icon = 'icons/effects/lasers2.dmi'
	icon_state = "mixer"
	density = 0
	anchored = 1


/obj/machinery/party/turntable/New()
	..()
	sleep(2)
	new /sound/turntable/test(src)
	if(!turntable_soundtracks.len)
		add_turntable_soundtracks()
	return

/obj/machinery/party/turntable/attack_paw(user as mob)
	return src.attack_hand(user)

/obj/machinery/party/turntable/attack_hand(mob/living/user as mob)
	if (..())
		return

	usr.set_machine(src)
	src.add_fingerprint(usr)

	var/t = "<body background='turntable_back.jpg'><br><br><br><div align='center'><table border='0'><B><font color='maroon' size='6'>J</font><font size='5' color='purple'>uke Box</font> <font size='5' color='green'>Interface</font></B><br><br><br><br>"
	t += "<A href='?src=\ref[src];on=1'>On</A><br>"
	t += "<tr><td height='50' weight='50'></td><td height='50' weight='50'><A href='?src=\ref[src];off=1'><font color='maroon'>T</font><font color='lightgreen'>urn</font> <font color='red'>Off</font></A></td><td height='50' weight='50'></td></tr>"
	t += "<tr>"


	var/lastcolor = "green"
	for(var/i = 10; i <= 100; i += 10)
		t += "<A href='?src=\ref[src];set_volume=[i]'><font color='[lastcolor]'>[i]</font></A> "
		if(lastcolor == "green")
			lastcolor = "purple"
		else
			lastcolor = "green"

	var/i = 0
	for(var/datum/turntable_soundtrack/D in turntable_soundtracks)
		if(i == 3)
			i = 0
			t += "</tr><tr>"

		if(i == 1)
			lastcolor = pick("lightgreen", "purple")
		else
			lastcolor = pick("green", "purple")

		t += "<td height='50' weight='50'><A href='?src=\ref[src];on=\ref[D]'><font color='maroon'>[D.f_name]</font><font color='[lastcolor]'>[D.name]</font></A></td>"
		i++

	t += "</table></div></body>"
	user << browse(t, "window=turntable;size=450x700;can_resize=1")
	onclose(user, "turntable")
	return

/obj/machinery/party/turntable/power_change()
	turn_off()

/obj/machinery/party/turntable/Topic(href, href_list)
	if(..())
		return
	if(href_list["on"])
		turn_on(locate(href_list["on"]))

	else if(href_list["off"])
		turn_off()

	else if(href_list["set_volume"])
		set_volume(text2num(href_list["set_volume"]))

/obj/machinery/party/turntable/process()
	var/area/A = get_area(src)
	if(playing)
		for(var/mob/M)
			if((get_area(M) in A.related) && M.music == 0)
				M << track
				M.music = 1
			else if(!(get_area(M) in A.related) && M.music == 1)
				var/sound/Soff = sound(null)
				Soff.channel = 10
				M << Soff
				M.music = 0

/obj/machinery/party/turntable/proc/turn_on(var/datum/turntable_soundtrack/selected)
	if(playing)
		turn_off()
	if(selected)
		track = sound(selected.path)
	if(!track)
		return
	track.repeat = 1
	track.channel = 10
	track.falloff = 2
	track.wait = 1
	track.volume = src.volume
	track.environment = 0

	var/area/A = get_area(src)
	for(var/area/RA in A.related)
		for(var/obj/machinery/party/lasermachine/L in RA)
			L.turnon()

	playing = 1
	process()

/obj/machinery/party/turntable/proc/turn_off()
	if(!playing)
		return
	var/sound/Soff = sound(null)
	Soff.channel = 10
	Soff.wait = 1
	for(var/mob/M)
		if(M.music)
			M << Soff
			M.music = 0

	playing = 0
	var/area/A = get_area(src)
	for(var/area/RA in A.related)
		for(var/obj/machinery/party/lasermachine/L in RA)
			L.turnoff()

/obj/machinery/party/turntable/proc/set_volume(var/new_volume)
	volume = max(0, min(100, new_volume))
	if(playing)
		turn_off()
		turn_on()

/obj/machinery/party/lasermachine
	name = "laser machine"
	desc = "A laser machine that shoots lasers."
	icon = 'icons/effects/lasers2.dmi'
	icon_state = "lasermachine"
	anchored = 1
	var/mirrored = 0

/obj/effects/laser
	name = "laser"
	desc = "A laser..."
	icon = 'icons/effects/lasers2.dmi'
	icon_state = "laserred1"
	anchored = 1
	layer = 4

/obj/machinery/party/lasermachine/proc/turnon()
	var/wall = 0
	var/cycle = 1
	var/area/A = get_area(src)
	var/X = 1
	var/Y = 0
	if(mirrored == 0)
		while(wall == 0)
			if(cycle == 1)
				var/obj/effects/laser/F = new/obj/effects/laser(src)
				F.x = src.x+X
				F.y = src.y+Y
				F.z = src.z
				F.icon_state = "laserred1"
				var/area/AA = get_area(F)
				var/turf/T = get_turf(F)
				if(T.density == 1 || AA.name != A.name)
					del(F)
					return
				cycle++
				if(cycle > 3)
					cycle = 1
				X++
			if(cycle == 2)
				var/obj/effects/laser/F = new/obj/effects/laser(src)
				F.x = src.x+X
				F.y = src.y+Y
				F.z = src.z
				F.icon_state = "laserred2"
				var/area/AA = get_area(F)
				var/turf/T = get_turf(F)
				if(T.density == 1 || AA.name != A.name)
					del(F)
					return
				cycle++
				if(cycle > 3)
					cycle = 1
				Y++
			if(cycle == 3)
				var/obj/effects/laser/F = new/obj/effects/laser(src)
				F.x = src.x+X
				F.y = src.y+Y
				F.z = src.z
				F.icon_state = "laserred3"
				var/area/AA = get_area(F)
				var/turf/T = get_turf(F)
				if(T.density == 1 || AA.name != A.name)
					del(F)
					return
				cycle++
				if(cycle > 3)
					cycle = 1
				X++
	if(mirrored == 1)
		while(wall == 0)
			if(cycle == 1)
				var/obj/effects/laser/F = new/obj/effects/laser(src)
				F.x = src.x+X
				F.y = src.y-Y
				F.z = src.z
				F.icon_state = "laserred1m"
				var/area/AA = get_area(F)
				var/turf/T = get_turf(F)
				if(T.density == 1 || AA.name != A.name)
					del(F)
					return
				cycle++
				if(cycle > 3)
					cycle = 1
				Y++
			if(cycle == 2)
				var/obj/effects/laser/F = new/obj/effects/laser(src)
				F.x = src.x+X
				F.y = src.y-Y
				F.z = src.z
				F.icon_state = "laserred2m"
				var/area/AA = get_area(F)
				var/turf/T = get_turf(F)
				if(T.density == 1 || AA.name != A.name)
					del(F)
					return
				cycle++
				if(cycle > 3)
					cycle = 1
				X++
			if(cycle == 3)
				var/obj/effects/laser/F = new/obj/effects/laser(src)
				F.x = src.x+X
				F.y = src.y-Y
				F.z = src.z
				F.icon_state = "laserred3m"
				var/area/AA = get_area(F)
				var/turf/T = get_turf(F)
				if(T.density == 1 || AA.name != A.name)
					del(F)
					return
				cycle++
				if(cycle > 3)
					cycle = 1
				X++



/obj/machinery/party/lasermachine/proc/turnoff()
	var/area/A = src.loc.loc
	for(var/area/RA in A.related)
		for(var/obj/effects/laser/F in RA)
			del(F)

