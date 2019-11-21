extends "res://Point.gd"

export(String) var next_scene
export(NodePath) var next_point
export(int) var destination_point

func _ready():
	assert(next_point)
	next_point = get_node(next_point)