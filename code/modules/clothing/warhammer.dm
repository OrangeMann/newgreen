/*
Champion armor
*/
/*
Krieg uniform
Krieg sergeant uniform
Commissar uniform
*/

/*
melee - 25, laser - 25, bullet - 5, fire - 15
Champion - melee - 35, laser - 50, bullet - 15, fire - 25
*/

/obj/item/clothing/under/warhammer
	armor = list(melee = 10, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	desc = "It's made of a slightly sturdier material than standard jumpsuits, to allow for more robust protection."

/obj/item/clothing/under/warhammer/BPact
	name = "Blood Pact uniform"
	icon_state = "black"
	item_state = "bl_suit"
	item_color = "bloodpact"
	flags = FPRINT | TABLEPASS

/obj/item/clothing/under/warhammer/BPact_serg
	name = "Blood Pact sergeant uniform"
	icon_state = "black"
	item_state = "bl_suit"
	item_color = "bloodpact_sgt"
	flags = FPRINT | TABLEPASS

/obj/item/clothing/suit/armor/warhammer
	name = "armor"
	desc = "A suit that excels in protecting the wearer against high-velocity solid projectiles and hard hits."
	icon_state = "deathsquad"
	item_state = "swat_suit"
	armor = list(melee = 25, bullet = 5, laser = 25, energy = 15, bomb = 10, bio = 0, rad = 0)
	siemens_coefficient = 1

/obj/item/clothing/suit/armor/warhammer/bloodpact
	name = "Blood Pact armor"
	item_state = "bloodpact"

/obj/item/clothing/suit/armor/warhammer/bloodpact_sgt
	name = "Blood Pact sergeant armor"
	item_state = "bloodpact_sgt"



/obj/item/clothing/head/warhammer
	name = "helmet"
	desc = "Standard Security gear. Protects the head from impacts."
	icon_state = "helmet"
	flags = FPRINT | TABLEPASS
	item_state = "helmet"
	armor = list(melee = 15, bullet = 5, laser = 15, energy = 10, bomb = 5, bio = 0, rad = 0)
	flags_inv = HIDEEARS
	cold_protection = HEAD
	min_cold_protection_temperature = HELMET_MIN_COLD_PROTECITON_TEMPERATURE
	heat_protection = HEAD
	max_heat_protection_temperature = HELMET_MAX_HEAT_PROTECITON_TEMPERATURE
	siemens_coefficient = 0.7

/obj/item/clothing/head/warhammer/khelmet
	name = "Krieg helmet"
	desc = "Krieg helmet"
	icon = 'icons/Warhammer/Head.dmi'
	flags = FPRINT|TABLEPASS|BLOCKHAIR
	flags_inv = HIDEEARS
	siemens_coefficient = 1

/obj/item/clothing/head/warhammer/khelmet_sgt
	name = "Krieg sergeant helmet"
	desc = "Krieg sergeant helmet"
	icon = 'icons/Warhammer/Head2.dmi'
	flags = FPRINT|TABLEPASS|BLOCKHAIR
	flags_inv = HIDEEARS
	siemens_coefficient = 1

/obj/item/clothing/head/warhammer/BPact_sgt
	name = "Blood Pact sergeant helmet"
	desc = "Blood Pact sergeant helmet"
	icon = 'icons/Warhammer/sgthlm.dmi'
	flags = FPRINT|TABLEPASS|BLOCKHAIR
	flags_inv = HIDEEARS
	siemens_coefficient = 1

/obj/item/clothing/head/warhammer/BPact
	name = "Blood Pact helmet"
	desc = "Blood Pact helmet"
	icon = 'icons/Warhammer/sldhlm.dmi'
	flags = FPRINT|TABLEPASS|BLOCKHAIR
	flags_inv = HIDEEARS
	siemens_coefficient = 1

/obj/item/clothing/mask/BPmask
	name = "Blood Pact mask"
	desc = "Blood Pact mask"
	icon = 'icons/Warhammer/BPmask.dmi'
	icon_state = "mask"
	item_state = "mask"
	flags = FPRINT|TABLEPASS
	flags_inv = HIDEFACE
	w_class = 2
	siemens_coefficient = 0.9

/obj/item/clothing/mask/gas/krieg
	name = "Krieg gasmask"
	desc = "krieg gasmask"
	icon = 'icons/Warhammer/Mask.dmi'
	siemens_coefficient = 0.9
	can_breath = 1
	can_eat = 0