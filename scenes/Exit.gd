extends "res://nodes/points/Point.gd"

onready var sc = get_node("/root/SceneChanger")


export(String) var destination_scene # Scene that the exit links to
export(int) var destination_point # Which exit in the destination scene this one links to
export(int) var connected_point # Which point in the current scene the character will go from this one

func _on_Exit_input_event(viewport, event, shape_idx):
	$Teleport/CollisionShape2D.disabled = false
	emit_signal("clicked", event, self)

func _on_Teleport_area_entered(area):
	if area.get_class() == "Player":
		get_tree().change_scene("res://scenes/Scene2.tscn")
