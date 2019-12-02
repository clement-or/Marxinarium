extends Area2D

export(String, "fall_left", "fall_right") var animation
onready var parent = get_parent()

func _ready():
	if animation == "fall_left":
		animation = preload("res://scenes/house/objects/conveyor_belt/animations/fall_left.tres")
	else:
		animation = preload("res://scenes/house/objects/conveyor_belt/animations/fall_right.tres")

func _on_End_area_entered(area):
	# Check if area is in objects
	var objs = parent.objects
	var area_is_in_parent = false
	for obj in objs:
		area_is_in_parent = area_is_in_parent || area == obj
		
	if area == parent || !area_is_in_parent:
		return
	
	# Instianciate AnimPlayer
	var anim_player = AnimationPlayer.new()
	anim_player.add_animation("fall", animation) # Add custom anim
	area.add_child(anim_player)
	# Play and wait
	anim_player.play("fall")
	yield(anim_player, "animation_finished")
	# Kill object
	area.call_deferred("queue_free")
