extends Area2D

@onready var parent = get_parent()

# This doesn't work because it doesn't consider which hitbox is detecting the player
# This type of thing only works when there's one hitbox activate at a time

#func _on_body_entered(body: Node2D) -> void:
	#if body.is_in_group("Player"):
		#for hitbox in get_children():
			## Not really necessary?
			#if hitbox.disabled == false:
				## When player hitting is implemented
				## If hitbox is a damage one
					## body.hit()
				#if hitbox == $FrontStun:
					#body.stunChance(true, "front", get_parent())
				#if hitbox == $BackStun:
					#body.stunChance(true, "back", get_parent())
#
#func _on_body_exited(body: Node2D) -> void:
	#if body.is_in_group("Player"):
		#for hitbox in get_children():
			#if hitbox == $FrontStun:
				#body.stunChance(false, "front", get_parent())
			#if hitbox == $BackStun:
				#body.stunChance(false, "back", get_parent())
				
# Switching to a manager node system with children Area2Ds (and children Collision shapes) is better suited
# More complicated but better control over what hitboxes can collide with what

func _on_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	var local_shape_owner = shape_find_owner(local_shape_index)
	var hitbox = shape_owner_get_owner(local_shape_owner)
	if body.is_in_group("Player"):
		# print(hitbox.name)
		if hitbox == $FrontStun:
			body.stunChance(true, "front", parent)
		if hitbox == $BackStun:
			body.stunChance(true, "back", parent)
	# Currently this smacks the enemies all over the place making training hard
	# Maybe use a custom function for enemies to dodge heavy knockback or catch them, slowing their knockback
	# Catch state + halve parent.knockforce
	#if body.is_in_group("Enemy"):
		#if hitbox == $Knockback:
			#if parent.knockforce > 50:
				#body.hit(parent.knockback_source, self, 0, 5, false)
	
func _on_body_shape_exited(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.is_in_group("Player"):
		var local_shape_owner = shape_find_owner(local_shape_index)
		var hitbox = shape_owner_get_owner(local_shape_owner)
		if hitbox == $FrontStun:
			body.stunChance(false, "front", parent)
		if hitbox == $BackStun:
			body.stunChance(false, "back", parent)
