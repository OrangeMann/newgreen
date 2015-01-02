/datum/job/BPact_soldier
	title = "Blood Pact Soldier"
	flag = BPACTS
	department_flag = BPACT
	faction = "Station"
	total_positions = -1
	spawn_positions = -1
	supervisors = "the Blood Pact sergeants and commisars"
	selection_color = "#ffeeee"
	minimal_player_age = 7
	equip(var/mob/living/carbon/human/H)
		if(!H)	return 0
		H.equip_to_slot_or_del(new /obj/item/clothing/under/warhammer/BPact(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/warhammer/bloodpact(H), slot_wear_suit)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/warhammer/BPact(H), slot_head)
		H.equip_to_slot_or_del(new /obj/item/clothing/mask/BPmask(H), slot_wear_mask)
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack(H), slot_back)
		H.equip_to_slot_or_del(new /obj/item/weapon/gun/energy/laser(H), slot_in_backpack)
		H.equip_to_slot_or_del(new /obj/item/weapon/cell/(H), slot_in_backpack)
		H.equip_to_slot_or_del(new /obj/item/weapon/cell/(H), slot_in_backpack)
		H.equip_to_slot_or_del(new /obj/item/weapon/spade(H), slot_belt)
		H.equip_to_slot_or_del(new /obj/item/device/radio(H), slot_r_hand)
		return 1


/datum/job/BPact_sergeant
	title = "Blood Pact Sergeant"
	flag = BPSGT
	department_flag = BPACT
	faction = "Station"
	total_positions = 5
	spawn_positions = 5
	supervisors = "the Blood Pact commisars"
	selection_color = "#ffeeee"
	minimal_player_age = 7
	equip(var/mob/living/carbon/human/H)
		if(!H)	return 0
		H.equip_to_slot_or_del(new /obj/item/clothing/under/warhammer/BPact_sgt(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/warhammer/bloodpact_sgt(H), slot_wear_suit)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/warhammer/BPact_sgt(H), slot_head)
		H.equip_to_slot_or_del(new /obj/item/clothing/mask/BPmask(H), slot_wear_mask)
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack(H), slot_back)
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/belt/utility/full(H), slot_belt)
		return 1


/datum/job/BPact_comm
	title = "Blood Pact Commisar"
	flag = BPCOMM
	department_flag = BPACT
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "your boss"
	selection_color = "#ffeeee"
	minimal_player_age = 7
	equip(var/mob/living/carbon/human/H)
		if(!H)	return 0
		H.equip_to_slot_or_del(new /obj/item/clothing/under/warhammer/krieg(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/hos(H), slot_wear_suit)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/warhammer/khelmet(H), slot_head)
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack(H), slot_back)
		H.equip_to_slot_or_del(new /obj/item/weapon/spade(H), slot_belt)
		H.equip_to_slot_or_del(new /obj/item/device/radio(H), slot_r_hand)
		H.equip_to_slot_or_del(new /obj/item/weapon/cell(H), slot_in_backpack)
		H.equip_to_slot_or_del(new /obj/item/weapon/cell(H), slot_in_backpack)
		H.equip_to_slot_or_del(new /obj/item/weapon/melee/baton(H), slot_in_backpack)
		return 1


/datum/job/Krieg_soldier
	title = "Krieg Soldier"
	flag = KRIEGS
	department_flag = KRIEG
	faction = "Station"
	total_positions = -1
	spawn_positions = -1
	supervisors = "the Krieg sergeants and commisars"
	selection_color = "#ffddf0"
	minimal_player_age = 7
	equip(var/mob/living/carbon/human/H)
		if(!H)	return 0
		H.equip_to_slot_or_del(new /obj/item/clothing/under/warhammer/krieg(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/warhammer/krieg(H), slot_wear_suit)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/warhammer/khelmet(H), slot_head)
		H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/krieg(H), slot_wear_mask)
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack(H), slot_back)
		H.equip_to_slot_or_del(new /obj/item/weapon/spade(H), slot_belt)
		H.equip_to_slot_or_del(new /obj/item/device/radio(H), slot_r_hand)
		H.equip_to_slot_or_del(new /obj/item/weapon/cell(H), slot_in_backpack)
		H.equip_to_slot_or_del(new /obj/item/weapon/cell(H), slot_in_backpack)
		return 1

/datum/job/Krieg_sergeant
	title = "Krieg Sergeant"
	flag = KRIEGSGT
	department_flag = KRIEG
	faction = "Station"
	total_positions = 5
	spawn_positions = 5
	supervisors = "the Krieg commisars"
	selection_color = "#ffddf0"
	minimal_player_age = 7
	equip(var/mob/living/carbon/human/H)
		if(!H)	return 0
		H.equip_to_slot_or_del(new /obj/item/clothing/under/warhammer/krieg(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/warhammer/krieg_sgt(H), slot_wear_suit)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/warhammer/khelmet_sgt(H), slot_head)
		H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/krieg(H), slot_wear_mask)
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack(H), slot_back)
		H.equip_to_slot_or_del(new /obj/item/weapon/gun/energy/laser(H), slot_in_backpack)
		H.equip_to_slot_or_del(new /obj/item/weapon/cell(H), slot_in_backpack)
		H.equip_to_slot_or_del(new /obj/item/weapon/cell(H), slot_in_backpack)
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/belt/utility/full(H), slot_belt)
		H.equip_to_slot_or_del(new /obj/item/device/radio(H), slot_r_hand)
		return 1

/datum/job/Krieg_comm
	title = "Krieg Commisar"
	flag = KRIEGCOMM
	department_flag = KRIEG
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "your boss"
	selection_color = "#ffddf0"
	minimal_player_age = 7
	equip(var/mob/living/carbon/human/H)
		if(!H)	return 0
		H.equip_to_slot_or_del(new /obj/item/clothing/under/warhammer/krieg(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/warhammer/krieg_com(H), slot_wear_suit)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/warhammer/khelmet(H), slot_head)
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack(H), slot_back)
		H.equip_to_slot_or_del(new /obj/item/weapon/spade(H), slot_belt)
		H.equip_to_slot_or_del(new /obj/item/device/radio(H), slot_r_hand)
		H.equip_to_slot_or_del(new /obj/item/weapon/cell(H), slot_in_backpack)
		H.equip_to_slot_or_del(new /obj/item/weapon/cell(H), slot_in_backpack)
		H.equip_to_slot_or_del(new /obj/item/weapon/melee/baton(H), slot_in_backpack)
		return 1