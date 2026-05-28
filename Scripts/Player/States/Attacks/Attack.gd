extends State

@export var idle_state: State
@export var move_state: State
@export var attack2_state: State

var finished: bool = false
var attack2: bool = false

func enter() -> void:
	super()
	$"../../Hitboxes/LP".disabled = false

func _on_player_animations_animation_finished():
	if animations.animation == "attack1":
		finished = true
	
func process_input(event: InputEvent) -> State:
	if animations.animation == "attack1":
		if animations.frame >= 1:
			if Input.is_action_just_pressed("Light Attack"):
				attack2 = true
	return null

func process_physics(delta: float) -> State:
	if animations.frame > 1:
		$"../../Hitboxes/LP".disabled = true
		if attack2:
			attack2 = false
			return attack2_state
	if finished:
		finished = false
		if Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down"):
			return move_state
		return idle_state
	return null
