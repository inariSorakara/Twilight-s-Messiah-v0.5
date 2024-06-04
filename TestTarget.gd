extends CharacterBody2D

#References parent node
@onready var test_floor = $".."

#References the Rooms tilemap
@onready var rooms = $"../Rooms"

#References the player's sprite.
@onready var player = $"../TestPlayer"

#References the UI
@onready var ui = $"../CanvasLayer/UI"

#References the Player's Raycast
@onready var player_ray_cast_2d = $"../TestPlayer/RayCast2D"

#Preloads and instantiates the pop_up_confirmation
@onready var pop_up = Global.confirmation_pop_up.instantiate()

#States of the player's avatar movement.
enum movement {
	IDLE,
	CHOOSING,
	CONFIRMING,
	MOVING
	}
	
#Initiates the state machine
var movement_state = movement.IDLE

#Coordinate variable used for custom data
var coordinate_name

#Signal for moving to a new room. Used for room assignment.
signal moving_to_a_new_room

#Called when the node is ready
func _ready():
	pop_up.connect("confirm", _on_confirm)
	
# Called a fixed amount of times.
func _physics_process(delta):
	#Checks if player is moving. Returns if not.
	if movement_state != movement.MOVING:
		return
	#If both global positions are the same, changes state to IDLE
	if global_position == player.global_position:
		movement_state = movement.IDLE
		return
	#Else, moves the sprite towards the player.
	if movement_state == movement.MOVING:
		moving_to_a_new_room.emit()
		player.global_position = player.global_position.move_toward(global_position,1)
		

	
func _input(event):
	#Handles player input if the movement state is "Choosing"
	if event.is_action_pressed("Confirm"):
		if movement_state == movement.IDLE:
			movement_state = movement.CHOOSING
			print("Choosing where to move")
		elif movement_state == movement.CHOOSING:
			if get_coordinate_plus(Global.target_tile) == null or get_room_type(Global.target_tile) == null:
				print("You can't go there")
				return
			else:
				confirm_movement()
		else:
			return
	if movement_state == movement.CHOOSING:
		if event.is_action_pressed("Left"):
			if check_distance() == true:
				move(Vector2.LEFT)
			elif check_distance() == false:
				print("You can only move 1 tile at a time")
		elif event.is_action_pressed("Right"):
			if check_distance() == true:
				move(Vector2.RIGHT)
			elif check_distance() == false:
				print("You can only move 1 tile at a time")
		elif event.is_action_pressed("Up"):
			if check_distance() == true:
				move(Vector2.UP)
			elif check_distance() == false:
				print("You can only move 1 tile at a time")
		elif event.is_action_pressed("Down"):
			if check_distance() == true:
				move(Vector2.DOWN)
			elif check_distance() == false:
				print("You can only move 1 tile at a time")
	else:
		return

func move(direction: Vector2):
	#Calculate Current tile, Target tile and sprite tile
	var player_tile: Vector2i = rooms.local_to_map(player.global_position)
	
	# target tile getter
	get_target_tile(player_tile,direction)
	#Tile coordinate and data getters
	get_coordinate_plus(Global.target_tile)
	get_room_type(Global.target_tile)
	
	#Updates and points target position
	player_ray_cast_2d.target_position = direction * 16
	player_ray_cast_2d.force_raycast_update()
	#Checks for collision to stop it for moving into walls.
	if player_ray_cast_2d.is_colliding():
		print("There's nothing there")
		return
		
	global_position = rooms.map_to_local(Global.target_tile)
	return

func move_player():
	movement_state = movement.MOVING
	
func check_distance():
	var distance = global_position.distance_to(player.global_position)
	if distance <= 1:
		return true
	else:
		global_position = player.global_position
		return false

func confirm_movement():
	movement_state = movement.CONFIRMING
	test_floor.add_child(pop_up)
	pop_up.global_position = ui.global_position + Vector2(-75,-55)  
	
func _on_confirm(answer):
	if answer == "Yes!":
		movement_state = movement.MOVING
		move_player()
		test_floor.remove_child(pop_up)
	else:
		global_position = player.global_position
		test_floor.remove_child(pop_up)
		movement_state = movement.CHOOSING

func get_target_tile(player_tile, direction):
	Global.target_tile = Vector2i(
		player_tile.x + direction.x,
		player_tile.y + direction.y)
	return Global.target_tile
	
func get_coordinate_plus(target_tile: Vector2i):
	Global.tile_data = rooms.get_cell_tile_data(3,Global.target_tile)
	if Global.tile_data == null:
		print("Tile data not found")
		return null

	var coordinate = Global.tile_data.get_custom_data("Coordinate")
	if coordinate == null:
		print("There's nothing there")
		return null

	Global.coordinate_name = coordinate
	return Global.coordinate_name

func get_room_type(target_tile: Vector2):
	Global.tile_data = rooms.get_cell_tile_data(3, Global.target_tile)
	if Global.tile_data == null:
		print("Tile data not found")
		return null

	var coordinate = Global.tile_data.get_custom_data("Coordinate")
	if coordinate == null:
		print("There's nothing there")
		return null

	Global.room_type = Global.tile_data.get_custom_data("Type")
	return Global.room_type

func _on_moving_to_a_new_room():
	if Global.tile_data.get_custom_data("Empty?") == true:
		Global.room_type = Global.room_randomizer()
		print(Global.room_type)
		Global.tile_data.set_custom_data("Type", Global.room_type)
		Global.tile_data.set_custom_data("Empty?", false)
		print(Global.tile_data.get_custom_data("Type"))
	else:
		print("Room type already set: ", Global.tile_data.get_custom_data("Type"))

#TODO 
#Remind my girlfriend I love her/ Recordarle a mi novia que la amo!
# Create a Room type manager
# Create a placeholder function for managing Room Type events
# Create a placeholder function for each room type
# If ALL of that works, THEN we start working on the turn system.
#We will re-develope everything from version V 0.4 on this Version V 0.5. V 0.04 is dead. All hail V 0.5.

