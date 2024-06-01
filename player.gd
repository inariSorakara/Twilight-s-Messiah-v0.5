extends CharacterBody2D
#References the Rooms tilemap
@onready var rooms = $"../Rooms"

#References the Button
@onready var button = $"../Button"

#References the player's sprite.
@onready var sprite_2d = $Sprite2D

#References the confirmation pop up
@onready var confirmation_pop_up = $"../ConfirmationPopUp"

#States of the player's avatar movement.
enum movement {
	IDLE,
	CHOOSING,
	CONFIRMING,
	MOVING
	}

#Initiates the state machine
@onready var current_movement_state = movement.IDLE

# Called a fixed amount of times.
func _physics_process(delta):
	#Checks if player is moving. Returns if not.
	if current_movement_state != movement.MOVING:
		return
	#If both global positions are the same, changes state to IDLE
	if global_position == sprite_2d.global_position:
		current_movement_state = movement.IDLE
		return
	#Else, moves the sprite towards the player.
	sprite_2d.global_position = sprite_2d.global_position.move_toward(global_position,2)

#This button changes the movement_state depending on it's toggle state.
func _on_button_toggled(toggled_on):
	if toggled_on == true:
		current_movement_state = movement.CHOOSING
	else:
		current_movement_state = movement.IDLE

func _input(event):
	#Handles player input if the movement state is "Choosing"
	if current_movement_state == movement.CHOOSING:
		if event.is_action_pressed("Up"):
			move(Vector2.UP)
		elif event.is_action_pressed("Down"):
			move(Vector2.DOWN)
		elif event.is_action_pressed("Left"):
			move(Vector2.LEFT)
		elif event.is_action_pressed("Right"):
			move(Vector2.RIGHT)
		elif event.is_action("Confirm"):
			pass

#Function that handles player movement
func move(direction:Vector2):
	#Turns the player's global position into an interger grid position.
	var current_tile:Vector2i = rooms.local_to_map(rooms.to_local(global_position))
	print("Current tile before move: ", current_tile)
	
	#Defines the target position by adding the current position to the direction.
	var target_tile:Vector2i = Vector2i (
		current_tile.x + direction.x,
		current_tile.y + direction.y)
	print("Target tile: ", target_tile)
	
	# Defines the sprite's current position
	var sprite_current_position = sprite_2d.global_position
	print("Sprite current position: ", sprite_current_position)
	
	#Changes the movement state to "MOVING" so the player input can't be heard
	#current_movement_state = movement.MOVING
	
	#Changes the target tile to a global position and updates the player position to it.
	global_position = rooms.map_to_local(target_tile)
	
	#Keeps the player tile behind to simulate the player moving to a position.
	sprite_2d.global_position = sprite_current_position
	
	#Toggles the button off and the function, making the movement state "IDLE" once more.
	#button.set_pressed_no_signal(false)
