extends State

@export var move_state: State
@export var attack_state: State

func process_input(event: InputEvent) -> State:
	if Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down"):
		return move_state
	if Input.is_action_just_pressed("Light Attack"):
		return attack_state
	return null
