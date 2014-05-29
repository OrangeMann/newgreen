//This could either be split into the proper DM files or placed somewhere else all together, but it'll do for now -Nodrak

/*

A list of items and costs is stored under the datum of every game mode, alongside the number of crystals, and the welcoming message.

*/

/obj/item/device/uplink
	var/welcome 						// Welcoming menu message
	var/list/datum/spawn_item/items	// Parsed list of items
	var/uses 							// Numbers of crystals
	// List of items not to shove in their hands.
	var/list/NotInHand = list(/obj/machinery/singularity_beacon/syndicate)

/obj/item/device/uplink/New()
	welcome = ticker.mode.uplink_welcome
	items = ticker.mode.uplink_items
	uses = ticker.mode.uplink_uses

//Let's build a menu!
/obj/item/device/uplink/proc/generate_menu()
	var/count_of_items = 1
	var/dat = "<B>[src.welcome]</B><BR>"
	dat += "Tele-Crystals left: [src.uses]<BR>"
	dat += "<HR>"
	dat += "<B>Request item:</B><BR>"
	dat += "<I>Each item costs a number of tele-crystals as indicated by the number following their name.</I><br>"

	for(var/datum/spawn_item/i in items)
		if(istype(i, /datum/spawn_item/string))
			if(count_of_items <= 0)
				dat += "<i>We apologize, as you could not afford anything from this category.</i><br><br>"
			dat += "<br><b>[i.name]</b><br>"
			count_of_items = 0
			continue
		if(uses < i.cost)
			continue
		count_of_items++
		dat += "<a href='?src=\ref[src];buy_item=\ref[i]'>[i.name]</a> ([i.cost])<br>"
	if(count_of_items <= 0)
		dat += "<i>We apologize, as you could not afford anything from this category.</i><br>"
	dat += "<HR>"
	return dat

/obj/item/device/uplink/Topic(href, href_list)

	if (href_list["buy_item"])
		var/datum/spawn_item/i = locate(href_list["buy_item"])
		if(!i)
			return 0
		if(!(i in items))
			return 0
		if(i.cost > uses)
			return 0
		uses -= i.cost

		return 1



// HIDDEN UPLINK - Can be stored in anything but the host item has to have a trigger for it.
/* How to create an uplink in 3 easy steps!

 1. All obj/item 's have a hidden_uplink var. By default it's null. Give the item one with "new(src)", it must be in it's contents. Feel free to add "uses".

 2. Code in the triggers. Use check_trigger for this, I recommend closing the item's menu with "usr << browse(null, "window=windowname") if it returns true.
 The var/value is the value that will be compared with the var/target. If they are equal it will activate the menu.

 3. If you want the menu to stay until the users locks his uplink, add an active_uplink_check(mob/user as mob) in your interact/attack_hand proc.
 Then check if it's true, if true return. This will stop the normal menu appearing and will instead show the uplink menu.
*/

/obj/item/device/uplink/hidden
	name = "Hidden Uplink."
	desc = "There is something wrong if you're examining this."
	var/active = 0
	var/list/purchase_log = list()

// The hidden uplink MUST be inside an obj/item's contents.
/obj/item/device/uplink/hidden/New()
	spawn(2)
		if(!istype(src.loc, /obj/item))
			del(src)
	..()

// Toggles the uplink on and off. Normally this will bypass the item's normal functions and go to the uplink menu, if activated.
/obj/item/device/uplink/hidden/proc/toggle()
	active = !active

// Directly trigger the uplink. Turn on if it isn't already.
/obj/item/device/uplink/hidden/proc/trigger(mob/user as mob)
	if(!active)
		toggle()
	interact(user)

// Checks to see if the value meets the target. Like a frequency being a traitor_frequency, in order to unlock a headset.
// If true, it accesses trigger() and returns 1. If it fails, it returns false. Use this to see if you need to close the
// current item's menu.
/obj/item/device/uplink/hidden/proc/check_trigger(mob/user as mob, var/value, var/target)
	if(value == target)
		trigger(user)
		return 1
	return 0

// Interaction code. Gathers a list of items purchasable from the paren't uplink and displays it. It also adds a lock button.
/obj/item/device/uplink/hidden/interact(mob/user as mob)

	var/dat = "<body link='yellow' alink='white' bgcolor='#601414'><font color='white'>"
	dat += src.generate_menu()
	dat += "<A href='byond://?src=\ref[src];lock=1'>Lock</a>"
	dat += "</font></body>"
	user << browse(dat, "window=hidden")
	onclose(user, "hidden")
	return

// The purchasing code.
/obj/item/device/uplink/hidden/Topic(href, href_list)

	if (usr.stat || usr.restrained())
		return

	if (!( istype(usr, /mob/living/carbon/human)))
		return 0

	if ((usr.contents.Find(src.loc) || (in_range(src.loc, usr) && istype(src.loc.loc, /turf))))
		usr.set_machine(src)
		if(href_list["lock"])
			toggle()
			usr << browse(null, "window=hidden")
			return 1

		if(..(href, href_list) == 1)
			var/datum/spawn_item/i = locate(href_list["buy_item"])
			var/obj/I = i.give_item(usr)
			purchase_log += "[usr] ([usr.ckey]) bought [I]."
	interact(usr)
	return

// I placed this here because of how relevant it is.
// You place this in your uplinkable item to check if an uplink is active or not.
// If it is, it will display the uplink menu and return 1, else it'll return false.
// If it returns true, I recommend closing the item's normal menu with "user << browse(null, "window=name")"
/obj/item/proc/active_uplink_check(mob/user as mob)
	// Activates the uplink if it's active
	if(src.hidden_uplink)
		if(src.hidden_uplink.active)
			src.hidden_uplink.trigger(user)
			return 1
	return 0

// PRESET UPLINKS
// A collection of preset uplinks.
//
// Includes normal radio uplink, multitool uplink,
// implant uplink (not the implant tool) and a preset headset uplink.

/obj/item/device/radio/uplink/New()
	hidden_uplink = new(src)
	icon_state = "radio"

/obj/item/device/radio/uplink/attack_self(mob/user as mob)
	if(hidden_uplink)
		hidden_uplink.trigger(user)

/obj/item/device/multitool/uplink/New()
	hidden_uplink = new(src)

/obj/item/device/multitool/uplink/attack_self(mob/user as mob)
	if(hidden_uplink)
		hidden_uplink.trigger(user)

/obj/item/device/radio/headset/uplink
	traitor_frequency = 1445

/obj/item/device/radio/headset/uplink/New()
	..()
	hidden_uplink = new(src)
	hidden_uplink.uses = 10



