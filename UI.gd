extends Node
@onready var coordinate_label = $coordinate_label
@onready var type_label = $Type_label
@onready var rooms = $"../../Rooms"
@onready var test_target = $"../../TestTarget"
@onready var current_tile =  rooms.local_to_map(test_target.global_position)
signal confirm(answer)

# Called when the node enters the scene tree for the first time.
func _ready():
	var tile_data = rooms.get_cell_tile_data(3,current_tile)
	_on_test_target_moved_to_a_new_room(tile_data)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_test_target_moved_to_a_new_room(tile_data):
	if tile_data:
		coordinate_label.text = tile_data.get_custom_data("Coordinate")
		type_label.text = tile_data.get_custom_data("Type")
	else:
		coordinate_label.text = "???"
		type_label.text = "???"
	

func _input(event):
	if test_target.CROSSHAIR_IS == test_target.CROSSHAIR_STATE.CONFIRMING:
		if event.is_action_pressed("Yes"):
			_on_yes_button_pressed()
		elif event.is_action_pressed("No"):
			_on_no_button_pressed()

func _on_yes_button_pressed():
	confirm.emit("Yes")


func _on_no_button_pressed():
	confirm.emit("No")
