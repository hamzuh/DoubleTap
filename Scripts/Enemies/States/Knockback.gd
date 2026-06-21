extends State

@export var idle_state: State
var length: float

func enter() -> void:
	length = parent.knockforce / 1000
	print(length)
	animations.sprite_frames.set_animation_speed("knocked_back", 6 / length)
	super()
	$"../../Hitboxes/Knockback".set_deferred("disabled", false)

# Animation doesn't loop and the length of knockback is set
# This means we exit through this instead of the animation ended signal
# Speed up animation through code to fit
func process_physics(delta: float) -> State:
	parent.velocity = parent.knockdirect * parent.knockforce * Globals.speed_scale
	parent.move_and_slide()
	parent.knockforce -= 1000 * delta * Globals.speed_scale
	if parent.knockforce <= 0:
		return idle_state
	return null

func exit() -> void:
	$"../../Hitboxes/Knockback".set_deferred("disabled", true)
	super()
