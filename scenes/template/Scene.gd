extends Node2D

onready var scene_changer = get_node("/root/SceneChanger")

onready var points = $Points.get_children()
onready var exits = $Exits.get_children()
onready var player = $Navigation2D/Player

var current_point

func _ready():
	var first_point = points[0].global_position
	# Connect all points
	player.points = points
	
	# Connect signals for every point
	for point in points:
		point.connect("clicked", self, "_on_Point_clicked")
	for point in exits:
		point.connect("clicked", self, "_on_Point_clicked")

func _move_player_to(point):
	player.path = $Navigation2D.get_simple_path(player.global_position, point.global_position, true)
	current_point = point

func _on_Point_clicked(event, point):
	if event.is_action_pressed("click") && player.global_position != point.global_position:
		_move_player_to(point)
