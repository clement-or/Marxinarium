extends "res://nodes/objects/Object.gd"

onready var area = $ConveyorChecker/CollisionShape2D
var target

onready var inventory = $Polygons/Inventory
onready var inventory_content setget set_inventory_content,get_inventory_content
onready var attach_point = $Skeleton/Root/ArmR1/ArmR2/ArmR3/ArmR4/HandR/Attach

func _ready():
	states = [
	{"func": "take_book", "next": 0},
	{"func": "take_key", "next": -1}
	]
	anim = $Skeleton/HouseAnim

func _on_ConveyorChecker_area_entered(area):
	if !area.get_class() == "Book":
		return
	target = area
	.actions()

func take_book():
	area.call_deferred("set_disabled",true)
	anim.play("take_book")
	yield(anim, "animation_finished")
	empty_inventory()
	anim.play("go_back")
	yield(anim, "animation_finished")
	#yield(get_tree().create_timer(3), "timeout")
	area.call_deferred("set_disabled",false)

func put_book_in_inventory():
	# Reparent Book
	var obj = target

	obj.get_parent().remove_child(obj)
	set_inventory_content(target)
	obj.set_owner(inventory)
	
	obj.global_position = attach_point.global_position
	obj.scale = Vector2(.5, .5)

func get_inventory_content():
	if inventory.get_children().size() > 0:
		return inventory.get_child(0)
	else: return false

func set_inventory_content(content):
	inventory.add_child(content)

func empty_inventory(): 
	get_inventory_content().queue_free()