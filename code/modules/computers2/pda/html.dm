// I never used css before, so these styles may be hackish, shitty, etc.
// Feel free to fix it. --ACCount

var/const/pda_styles = {"
html{overflow: hidden;}
a, a:link, a:visited, a:active{color: #111111; text-decoration: none; margin: 1px; padding: 1px 6px; cursor:default; display: block; font-weight: normal;}
a:hover{background: #606000;}
img{border-style:none;}

body{padding: 0px; margin: 0px; background-color: #808000; font-size: 12px; color: #111111; font-family: monospace;}

div.title{padding: 6px 8px; font-size: 16px; font-weight: bold; border-bottom: 1px solid #505000;}
a.title{font-size: 14px;}
div.content{padding: 2px 6px;}
div.sysdata{border-top: 1px solid #505000; padding: 2px 5px; position:absolute; left:0px; bottom:0px; background-color: #808000; width: 100%;}
div.block{padding: 0px 4px;}
h4{padding: 1px; margin: 2px;}

input{width: 100%; background-color: #808000; color: #111111; font-family: monospace; border: 1px solid #111111;}
textarea{width: 100%; background-color: #808000; color: #111111; font-family: monospace; border: 1px solid #111111;}
hr{background-color: #111111; color: #111111; height: 1px;}
"}


/obj/machinery/newComputer/pda
	ComputerHtml(var/title = "PERSONAL DATA ASSISTANT v.1.2", var/content = "", var/use_frame = 1, var/add_style = "")
		var/t = {"<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
		<html>
		<meta http-equiv="Content-Type" content="text/html; charset=windows-1251" />

		<head>
		<style type='text/css'>[pda_styles][add_style]</style>
		</head>

		<body>"}
		if(use_frame)
			t += "<div class='title' id='title'>[title]</div><div class='content'>[content]</div>"
		else
			t += content
		t +={"<div class='sysdata'>[SysHtml()]</div>
		</body>

		</html>"}
		return t

	Bios()
		var/t = ""
		for(var/obj/item/weapon/hardware/memory/M in GetActiveDisks())
			var/list/oslist = M.GetFiles(/datum/file/software/os/pda)
			if(oslist.len)
				sysdisk = M
				LaunchOS(oslist[1])
				spawn(1)
					updateDialog()
		if(!sys)
			t += "Failed to load OS file."
		return ComputerHtml("RECOVERY MODE", t)

	SysHtml()
		var/t = ""

		t += "Station Time: [worldtime2text()] " //:[world.time / 100 % 6][world.time / 100 % 10]"

		if(auth)
			if(auth.id)
				t += "<A href='?src=\ref[src];ejectid=1'>ID: [auth.id.name]</A>"
			else
				t += "<A href='?src=\ref[src];insertid=1'>ID: ----------</A>"

		for(var/obj/item/weapon/hardware/memory/reader/D in disks)
			if(D.disk)
				t += "<A href='?src=\ref[src];eject=1;disk=\ref[D]'>Cartridge: [D.GetName()]</A>"
			else
				t += "<A href='?src=\ref[src];insert=1;disk=\ref[D]'>Cartridge: [D.GetName()]</A>"
		t += "<A href='?src=\ref[src];refresh=1'>Refresh</A>"
		return t