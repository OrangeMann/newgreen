var/list/sacrificed = list()

/obj/effect/rune
/////////////////////////////////////////FIRST RUNE
	proc
		teleport(var/key)
			var/mob/living/user = usr
			var/allrunesloc[]
			allrunesloc = new/list()
			var/index = 0
		//	var/tempnum = 0
			for(var/obj/effect/rune/R in world)
				if(R == src)
					continue
				if(R.word1 == cultwords["travel"] && R.word2 == cultwords["self"] && R.word3 == key && R.z != 2)
					index++
					allrunesloc.len = index
					allrunesloc[index] = R.loc
			if(index >= 5)
				user << "\red You feel pain, as rune disappears in reality shift caused by too much wear of space-time fabric"
				if (istype(user, /mob/living))
					user.take_overall_damage(5, 0)
				del(src)
			if(allrunesloc && index != 0)
				var/cultist_use = "talisman"
				if(istype(src,/obj/effect/rune))
					user.say("Sas[pick("'","`")]so c'arta forbici!")//Only you can stop auto-muting
					cultist_use = "rune"
				else
					user.whisper("Sas[pick("'","`")]so c'arta forbici!")
				user.visible_message("\red [user] disappears in a flash of red light!", \
				"\red You feel as your body gets dragged through the dimension of Nar-Sie!", \
				"\red You hear a sickening crunch and sloshing of viscera.")
				var/turf/prev_loc = user.loc
				user.loc = allrunesloc[rand(1,index)]
				log_game("[usr.name]([usr.ckey]) use [cultist_use] to teleport from [prev_loc.x],[prev_loc.y],[prev_loc.z] to [user.loc.x],[user.loc.y],[user.loc.z]")
				return
			if(istype(src,/obj/effect/rune))
				return	fizzle() //Use friggin manuals, Dorf, your list was of zero length.
			else
				call(/obj/effect/rune/proc/fizzle)()
				return


		itemport(var/key)
//			var/allrunesloc[]
//			allrunesloc = new/list()
//			var/index = 0
		//	var/tempnum = 0
			var/culcount = 0
			var/runecount = 0
			var/obj/effect/rune/IP = null
			var/mob/living/user = usr
			for(var/obj/effect/rune/R in world)
				if(R == src)
					continue
				if(R.word1 == cultwords["travel"] && R.word2 == cultwords["other"] && R.word3 == key)
					IP = R
					runecount++
			if(runecount >= 2)
				user << "\red You feel pain, as rune disappears in reality shift caused by too much wear of space-time fabric"
				if (istype(user, /mob/living))
					user.take_overall_damage(5, 0)
				del(src)
			var/list/cultists_names = new()
			for(var/mob/living/carbon/C in orange(1,src))
				if(iscultist(C) && !C.stat)
					culcount++
					cultists_names += "|[C] ([C.ckey])|"
			if(culcount>=3)
				user.say("Sas[pick("'","`")]so c'arta forbici tarem!")
				user.visible_message("\red You feel air moving from the rune - like as it was swapped with somewhere else.", \
				"\red You feel air moving from the rune - like as it was swapped with somewhere else.", \
				"\red You smell ozone.")
				var/items_names = ""
				var/mobs_names = ""
				for(var/obj/O in src.loc)
					if(!O.anchored)
						O.loc = IP.loc
						items_names += "[O.name]|"
				for(var/mob/M in src.loc)
					M.loc = IP.loc
					mobs_names += "[M] ([M.ckey])|"
				log_game("Cultists teleported items/mobs from [src.loc] to [IP.loc]. Items: [items_names] Mobs: [mobs_names]")
				return

			return fizzle()


/////////////////////////////////////////SECOND RUNE

		tomesummon()
			var/cultist_use = "talisman"
			if(istype(src,/obj/effect/rune))
				usr.say("N[pick("'","`")]ath reth sh'yro eth d'raggathnor!")
				cultist_use = "rune"
			else
				usr.whisper("N[pick("'","`")]ath reth sh'yro eth d'raggathnor!")
			usr.visible_message("\red Rune disappears with a flash of red light, and in its place now a book lies.", \
			"\red You are blinded by the flash of red light! After you're able to see again, you see that now instead of the rune there's a book.", \
			"\red You hear a pop and smell ozone.")
			log_game("[usr.name]([usr.ckey]) use [cultist_use] to summon arcane tome")
			if(istype(src,/obj/effect/rune))
				new /obj/item/weapon/tome(src.loc)
			else
				new /obj/item/weapon/tome(usr.loc)
			del(src)
			return



/////////////////////////////////////////THIRD RUNE

		convert()
			for(var/mob/living/carbon/M in src.loc)
				if(iscultist(M))
					continue
				if(M.stat==2)
					continue
				usr.say("Mah[pick("'","`")]weyh pleggh at e'ntrath!")
				M.visible_message("\red [M] writhes in pain as the markings below him glow a bloody red.", \
				"\red AAAAAAHHHH!.", \
				"\red You hear an anguished scream.")
				if(is_convertable_to_cult(M.mind) && !jobban_isbanned(M, "cultist"))//putting jobban check here because is_convertable uses mind as argument
					ticker.mode.add_cultist(M.mind)
					M.mind.special_role = "Cultist"
					message_admins("[usr.name]([usr.ckey])(<A HREF='?_src_=holder;adminplayerobservejump=\ref[usr]'>JMP</A>) converted [M]([M.ckey]) into cultist.", 0)
					log_game("[usr.name]([usr.ckey]) converted [M]([M.ckey]) into cultist")
					M << "<font color=\"purple\"><b><i>Your blood pulses. Your head throbs. The world goes red. All at once you are aware of a horrible, horrible truth. The veil of reality has been ripped away and in the festering wound left behind something sinister takes root.</b></i></font>"
					M << "<font color=\"purple\"><b><i>Assist your new compatriots in their dark dealings. Their goal is yours, and yours is theirs. You serve the Dark One above all else. Bring It back.</b></i></font>"
					return 1
				else
					M << "<font color=\"purple\"><b><i>Your blood pulses. Your head throbs. The world goes red. All at once you are aware of a horrible, horrible truth. The veil of reality has been ripped away and in the festering wound left behind something sinister takes root.</b></i></font>"
					M << "<font color=\"red\"><b>And you were able to force it out of your mind. You now know the truth, there's something horrible out there, stop it and its minions at all costs.</b></font>"
					return 0

			return fizzle()



/////////////////////////////////////////FOURTH RUNE

		tearreality()
			var/cultist_count = 0
			var/cultist_names = ""
			for(var/mob/M in range(1,src))
				if(iscultist(M) && !M.stat)
					M.say("Tok-lyr rqa'nap g[pick("'","`")]lt-ulotf!")
					cultist_count += 1
					cultist_names +="[M] ([M.ckey])|"
			if(cultist_count >= 9)
				new /obj/machinery/singularity/narsie/large(src.loc)
				if(ticker.mode.name == "cult")
					ticker.mode:eldergod = 0
				log_game("Nar-Sie was summoned. Summoners : [cultist_names]")
				return
			else
				return fizzle()

/////////////////////////////////////////FIFTH RUNE

		emp(var/U,var/range_red) //range_red - var which determines by which number to reduce the default emp range, U is the source loc, needed because of talisman emps which are held in hand at the moment of using and that apparently messes things up -- Urist
			var/cultist_use = "talisman"
			if(istype(src,/obj/effect/rune))
				usr.say("Ta'gh fara[pick("'","`")]qha fel d'amar det!")
				cultist_use = "rune"
			else
				usr.whisper("Ta'gh fara[pick("'","`")]qha fel d'amar det!")
			log_game("[usr.name]([usr.ckey]) use [cultist_use] to activate emp")
			playsound(U, 'sound/items/Welder2.ogg', 25, 1)
			var/turf/T = get_turf(U)
			if(T)
				T.hotspot_expose(700,125)
			var/rune = src // detaching the proc - in theory
			empulse(U, (range_red - 2), range_red)
			del(rune)
			return

/////////////////////////////////////////SIXTH RUNE

		drain()
			var/drain = 0
			var/victims_names = ""
			for(var/obj/effect/rune/R in world)
				if(R.word1==cultwords["travel"] && R.word2==cultwords["blood"] && R.word3==cultwords["self"])
					for(var/mob/living/carbon/D in R.loc)
						if(D.stat!=2)
							var/bdrain = rand(1,25)
							D << "\red You feel weakened."
							D.take_overall_damage(bdrain, 0)
							drain += bdrain
							if (D != usr)
								victims_names +="[D] ([D.ckey])|"
								D.attack_log += "\[[time_stamp()]\]<font color='orange'> Drained by [usr.name] ([usr.ckey]) with rune</font>"
			if(!drain)
				return fizzle()
			usr.say ("Yu[pick("'","`")]gular faras desdae. Havas mithum javara. Umathar uf'kal thenar!")
			usr.visible_message("\red Blood flows from the rune into [usr]!", \
			"\red The blood starts flowing from the rune and into your frail mortal body. You feel... empowered.", \
			"\red You hear a liquid flowing.")
			var/mob/living/user = usr
			if(user.bhunger)
				user.bhunger = max(user.bhunger-2*drain,0)
			if(drain>=50)
				user.visible_message("\red [user]'s eyes give off eerie red glow!", \
				"\red ...but it wasn't nearly enough. You crave, crave for more. The hunger consumes you from within.", \
				"\red You hear a heartbeat.")
				user.bhunger += drain
				src = user
				spawn()
					for (,user.bhunger>0,user.bhunger--)
						sleep(50)
						user.take_overall_damage(3, 0)
				return
			user.heal_organ_damage(drain%5, 0)
			drain-=drain%5
			for (,drain>0,drain-=5)
				sleep(2)
				user.heal_organ_damage(5, 0)
			user.attack_log += "\[[time_stamp()]\]<font color='red'> Use rune to drain energy from [victims_names]</font>"
			message_admins("[usr.name]([usr.ckey])(<A HREF='?_src_=holder;adminplayerobservejump=\ref[user]'>JMP</A>) use rune to drain energy from victim(s). Victims: [victims_names]", 0)
			log_attack("[usr.name]([usr.ckey]) use rune to drain energy from victims. Victims: [victims_names]")
			return






/////////////////////////////////////////SEVENTH RUNE

		seer()
			if(usr.loc==src.loc)
				if(usr.seer==1)
					usr.say("Rash'tla sektath mal[pick("'","`")]zua. Zasan therium viortia.")
					usr << "\red The world beyond fades from your vision."
					usr.see_invisible = SEE_INVISIBLE_LIVING
					usr.seer = 0
				else if(usr.see_invisible!=SEE_INVISIBLE_LIVING)
					usr << "\red The world beyond flashes your eyes but disappears quickly, as if something is disrupting your vision."
					usr.see_invisible = SEE_INVISIBLE_OBSERVER
					usr.seer = 0
				else
					usr.say("Rash'tla sektath mal[pick("'","`")]zua. Zasan therium vivira. Itonis al'ra matum!")
					usr << "\red The world beyond opens to your eyes."
					usr.see_invisible = SEE_INVISIBLE_OBSERVER
					usr.seer = 1
				log_game("[usr.name]([usr.ckey]) use rune to see invisible")
				return
			return fizzle()

/////////////////////////////////////////EIGHTH RUNE

		raise()
			var/mob/living/carbon/human/corpse_to_raise
			var/mob/living/carbon/human/body_to_sacrifice

			var/is_sacrifice_target = 0
			for(var/mob/living/carbon/human/M in src.loc)
				if(M.stat == DEAD)
					if(ticker.mode.name == "cult" && M.mind == ticker.mode:sacrifice_target)
						is_sacrifice_target = 1
					else
						corpse_to_raise = M
						if(M.key)
							M.ghostize(1)	//kick them out of their body
						break
			if(!corpse_to_raise)
				if(is_sacrifice_target)
					usr << "\red The Geometer of blood wants this mortal for himself."
				return fizzle()


			is_sacrifice_target = 0
			find_sacrifice:
				for(var/obj/effect/rune/R in world)
					if(R.word1==cultwords["blood"] && R.word2==cultwords["join"] && R.word3==cultwords["hell"])
						for(var/mob/living/carbon/human/N in R.loc)
							if(ticker.mode.name == "cult" && N.mind && N.mind == ticker.mode:sacrifice_target)
								is_sacrifice_target = 1
							else
								if(N.stat!= DEAD)
									body_to_sacrifice = N
									break find_sacrifice

			if(!body_to_sacrifice)
				if (is_sacrifice_target)
					usr << "\red The Geometer of blood wants that corpse for himself."
				else
					usr << "\red The sacrifical corpse is not dead. You must free it from this world of illusions before it may be used."
				return fizzle()

			var/mob/dead/observer/ghost
			for(var/mob/dead/observer/O in loc)
				if(!O.client)	continue
				if(O.mind && O.mind.current && O.mind.current.stat != DEAD)	continue
				ghost = O
				break

			if(!ghost)
				usr << "\red You require a restless spirit which clings to this world. Beckon their prescence with the sacred chants of Nar-Sie."
				return fizzle()

			usr.attack_log += "\[[time_stamp()]\]<font color='red'> Sacrifice [body_to_sacrifice.name]([body_to_sacrifice.ckey]) to revive [corpse_to_raise.name]([corpse_to_raise.ckey]) with entered ghost [ghost.name]([ghost.ckey])</font>"
			message_admins("[usr.name]([usr.ckey])(<A HREF='?_src_=holder;adminplayerobservejump=\ref[usr]'>JMP</A>) sacrifice [body_to_sacrifice.name]([body_to_sacrifice.ckey]) to revive [corpse_to_raise.name]([corpse_to_raise.ckey]) with entered ghost [ghost.name]([ghost.ckey])", 0)
			log_attack("[usr.name]([usr.ckey]) sacrifice [body_to_sacrifice.name]([body_to_sacrifice.ckey]) to revive [corpse_to_raise.name]([corpse_to_raise.ckey]) with entered ghost [ghost.name]([ghost.ckey])")

			corpse_to_raise.revive()

			corpse_to_raise.key = ghost.key	//the corpse will keep its old mind! but a new player takes ownership of it (they are essentially possessed)
											//This means, should that player leave the body, the original may re-enter
			usr.say("Pasnar val'keriam usinar. Savrae ines amutan. Yam'toth remium il'tarat!")
			corpse_to_raise.visible_message("\red [corpse_to_raise]'s eyes glow with a faint red as he stands up, slowly starting to breathe again.", \
			"\red Life... I'm alive again...", \
			"\red You hear a faint, slightly familiar whisper.")
			body_to_sacrifice.visible_message("\red [body_to_sacrifice] is torn apart, a black smoke swiftly dissipating from his remains!", \
			"\red You feel as your blood boils, tearing you apart.", \
			"\red You hear a thousand voices, all crying in pain.")
			body_to_sacrifice.gib()

//			if(ticker.mode.name == "cult")
//				ticker.mode:add_cultist(corpse_to_raise.mind)
//			else
//				ticker.mode.cult |= corpse_to_raise.mind

			corpse_to_raise << "<font color=\"purple\"><b><i>Your blood pulses. Your head throbs. The world goes red. All at once you are aware of a horrible, horrible truth. The veil of reality has been ripped away and in the festering wound left behind something sinister takes root.</b></i></font>"
			corpse_to_raise << "<font color=\"purple\"><b><i>Assist your new compatriots in their dark dealings. Their goal is yours, and yours is theirs. You serve the Dark One above all else. Bring It back.</b></i></font>"
			return





/////////////////////////////////////////NINETH RUNE

		obscure(var/rad)
			var/S=0
			for(var/obj/effect/rune/R in orange(rad,src))
				if(R!=src)
					R.invisibility=INVISIBILITY_OBSERVER
				S=1
			if(S)
				var/cultist_use = "talisman"
				if(istype(src,/obj/effect/rune))
					cultist_use = "rune"
					usr.say("Kla[pick("'","`")]atu barada nikt'o!")
					for (var/mob/V in viewers(src))
						V.show_message("\red The rune turns into gray dust, veiling the surrounding runes.", 3)
					log_game("[usr.name]([usr.ckey]) use [cultist_use] to hide runes")
					del(src)
				else
					usr.whisper("Kla[pick("'","`")]atu barada nikt'o!")
					usr << "\red Your talisman turns into gray dust, veiling the surrounding runes."
					for (var/mob/V in orange(1,src))
						if(V!=usr)
							V.show_message("\red Dust emanates from [usr]'s hands for a moment.", 3)
					log_game("[usr.name]([usr.ckey]) use [cultist_use] to hide runes")

				return
			if(istype(src,/obj/effect/rune))
				return	fizzle()
			else
				call(/obj/effect/rune/proc/fizzle)()
				return

/////////////////////////////////////////TENTH RUNE

		ajourney() //some bits copypastaed from admin tools - Urist
			if(usr.loc==src.loc)
				var/mob/living/carbon/human/L = usr
				usr.say("Fwe[pick("'","`")]sh mah erl nyag r'ya!")
				usr.visible_message("\red [usr]'s eyes glow blue as \he freezes in place, absolutely motionless.", \
				"\red The shadow that is your spirit separates itself from your body. You are now in the realm beyond. While this is a great sight, being here strains your mind and body. Hurry...", \
				"\red You hear only complete silence for a moment.")
				usr.ghostize(1)
				L.ajourn = 1
				log_game("[usr.name]([usr.ckey]) use rune to start travel as ghost")
				while(L)
					if(L.key)
						L.ajourn=0
						ticker.mode.update_cult_icons_added(L.mind)
						return
					else
						L.take_organ_damage(10, 0)
					sleep(100)
			return fizzle()




/////////////////////////////////////////ELEVENTH RUNE

		manifest()
			var/obj/effect/rune/this_rune = src
			src = null
			if(usr.loc!=this_rune.loc)
				return this_rune.fizzle()
			var/mob/dead/observer/ghost
			for(var/mob/dead/observer/O in this_rune.loc)
				if(!O.client)	continue
				if(O.mind && O.mind.current && O.mind.current.stat != DEAD)	continue
				ghost = O
				break
			if(!ghost)
				return this_rune.fizzle()
			if(jobban_isbanned(ghost, "cultist"))
				return this_rune.fizzle()

			usr.say("Gal'h'rfikk harfrandid mud[pick("'","`")]gib!")
			var/mob/living/carbon/human/dummy/D = new(this_rune.loc)
			usr.visible_message("\red A shape forms in the center of the rune. A shape of... a man.", \
			"\red A shape forms in the center of the rune. A shape of... a man.", \
			"\red You hear liquid flowing.")
			D.real_name = "Unknown"
			var/chose_name = 0
			for(var/obj/item/weapon/paper/P in this_rune.loc)
				if(P.info)
					D.real_name = copytext(P.info, findtext(P.info,">")+1, findtext(P.info,"<",2) )
					chose_name = 1
					break
			if(!chose_name)
				D.real_name = "[pick(first_names_male)] [pick(last_names)]"
			D.universal_speak = 1
			D.status_flags &= ~GODMODE

			log_game("[usr.name]([usr.ckey]) use rune to create body for ghost [ghost.name]([ghost.ckey])")

			D.key = ghost.key

			if(ticker.mode.name == "cult")
				ticker.mode:add_cultist(D.mind)
			else
				ticker.mode.cult+=D.mind

			D.mind.special_role = "Cultist"
			D << "<font color=\"purple\"><b><i>Your blood pulses. Your head throbs. The world goes red. All at once you are aware of a horrible, horrible truth. The veil of reality has been ripped away and in the festering wound left behind something sinister takes root.</b></i></font>"
			D << "<font color=\"purple\"><b><i>Assist your new compatriots in their dark dealings. Their goal is yours, and yours is theirs. You serve the Dark One above all else. Bring It back.</b></i></font>"

			var/mob/living/user = usr
			while(this_rune && user && user.stat==CONSCIOUS && user.client && user.loc==this_rune.loc)
				user.take_organ_damage(1, 0)
				sleep(30)
			if(D)
				D.visible_message("\red [D] slowly dissipates into dust and bones.", \
				"\red You feel pain, as bonds formed between your soul and this homunculus break.", \
				"\red You hear faint rustle.")
				D.dust()
			return





/////////////////////////////////////////TWELFTH RUNE

		talisman()//only hide, emp, teleport, deafen, blind and tome runes can be imbued atm
			var/obj/item/weapon/paper/newtalisman
			var/unsuitable_newtalisman = 0
			for(var/obj/item/weapon/paper/P in src.loc)
				if(!P.info)
					newtalisman = P
					break
				else
					unsuitable_newtalisman = 1
			if (!newtalisman)
				if (unsuitable_newtalisman)
					usr << "\red The blank is tainted. It is unsuitable."
				return fizzle()

			var/obj/effect/rune/imbued_from
			var/obj/item/weapon/paper/talisman/T
			for(var/obj/effect/rune/R in orange(1,src))
				if(R==src)
					continue
				if(R.word1==cultwords["travel"] && R.word2==cultwords["self"])  //teleport
					T = new(src.loc)
					T.imbue = "[R.word3]"
					T.info = "[R.word3]"
					imbued_from = R
					break
				if(R.word1==cultwords["see"] && R.word2==cultwords["blood"] && R.word3==cultwords["hell"]) //tome
					T = new(src.loc)
					T.imbue = "newtome"
					imbued_from = R
					break
				if(R.word1==cultwords["destroy"] && R.word2==cultwords["see"] && R.word3==cultwords["technology"]) //emp
					T = new(src.loc)
					T.imbue = "emp"
					imbued_from = R
					break
				if(R.word1==cultwords["blood"] && R.word2==cultwords["see"] && R.word3==cultwords["destroy"]) //conceal
					T = new(src.loc)
					T.imbue = "conceal"
					imbued_from = R
					break
				if(R.word1==cultwords["hell"] && R.word2==cultwords["destroy"] && R.word3==cultwords["other"]) //armor
					T = new(src.loc)
					T.imbue = "armor"
					imbued_from = R
					break
				if(R.word1==cultwords["blood"] && R.word2==cultwords["see"] && R.word3==cultwords["hide"]) //reveal
					T = new(src.loc)
					T.imbue = "revealrunes"
					imbued_from = R
					break
				if(R.word1==cultwords["hide"] && R.word2==cultwords["other"] && R.word3==cultwords["see"]) //deafen
					T = new(src.loc)
					T.imbue = "deafen"
					imbued_from = R
					break
				if(R.word1==cultwords["destroy"] && R.word2==cultwords["see"] && R.word3==cultwords["other"]) //blind
					T = new(src.loc)
					T.imbue = "blind"
					imbued_from = R
					break
				if(R.word1==cultwords["self"] && R.word2==cultwords["other"] && R.word3==cultwords["technology"]) //communicat
					T = new(src.loc)
					T.imbue = "communicate"
					imbued_from = R
					break
				if(R.word1==cultwords["join"] && R.word2==cultwords["hide"] && R.word3==cultwords["technology"]) //communicat
					T = new(src.loc)
					T.imbue = "runestun"
					imbued_from = R
					break
			if (imbued_from)
				for (var/mob/V in viewers(src))
					V.show_message("\red The runes turn into dust, which then forms into an arcane image on the paper.", 3)
				usr.say("H'drak v[pick("'","`")]loso, mir'kanas verbot!")
				var/t = "[T.imbue]"
				if (T.info)
					t = "teleport to key: [T.info]"
				log_game("[usr.name]([usr.ckey]) use rune to create talisman (TYPE:[t])")
				del(imbued_from)
				del(newtalisman)
			else
				return fizzle()

/////////////////////////////////////////THIRTEENTH RUNE

		mend()
			var/mob/living/user = usr
			src = null
			user.say("Uhrast ka'hfa heldsagen ver[pick("'","`")]lot!")
			user.take_overall_damage(200, 0)
			runedec+=10
			user.visible_message("\red [user] keels over dead, his blood glowing blue as it escapes his body and dissipates into thin air.", \
			"\red In the last moment of your humble life, you feel an immense pain as fabric of reality mends... with your blood.", \
			"\red You hear faint rustle.")
			for(,user.stat==2)
				sleep(600)
				if (!user)
					return
			runedec-=10
			return


/////////////////////////////////////////FOURTEETH RUNE

		// returns 0 if the rune is not used. returns 1 if the rune is used.
		communicate()
			. = 1 // Default output is 1. If the rune is deleted it will return 1
			var/input = stripped_input(usr, "Please choose a message to tell to the other acolytes.", "Voice of Blood", "")
			if(!input)
				if (istype(src))
					fizzle()
					return 0
				else
					return 0
			var/cultist_use = "talisman"
			if(istype(src,/obj/effect/rune))
				cultist_use = "rune"
				usr.say("O bidai nabora se[pick("'","`")]sma!")
				usr.say("[input]")
			else
				usr.whisper("O bidai nabora se[pick("'","`")]sma!")
				usr.whisper("[input]")

			for(var/datum/mind/H in ticker.mode.cult)
				if (H.current)
					H.current << "\red \b [sanitize(input)]"
			log_game("[usr.name]([usr.ckey]) use [cultist_use] to communicate with the others cultists")
			del(src)
			return 1

/////////////////////////////////////////FIFTEENTH RUNE

		sacrifice()
			var/list/mob/living/carbon/human/cultsinrange = list()
			var/list/mob/living/carbon/human/victims = list()
			var/cultists_names = ""
			var/victims_names = ""
			for(var/mob/living/carbon/human/V in src.loc)//Checks for non-cultist humans to sacrifice
				if(ishuman(V))
					if(!(iscultist(V)))
						victims += V//Checks for cult status and mob type
			for(var/obj/item/I in src.loc)//Checks for MMIs/brains/Intellicards
				if(istype(I,/obj/item/brain))
					var/obj/item/brain/B = I
					victims += B.brainmob
				else if(istype(I,/obj/item/device/mmi))
					var/obj/item/device/mmi/B = I
					victims += B.brainmob
				else if(istype(I,/obj/item/device/aicard))
					for(var/mob/living/silicon/ai/A in I)
						victims += A
			for(var/mob/living/carbon/C in orange(1,src))
				if(iscultist(C) && !C.stat)
					cultsinrange += C
					C.say("Barhah hra zar[pick("'","`")]garis!")
					cultists_names +="[C] ([C.ckey])|"
			var/target_success = 0
			var/target_fail = 0
			var/victim_success = 0
			var/victim_fail = 0
			var/victim_dead_fail = 0
			var/victim_alive_fail = 0
			var/monkey_success = 0
			var/monkey_fail = 0
			for(var/mob/H in victims)
				if (ticker.mode.name == "cult" && H.mind == ticker.mode:sacrifice_target)
					if(cultsinrange.len >= 3)
						sacrificed += H.mind
						target_success = 1
					else
						target_fail = 1
						continue
				else
					if(H.stat !=2)
						if(cultsinrange.len >= 3)
							if(prob(80))
								victim_success = 1
								ticker.mode:grant_runeword(usr)
							else
								victim_fail = 1
						else
							victim_alive_fail = 1
							continue
					else
						if(prob(40))
							victim_success = 1
							ticker.mode:grant_runeword(usr)
						else
							victim_dead_fail = 1
				if(isrobot(H))
					victims_names +="[H] ([H.ckey])|"
					H.dust()//To prevent the MMI from remaining
				else
					victims_names +="[H] ([H.ckey])|"
					H.gib()
			for(var/mob/living/carbon/monkey/M in src.loc)
				if (ticker.mode.name == "cult" && M.mind == ticker.mode:sacrifice_target)
					if(cultsinrange.len >= 3)
						sacrificed += M.mind
						target_success = 1
					else
						target_fail = 1
						continue
				else
					if(prob(20))
						monkey_success = 1
						ticker.mode:grant_runeword(usr)
					else
						monkey_fail = 1
				victims_names +="[M] ([M.ckey])|"
				M.gib()
/*			for(var/mob/living/carbon/alien/A)
				for(var/mob/K in cultsinrange)
					K.say("Barhah hra zar'garis!")
				A.dust()      /// A.gib() doesnt work for some reason, and dust() leaves that skull and bones thingy which we dont really need.
				if (ticker.mode.name == "cult")
					if(prob(75))
						usr << "\red The Geometer of Blood accepts your exotic sacrifice."
						ticker.mode:grant_runeword(usr)
					else
						usr << "\red The Geometer of Blood accepts your exotic sacrifice."
						usr << "\red However, this alien is not enough to gain His favor."
				else
					usr << "\red The Geometer of Blood accepts your exotic sacrifice."
				return
			return fizzle() */

			if (target_success)
				usr << "\red The Geometer of Blood accepts this sacrifice, your objective is now complete."
			else if (victim_success)
				usr << "\red The Geometer of Blood accepts this sacrifice."
			else if (monkey_success)
				usr << "\red The Geometer of Blood accepts your meager sacrifice."
			else if (target_fail)
				usr << "\red Your target's earthly bonds are too strong. You need more cultists to succeed in this ritual."
			else if (victim_fail)
				usr << "\red The Geometer of Blood accepts this sacrifice."
				usr << "\red However, this soul was not enough to gain His favor."
			else if (victim_dead_fail)
				usr << "\red The Geometer of Blood accepts this sacrifice."
				usr << "\red However, a mere dead body is not enough to satisfy Him."
			else if (victim_alive_fail)
				usr << "\red The victim is still alive, you will need more cultists chanting for the sacrifice to succeed."
			else if (monkey_fail)
				usr << "\red The Geometer of Blood accepts this sacrifice."
				usr << "\red However, a mere monkey is not enough to satisfy Him."

			message_admins("Cultist(s) use rune to sacrifice victim(s)(<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[src.x];Y=[src.y];Z=[src.z]'>JMP</a>). Cultists: [cultists_names] Victims: [victims_names]", 0)
			log_attack("Cultist(s) use rune to sacrifice victim(s). Cultists: [cultists_names] Victims: [victims_names]")


/////////////////////////////////////////SIXTEENTH RUNE

		revealrunes(var/obj/W as obj)
			var/go=0
			var/rad
			var/S=0
			var/use = "rune"
			if(istype(W,/obj/effect/rune))
				rad = 6
				go = 1
				use = "rune"
			if (istype(W,/obj/item/weapon/paper/talisman))
				rad = 4
				go = 1
				use = "talisman"
			if (istype(W,/obj/item/weapon/nullrod))
				rad = 1
				go = 1
				use = "nullrod"
			if(go)
				for(var/obj/effect/rune/R in orange(rad,src))
					if(R!=src)
						R:visibility=15
					S=1
			if(S)
				log_game("[usr.name]([usr.ckey]) use [use] to reveal runes")
				if(istype(W,/obj/item/weapon/nullrod))
					usr << "\red Arcane markings suddenly glow from underneath a thin layer of dust!"
					return
				if(istype(W,/obj/effect/rune))
					usr.say("Nikt[pick("'","`")]o barada kla'atu!")
					for (var/mob/V in viewers(src))
						V.show_message("\red The rune turns into red dust, reveaing the surrounding runes.", 3)
					del(src)
					return
				if(istype(W,/obj/item/weapon/paper/talisman))
					usr.whisper("Nikt[pick("'","`")]o barada kla'atu!")
					usr << "\red Your talisman turns into red dust, revealing the surrounding runes."
					for (var/mob/V in orange(1,usr.loc))
						if(V!=usr)
							V.show_message("\red Red dust emanates from [usr]'s hands for a moment.", 3)
					return
				return
			if(istype(W,/obj/effect/rune))
				return	fizzle()
			if(istype(W,/obj/item/weapon/paper/talisman))
				call(/obj/effect/rune/proc/fizzle)()
				return

/////////////////////////////////////////SEVENTEENTH RUNE

		wall()
			usr.say("Khari[pick("'","`")]d! Eske'te tannin!")
			src.density = !src.density
			var/mob/living/user = usr
			user.take_organ_damage(2, 0)
			if(src.density)
				usr << "\red Your blood flows into the rune, and you feel that the very space over the rune thickens."
				log_game("[usr.name]([usr.ckey]) use rune to make space over the rune thickens")
			else
				usr << "\red Your blood flows into the rune, and you feel as the rune releases its grasp on space."
				log_game("[usr.name]([usr.ckey]) use rune to remove solid over the rune")
			return

/////////////////////////////////////////EIGHTTEENTH RUNE

		freedom()
			var/mob/living/user = usr
			var/list/mob/living/carbon/cultists = new
			var/cultists_names = ""
			var/target_name = ""
			for(var/datum/mind/H in ticker.mode.cult)
				if (istype(H.current,/mob/living/carbon))
					cultists+=H.current
			var/list/mob/living/carbon/users = new
			for(var/mob/living/carbon/C in orange(1,src))
				if(iscultist(C) && !C.stat)
					users+=C
					cultists_names +="[C] ([C.ckey])|"
			if(users.len>=3)
				var/mob/living/carbon/cultist = input("Choose the one who you want to free", "Followers of Geometer") as null|anything in (cultists - users)
				if(!cultist)
					return fizzle()
				if (cultist == user) //just to be sure.
					return
				if(!(cultist.buckled || \
					cultist.handcuffed || \
					istype(cultist.wear_mask, /obj/item/clothing/mask/muzzle) || \
					(istype(cultist.loc, /obj/structure/closet)&&cultist.loc:welded) || \
					(istype(cultist.loc, /obj/structure/closet/secure_closet)&&cultist.loc:locked) || \
					(istype(cultist.loc, /obj/machinery/dna_scannernew)&&cultist.loc:locked) \
				))
					user << "\red The [cultist] is already free."
					return
				target_name = "[cultist] ([cultist.ckey])|"
				cultist.buckled = null
				if (cultist.handcuffed)
					cultist.handcuffed.loc = cultist.loc
					cultist.handcuffed = null
					cultist.update_inv_handcuffed()
				if (cultist.legcuffed)
					cultist.legcuffed.loc = cultist.loc
					cultist.legcuffed = null
					cultist.update_inv_legcuffed()
				if (istype(cultist.wear_mask, /obj/item/clothing/mask/muzzle))
					cultist.u_equip(cultist.wear_mask)
				if(istype(cultist.loc, /obj/structure/closet)&&cultist.loc:welded)
					cultist.loc:welded = 0
				if(istype(cultist.loc, /obj/structure/closet/secure_closet)&&cultist.loc:locked)
					cultist.loc:locked = 0
				if(istype(cultist.loc, /obj/machinery/dna_scannernew)&&cultist.loc:locked)
					cultist.loc:locked = 0
				for(var/mob/living/carbon/C in users)
					user.take_overall_damage(15, 0)
					C.say("Khari[pick("'","`")]d! Gual'te nikka!")
				log_game("Cultists use rune to free [target_name]. Cultists: [cultists_names]")
				del(src)
			return fizzle()

/////////////////////////////////////////NINETEENTH RUNE

		cultsummon()
			var/mob/living/user = usr
			var/list/mob/living/carbon/cultists = new
			var/cultists_names = ""
			var/target_name = ""
			for(var/datum/mind/H in ticker.mode.cult)
				if (istype(H.current,/mob/living/carbon))
					cultists+=H.current
			var/list/mob/living/carbon/users = new
			for(var/mob/living/carbon/C in orange(1,src))
				if(iscultist(C) && !C.stat)
					users+=C
					cultists_names +="[C] ([C.ckey])|"
			if(users.len>=3)
				var/mob/living/carbon/cultist = input("Choose the one who you want to summon", "Followers of Geometer") as null|anything in (cultists - user)
				if(!cultist)
					return fizzle()
				if (cultist == user) //just to be sure.
					return
				if(cultist.buckled || cultist.handcuffed || (!isturf(cultist.loc) && !istype(cultist.loc, /obj/structure/closet) && !(istype(cultist.loc, /obj/machinery/dna_scannernew)&&cultist.loc:locked)))
					user << "\red You cannot summon the [cultist], for his shackles of blood are strong"
					return fizzle()
				target_name ="[cultist] ([cultist.ckey])|"
				cultist.loc = src.loc
				cultist.lying = 1
				cultist.regenerate_icons()
				for(var/mob/living/carbon/human/C in orange(1,src))
					if(iscultist(C) && !C.stat)
						C.say("N'ath reth sh'yro eth d[pick("'","`")]rekkathnor!")
						C.take_overall_damage(25, 0)
				user.visible_message("\red Rune disappears with a flash of red light, and in its place now a body lies.", \
				"\red You are blinded by the flash of red light! After you're able to see again, you see that now instead of the rune there's a body.", \
				"\red You hear a pop and smell ozone.")
				log_game("Cultists use rune to summon [target_name]. Cultists: [cultists_names]")
				del(src)
			return fizzle()

/////////////////////////////////////////TWENTIETH RUNES

		deafen()
			var/rune = 0
			var/cultist_use = "talisman"
			var/victims_names = ""
			if(istype(src,/obj/effect/rune))
				rune = 1
				cultist_use = "rune"
			else
				rune = 0
				cultist_use = "talisman"
			var/affected = 0
			for(var/mob/living/carbon/C in range(7,src))
				if (iscultist(C))
					continue
				var/obj/item/weapon/nullrod/N = locate() in C
				if(N)
					continue
				affected++
				victims_names +="[C] ([C.ckey])|"
				C.attack_log += "\[[time_stamp()]\]<font color='orange'> Deafened by [usr.name]([usr.ckey]) with [cultist_use]</font>"
				if(rune)
					C.ear_deaf += 50
					C.show_message("\red The world around you suddenly becomes quiet.", 3)
					if(prob(1))
						C.sdisabilities |= DEAF
				else //talismans is weaker.
					C.ear_deaf += 30
					C.show_message("\red The world around you suddenly becomes quiet.", 3)

			if(affected)
				if(rune)
					usr.say("Sti[pick("'","`")] kaliedir!")
					usr << "\red The world becomes quiet as the deafening rune dissipates into fine dust."
					usr.attack_log += "\[[time_stamp()]\]<font color='red'> Use [cultist_use] to deafen victim(s). Victims: [victims_names]</font>"
					message_admins("[usr.name]([usr.ckey])(<A HREF='?_src_=holder;adminplayerobservejump=\ref[usr]'>JMP</A>) use [cultist_use] to deafen victim(s). Victims: [victims_names]", 0)
					log_attack("[usr.name]([usr.ckey]) use [cultist_use] to deafen victim(s). Victims: [victims_names]")
					del(src)
				else
					usr.whisper("Sti[pick("'","`")] kaliedir!")
					usr << "\red Your talisman turns into gray dust, deafening everyone around."
					for (var/mob/V in orange(1,src))
						if(!(iscultist(V)))
							V.show_message("\red Dust flows from [usr]'s hands for a moment, and the world suddenly becomes quiet..", 3)
					usr.attack_log += "\[[time_stamp()]\]<font color='red'> Use [cultist_use] to deafen victim(s). Victims: [victims_names]</font>"
					message_admins("[usr.name]([usr.ckey])(<A HREF='?_src_=holder;adminplayerobservejump=\ref[usr]'>JMP</A>) use [cultist_use] to deafen victim(s). Victims: [victims_names]", 0)
					log_attack("[usr.name]([usr.ckey]) use [cultist_use] to deafen victim(s). Victims: [victims_names]")
			else if(rune)
				return fizzle()

			return

		blind()
			var/rune = 0
			var/cultist_use = "talisman"
			var/victims_names = ""
			var/list/range_view = null
			if(istype(src,/obj/effect/rune))
				rune = 1
				range_view = viewers(src)
				cultist_use = "rune"
			else
				rune = 0
				range_view = view(2,usr)
				cultist_use = "talisman"
			var/affected = 0
			for(var/mob/living/carbon/C in range_view)
				if (iscultist(C))
					continue
				var/obj/item/weapon/nullrod/N = locate() in C
				if(N)
					continue
				affected++
				victims_names +="[C] ([C.ckey])|"
				C.attack_log += "\[[time_stamp()]\]<font color='orange'> Blinded by [usr.name]([usr.ckey]) with [cultist_use]</font>"
				if(rune)
					C.eye_blurry += 50
					C.eye_blind += 20
					if(prob(5))
						C.disabilities |= NEARSIGHTED
						if(prob(10))
							C.sdisabilities |= BLIND
					C.show_message("\red Suddenly you see red flash that blinds you.", 3)
				else //talismans is weaker.
					C.eye_blurry += 30
					C.eye_blind += 10
					C.show_message("\red You feel a sharp pain in your eyes, and the world disappears into darkness..", 3)

			if(affected)
				if(rune)
					usr.say("Sti[pick("'","`")] kaliesin!")
					usr << "\red The rune flashes, blinding those who not follow the Nar-Sie, and dissipates into fine dust."
					usr.attack_log += "\[[time_stamp()]\]<font color='red'> Use [cultist_use] to blind victim(s). Victims: [victims_names]</font>"
					message_admins("[usr.name]([usr.ckey])(<A HREF='?_src_=holder;adminplayerobservejump=\ref[usr]'>JMP</A>) use [cultist_use] to blind victim(s). Victims: [victims_names]", 0)
					log_attack("[usr.name]([usr.ckey]) use [cultist_use] to blind victim(s). Victims: [victims_names]")
					del(src)
				else
					usr.whisper("Sti[pick("'","`")] kaliesin!")
					usr << "\red Your talisman turns into gray dust, blinding those who not follow the Nar-Sie."
					usr.attack_log += "\[[time_stamp()]\]<font color='red'> Use [cultist_use] to blind victim(s). Victims: [victims_names]</font>"
					message_admins("[usr.name]([usr.ckey])(<A HREF='?_src_=holder;adminplayerobservejump=\ref[usr]'>JMP</A>) use [cultist_use] to blind victim(s). Victims: [victims_names]", 0)
					log_attack("[usr.name]([usr.ckey]) use [cultist_use] to blind victim(s). Victims: [victims_names]")
			else if(rune)
				return fizzle()

			return


		bloodboil() //cultists need at least one DANGEROUS rune. Even if they're all stealthy.
/*
			var/list/mob/living/carbon/cultists = new
			for(var/datum/mind/H in ticker.mode.cult)
				if (istype(H.current,/mob/living/carbon))
					cultists+=H.current
*/
			var/culcount = 0 //also, wording for it is old wording for obscure rune, which is now hide-see-blood.
//			var/list/cultboil = list(cultists-usr) //and for this words are destroy-see-blood.
			var/cultists_names = ""
			var/victims_names = ""
			for(var/mob/living/carbon/C in orange(1,src))
				if(iscultist(C) && !C.stat)
					culcount++
					cultists_names +="[C] ([C.ckey])|"
			if(culcount>=3)
				for(var/mob/living/carbon/M in viewers(usr))
					if(iscultist(M))
						continue
					var/obj/item/weapon/nullrod/N = locate() in M
					if(N)
						continue
					victims_names +="[M] ([M.ckey])|"
					M.attack_log += "\[[time_stamp()]\]<font color='orange'> Blood is boiled by cultists with rune. Cultists: [cultists_names]</font>"
					M.take_overall_damage(51,51)
					M << "\red Your blood boils!"
					if(prob(5))
						spawn(5)
							M.gib()
				for(var/obj/effect/rune/R in view(src))
					if(prob(10))
						explosion(R.loc, -1, 0, 1, 5)
				for(var/mob/living/carbon/human/C in orange(1,src))
					if(iscultist(C) && !C.stat)
						C.say("Dedo ol[pick("'","`")]btoh!")
						C.take_overall_damage(15, 0)
						C.attack_log += "\[[time_stamp()]\]<font color='red'> Use rune to boil victim(s)'s blood. Victims: [victims_names]</font>"
				message_admins("Cultists use to boil victim(s)'s blood(<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[src.x];Y=[src.y];Z=[src.z]'>JMP</a>). Cultists: [cultists_names] Victims: [victims_names]", 0)
				log_attack("Cultists use to boil victim(s)'s blood. Cultists: [cultists_names] Victims: [victims_names]")
				del(src)
			else
				return fizzle()
			return

// WIP rune, I'll wait for Rastaf0 to add limited blood.

		burningblood()
			var/culcount = 0
			for(var/mob/living/carbon/C in orange(1,src))
				if(iscultist(C) && !C.stat)
					culcount++
			if(culcount >= 5)
				for(var/obj/effect/rune/R in world)
					if(R.blood_DNA == src.blood_DNA)
						for(var/mob/living/M in orange(2,R))
							M.take_overall_damage(0,15)
							if (R.invisibility>M.see_invisible)
								M << "\red Aargh it burns!"
							else
								M << "\red Rune suddenly ignites, burning you!"
							var/turf/T = get_turf(R)
							T.hotspot_expose(700,125)
				for(var/obj/effect/decal/cleanable/blood/B in world)
					if(B.blood_DNA == src.blood_DNA)
						for(var/mob/living/M in orange(1,B))
							M.take_overall_damage(0,5)
							M << "\red Blood suddenly ignites, burning you!"
							var/turf/T = get_turf(B)
							T.hotspot_expose(700,125)
							del(B)
				del(src)

//////////             Rune 24 (counting burningblood, which kinda doesnt work yet.)

		runestun(var/mob/living/T as mob)
			if(istype(src,/obj/effect/rune))   ///When invoked as rune, flash and stun everyone around.
				usr.say("Fuu ma[pick("'","`")]jin!")
				var/victims_names = ""
				for(var/mob/living/L in viewers(src))

					if(iscarbon(L))
						var/mob/living/carbon/C = L
						flick("e_flash", C.flash)
						if(C.stuttering < 1 && (!(HULK in C.mutations)))
							C.stuttering = 1
						C.Weaken(1)
						C.Stun(1)
						C.show_message("\red The rune explodes in a bright flash.", 3)
						C.attack_log += "\[[time_stamp()]\]<font color='orange'> Stuned by [usr.name]([usr.ckey]) with rune</font>"
						victims_names +="[L] ([L.ckey])|"

					else if(issilicon(L))
						var/mob/living/silicon/S = L
						S.Weaken(5)
						S.show_message("\red BZZZT... The rune has exploded in a bright flash.", 3)
						S.attack_log += "\[[time_stamp()]\]<font color='orange'> Stuned by [usr.name]([usr.ckey]) with rune</font>"
						victims_names +="[L] ([L.ckey])|"
				if (victims_names)
					usr.attack_log += "\[[time_stamp()]\]<font color='red'> Use rune to stun victim(s). Victims: [victims_names]</font>"
					message_admins("[usr.name]([usr.ckey])(<A HREF='?_src_=holder;adminplayerobservejump=\ref[usr]'>JMP</A>) use rune to stun victim(s). Victims: [victims_names]", 0)
					log_attack("[usr.name]([usr.ckey]) use rune to blind victim(s). Victims: [victims_names]")
				del(src)
			else                        ///When invoked as talisman, stun and mute the target mob.
				usr.say("Dream sign ''Evil sealing talisman'[pick("'","`")]!")
				var/obj/item/weapon/nullrod/N = locate() in T
				if(N)
					for(var/mob/O in viewers(T, null))
						O.show_message(text("\red <B>[] invokes a talisman at [], but they are unaffected!</B>", usr, T), 1)
				else
					for(var/mob/O in viewers(T, null))
						O.show_message(text("\red <B>[] invokes a talisman at []</B>", usr, T), 1)

					if(issilicon(T))
						T.Weaken(15)

					else if(iscarbon(T))
						var/mob/living/carbon/C = T
						flick("e_flash", C.flash)
						if (!(HULK in C.mutations))
							C.silent += 15
						C.Weaken(25)
						C.Stun(25)
					usr.attack_log += "\[[time_stamp()]\]<font color='red'> Use talisman to stun [T.name]([T.ckey])</font>"
					T.attack_log += "\[[time_stamp()]\]<font color='orange'> Stuned by [usr.name]([usr.ckey]) with talisman</font>"
					message_admins("[usr.name]([usr.ckey])(<A HREF='?_src_=holder;adminplayerobservejump=\ref[usr]'>JMP</A>) use talisman to stun [T.name]([T.ckey])", 0)
					log_attack("[usr.name]([usr.ckey]) use talisman to stun [T.name]([T.ckey])")
				return

/////////////////////////////////////////TWENTY-FIFTH RUNE

		armor()
			var/mob/living/carbon/human/user = usr
			if(istype(src,/obj/effect/rune))
				usr.say("N'ath reth sh'yro eth d[pick("'","`")]raggathnor!")
			else
				usr.whisper("N'ath reth sh'yro eth d[pick("'","`")]raggathnor!")
			usr.visible_message("\red The rune disappears with a flash of red light, and a set of armor appears on [usr]...", \
			"\red You are blinded by the flash of red light! After you're able to see again, you see that you are now wearing a set of armor.")

			user.equip_to_slot_or_del(new /obj/item/clothing/head/culthood/alt(user), slot_head)
			user.equip_to_slot_or_del(new /obj/item/clothing/suit/cultrobes/alt(user), slot_wear_suit)
			user.equip_to_slot_or_del(new /obj/item/clothing/shoes/cult(user), slot_shoes)
			user.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/cultpack(user), slot_back)
			//the above update their overlay icons cache but do not call update_icons()
			//the below calls update_icons() at the end, which will update overlay icons by using the (now updated) cache
			user.put_in_hands(new /obj/item/weapon/melee/cultblade(user))	//put in hands or on floor
			user.take_overall_damage(15, 0)
			log_game("[usr.name]([usr.ckey]) use rune to stun summon a set of armor")

			del(src)
			return
