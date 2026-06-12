extends Node

var enemy = preload("res://Entities/EnemyOfTheState.tscn")

func _ready() -> void:
	get_Player().get_node("Flashlight").visible = false
	get_Player().get_node("AuraLight").visible = false

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
	await get_tree().process_frame
	if get_current_enemy_count() <= 0:
		var enemySpawn = enemy.instantiate()
		enemySpawn.position = Vector2(0, 0)
		enemySpawn.enemy_dead.connect(self._on_enemy_enemy_dead)
		self.add_child(enemySpawn)
