extends Area2D

onready var scene_changer = get_node("/root/SceneChanger")

export(NodePath) var points
export(int) var speed = 100

signal has_arrived

var path

func _ready():
	assert(points)
	points = get_node(points)
	
	global_position = points.get_children()[scene_changer.point_number].global_position

func _process(delta):
	if path:
		move_along_path(speed*delta)

func move_along_path(distance):
	var last_point = global_position
	while path.size():
		var distance_between_points = last_point.distance_to(path[0])
		
		# the position to move to falls between two points
		if distance <= distance_between_points:
			global_position = last_point.linear_interpolate(path[0], distance / distance_between_points)
			return
		
		# the position is past the end of the segment
		distance -= distance_between_points
		last_point = path[0]
		path.remove(0)
	# the character reached the end of the path
	global_position = last_point
	emit_signal("has_arrived")

func get_class(): return "Player"