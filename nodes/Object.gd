extends Area2D

onready var anim = $Anim

export(NodePath) var connected_point

signal is_activated
signal action_is_finished

var states = [
	"default",
	"cover_fall",
	"wire1",
	"wire2"
	]

var state = states.default

func _ready():
	assert(connected_point)
	connected_point = get_node(connected_point)

func _on_Object_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.is_pressed():
		emit_signal("is_activated",self)

func actions():
	if state == states.default:
		anim.play("cover_fall")
		state = states.cover_fall
		
	elif state == states.cover_fall:
		anim.play("wire1")
		state = states.wire1
		
	elif state == states.wire1:
		anim.play("wire2")
		state = states.wire2
		
	elif state == states.wire2:
		anim.play("wire1")
		state = states.wire1

func _on_Anim_animation_finished(anim_name):
	emit_signal("action_is_finished")
