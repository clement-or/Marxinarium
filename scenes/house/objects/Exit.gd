extends "res://nodes/objects/Object.gd"

onready var sc = get_node("/root/SceneChanger")

func _ready():
	states = [
	{"anim": "default", "next": -1},
	{"func": "exit", "next": -1}
	]

func exit():
	player.house_anim.stop()
	player.anim.stop()
	
	player.house_anim.play("exit")
	yield(house_anim, "animation_finished")
	sc.fade_scene("res://ui/Menu.tscn")