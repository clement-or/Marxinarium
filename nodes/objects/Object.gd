extends Area2D

onready var anim = $Anim
onready var player_anim
onready var house_anim

export(NodePath) var player
export(NodePath) var connected_point

signal is_activated
signal action_is_finished

# state template
# {"anim" : "name", "next": -1}
# {"func" : "name", "next": -1}
var states = [
]

var cur_state = 0

func _ready():
	if player:
		player = get_node(player)
		house_anim = player.get_node("Skeleton/HouseAnim")
		player_anim = player.get_node("Skeleton/Anim")
	if connected_point:
		connected_point = get_node(connected_point)

func actions():
	# Get current state
	var state = states[cur_state]
	
	# Get next state
	if state.has("next") && state.get("next") == -1:
		cur_state +=1
	else:
		cur_state = state.get("next")
	state = states[cur_state]
	
	# Do the action
	if state.has("anim"):
		anim.play(state.get("anim"))
		yield(anim, "animation_finished")
		emit_signal("action_is_finished")
	elif state.has("func"):
		call(state.get("func"))
	

# On click
func _on_Object_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.is_pressed():
		emit_signal("is_activated", self)