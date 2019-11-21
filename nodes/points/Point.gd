extends Area2D

signal clicked

func _on_Point_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.is_pressed():
		emit_signal("clicked", event, self)
