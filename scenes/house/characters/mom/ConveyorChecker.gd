extends Area2D

func _on_ConveyorChecker_area_entered(area):
	if !area.get_class() == "Book":
		return
