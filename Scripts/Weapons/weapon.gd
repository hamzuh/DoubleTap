class_name Weapon extends Node2D

@export var weapon_type: WeaponStat
var stats: WeaponStat

@onready var sprite: Sprite2D = $Sprite2D
@onready var ray: RayCast2D = $RayCast2D

var spread: float
var automatic: bool
var firerate: float
var reload_speed: float
var damage: float
var knockback: float
var cooldown: float = 0

func _ready() -> void:
	stats = weapon_type.duplicate()
	
	firerate = stats.firerate
	damage = stats.damage
	knockback = stats.knockback
	spread = stats.spread
	sprite.texture = stats.texture
	
	ray.target_position = Vector2(1000, 0)

func _physics_process(delta: float) -> void:
	if cooldown > 0:
		cooldown -= delta

func fire():
	if cooldown <= 0:
		ray.target_position = Vector2(1000, 0).rotated(randf_range(-PI/2, PI/2) * spread)
		if ray.get_collider().is_in_group("Enemy"):
			ray.get_collider().hit(get_parent(), damage, knockback)
			print("BLAM!")
			print(ray.get_collider())
		cooldown = firerate
