extends CharacterBody2D

#References the Rooms tilemap
@onready var rooms = $"../Rooms"

#References the player's sprite.
@onready var player = $"../TestPlayer"

#States of the player's avatar movement.
enum movement {
	IDLE,
	CHOOSING,
	CONFIRMING,
	MOVING
	}
	
#Initiates the state machine
var movement_state = movement.IDLE

#Called when the node is ready
func _ready():
	pass

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
	player.global_position = player.global_position.move_toward(global_position,0.4)
		
	
func _input(event):
	#Handles player input if the movement state is "Choosing"
	if movement_state == movement.IDLE:
		if event.is_action_pressed("Confirm"):
			movement_state = movement.CHOOSING
			print("Choosing where to move")
	if movement_state == movement.CHOOSING:
		if event.is_action_pressed("Left"):
			move(Vector2.LEFT)
		elif event.is_action_pressed("Right"):
			move(Vector2.RIGHT)
		elif event.is_action_pressed("Up"):
			move(Vector2.UP)
		elif event.is_action_pressed("Down"):
			move(Vector2.DOWN)
	else:
		return

func move(direction: Vector2):
	#Calculate Current tile, Target tile and sprite tile
	var current_tile: Vector2i = rooms.local_to_map(global_position)
	var target_tile: Vector2i = Vector2i(
		current_tile.x + direction.x,
		current_tile.y + direction.y)
	var player_tile: Vector2i = rooms.local_to_map(player.global_position)
	prints("Current tile is:", current_tile, "target tile is", target_tile, "player tile is:", player_tile)
	movement_state = movement.MOVING
	global_position = rooms.map_to_local(target_tile)


#TRY MAKING THE TARGET AND THE PLAYER DIFFERENT NODES! IF IT DOESN'T WORK, I DON'T KNOW, I'LL KILL MYSELF.
