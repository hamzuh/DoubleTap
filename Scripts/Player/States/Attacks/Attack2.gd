extends attack_State

@export var idle_state: State
@export var move_state: State
@export var attack3_state: State

var finished: bool = false
var attack3: bool = false

func enter() -> void:
	super()
	parent.hands_occupied = true
	$"../../Hitboxes/RP".disabled = false

func _on_player_animations_animation_finished():
	if animations.animation == "attack2":
		finished = true

func process_input(event: InputEvent) -> State:
	if animations.animation == "attack2":
		if animations.frame >= 1:
			if Input.is_action_just_pressed("Heavy Attack"):
				attack3 = true
	return null

func process_physics(delta: float) -> State:
	if animations.frame > 1:
		$"../../Hitboxes/RP".disabled = true
		if attack3:
			attack3 = false
			return attack3_state
	if finished:
		finished = false
		if Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down"):
			return move_state
		return idle_state
	return null

func exit() -> void:
	parent.hands_occupied = false
	super()
