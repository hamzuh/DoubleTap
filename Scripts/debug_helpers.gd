extends Node

@onready var Player = get_node("../Main/Player")

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("debug_money"):
		Player.increase_points(1000)
