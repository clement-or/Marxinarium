extends "res://nodes/objects/Object.gd"

var Book = preload("res://scenes/house/book/Book.tscn")

# state template
# {"anim" : "name", "next": -1}
# {"func" : "name", "next": -1}

func _ready():
	states = [
		{"anim": "default", "next": -1},
		{"func": "first", "next": -1},
	]

func first():
	# If the player has the key
	if player.inventory && player.inventory.get_class() == "Key":
		return
		
	player.scale.x = -abs(player.scale.x)
	# If the player has a book, drop it
	if player.inventory_content && player.inventory_content.get_class() == "Book":
		house_anim.play("drop_book")
		yield(house_anim, "animation_finished")
	else:
		# Otherwise take a book
		house_anim.play("take_new_book1")
		yield(house_anim, "animation_finished")
		
		# Create Book
		player.inventory_content = Book.instance()
		# Randomize color
		randomize()
		player.get_inventory_content().modulate = Color(randf(), randf(), randf())
		
		house_anim.play("take_new_book2")
		yield(house_anim, "animation_finished")
	
	emit_signal("action_is_finished")
	connected_point.move_there()
	cur_state = 0