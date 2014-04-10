/datum/uplink_item
	var/name = "invalid"
	var/path = /obj
	var/cost = 1
	var/category = ""

	proc/give_item(var/atom/loc)
		var/obj/I = new path(loc)
		if(ishuman(loc))
			var/mob/living/carbon/human/A = loc
			A.put_in_any_hand_if_possible(I)

/datum/uplink_item/revolver
	name = "Revolver"
	path = /obj/item/weapon/gun/projectile/revolver
	cost = 6
	category = "Highly Visible and Dangerous Weapons"

/datum/uplink_item/revolver_ammo
	name = "Ammo-357"
	path = /obj/item/ammo_magazine/box/a357
	cost = 2
	category = "Highly Visible and Dangerous Weapons"

/datum/uplink_item/crossbow
	name = "Energy Crossbow"
	path = /obj/item/weapon/gun/energy/crossbow
	cost = 5
	category = "Highly Visible and Dangerous Weapons"

/datum/uplink_item/crossbow
	name = "Energy Crossbow"
	path = /obj/item/weapon/gun/energy/crossbow
	cost = 5
	category = "Highly Visible and Dangerous Weapons"

/datum/uplink_item/sword
	name = "Energy Sword"
	path = /obj/item/weapon/melee/energy/sword
	cost = 4
	category = "Highly Visible and Dangerous Weapons"

/datum/uplink_item/syndicate_bundle
	name = "Syndicate Bundle"
	path = /obj/item/weapon/storage/box/syndicate
	cost = 10
	category = "Highly Visible and Dangerous Weapons"

/datum/uplink_item/emp_grenades
	name = "5 EMP Grenades"
	path = /obj/item/weapon/storage/box/emps
	cost = 3
	category = "Highly Visible and Dangerous Weapons"

/datum/uplink_item/syndicate_bomb
	name = "Syndicate Bundle"
	path = /obj/item/device/syndicatebomb
	cost = 6
	category = "Highly Visible and Dangerous Weapons"

/datum/uplink_item/paralysis_pen
	name = "Paralysis Pen"
	path = /obj/item/weapon/pen/paralysis
	cost = 3
	category = "Stealthy and Inconspicuous Weapons"

/datum/uplink_item/syndicate_soap
	name = "Syndicate Soap"
	path = /obj/item/weapon/soap/syndie
	cost = 1
	category = "Stealthy and Inconspicuous Weapons"

/datum/uplink_item/detomatrix
	name = "Detomatix PDA Cartridge"
	path = /obj/item/weapon/cartridge/syndicate
	cost = 3
	category = "Stealthy and Inconspicuous Weapons"
/*
/datum/uplink_item
	name = ""
	path =
	cost =
	category = "Stealth and Camouflage Items"
*/
/datum/uplink_item/chameleon_kit
	name = "Chameleon Kit"
	path = /obj/item/weapon/storage/box/syndie_kit/chameleon
	cost = 7
	category = "Stealth and Camouflage Items"

/datum/uplink_item/syndicate_shoes
	name = "No-Slip Syndicate Shoes"
	path = /obj/item/clothing/shoes/syndigaloshes
	cost = 2
	category = "Stealth and Camouflage Items"

/datum/uplink_item/agentcard
	name = "Agent ID card"
	path = /obj/item/weapon/card/id/syndicate
	cost = 2
	category = "Stealth and Camouflage Items"

/datum/uplink_item/voice_changer
	name = "Voice Changer"
	path = /obj/item/clothing/mask/gas/voice
	cost = 4
	category = "Stealth and Camouflage Items"

/datum/uplink_item/chameleon_projector
	name = "Chameleon-Projector"
	path = /obj/item/device/chameleon
	cost = 4
	category = "Stealth and Camouflage Items"

/datum/uplink_item/cloaking_device
	name = "Cloaking Device"
	path = /obj/item/weapon/cloaking_device
	cost = 8
	category = "Stealth and Camouflage Items"

	give_item(var/atom/loc)
		loc << "You feel some shitty smell"
		..()