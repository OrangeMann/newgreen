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
	siemens_coefficient = 1

/obj/item/clothing/under/warhammer/BPact
	name = "Blood Pact uniform"
	icon_state = "black"
	item_state = "bl_suit"
	item_color = "bloodpact"
	flags = FPRINT | TABLEPASS

/obj/item/clothing/under/warhammer/BPact_sgt
	name = "Blood Pact sergeant uniform"
	icon_state = "black"
	item_state = "bl_suit"
	item_color = "bloodpact_sgt"
	flags = FPRINT | TABLEPASS

/obj/item/clothing/under/warhammer/krieg
	name = "Krieg uniform"
	icon_state = "hos_corporate"
	item_state = "hos_corporate"
	item_color = "hos_corporate"
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
	icon_state = "bloodpact"

/obj/item/clothing/suit/armor/warhammer/bloodpact_sgt
	name = "Blood Pact sergeant armor"
	item_state = "bloodpact_sgt"
	icon_state = "bloodpact_sgt"

/obj/item/clothing/suit/armor/warhammer/krieg
	name = "Krieg armor"
	item_state = "krieg"
	icon_state = "krieg"

/obj/item/clothing/suit/armor/warhammer/krieg_sgt
	name = "Krieg sergeant armor"
	item_state = "krieg_officer"
	icon_state = "krieg_officer"

/obj/item/clothing/suit/armor/warhammer/krieg_com
	name = "Krieg commissar armor"
	item_state = "krieg_commissar"
	icon_state = "krieg_commissar"


/obj/item/clothing/head/helmet/warhammer
	name = "helmet"
	desc = "Standard Security gear. Protects the head from impacts."
	icon_state = "helmet"
	item_state = "helmet"
	siemens_coefficient = 1

/obj/item/clothing/head/helmet/warhammer/khelmet
	name = "Krieg helmet"
	desc = "Krieg helmet"
	icon_state = "helmetkrieg"
	item_state = "helmetkrieg"

/obj/item/clothing/head/helmet/warhammer/khelmet_sgt
	name = "Krieg sergeant helmet"
	desc = "Krieg sergeant helmet"
	icon_state = "helmetkriegoff"
	item_state = "helmetkriegoff"

/obj/item/clothing/head/helmet/warhammer/BPact_sgt
	name = "Blood Pact sergeant helmet"
	desc = "Blood Pact sergeant helmet"
	icon_state = "bloodpact_sgt"
	item_state = "bloodpact_sgt"


/obj/item/clothing/head/helmet/warhammer/BPact
	name = "Blood Pact helmet"
	desc = "Blood Pact helmet"
	icon_state = "bloodpact"
	item_state = "bloodpact"

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
	icon_state = "mask"
	item_state = "mask"
	siemens_coefficient = 0.9
	can_breath = 1
	can_eat = 0

/obj/item/weapon/spade
	name = "spade"
	desc = "Dig a trench. Or chop enemies!"
	icon_state = "spade"
	slot_flags = SLOT_BELT
	force = 30