extends State

# Animation should have birds flying above head and whistling noise
# Stun noise should probably loop but it's a wav for now
# Nevermind, use the import tab!
@export var idle_state: State

@onready var sfxPlayer = $"../../AudioStreamPlayer2D"
@onready var sfx = load("res://Audio/Enemies/stun1.wav")
@onready var stunTimer = $"../../StunTimer"

# Hitbox variables
# Replace this with animationPlayer toggles
@onready var frontStun = $"../../Hitboxes/FrontStun"
@onready var backStun = $"../../Hitboxes/BackStun"

var finished
var stun_force = 350

func enter() -> void:
	super()
	finished = false
	stun_force = 350
	# Hitbox toggles
	frontStun.set_deferred("disabled", false)
	backStun.set_deferred("disabled", false)
	# Sound play
	sfxPlayer.stream = sfx
	sfxPlayer.play()
	stunTimer.start()
	
# Maybe make the knockback small and just use a timer to keep stunned
func process_physics(delta: float) -> State:
	parent.velocity = parent.knockdirect * stun_force * Globals.speed_scale
	parent.move_and_slide()
	if stun_force > 0:
		stun_force -= 1000 * delta * Globals.speed_scale
	# Not the best way to do this surely
	#if stun_force <= 0:
		#stun_force = 0
		#return idle_state
	if finished:
		return idle_state
	return null
	
func exit() -> void:
	# Hitbox toggles
	frontStun.set_deferred("disabled", true)
	backStun.set_deferred("disabled", true)
	# Stop sound
	if sfxPlayer.stream == sfx:
		sfxPlayer.stop()
	super()

func _on_stun_timer_timeout() -> void:
	finished = true
