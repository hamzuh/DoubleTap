class_name Weapon extends Node2D

@export var weapon_type: WeaponStat
var stats: WeaponStat

@onready var sprite: Sprite2D = $Sprite2D
@onready var ray: RayCast2D = $RayCast2D

var spread: float
var automatic: bool
var firerate: float
var reload_speed: float
var cooldown: float = 0

func _ready() -> void:
	stats = weapon_type.duplicate()
	
	firerate = stats.firerate
	sprite.texture = stats.texture

func _physics_process(delta: float) -> void:
	ray.target_position = get_parent().shotrot * 50000
	if cooldown > 0:
		cooldown -= delta

func fire():
	if cooldown <= 0:
		print("BLAM!")
		print(ray.get_collider())
		cooldown = firerate
