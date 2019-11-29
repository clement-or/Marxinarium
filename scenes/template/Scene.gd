extends Node2D

onready var sc = get_node("/root/SceneChanger")

onready var points = $Points.get_children()
onready var exits = $Exits.get_children()
onready var player = $Navigation2D/Player
onready var objects = $Objects.get_children()

export(NodePath) var starting_point

var current_point
var entrance

func _ready():
	# Chose where the player will appear
	if exits && exits[sc.point_number]:
		entrance = exits[sc.point_number]
		entrance.get_node("Teleport/CollisionShape2D").disabled
		_move_player_to(entrance.connected_point) # Move the player to a point
	elif starting_point:
		entrance = get_node(starting_point)
		
	player.global_position =  entrance.global_position
	player.points = points
	
	_connect_all_signals()


func _connect_all_signals():
	# Connect the has_arrived signal. When they arrive we re-activate the entrance they came in
	player.connect("has_arrived", self, "_on_Player_has_arrived")
	
	# Connect signals for every point
	for point in points:
		point.connect("clicked", self, "_on_Point_clicked")
	for point in exits:
		point.connect("clicked", self, "_on_Point_clicked")
	for object in objects:
		object.connect("is_activated", self, "_on_Object_is_activated")
		object.connect("action_is_finished", self, "_on_Object_action_is_finished")

func _move_player_to(point):
	player.path = $Navigation2D.get_simple_path(player.global_position, point.global_position, true)
	current_point = point

func _on_Point_clicked(event, point):
	if player.global_position != point.global_position && player.controls_enabled:
		if (typeof(event) == TYPE_STRING && event == "force") || event.is_action_pressed("click"):
			_move_player_to(point)

func _on_Player_has_arrived():
	if !entrance || !(exits && exits[sc.point_number]):
		return
	entrance.get_node("Teleport/CollisionShape2D").disabled
	entrance = null

func _on_Object_is_activated(obj):
	if player.controls_enabled && player.global_position == obj.connected_point.global_position:
		player.controls_enabled = false
		obj.actions()

func _on_Object_action_is_finished():
	player.controls_enabled = true