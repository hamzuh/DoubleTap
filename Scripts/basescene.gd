extends Node

@onready var spawnTimer = $SpawnTimer
@onready var roundTimer = $RoundTimer

var enemy = preload("res://Entities/followerenemy.tscn")
# Max amount of enemies allowed on screen at once
# Figure out how to hold spawning until there's space
var max_enemies: int = 50
# Current round, increase zombie health / speed / amount on the map accordingly
var round: int = 0
# Enemies planned for this round
# Maybe use timer for consecutive zombies from same spawn
var enemies_to_spawn: int

signal round_end
signal round_start(roundCount)

# Exits game
func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()

func get_Player():
	return get_node("Player")
	
func get_Level():
	return get_node("Level")

func get_current_enemy_count():
	return get_tree().get_nodes_in_group("Enemy").size()

func _on_enemy_enemy_dead() -> void:
	await get_tree().process_frame
	if enemies_to_spawn <= 0 and get_current_enemy_count() <= 0:
		round_end.emit()

func _on_spawn_timer_timeout() -> void:
	if enemies_to_spawn > 0 and get_current_enemy_count() < max_enemies:
		# consider activated spawners only !!!!!!!!
		enemies_to_spawn -= 1
		get_Level().suitable_spawners.filter(func(spawner): return spawner.activated).pick_random().spawn(self)

func _on_round_end() -> void:
	spawnTimer.stop()
	roundTimer.start()

func _on_round_timer_timeout() -> void:
	round += 1
	if round == 3:
		spawnTimer.wait_time = 1
	enemies_to_spawn = 5 + (round * 2)
	round_start.emit(round)
	spawnTimer.start()

func _on_player_power_on() -> void:
	$CanvasModulate.visible = false
