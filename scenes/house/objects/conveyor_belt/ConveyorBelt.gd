extends "res://nodes/objects/Object.gd"

export var speed = 1

onready var objects = $ConveyorObjects.get_children() setget ,get_objects

var is_going_right = false setget set_direction

# state template
# {"anim" : "name", "next": -1}
# {"func" : "name", "next": -1}

func _process(delta):
	for obj in get_objects():
		if !weakref(obj).get_ref():
			return
		obj.global_position.x += ((2*int(is_going_right))-1)*speed

func _ready() :
	states = [
		{"func" : "put_object_on", "next": 0}
	]
	set_direction(is_going_right)

func put_object_on():
	if !(player.get_inventory_content() && player.get_inventory_content().get_class() == "Book"):
		emit_signal("action_is_finished")
		return
	# Play the animation, player puts the book on the conveyor
	player_anim.stop()
	player.scale.x = -abs(player.scale.x)
	house_anim.play("put_book_on_conveyor")
	yield(house_anim, "animation_finished")
	
	# Reparent Book
	var obj = player.get_inventory_content()
	var pos = obj.global_position
	var target = $ConveyorObjects

	player.inventory.remove_child(obj)
	target.add_child(obj)
	obj.set_owner(target)
	
	obj.global_position = pos
	obj.scale = Vector2(-3,3)
	player_anim.play('idle')
	
	emit_signal("action_is_finished")

func set_direction(boolean):
	is_going_right = boolean
	if boolean:
		$Anim.play("right")
	else:
		$Anim.play_backwards("right")

func get_objects(): return $ConveyorObjects.get_children()