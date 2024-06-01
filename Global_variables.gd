extends Node

#A confirmation Pop up asking YES/NO
var confirmation_pop_up = preload("res://Scenes/confirmation_pop_up.tscn")

#Coordinate name used for Custom Data
var coordinate_name

#Type data used for Custom Data
var room_type

#Target tile, used for movement
var target_tile

#Tile data used for Custom Data
var tile_data:TileData
