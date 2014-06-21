/turf/unsimulated/beach
	name = "Beach"
	icon = 'icons/misc/beach.dmi'

/turf/unsimulated/beach/sand
	name = "Sand"
	icon_state = "sand"

/turf/unsimulated/beach/coastline
	name = "Coastline"
	icon = 'icons/misc/beach2.dmi'
	icon_state = "sandwater"

/turf/unsimulated/beach/coastline/newcoastline
	name = "Coastline"
	icon = 'icons/misc/beach.dmi'
	icon_state = "beach"

/turf/unsimulated/beach/water
	name = "Water"
	icon_state = "water"

/turf/unsimulated/beach/sea
	name = "Water"
	icon_state = "seashallow"

/turf/unsimulated/beach/
	name = "Beach"
	icon = 'icons/misc/beach.dmi'

/turf/unsimulated/beach/sand
	name = "Sand"
	icon_state = "sand"

/turf/unsimulated/beach/desert
	name = "Sand"
	icon_state = "desert"

/turf/unsimulated/beach/dgrass
	name = "Grass"
	icon_state = "dgrass0"

/turf/unsimulated/beach/grass
	name = "Grass"
	icon_state = "fullgrass0"

/turf/unsimulated/beach/desertdug
	name = "Sand"
	icon_state = "desert_dug"

/turf/unsimulated/beach/coastline
	name = "Coastline"
	icon = 'icons/misc/beach2.dmi'
	icon_state = "sandwater"

/turf/unsimulated/beach/water/New()
	..()
	overlays += image("icon"='icons/misc/beach.dmi',"icon_state"="water2","layer"=MOB_LAYER+0.1)

/turf/unsimulated/beach/sea/New()
	..()
	overlays += image("icon"='icons/misc/beach.dmi',"icon_state"="seashallow","layer"=MOB_LAYER+0.1, "alpha"=100)