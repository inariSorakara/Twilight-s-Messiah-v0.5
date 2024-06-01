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
	if movement_state == movement.MOVING:
		player.global_position = player.global_position.move_toward(global_position,0.4)

	
func _input(event):
	#Handles player input if the movement state is "Choosing"
	if event.is_action_pressed("Confirm"):
		if movement_state == movement.IDLE:
			movement_state = movement.CHOOSING
			print("Choosing where to move")
		elif movement_state == movement.CHOOSING:
			move_player()
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
	var current_tile: Vector2i = rooms.local_to_map(global_position)
	var target_tile: Vector2i = Vector2i(
		current_tile.x + direction.x,
		current_tile.y + direction.y)
	var player_tile: Vector2i = rooms.local_to_map(player.global_position)
	prints("Current tile is:", current_tile, "target tile is", target_tile)
	global_position = rooms.map_to_local(target_tile)

func move_player():
	movement_state = movement.MOVING
	print("Target tile chosen")
	
func check_distance():
	var distance = global_position.distance_to(player.global_position)
	if distance <= 1:
		print("Distance to player:", distance)
		return true
	else:
		global_position = player.global_position
		return false
#Making them different nodes worked.
#Yay! We made it mode only one tile AND figured out how to make it go back to the player by myself!

#TODO 
# Optional. Make so instead of moving left or right it moves to the left or to the right of the player. Trust me
# Make it so a message pops up asking if you want to confirm the movement, and if you cancel the target goes back to the player
# Optional. Make it so the message is added to the scene tree by code instead of show/hide
# Modify the code in V0.4 with this simplifications.
