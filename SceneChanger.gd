extends CanvasLayer

var point_number = 0

func change_scene(path, p):
	point_number = p
	get_tree().change_scene(path)