extends Node

#Trigger event state machine
enum event {
	WAITING,
	HAPPENING,
	HAPPENED
}

# Constant for the category of room types (as a dictionary of arrays)
const ROOM_CATEGORIES_AND_TYPES = {
	"Encounter rooms": ["Copper", "Bronze", "Silver", "Iron"],
	"Good Omen": ["Gold", "Emerald"],
	"Bad Omen": ["Amethyst", "Rhinestone"],
	"Neutral": ["Quartz"]
}

#Type and Category data used for Custom Data
var room_category
var room_type
var event_state

func _ready():
	event_state = event.WAITING

func room_randomizer() -> String:
	var weighted_categories = []
	for category in ROOM_CATEGORIES_AND_TYPES:
		var weight = get_category_weight(category)
		for _i in range(weight):
			weighted_categories.append(category)

	var random_category_index = randi() % weighted_categories.size()
	var chosen_category = weighted_categories[random_category_index]

	# Now, randomly select a type within the chosen category, also weighted
	var types_in_category = ROOM_CATEGORIES_AND_TYPES[chosen_category]
	var weighted_types = []
	for type in types_in_category:
		var type_weight = get_type_weight(chosen_category, type)
		for _i in range(type_weight):
			weighted_types.append(type)

	var random_type_index = randi() % weighted_types.size()
	return weighted_types[random_type_index]


# Helper function to get the weight for each category
func get_category_weight(category: String) -> int:
	match category:
		"Encounter rooms":
			return 50  # 50% chance
		"Good Omen":
			return 25  # 25% chance
		"Bad Omen":
			return 15  # 15% chance
		"Neutral":
			return 10  # 10% chance
	return 0  # Default (should not happen)

# New helper function to get the weight for each type within a category
func get_type_weight(category: String, type: String) -> int:
	match category:
		"Encounter rooms":
			match type:
				"Copper":
					return 15
				"Bronze":
					return 45
				"Silver":
					return 30
				"Iron":
					return 10
		"Good Omen":
			match type:
				"Gold":
					return 60
				"Emerald":
					return 40
		"Bad Omen":
			match type:
				"Amethyst":
					return 20
				"Rhinestone":
					return 80
		"Neutral":
			return 100  # Quartz is the only type, so 100% chance
	return 0  # Default (should not happen)

func trigger_room_event(tile_data: TileData):
	event_state = event.HAPPENING
	print("Event is happening")
	var type = tile_data.get_custom_data("Type")

	match type:
		"Copper":
			handle_copper_room_event(tile_data)
		"Bronze":
			handle_bronze_room_event(tile_data)
		"Silver":
			handle_silver_room_event(tile_data)
		"Iron":
			handle_iron_room_event(tile_data)
		"Gold":
			handle_gold_room_event(tile_data)
		"Emerald":
			handle_emerald_room_event(tile_data)
		"Amethyst":
			handle_amethyst_room_event(tile_data)
		"Rhinestone":
			handle_rhinestone_room_event(tile_data)
		"Quartz":
			handle_quartz_room_event(tile_data)
	event_state = event.HAPPENED
	print("event happened")
	event_state = event.HAPPENING
	print("Back to waiting")


# Room Event Handlers

func handle_copper_room_event(tile_data: TileData):
	print("The type is Copper")

func handle_bronze_room_event(tile_data: TileData):
	print("The type is Bronze")

func handle_silver_room_event(tile_data: TileData):
	print("The type is Silver")

func handle_iron_room_event(tile_data: TileData):
	print("The type is Iron")

func handle_gold_room_event(tile_data: TileData):
	print("The type is Gold")

func handle_emerald_room_event(tile_data: TileData):
	print("The type is Emerald")

func handle_amethyst_room_event(tile_data: TileData):
	print("The type is Amethyst")

func handle_rhinestone_room_event(tile_data: TileData):
	print("The type is Rhinestone")

func handle_quartz_room_event(tile_data: TileData):
	print("The type is Quartz")




func initialize_room(tile_data:TileData):
	var room_type = room_randomizer() #randomly chooses a room type
	tile_data.set_custom_data("Type", room_type) #Sets the room type to the chosen
	tile_data.set_custom_data("Empty?", false) #Sets empty to false
	trigger_room_event(tile_data)  # Trigger event after setting type

func _on_test_target_player_entered_room(tile_data):
		if not tile_data.get_custom_data("Empty?"): #If the room isn't empty
			if event_state == event.WAITING: #If the event hasn't been triggered yet
				trigger_room_event(tile_data) #Trigger the event 
			else: #Room is empty
				initialize_room(tile_data)
