extends State

@export var idle_state: State
@export var move_state: State

var finished: bool = false

func enter() -> void:
	super()
	parent.hands_occupied = true
	$"../../Hitboxes/LK".disabled = false

func _on_player_animations_animation_finished():
	if animations.animation == "attack3":
		finished = true

func process_physics(delta: float) -> State:
	if animations.frame > 1:
		$"../../Hitboxes/LK".disabled = true
	if finished:
		finished = false
		if Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down"):
			return move_state
		return idle_state
	return null

func exit() -> void:
	parent.hands_occupied = false
	super()
