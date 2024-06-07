extends CharacterBody2D

###References###

#Tile map
@onready var rooms = $"../Rooms"

#Player sprite
@onready var player = $"../TestPlayer"

#UI
@onready var ui = $"../CanvasLayer/UI"

#Player's ray cast
@onready var player_ray_cast_2d = $"../TestPlayer/RayCast2D"

# Confirmation pop up
@onready var confirmation_pop_up = $"../CanvasLayer/UI/ConfirmationPopUp"

### Constants ###

# Tile size
const TILE_SIZE = 16

#Player's sprite speed.
const PLAYER_MOVE_SPEED = 1

###State machines###

#Checks the player's state
enum PLAYER_STATE {IDLE, MOVING}

#Checks the crosshair's state
enum CROSSHAIR_STATE {IDLE, CHOOSING, CONFIRMING}

###Global variables###

#Define player state machine state
var PLAYER_STATE_IS 

#Initialize crosshair state machine state
var CROSSHAIR_IS

#Player current_position on the tile map
var player_current_position

#Crosshair current_position on the tile map
var crosshair_current_position

###Signals###

# Player sprite moved from a room to another room
signal player_entered_room(tile_data:TileData)


###Functions###

#Called when the node is ready
func _ready():
	PLAYER_STATE_IS = PLAYER_STATE.IDLE
	CROSSHAIR_IS = CROSSHAIR_STATE.IDLE
	player_current_position = rooms.local_to_map(player.global_position)
	crosshair_current_position = rooms.local_to_map(global_position)

#Handles user input
func _input(event):
	#Change crosshair state to "choosing" when pressing ENTER
	if CROSSHAIR_IS == CROSSHAIR_STATE.IDLE:
		if event.is_action_pressed("Confirm"):
			CROSSHAIR_IS = CROSSHAIR_STATE.CHOOSING
			print("Now choosing where to move")
	elif CROSSHAIR_IS == CROSSHAIR_STATE.CHOOSING:
		#Moves the crosshair up
		if event.is_action_pressed("Up"):
			move(Vector2.UP)
		#Moves the crosshair down
		elif event.is_action_pressed("Down"):
			move(Vector2.DOWN)
		#Moves the crosshair to the left
		elif event.is_action_pressed("Left"):
			move(Vector2.LEFT)
		#Moves the crosshair to the right
		elif event.is_action_pressed("Right"):
			move(Vector2.RIGHT)
		elif event.is_action_pressed("Confirm"):
			#Change crosshair state to "choosing" when pressing ENTER
			CROSSHAIR_IS = CROSSHAIR_STATE.CONFIRMING
			print("Confirming destination")
			confirmation_pop_up.visible = true

#Used for moving the crosshair in an specific direction.
func move(direction:Vector2):
	#Player current_position on the tile map
	player_current_position = rooms.local_to_map(player.global_position)

	#Calculates the target position adding the current position of the player + the direction
	var target_position:Vector2i = Vector2i(
		player_current_position.x + direction.x,
		player_current_position.y + direction.y)

	#Gets the target tile custom data 
	var tile_data:TileData = rooms.get_cell_tile_data(3, target_position)

	# Checks for collision
	player_ray_cast_2d.target_position = direction * TILE_SIZE
	player_ray_cast_2d.force_raycast_update()
	if player_ray_cast_2d.is_colliding():
		print("You can't move inside walls")
		return #Can't move the crosshair inside the walls-

	# Checks how far is the crosshair moving
	if abs(target_position.x - player_current_position.x) <= 1 and abs(target_position.y - player_current_position.y) <= 1:
		#Actually moves the crosshair
		global_position = rooms.map_to_local(target_position)
	else:
		print("You can only move one tile at a time")
		return #Can't move more than one tile at a time

#Updates player position to the crosshair's position
func update_player_position():
	player.global_position = player.global_position.move_toward(global_position, PLAYER_MOVE_SPEED * TILE_SIZE)
	var new_player_position = rooms.local_to_map(player.global_position)
	var tile_data: TileData = rooms.get_cell_tile_data(3, new_player_position)
	
	position_check()
	reset_states()
	player_entered_room.emit(tile_data)

#Handles what happens on each option of the confirm pop up
func _on_ui_confirm(answer):
	if answer == "Yes":
		update_player_position()
	else:
		crosshair_current_position = player_current_position
	confirmation_pop_up.visible = false

#Prints the player and crosshair positions on the tile map
func position_check():
	print("Player current position is:", rooms.local_to_map(player.global_position))
	print("Crosshair current position is:", rooms.local_to_map(global_position))

#Resets the states of the states machines.
func reset_states():
	CROSSHAIR_IS = CROSSHAIR_STATE.IDLE
	PLAYER_STATE_IS = PLAYER_STATE.IDLE
	print("Player and Crosshair are now IDLE")
