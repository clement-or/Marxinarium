extends Area2D

onready var anim = $Anim

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
	assert(connected_point)
	connected_point = get_node(connected_point)

func actions():
	# Get current state
	var state = states[cur_state]
	
	# Get next state
	if state.next == -1:
		cur_state +=1
	else:
		cur_state = state.next
	state = states[cur_state]
	
	# Do the action
	if state.anim:
		anim.play(state.anim)
	elif state.func:
		call(state.func)

# On click
func _on_Object_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.is_pressed():
		emit_signal("is_activated",self)


func _on_Anim_animation_finished(anim_name):
	emit_signal("action_is_finished")
