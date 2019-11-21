extends "res://nodes/points/Point.gd"

onready var sc = get_node("/root/SceneChanger")

export(String) var destination_scene # Scene that the exit links to
export(int) var destination_point # Which exit in the destination scene this one links to
export(NodePath) var connected_point # Which point in the current scene the character will go from this one

func _ready():
	assert(destination_scene)
	assert(connected_point)
	connected_point = get_node(connected_point)

func _on_Exit_input_event(viewport, event, shape_idx):
	$Teleport/CollisionShape2D.disabled = false
	emit_signal("clicked", event, self)

func _on_Teleport_area_entered(area):
	if area.get_class() == "Player":
		sc.change_scene(destination_scene, destination_point)