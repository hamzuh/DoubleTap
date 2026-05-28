class_name Weapon extends Node2D

@export var weapon_type: WeaponStat
var stats: WeaponStat

@onready var sprite: Sprite2D = $Sprite2D

func _ready() -> void:
	stats = weapon_type.duplicate()
	
	sprite.texture = stats.texture

func fire():
	pass
