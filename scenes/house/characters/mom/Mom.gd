extends "res://nodes/objects/Object.gd"

func _ready():
	states = [
	{"func": "take_book", "next": 0},
	{"func": "take_key", "next": -1}
	]

func _on_ConveyorChecker_area_entered(area):
	if !area.get_class() == "Book":
		return

func take_book():
	pass