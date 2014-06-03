/var/global/sent_aliens_to_station = 0

/datum/event/alien_infestation
	announceWhen	= 400
	oneShot			= 1

	var/silent = 0
	var/spawncount = 1
	var/successSpawn = 0	//So we don't make a command report if nothing gets spawned.


/datum/event/alien_infestation/setup()
	announceWhen = rand(announceWhen, announceWhen + 50)
	spawncount = rand(1, 2)
	sent_aliens_to_station = 1

/datum/event/alien_infestation/announce()
	if(successSpawn)
		message_admins("\blue Alien Infestation event automatically turned on aliens.")
		log_admin("Alien Infestation event automatically turned on aliens.", 1)
		aliens_allowed = 1
		if(!silent)
			command_alert("ќбнаружено присутствие неустановленных признаков жизни на борту станции [station_name()]. ”сильте безопасность всех доступов в отсеки извне, включа€ воздуховоды и вентил€цию.", "Ѕиологическа&#255; “ревога")
			world << sound('sound/AI/aliens.ogg')


/datum/event/alien_infestation/start()
	var/list/vents = list()
	for(var/obj/machinery/atmospherics/unary/vent_pump/temp_vent in machines)
		if(temp_vent.loc.z == 1 && !temp_vent.welded && temp_vent.network)
			if(temp_vent.network.normal_members.len > 50)	//Stops Aliens getting stuck in small networks. See: Security, Virology
				vents += temp_vent

	var/list/candidates = get_alien_candidates()

	while(spawncount > 0 && vents.len && candidates.len)
		var/obj/vent = pick(vents)
		var/candidate = pick(candidates)

		var/mob/living/carbon/alien/larva/new_xeno = new(vent.loc)
		new_xeno.key = candidate

		candidates -= candidate
		vents -= vent
		spawncount--
		successSpawn = 1

/datum/event/alien_eggs
	announceWhen = 400
	oneShot = 1

	var/silent = 0

/datum/event/alien_eggs/announce()
	if(!silent)
		command_alert("ќбнаружено присутствие неустановленных признаков жизни на борту станции [station_name()]. ”сильте безопасность всех доступов в отсеки извне, включа€ воздуховоды и вентил€цию.", "Ѕиологическа€ “ревога")
		world << sound('sound/AI/aliens.ogg')

/datum/event/alien_eggs/start()
	var/list/places = list()
	var/spawns = rand(1, 4)
	for(var/obj/effect/landmark/L in landmarks_list)
		if(L.name == "alien_egg")
			places += L
	if(places.len <= 0)
		return
	message_admins("\blue Alien Infestation event automatically turned on aliens.")
	log_admin("Alien Infestation event automatically turned on aliens.", 1)
	aliens_allowed = 1
	while(spawns > 0)
		if(places.len <= 0)
			break
		var/P = pick(places)
		places &= !P
		var/turf/T = get_turf(P)
		new /obj/effect/alien/egg(T)
		spawns--
