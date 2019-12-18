extends "res://nodes/objects/Object.gd"

export(NodePath) var next_point

func _ready():
	assert(next_point)
	next_point = get_node(next_point)
	
	states = [
	{"anim": "default", "next": -1,},
	{"func": "fall", "next": -1,},
	]

func fall():
	anim.play("fall")
	
	player.house_anim.stop()
	player.anim.stop()
	player.house_anim.play("kick_books")
	yield(anim, "animation_finished")
	next_point.disabled = false
	emit_signal("action_is_finished")