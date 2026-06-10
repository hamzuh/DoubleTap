extends State

@export var chasing_state: State
@export var swiping_state: State

func process_physics(delta: float) -> State:
	if parent.position.distance_to(parent.Player.position) >= 100:
		return chasing_state
	else:
		return swiping_state
