extends Node2D

func get_next_position():
	var i = -1
	for child in get_children():
		if child.get_class() == "Book":
			i += 1
	return $Positions.get_child(i).global_position

func is_full():
	var i = -1
	for child in get_children():
		if child.get_class() == "Book":
			i += 1
	return true if i >= 3 else false