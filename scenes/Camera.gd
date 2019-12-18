extends Camera2D

onready var anim = $Anim

func screen_shake():
	anim.play("screen_shake")