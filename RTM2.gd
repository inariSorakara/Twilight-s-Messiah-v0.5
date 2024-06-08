extends Node
###References###
#----------------#

###Constants###

# Constant for the type of rooms (As a dictionary)
const ROOM_TYPES = {
	"Copper":{"weight": 15}, # Encounter a Weak enemy
	"Bronze": {"weight": 20}, # Encounter a regular enemy
	"Silver":{"weight": 10}, # Encounter a strong enemy
	"Iron":{"weight": 5}, # Encounter a gatekeeper/challenger enemy. Challenger enemies are encountered after encountering an already defeated gatekeeper.
	"Gold":{"weight": 20}, #Encounter a treasure room. On exit, this rooms default to Quartz once more. 
	"Emerald":{"weight": 10}, #Encounter a Shop room
	"Amethyst":{"weight": 5}, # Encounter a cosmic room. Call three flip coins, if you guess two correctly, get teleported to an already discovered room of your choice. Miss two, and face a cosmic enemy
	"Rhinestone": {"weight": 10}, #Fall into a trap room
	"Quartz":{"weight": 5}} #Empty rooms. On entering this rooms once more, another random type is chosen. Quartz could be chosen again.

###State Machines###
#--------------------#

###Global Variables###
#--------------------#
###Functions###

#Reciever function for the target.gd player entered room signal
func _on_test_target_player_entered_room(tile_data):
	var coordinate = tile_data.get_custom_data("Coordinate")
	var room_type = tile_data.get_custom_data("Type")
	if room_type == "Quartz":
    room_randomizer()
  trigger_room_event(tile_data)
else:
  trigger_room_event(tile_data)

#Randomly chooses a room using the weights from the CONS
func room_randomizer() -> String:
    var total_weight = 0
    for room_type in ROOM_TYPES:
        total_weight += ROOM_TYPES[room_type]["weight"]

    var random_value = randi() % total_weight
    var current_weight = 0

    for room_type in ROOM_TYPES:
        current_weight += ROOM_TYPES[room_type]["weight"]
        if random_value < current_weight:
            return room_type  # Return the selected room type

    # This should not happen if weights are set up correctly
    return "Quartz"  # Default to Quartz if something goes wrong 

#Triggers the corresponding room event.
func trigger_room_event(tile_data: TileData):
    var room_type = tile_data.get_custom_data("Type")
    var coordinate = tile_data.get_custom_data("Coordinate")

    print("Moved to a new room")
    print("New room coordinate is:", coordinate)
    print("New room type is:", room_type)

    # Use a match statement to call the appropriate handler function
    match room_type:
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
            pass  # Do nothing for empty rooms (Quartz)
        _:  # Default case (optional)
            print("Unrecognized room type:", room_type)  # Handle unexpected types


#Room Events handlers 
func handle_copper_room_event(tile_data):
    pass

func handle_bronze_room_event(tile_data):
    pass

func handle_silver_room_event(tile_data):
    pass

func handle_iron_room_event(tile_data):
    pass

func handle_gold_room_event(tile_data):
    pass

func handle_emerald_room_event(tile_data):
    pass

func handle_amethyst_room_event(tile_data):
    pass


func handle_rhinestone_room_event(tile_data):
    pass

func handle_quartz_room_event(tile_data):
    pass


###TODO###
#We have 9 types of rooms. Each type has it's own event.
# Events: encounter an weak/normal/strong/Boss enemy; find treasure, find a shop, find a forbidden room, fall into a trap, or an empty room
# Whenever the player's sprite enters a type empty room, another type of room will be randomly chosen and the event of that room will be triggered. Type = empty is among the possible random choices. 
# Introduce the random room assignment from RTM v1 and the specific event type triggering from RTMv1
# On version v2, instead of checking if the room is empty, we are checking if the room is of type "Quartz" (The type of room where nothing happens). Meaning, we don't need the "Empty?" custom data layer anymore.

