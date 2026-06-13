extends State

@export var idle_state: State
@export var attack_state: State
@export var stun_kick_state: State

var direction: Vector2

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
	parent.velocity = direction * parent.speed * Globals.speed_scale
	parent.move_and_slide()
	return null
