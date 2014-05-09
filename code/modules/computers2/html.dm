// I never used css before, so these styles may be hackish, shitty, etc.
// Feel free to fix it. --ACCount

var/const/computer_styles = {"
html{overflow: hidden;}
a, a:link, a:visited, a:active{color: #B3B3B3; text-decoration: none; padding: 1px 6px 1px 6px; cursor:default; display: block; font-weight: normal;}
a:hover{color: #000000; background: #B3B3B3;}
body{padding: 0px; margin: 0px; background-color: #000000; font-size: 12px; color: #B3B3B3; font-family: monospace;}
.title{padding: 6px 8px 0px 8px; font-size: 16px; font-weight: bold;}
.content{padding: 8px 0px 0px 8px; width: 70%; float:left; position:absolute;}
.sysdata{border-left: 1px solid #B3B3B3; padding: 20px 0px 0px 4px; float: right; height: 100%; width: 25%; position:absolute; top:0px; right:1px; font-weight: bold; overflow: hidden; background-color: #000000;}
.block{padding: 3px 0px 3px 8px;}
img{border-style:none;}

.bsod{background-color: #0000AA; color: #FFFFFF; padding: 0px; border-right: 1px solid #B3B3B3; width: 75%; height: 100%; float:left; position:absolute; font-weight: bold; font-size: 14px;}
.bsodtitle{background-color: #AAAAAA; color: #0000AA; width: 52px; top: 30%; position: relative;}
.bsodcontent{top: 30%; position: relative; width: 85%; padding: 14px 0px 0px 0px;}

input{width: 100%; background-color: #000000; color: #B3B3B3; font-family: monospace; border: 1px solid #B3B3B3;}
textarea{width: 100%; background-color: #000000; color: #B3B3B3; font-family: monospace; border: 1px solid #B3B3B3;}
hr{background-color: #B3B3B3; color: #B3B3B3; height: 1px;}
"}



/obj/machinery/newComputer
	proc/ComputerHtml(var/title = "ComTec BIOS", var/content = "", var/use_frame = 1, var/add_style = "")
		var/t = {"<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
		<html>
		<meta http-equiv="Content-Type" content="text/html; charset=windows-1251" />

		<head>
		<style type='text/css'>[computer_styles][add_style]</style>
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

	proc/Bios()
		var/t = ""
		if(sysdisk)
			var/list/oslist = sysdisk.GetFiles(/datum/file/software/os)
			if(oslist.len == 1)
				LaunchOS(oslist[1])
				spawn(1)
					updateDialog()
			else if(oslist.len)
				t += "Select OS to boot:"
				for(var/datum/file/software/os/s in oslist)
					t += "<A href='?src=\ref[src];OS=\ref[s]'>[s.GetName()]</A>"
			else
				t += "Reboot and Select proper Boot device or Insert Boot Media in selected Boot device."

		else
			var/list/activedisks = list()
			for(var/obj/item/weapon/hardware/memory/M in GetActiveDisks())
				var/list/oses = M.GetFiles(/datum/file/software/os)
				if(oses.len)
					activedisks.Add(M)
			if(activedisks.len == 1)
				sysdisk = activedisks[1]
				spawn(1)
					updateDialog()

			else if(activedisks.len)
				t += "Select Boot Device:"
				for(var/obj/item/weapon/hardware/memory/M in activedisks)
					t += "<A href='?src=\ref[src];choose_sysdisk=\ref[M]'>[M.GetName()]</A>"
			else
				t += "No boot media found."
		return ComputerHtml("ComTec BIOS", t)

	proc/HtmlBSOD(var/error = "01 : 016F : BFF9B3D4")
		// Nostalgic.
		var/t = {"
<div class='bsod' align='center'>
<div class='bsodtitle'>Error</div>
<div class='bsodcontent' align='left'>An error has occured. To continue:</div>
<div class='bsodcontent' align='left'>Press Enter to return to OS, or</div>
<div class='bsodcontent' align='left'>Press CTRL+ALT+DEL to restart your computer. If you do this, you will lose any unsaved information in all open applications</div>
<div class='bsodcontent' align='left'>Error: [error]</div>
<div class='bsodcontent'>Press any key to continue</div>
</div>
"}
		return ComputerHtml("BSOD", t, 0)

	proc/SysHtml() // PC's buttons and slots
		var/t = ""
		//if(sys)
		//	t +=

		if(auth)
			t+= "<div class='block'>ID card reader:"
			if(auth.id)
				t+= "<A href='?src=\ref[src];ejectid=1'>[auth.id.name]</A>"
			else
				t+= "<A href='?src=\ref[src];insertid=1'>empty</A>"
			t+= "</div>"

		for(var/obj/item/weapon/hardware/memory/reader/D in disks)
			t+= "<div class='block'>[D.name]:"
			if(D.disk)
				t+= "<A href='?src=\ref[src];eject=1;disk=\ref[D]'>[D.GetName()]</A>"
			else
				t+= "<A href='?src=\ref[src];insert=1;disk=\ref[D]'>empty</A>"
			t+= "</div>"

		t+= "<A href='?src=\ref[src];shutdown=1'>Shutdown</A>"
		t+= "<A href='?src=\ref[src];reset=1'>Reset</A>"
		return t