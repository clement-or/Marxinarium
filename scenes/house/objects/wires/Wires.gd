extends Area2D

onready var anim = $Anim
onready var player_anim
onready var house_anim

export(NodePath) var connected_point
export(NodePath) var player
export(NodePath) var conveyor

var is_going_right = false

signal is_activated
signal action_is_finished

# States the object can be. 2 parameters
# param 1 : name of the animation the state is linked to
# param 2 : the index of the next state. If it is the next state, -1
var states = [
	{"anim": "default", "next": -1},
	{"func": "cover_fall", "next": -1},
	{"func": "wires", "next": 2}
]

var cur_state = 0

func _ready():
	assert(connected_point)
	connected_point = get_node(connected_point)
	assert(player)
	player = get_node(player)
	assert(conveyor)
	conveyor = get_node(conveyor)
	
	house_anim = player.get_node("Skeleton/HouseAnim")
	player_anim = player.get_node("Skeleton/Anim")

func _on_Wires_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.is_pressed():
		emit_signal("is_activated",self)

func actions():
	# Get current state
	var state = states[cur_state]
	
	# Get next state
	if state.get("next") == -1:
		cur_state +=1
	else:
		cur_state = state.get("next")
	state = states[cur_state]
	
	# Do the action
	if state.has("anim"):
		anim.play(state.get("anim"))
		# Wait for the animation
		yield(anim, "animation_finished")
		emit_signal("action_is_finished")
	elif state.has("func"):
		call(state.get("func"))

func _on_Anim_animation_finished(anim_name):
	pass
	#emit_signal("action_is_finished")

func cover_fall():
	player_anim.stop()
	
	house_anim.play("remove_cover1")
	anim.play("cover_fall")
	
	# Wait for the anim
	yield(anim, "animation_finished")
	emit_signal("action_is_finished")
	player_anim.play("idle")

func wires():
	is_going_right = !is_going_right
	if is_going_right:
		$Anim.play("wire2")
	else:
		$Anim.play("wire1")
	conveyor.is_going_right = is_going_right
	emit_signal("action_is_finished")
