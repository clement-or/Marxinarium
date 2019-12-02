extends "res://nodes/objects/Object.gd"

var is_going_right = false setget set_direction

# state template
# {"anim" : "name", "next": -1}
# {"func" : "name", "next": -1}

func _ready() :
	states = [
	]
	$Anim.play_backwards("right")

func set_direction(boolean):
	is_going_right = boolean
	if boolean:
		$Anim.play("right")
	else:
		$Anim.play_backwards("right")