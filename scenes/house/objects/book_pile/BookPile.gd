extends "res://nodes/objects/Object.gd"

export(NodePath) var next_point

func _ready():
	assert(next_point)
	next_point = get_node(next_point).get_node("Zone")
	
	states = [
	{"anim": "default", "next": -1,},
	{"func": "fall", "next": -1,},
	]

func fall():
	anim.play("fall")
	yield(anim, "animation_finished")