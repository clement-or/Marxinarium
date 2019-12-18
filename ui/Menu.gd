extends Control

onready var jouer = $VBoxContainer/Jouer
onready var quitter = $VBoxContainer/Quitter
onready var sc = get_node("/root/SceneChanger")

func _on_Jouer_pressed():
	quitter.disabled = true
	jouer.disabled = true
	sc.fade_scene("res://scenes/house/House.tscn")

func _on_Quitter_pressed():
	get_tree().quit()
