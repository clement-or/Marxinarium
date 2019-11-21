extends Node2D

onready var scene_changer = get_node("/root/SceneChanger")

onready var points = $Points.get_children()
onready var josef = $Navigation2D/Josef

var current_point

func _ready():
	var first_point = points[0].global_position
	# Connect all points
	josef.points = points
	for point in points:
		point.connect("clicked", self, "_on_Point_clicked")

func _move_Josef_to(point):
	josef.path = $Navigation2D.get_simple_path(josef.global_position, point.global_position, true)
	current_point = point

func _on_Point_clicked(event, point):
	if event.is_action_pressed("click") && josef.global_position != point.global_position:
		_move_Josef_to(point)
