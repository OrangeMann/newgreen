/datum/admins/proc/addwhitelist()
	set category = "Server"
	set desc="Add to whitelist"
	set name="Add To Whitelist"
	if(usr.client.holder.rank in list("Game Master", "Host", "Game Admin"))
		var/accname = ckey(input(usr,"Ckey of a player","ckey", null) as text|null)
		if(!accname)
			return
		var/DBConnection/dbcon = new()
		dbcon.Connect("dbi:mysql:[sqldb]:[sqladdress]:[sqlport]","[sqllogin]","[sqlpass]")
		if(!dbcon.IsConnected())
			log_admin("Failed to connect DB. Error: [dbcon.ErrorMsg()]")
			return
		var/DBQuery/query = dbcon.NewQuery("INSERT INTO whitelist (byond) VALUES ('[accname]')")
		if(!query.Execute())
			src << "Unable to add key into DB"
			dbcon.Disconnect()
			return
		dbcon.Disconnect()
		log_admin("[key_name(usr)] added [accname] to whitelist.")
		message_admins("[key_name_admin(usr)] added [accname] to whitelist.", 1)
	else
		usr << "Not enough high admin rank to do this"

mob/var/whiteoff = 0