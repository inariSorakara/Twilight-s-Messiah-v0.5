extends Control

signal confirm(answer)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _input(event):
	if event.is_action_pressed("Yes"):
		_on_yes_button_pressed()
	elif event.is_action_pressed("No"):
		_on_no_button_pressed()
		
func _on_yes_button_pressed():
	confirm.emit("Yes!")

func _on_no_button_pressed():
	confirm.emit("No!")
