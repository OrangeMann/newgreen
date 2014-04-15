import os

output_define = open("output.txt", "w")
output_add = open("outputadd.txt", "w")
#	dat += "Ushanka: <A href='?src=\ref[src];item=/obj/item/clothing/head/ushanka;cost=300'>300</A><br>"
with open("input.txt", "r") as f:
	data = f.readlines()
	
	category = "null"
	last_category = "not_null"
	
	
	for line in data:
		line = line.strip()
		if(not line):
			continue
			
		if(line[0] == '/' and line[1] == '/'):
			continue
			
		if(line.find(";") == -1):
			posfirst = line.find("<b>")
			poslast = line.find("</b>")
			category = line[posfirst + 3: poslast - 1]
			continue
			
		posfirst = line.find("\"") + 1
		poslast = line.find(":")
		name = line[posfirst:poslast]
		line = line[line.find(";") + 1:]
		
		posfirst = line.find("item=")
		poslast = line.find(";")
		path = line[posfirst + 5:poslast]
		line = line[line.find(";") + 1:]
		
		posfirst = line.find("cost=")
		poslast = line.find("'")
		cost = line[posfirst + 5:poslast]
		
		path_name = name.lower()
		path_name = path_name.replace(" ", "_")
		
		output_define.write("/datum/spawn_item/" + path_name + "\n	name = \"" + name + "\"\n	path = " + path + "\n	cost = " + cost + "\n	category = \"" +  category + "\"\n\n")
		if(last_category != category):
			last_category = category
			output_add.write("	//" + category + "\n")
		output_add.write("	donator_items.Add(new /datum/spawn_item/" + path_name + ")\n")
		
output_define.close()
output_add.close()