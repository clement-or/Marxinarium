extends Area2D

signal clicked

func _on_Point_input_event(viewport, event, shape_idx):
	emit_signal("clicked", event, self)
