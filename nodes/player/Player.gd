extends Area2D

onready var scene_changer = get_node("/root/SceneChanger")
onready var anim = $Skeleton/Anim
onready var house_anim = $Skeleton/HouseAnim
onready var inventory = $Polygons/Inventory
onready var inventory_content setget set_inventory_content,get_inventory_content
onready var attach_point = $Skeleton/Root/ArmR1/ArmR2/ArmR3/ArmR4/HandR/Attach

export(NodePath) var points
export(int) var speed = 5

signal has_arrived

var controls_enabled = true
var path


func _ready():
	update()
	assert(points)
	points = get_node(points)
	
	# Place player on first point
	global_position = points.get_children()[scene_changer.point_number].global_position
	anim.play("idle")

func _process(delta):
	
	inventory.global_position = attach_point.global_position
	inventory.rotation = attach_point.rotation
	if path:
		move_along_path(speed*delta)

func move_along_path(distance):
	var last_point = global_position
	controls_enabled = false
	while path.size():
		# Play walk animation
		anim.play("walk")
		scale.x = abs(scale.x) if path[0].x > global_position.x else -abs(scale.x)
		
		var distance_between_points = last_point.distance_to(path[0])
		
		# the position to move to falls between two points
		if distance <= distance_between_points:
			global_position = last_point.linear_interpolate(path[0], distance / distance_between_points)
			return
		
		# the position is past the end of the segment
		distance -= distance_between_points
		last_point = path[0]
		path.remove(0)
	# the character reached the end of the path
	global_position = last_point
	controls_enabled = true
	emit_signal("has_arrived")
	anim.play("idle")


func get_inventory_content():
	if inventory.get_children().size() > 0:
		return inventory.get_child(0)
	else: return false

func set_inventory_content(content):
	inventory.add_child(content)

func empty_inventory(): 
	get_inventory_content().queue_free()

func get_class(): return "Player"