extends State

@export var idle_state: State
@export var attack_state: State
@export var stun_kick_state: State

@onready var legAnim = $"../../Legs"

var direction: Vector2

func enter() -> void:
	legAnim.play("walk")

func process_input(event: InputEvent) -> State:
	if Input.is_action_just_pressed("Light Attack"):
		return attack_state
	if Input.is_action_just_pressed("Heavy Attack") and parent.frontStun:
		return stun_kick_state
	return null

func process_physics(delta: float) -> State:
	direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if direction == Vector2(0, 0):
		return idle_state
	# If the player is aiming in the "opposite" direction of their movement...
	if Globals.speed_scale:
		if direction.dot(Vector2(1, 0).rotated(parent.rotation)) < 0:
			#print("guh")
			#legAnim.play_backwards("walk")
			#legAnim.speed_scale = -(0.25 + (0.75 * direction.length() * Globals.speed_scale))
			# Flip the sprite 180 degrees
			legAnim.rotation = direction.angle() - parent.rotation - PI
		else:
			legAnim.rotation = direction.angle() - parent.rotation
	# Slow walk speed based on movement speed
	#animations.speed_scale = 0.1 + (0.9 * direction.length() * Globals.speed_scale)
	legAnim.speed_scale = (0.1 + (0.9 * direction.length())) * Globals.speed_scale
	parent.velocity = direction * parent.speed * Globals.speed_scale
	parent.move_and_slide()
	return null

func exit() -> void:
	# Reset animation speed
	legAnim.speed_scale = 1 * Globals.speed_scale
	legAnim.stop()
	#animations.speed_scale = 1 * Globals.speed_scale
	super()
