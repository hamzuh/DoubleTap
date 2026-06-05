extends Area2D

#@onready var punch = $"../Punch"
#@onready var kick = $"../Kick"

func _on_body_entered(body):
	if body.is_in_group("Enemy"):
		for hitbox in get_children():
			if hitbox.disabled == false:
				body.hit(owner, hitbox.damage, hitbox.knockback, owner.instakill)
				if hitbox == $LK:
					owner.camera.shake(11, 0.15)
				#print(hitbox)
