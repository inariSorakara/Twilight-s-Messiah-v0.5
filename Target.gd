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
enum PLAYER {IDLE, MOVING}

#Checks the crosshair's state
enum CROSSHAIR {IDLE, CHOOSING, CONFIRMING}

###Global variables###

#Define player state machine state
var PLAYER_IS 

#Initialize crosshair state machine state
var CROSSHAIR_IS

#Player current_position on the tile map
@onready var player_current_position = rooms.local_to_map(player.global_position)

#Crosshair current_position on the tile map
@onready var crosshair_current_position = rooms.local_to_map(global_position)

###Signals###

# Player sprite moved from a room to another room
signal Player_entered_room

###Functions###

#Called when the node is ready
func _ready():
	PLAYER_IS = PLAYER.IDLE
	CROSSHAIR_IS = CROSSHAIR.IDLE
	position_check()


# Called a fixed amount of times
func _physics_process(_delta):
	#check for a new room
	var current_tile = rooms.local_to_map(global_position)
	var tile_data = rooms.get_cell_tile_data(3, current_tile)
	if PLAYER_IS != PLAYER.MOVING:
		return
	if global_position == player.global_position:
		PLAYER_IS = PLAYER.IDLE
		return
	player.global_position = player.global_position.move_toward(global_position, PLAYER_MOVE_SPEED)
	position_check()

# Move crosshair in a given direction
func move(direction: Vector2):
	# Get player's current tile
	var player_tile: Vector2i = rooms.local_to_map(player.global_position)

	# Calculate target tile (inline)
	var target_tile: Vector2i = Vector2i(
		player_tile.x + direction.x,
		player_tile.y + direction.y
	)

	# Check that target tile is within the tilemap bounds and one tile away
	if abs(target_tile.x - player_tile.x) <= 1 and abs(target_tile.y - player_tile.y) <= 1:
		if rooms.get_used_cells(3).has(target_tile):

			# Get tile info (inline)
			var tile_data = rooms.get_cell_tile_data(3, target_tile)
			if tile_data != null: # Changed from that tile_data:
				var coordinate_name = tile_data.get_custom_data("Coordinate")
				RTM.room_type = tile_data.get_custom_data("Type")

				# Raycast collision check
				player_ray_cast_2d.target_position = direction * TILE_SIZE
				player_ray_cast_2d.force_raycast_update()
				if player_ray_cast_2d.is_colliding():
					return  # Doesn't move when colliding

			global_position = rooms.map_to_local(target_tile)
			position_check()

		else:
			print("You can only move 1 tile at a time")
			global_position = player.global_position
	else:
		print("There's nothing there")
		global_position = player.global_position

# Handle confirmation response (in the UI script)
func _on_confirm(answer):
	if answer == "Yes":
		PLAYER_IS = PLAYER.MOVING
	else:
		global_position = player.global_position
		CROSSHAIR_IS = CROSSHAIR.CHOOSING
	confirmation_pop_up.visible = false

#Handles the handling input function, yeah, I know.
func _input(event):
	handle_input_based_on_state(event)

#Actually handles the function depending on the state of movement.
func handle_input_based_on_state(event):
	match CROSSHAIR_IS:
		CROSSHAIR.IDLE:
			if event.is_action_pressed("Confirm"):
				CROSSHAIR_IS = CROSSHAIR.CHOOSING
				print("Choosing where to move")
		CROSSHAIR.CHOOSING:
			if event.is_action_pressed("Left"):
				move(Vector2.LEFT)
			elif event.is_action_pressed("Right"):
				move(Vector2.RIGHT)
			elif event.is_action_pressed("Up"):
				move(Vector2.UP)
			elif event.is_action_pressed("Down"):
				move(Vector2.DOWN)
			elif event.is_action_pressed("Confirm"):
					CROSSHAIR_IS = CROSSHAIR.CONFIRMING
					confirmation_pop_up.visible = true

func position_check():
	#Prints the crosshair current position
	print("Crosshair current position is:", crosshair_current_position)
	
	#Prints the crosshair current position
	print("Player current position is:", player_current_position)
#TODO 
#Remind my girlfriend I love her/ Recordarle a mi novia que la amo!
# Make it so events are triggered every time the player enters a room, but only once per time!
# If ALL of that works, THEN we start working on the turn system.
#We will re-develope everything from version V 0.4 on this Version V 0.5. V 0.04 is dead. All hail V 0.5.
