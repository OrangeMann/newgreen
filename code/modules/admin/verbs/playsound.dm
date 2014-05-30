/client/proc/play_sound(S as sound)
	set category = "Fun"
	set name = "Play Global Sound"
	if(!check_rights(R_SOUNDS))	return

	var/sound/uploaded_sound = sound(S, repeat = 0, wait = 1, channel = 777)
	uploaded_sound.priority = 250
	uploaded_sound.volume = min(100, max(0, input("Set Volume", null, 100)))

	var/playing_sound = 0
	while(1)
		switch(alert("Do you really want to play this sound?",,"Yes","No", "Listen"))
			if("Yes")
				log_admin("[key_name(src)] played sound [S]")
				message_admins("[key_name_admin(src)] played sound [S]", 1)
				uploaded_sound.status = SOUND_STREAM
				for(var/mob/M in player_list)
					if(M.client.prefs.toggles & SOUND_MIDI)
						M << uploaded_sound
				feedback_add_details("admin_verb","PGS") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
				return
			if("No")
				if(playing_sound)
					src << sound(null, channel = 777)
				return
			if("Listen")
				if(playing_sound)
					src << sound(null, channel = 777)
				else
					playing_sound = 1
				src << uploaded_sound
				while(1)
					switch(alert("Change Volume?",, "Change", "No", "Cancel"))//Cause alert can use only 3 buttons
						if("Change")
							uploaded_sound.volume = min(100, max(0, input("Set Volume", null, 100)))
							if(playing_sound)
								var/sound/s = sound(null, volume = uploaded_sound.volume)
								s.status = SOUND_UPDATE
								src << s
						if("No")
							if(playing_sound)
								src << sound(null, channel = 777)
							break
						if("Cancel")
							if(playing_sound)
								src << sound(null, channel = 777)
							return

/client/proc/play_local_sound(S as sound)
	set category = "Fun"
	set name = "Play Local Sound"
	if(!check_rights(R_SOUNDS))	return

	log_admin("[key_name(src)] played a local sound [S]")
	message_admins("[key_name_admin(src)] played a local sound [S]", 1)
	playsound(get_turf_loc(src.mob), S, 50, 0, 0)
	feedback_add_details("admin_verb","PLS") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!


/*
/client/proc/cuban_pete()
	set category = "Fun"
	set name = "Cuban Pete Time"

	message_admins("[key_name_admin(usr)] has declared Cuban Pete Time!", 1)
	for(var/mob/M in world)
		if(M.client)
			if(M.client.midis)
				M << 'cubanpetetime.ogg'

	for(var/mob/living/carbon/human/CP in world)
		if(CP.real_name=="Cuban Pete" && CP.key!="Rosham")
			CP << "Your body can't contain the rhumba beat"
			CP.gib()


/client/proc/bananaphone()
	set category = "Fun"
	set name = "Banana Phone"

	message_admins("[key_name_admin(usr)] has activated Banana Phone!", 1)
	for(var/mob/M in world)
		if(M.client)
			if(M.client.midis)
				M << 'bananaphone.ogg'


client/proc/space_asshole()
	set category = "Fun"
	set name = "Space Asshole"

	message_admins("[key_name_admin(usr)] has played the Space Asshole Hymn.", 1)
	for(var/mob/M in world)
		if(M.client)
			if(M.client.midis)
				M << 'sound/music/space_asshole.ogg'


client/proc/honk_theme()
	set category = "Fun"
	set name = "Honk"

	message_admins("[key_name_admin(usr)] has creeped everyone out with Blackest Honks.", 1)
	for(var/mob/M in world)
		if(M.client)
			if(M.client.midis)
				M << 'honk_theme.ogg'*/
