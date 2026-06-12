extends State

# Should probably standardise the behaviour of other states returning to here
# Or straight to chasing, swiping, etc.
# I'm assuming moving back to this first incurs a frame delay or something
@export var chasing_state: State
@export var swiping_state: State

func process_physics(delta: float) -> State:
	if parent.position.distance_to(parent.Player.position) >= 100:
		return chasing_state
	else:
		return swiping_state
