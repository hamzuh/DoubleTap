extends Node

@onready var spawnTimer = $SpawnTimer
@onready var roundTimer = $RoundTimer

#var enemy = preload("res://Entities/followerenemy.tscn")
# Max amount of enemies allowed on screen at once
# Figure out how to hold spawning until there's space
var max_enemies: int = 40
# Current round, increase zombie health / speed / amount on the map accordingly
var round: int = 0
# Enemies planned for this round
# Maybe use timer for consecutive zombies from same spawn
var enemies_to_spawn: int

var powerup = preload("res://Entities/Powerup.tscn")
signal powerup_activate(startOrEnd, powerup_name)

@onready var levelSFX: Node = $LevelSFX
@onready var roundStartFX: AudioStream = load("res://Audio/Environment/roundstart.wav")
@onready var roundEndFX: AudioStream = load("res://Audio/Environment/roundend.wav")
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
	# Rework this, it's a little hacky
	# Probably only need to check against the second arg
	return min(get_tree().get_nodes_in_group("Enemy").size(), get_tree().get_nodes_in_group("Enemy").filter(func(enemy): return enemy.dead == false).size())

func _on_enemy_enemy_dead(enemy_position) -> void:
	# Random chance to spawn powerup
	var spawn_chance = randi_range(0, 7)
	if spawn_chance == 7:
		spawn_powerup(enemy_position)
	await get_tree().process_frame
	if enemies_to_spawn <= 0 and get_current_enemy_count() <= 0:
		# Spawn powerup on last enemy of round
		spawn_powerup(enemy_position)
		#var powerupSpawn = powerup.instantiate()
		#powerupSpawn.position = enemy_position
		#powerupSpawn.picked_up.connect(self._on_powerup_picked_up)
		#self.add_child(powerupSpawn)
		round_end.emit()

func _on_spawn_timer_timeout() -> void:
	if enemies_to_spawn > 0 and get_current_enemy_count() < max_enemies:
		# consider activated spawners only !!!!!!!!
		enemies_to_spawn -= 1
		get_Level().suitable_spawners.filter(func(spawner): return spawner.activated).pick_random().spawn(self)

func _on_round_end() -> void:
	spawnTimer.stop()
	roundTimer.start()
	levelSFX.stream = roundEndFX
	levelSFX.play()

func _on_round_timer_timeout() -> void:
	round += 1
	if round == 3:
		spawnTimer.wait_time = 1
	enemies_to_spawn = 5 + (round * 3)
	round_start.emit(round)
	spawnTimer.start()
	levelSFX.stream = roundStartFX
	levelSFX.play()

func _on_player_power_on() -> void:
	$CanvasModulate.visible = false

# Might be worth splitting powerup stuff into its own node and script
# Powerup Manager, etc.
func spawn_powerup(spawn_position, powerup_load = null):
	var powerupSpawn = powerup.instantiate()
	powerupSpawn.position = spawn_position
	if powerup_load:
		powerupSpawn.powerup_type = powerup_load
	powerupSpawn.picked_up.connect(self._on_powerup_picked_up)
	self.add_child(powerupSpawn)

func _on_powerup_picked_up(powerup_name, picker) -> void:
	match powerup_name:
		"Double Points":
			$"Powerup Timers/DoublePoints".start()
			powerup_activate.emit(true, powerup_name)
		"Fire Sale":
			$"Powerup Timers/FireSale".start()
			powerup_activate.emit(true, powerup_name)
		"Instakill":
			$"Powerup Timers/Instakill".start()
			powerup_activate.emit(true, powerup_name)
		"Max Ammo":
			powerup_activate.emit(true, powerup_name)
		"Nuke":
			# Kill all enemies on screen
			# Make a custom nuke death for enemies and give points to player directly
			# Give player 400 points
			for enemy in get_tree().get_nodes_in_group("Enemy"):
				enemy.die(picker)

func _on_double_points_timeout() -> void:
	powerup_activate.emit(false, "Double Points")

func _on_fire_sale_timeout() -> void:
	powerup_activate.emit(false, "Fire Sale")

func _on_instakill_timeout() -> void:
	powerup_activate.emit(false, "Instakill")
