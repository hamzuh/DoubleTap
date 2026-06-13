extends Area2D

#@onready var punch = $"../Punch"
#@onready var kick = $"../Kick"

func _on_body_entered(body):
	if body.is_in_group("Enemy"):
		for hitbox in get_children():
			if hitbox.disabled == false:
				body.hit(owner, owner, hitbox.damage, hitbox.knockback, owner.instakill)
				if hitbox == $LK:
					Globals.hitstop_activate(0.1, 0, true, 11, 0.15)
					#owner.camera.shake(11, 0.15)
					# This sucks major ass
					await get_tree().create_timer(0.1, true, false, true).timeout
				owner.melee_audio.stream = hitbox.onHitSFX
				owner.melee_audio.play()
				#print(hitbox)
