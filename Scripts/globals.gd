extends Node

var speed_scale: float = 1
@onready var base: Node = get_node("../Main")

#var eq = AudioServer.get_bus_effect(1, 0)
#var rev = AudioServer.get_bus_effect(1, 1)

signal hitstop(start, timescale, camera_shake, intensity, time)

# Add parameters for activating camera shake, intensity, time etc. after hitstop
func hitstop_activate(duration, timescale, camera_shake: bool, intensity, time):
	speed_scale = timescale
	AudioServer.set_bus_effect_enabled(1, 0, true)
	AudioServer.set_bus_effect_enabled(1, 1, true)
	hitstop.emit(true, speed_scale, camera_shake, intensity, time)
	await get_tree().create_timer(duration, true, false, true).timeout
	speed_scale = 1
	AudioServer.set_bus_effect_enabled(1, 0, false)
	AudioServer.set_bus_effect_enabled(1, 1, false)
	hitstop.emit(false, speed_scale, camera_shake, intensity, time)

func hitstop_camera_shake():
	pass
