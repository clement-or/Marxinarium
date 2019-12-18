extends CanvasLayer

onready var anim = $AnimationPlayer
var point_number = 0

func _ready():
	anim = $AnimationPlayer

func change_scene(path, p):
	point_number = p
	get_tree().change_scene(path)

func fade_scene(path):
	anim.play("fade_in")
	yield(anim, "animation_finished")
	get_tree().change_scene(path)
	anim.play_backwards("fade_in")