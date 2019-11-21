extends Node2D

onready var sc = get_node("/root/SceneChanger")

onready var points = $Points.get_children()
onready var exits = $Exits.get_children()
onready var player = $Navigation2D/Player

var current_point
var entrance

func _ready():
	# Put the player on an exit
	entrance = exits[sc.point_number]
	entrance.get_node("Teleport/CollisionShape2D").disabled
	player.global_position =  entrance.global_position
	player.points = points
	
	# Connect the has_arrived signal. When they arrive we re-activate the entrance they came in
	player.connect("has_arrived", self, "_on_Player_has_arrived")
	
	# Connect signals for every point
	for point in points:
		point.connect("clicked", self, "_on_Point_clicked")
	for point in exits:
		point.connect("clicked", self, "_on_Point_clicked")
	
	_move_player_to(entrance.connected_point) # Move the player to a point

func _move_player_to(point):
	player.path = $Navigation2D.get_simple_path(player.global_position, point.global_position, true)
	current_point = point

func _on_Point_clicked(event, point):
	if event.is_action_pressed("click") && player.global_position != point.global_position && player.controls_enabled:
		_move_player_to(point)

func _on_Player_has_arrived():
	if !entrance:
		return
	entrance.get_node("Teleport/CollisionShape2D").disabled
	entrance = null