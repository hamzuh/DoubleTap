class_name Weapon extends Node2D

@onready var loadout: Array = [load("res://Scripts/Weapons/Guns/Pistol.tres"), load("res://Scripts/Weapons/Guns/SMG.tres")]
@onready var currentWeapon = 0
@onready var weapon_type: WeaponStat = loadout[currentWeapon]
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
var triggerHeld: bool = false

func _ready() -> void:
	stats = weapon_type.duplicate()
	
	firerate = stats.firerate
	damage = stats.damage
	knockback = stats.knockback
	spread = stats.spread
	automatic = stats.automatic
	sprite.texture = stats.texture
	
	ray.target_position = Vector2(1000, 0)

func _physics_process(delta: float) -> void:
	if cooldown > 0:
		cooldown -= delta

func fire():
	if canFire():
		ray.target_position = Vector2(1000, 0).rotated(randf_range(-PI/2, PI/2) * spread)
		if ray.is_colliding():
			if ray.get_collider().is_in_group("Enemy"):
				ray.get_collider().hit(get_parent(), damage, knockback)
				print("BLAM!")
				print(ray.get_collider())
		cooldown = firerate
	if not triggerHeld:
		triggerHeld = true

func canFire():
	if automatic:
		return (cooldown <= 0)
	else:
		return ((not triggerHeld) and cooldown <= 0)
		
func releaseTrigger():
	if not automatic:
		triggerHeld = false

func swap():
	currentWeapon += 1
	if currentWeapon >= loadout.size():
		currentWeapon = 0
	weapon_type = loadout[currentWeapon]
	stats = weapon_type.duplicate()
	
	firerate = stats.firerate
	damage = stats.damage
	knockback = stats.knockback
	spread = stats.spread
	automatic = stats.automatic
	sprite.texture = stats.texture
