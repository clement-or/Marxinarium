extends "res://nodes/objects/Object.gd"

export(NodePath) var book_pile_node

onready var area = $ConveyorChecker/CollisionShape2D
var target

onready var inventory = $Polygons/Inventory
onready var inventory_content setget set_inventory_content,get_inventory_content
onready var attach_point = $Skeleton/Root/ArmR1/ArmR2/ArmR3/ArmR4/HandR/Attach

func _ready():
	assert(book_pile_node)
	book_pile_node = get_node(book_pile_node)
	
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
	
	anim.play("go_back")
	yield(anim, "animation_finished")
	
	area.call_deferred("set_disabled",false)

func put_book_in_inventory():
	# Reparent Book
	var obj = target

	obj.get_parent().remove_child(obj)
	set_inventory_content(target)
	obj.set_owner(inventory)
	
	obj.global_position = attach_point.global_position
	obj.scale = Vector2(.5, .5)

func drop_book():
	# Reparent book
	var obj = get_inventory_content()
	var pos = obj.global_position
	var rot = obj.global_rotation
	
	inventory.remove_child(obj)
	book_pile_node.add_child(obj)
	obj.set_owner(obj)
	# Reposition book
	obj.global_position = pos
	obj.global_rotation = rot
	obj.scale = Vector2(2,2)
	obj.z_index = 2
	
	# Animate book
	var tween = obj.get_node("Tween")
	tween.interpolate_property(obj, "global_position", obj.global_position, book_pile_node.get_next_position(), 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()
	#yield(tween, "tween_completed")

func get_inventory_content():
	if inventory.get_children().size() > 0:
		return inventory.get_child(0)
	else: return false

func set_inventory_content(content):
	inventory.add_child(content)

func empty_inventory(): 
	get_inventory_content().queue_free()