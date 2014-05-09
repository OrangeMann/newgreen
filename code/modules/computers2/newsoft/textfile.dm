///////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////TEXT FILE////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
/datum/file/software/app/textfile
	name = "Text file"
	size = 1
	display_icon = "solar"
	var/saved_text = ""
	var/file_name = "Text file"

	Display()
		//var/t = html_encode(saved_text)
		var/t = {"
		<form name="textfield" action="byond://" method="get">
			<input type="hidden" name="src" value="\ref[src]" />
			<input type="text" name="set_name" value="[file_name]"/>
			<input type="submit" value="Rename"/>
		</form>
		<form name="textfield" action="byond://" method="get">
			<input type="hidden" name="src" value="\ref[src]" />
			<textarea name="set_text" rows="10" cols="30">[saved_text]</textarea><BR>
			<input type="submit" value="Save"/>
		</form>
		"}
		return t

	Topic(href, href_list)
		if(..()) return
		if(href_list["set_text"])
			saved_text = href_list["set_text"]
		else if(href_list["set_name"])
			file_name = copytext(href_list["set_name"], 1, 30)
		updateUsrDialog()

	Copy()
		//Transfer some data
		var/datum/file/software/app/textfile/txt = new /datum/file/software/app/textfile()
		txt.saved_text = saved_text
		return txt

	GetName()
		return file_name + ".text"

	//Stuff for using by apps
	proc/AddText(var/t = "")
		if(!Connected()) return
		saved_text += "<BR>" + t

	proc/Clear()
		if(!Connected()) return
		saved_text = ""
