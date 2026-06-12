extends State

@export var idle_state: State
@export var chasing_state: State

var finished: bool = false

# This'll require the animation player instead to animate hitboxes
func _on_animated_sprite_2d_animation_finished() -> void:
	if animations.animation == "swipe":
		finished = true
			
func process_physics(delta: float) -> State:
	if finished:
		if parent.position.distance_to(parent.Player.position) >= 100:
			return chasing_state
		else:
			return idle_state
	return null
