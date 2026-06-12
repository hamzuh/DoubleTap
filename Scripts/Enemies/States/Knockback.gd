extends State

@export var idle_state: State

# Animation doesn't loop and the length of knockback is set
# This means we exit through this instead of the animation ended signal
func process_physics(delta: float) -> State:
	parent.velocity = parent.knockdirect * parent.knockforce * Globals.speed_scale
	parent.move_and_slide()
	parent.knockforce -= 1000 * delta * Globals.speed_scale
	if parent.knockforce <= 0:
		return idle_state
	return null
