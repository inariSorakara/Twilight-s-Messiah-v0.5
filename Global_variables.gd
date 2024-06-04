extends Node

#A confirmation Pop up asking YES/NO
var confirmation_pop_up = preload("res://Scenes/confirmation_pop_up.tscn")

#Coordinate name used for Custom Data
var coordinate_name

#Type and Category data used for Custom Data
var room_category
var room_type

#Target tile, used for movement
var target_tile

#Tile data used for Custom Data
var tile_data:TileData

# Constant for the category of room types
const  room_categories_and_types: = {
	"Encounter rooms": ["Copper", "Bronze", "Silver", "Iron"],
	"Good Omen": ["Gold", "Emerald"],
	"Bad Omen": ["Amethyst", "Rhinestone"],
	"Neutral": ["Quartz"] }

# Randomly assigns a type to empty rooms

func room_randomizer():
	var roll_room_category = randf()
	if roll_room_category <= 0.50:
		room_category = room_categories_and_types["Encounter rooms"]
		var roll_room_type = randf()
		if roll_room_type <= 0.15:
			room_type = room_categories_and_types["Encounter rooms"][0]
		elif roll_room_type <= 0.60:
			room_type = room_categories_and_types["Encounter rooms"][1]
		elif roll_room_type <= 0.90:
			room_type = room_categories_and_types["Encounter rooms"][2]
		else:
			room_type = room_categories_and_types["Encounter rooms"][3]
	elif roll_room_category <= 0.75:
		room_category = room_categories_and_types["Good Omen"]
		var roll_room_type = randf()
		if roll_room_type <= 0.60:
			room_type = room_categories_and_types["Good Omen"][0]
		else:
			room_type = room_categories_and_types["Good Omen"][1]
	elif roll_room_category <= 0.90:
		room_category = room_categories_and_types["Bad Omen"]
		var roll_room_type = randf()
		if roll_room_type <= 0.20:
			room_type = room_categories_and_types["Bad Omen"][0]
		else:
			room_type = room_categories_and_types["Bad Omen"][1]
	else:
		room_category = room_categories_and_types["Neutral"]
		room_type = room_categories_and_types["Neutral"][0]
	return room_type


