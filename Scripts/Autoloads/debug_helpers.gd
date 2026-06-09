extends Node

@onready var Base = get_node("../Main")
@onready var Player = get_node("../Main/Player")

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("debug_money"):
		Player.increase_points(1000)
	if Input.is_action_just_pressed("debug_lights"):
		Base.lights.visible = false
		Player.get_node("Flashlight").visible = false
		Player.get_node("AuraLight").visible = false
