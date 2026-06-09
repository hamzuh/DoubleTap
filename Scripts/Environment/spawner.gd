extends Node2D

# Enemy scene reference for spawning
var enemy = preload("res://Entities/followerenemy.tscn")
# Activated when room is first opened
@export var activated: bool

func spawn(topnode):
	var enemySpawn = enemy.instantiate()
	enemySpawn.position = self.position
	enemySpawn.enemy_dead.connect(topnode._on_enemy_enemy_dead)
	topnode.add_child(enemySpawn)
