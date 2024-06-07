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
	if tile_data:
		print("Moved to a new room")
		print("New room coordinate is:", coordinate)
		print("New room type is:", room_type)





###TODO###
#We have 9 types of rooms. Each type has it's own event.
# Events: encounter an weak/normal/strong/Boss enemy; find treasure, find a shop, find a forbidden room, fall into a trap, or an empty room
# Whenever the player's sprite enters a type empty room, another type of room will be randomly chosen and the event of that room will be triggered. Type = empty is among the possible random choices. 
# Introduce the random room assignment from RTM v1 and the specific event type triggering from RTMv1
# On version v2, instead of checking if the room is empty, we are checking if the room is of type "Quartz" (The type of room where nothing happens). Meaning, we don't need the "Empty?" custom data layer anymore.

