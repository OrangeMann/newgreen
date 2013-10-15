// JARLA, U ARE MAD! -- Jarlo
//Jail shit here


/obj/item/weapon/ore/sand //unusable.
	name = "Sand"
	icon_state = "Glass ore"
	origin_tech = "materials=1"
	desc = "ON PATH TO MOTHERLAND!"

//paper spoon!
/obj/item/weapon/paperspoon
	icon = 'icons/obj/kitchen.dmi'
	name = "paper spoon"
	desc = "Jailers are so brutal."
	icon_state = "pspoon"
	attack_verb = list("attacked", "poked")
	var/drill_sound = 'sound/weapons/Genhit.ogg'


//wall. Only for jail, lol
/turf/simulated/wall/r_wall/jail
	var/sandcapas = 10
	var/last_act = 0
	proc/digproc(mob/user as mob)
		var/loca = usr.loc
		sleep(180)
		if (usr.loc == loca)
			if (sandcapas == 1)
				src.ChangeTurf(/turf/simulated/floor/plating)
				var/turf/simulated/floor/F = src
				F.burn_tile()
				F.icon_state = "wall_thermite"
				usr << "\blue You finish picking the wall."
			else
				usr << "\blue You picked out some sand."
				var/obj/item/weapon/ore/sand/S = new(usr)
				S.loc = usr.loc	//recheck.
				sandcapas -= 1
				digproc() //again.


	attackby(obj/item/weapon/W as obj, mob/user as mob)
		if (istype(W, /obj/item/weapon/paperspoon))
			var/obj/item/weapon/paperspoon/P = W
			if(last_act+100 > world.time)//prevents message spam
				return
			last_act = world.time

			playsound(user, P.drill_sound, 20, 1)
			usr << "\red You start picking a wall."
			digproc(user)



/obj/structure/sink/attackby(obj/item/O as obj, mob/user as mob)
	if (istype(O, /obj/item/weapon/paper))
		new /obj/item/weapon/paperspoon( get_turf(usr.loc), 2 )
		usr << "You make paper spoon! You are mad!"
		del(O)
		return
	..()