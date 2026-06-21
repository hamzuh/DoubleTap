extends State

@export var idle_state: State
@export var chasing_state: State

@onready var sfxPlayer = $"../../AudioStreamPlayer2D"
@export var sfxArray: Array[AudioStream]

var finished: bool = false

func enter() -> void:
	super()
	# Start cooldown timer for use in other states
	sfxPlayer.stream = sfxArray.pick_random()
	sfxPlayer.play()

# This'll require the animation player instead to animate hitboxes
func _on_animated_sprite_2d_animation_finished() -> void:
	if animations.animation == "swipe":
		finished = true
			
func process_physics(delta: float) -> State:
	if finished:
		finished = false
		if parent.position.distance_to(parent.Player.position) >= 100:
			return chasing_state
		else:
			return idle_state
	return null

func exit() -> void:
	if sfxPlayer.playing:
		sfxPlayer.stop()
