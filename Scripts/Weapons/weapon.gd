class_name Weapon extends Node2D

@onready var audioPlayer = $AudioStreamPlayer2D

@onready var loadout: Array = [load("res://Scripts/Weapons/Guns/Pistol.tres"), load("res://Scripts/Weapons/Guns/SMG.tres")]
@onready var currentWeapon = 0
@onready var weapon_type: WeaponStat = loadout[currentWeapon]
var stats: WeaponStat

@onready var sprite: Sprite2D = $Sprite2D
@onready var ray: RayCast2D = $RayCast2D

@onready var tracer: Line2D = $Line2D
@onready var muzzleFlash = $Muzzle
var tracerCooldown: float

var weaponName: String
var spread: float
var automatic: bool
var firerate: float
var reload_speed: float
var damage: float
var knockback: float
var cooldown: float = 0
var sfx: Array[AudioStream]
var drawSFX: AudioStream
var reloadSFX: AudioStream

var triggerHeld: bool = false

# Ammo tracking variables
var ammo_dict = {}
var max_ammo: int
var mag_size: int

func _ready() -> void:
	stats = weapon_type.duplicate()
	
	for weapon in loadout:
		ammo_dict[weapon.weaponName] = [weapon.mag_size, weapon.max_ammo - weapon.mag_size]
	
	weaponName = stats.weaponName
	firerate = stats.firerate
	damage = stats.damage
	knockback = stats.knockback
	spread = stats.spread
	automatic = stats.automatic
	sprite.texture = stats.texture
	sfx = stats.fireSFX
	drawSFX = stats.drawSFX
	reloadSFX = stats.reloadSFX
	
	max_ammo = stats.max_ammo
	mag_size = stats.mag_size
	
	tracer.visible = false
	muzzleFlash.visible = false
	
	ray.target_position = Vector2(1000, 0)
	get_parent().ammo_changed.emit(ammo_dict[weaponName][0], ammo_dict[weaponName][1])

func _physics_process(delta: float) -> void:
	if cooldown > 0:
		cooldown -= delta
	if tracerCooldown > 0:
		tracerCooldown -= delta
	else:
		tracer.visible = false
		muzzleFlash.visible = false

func fire():
	if canFire():
		ammo_dict[weaponName][0] -= 1
		get_parent().ammo_changed.emit(ammo_dict[weaponName][0], ammo_dict[weaponName][1])
		# Play shot effect
		# Probably randomise pitch a bit too
		
		audioPlayer.pitch_scale = 1 + randf_range(-0.2, 0.2)
		audioPlayer.stream = sfx.pick_random()
		audioPlayer.play()
		# Shake the camera
		# Maybe change this to take info from resource and increase intensity over time for automatics
		get_parent().camera.shake(8, 0.08)
		ray.target_position = Vector2(1000, 0).rotated(randf_range(-PI/2, PI/2) * spread)
		if ray.is_colliding():
			if ray.get_collider().is_in_group("Enemy"):
				ray.get_collider().hit(get_parent(), damage, knockback, get_parent().instakill)
			tracer.set_point_position(1, to_local(ray.get_collision_point()))
		else:
			tracer.set_point_position(1, ray.target_position)
		muzzleFlash.visible = true
		tracer.visible = true
		tracerCooldown = 0.02
		cooldown = firerate
	if not triggerHeld:
		triggerHeld = true

func canFire():
	if ammo_dict[weaponName][0] > 0:
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
	
	weaponName = stats.weaponName
	firerate = stats.firerate
	damage = stats.damage
	knockback = stats.knockback
	spread = stats.spread
	automatic = stats.automatic
	sprite.texture = stats.texture
	sfx = stats.fireSFX
	drawSFX = stats.drawSFX
	reloadSFX = stats.reloadSFX
	
	max_ammo = stats.max_ammo
	mag_size = stats.mag_size
	
	get_parent().ammo_changed.emit(ammo_dict[weaponName][0], ammo_dict[weaponName][1])
	
	audioPlayer.pitch_scale = 1
	audioPlayer.stream = drawSFX
	audioPlayer.play()

func reload():
	# If no ammo left in reserve or current mag is full...
	if ammo_dict[weaponName][1] == 0 or ammo_dict[weaponName][0] == mag_size:
		# No reloading
		return
	elif (ammo_dict[weaponName][0] + ammo_dict[weaponName][1]) <= mag_size:
		ammo_dict[weaponName][0] += ammo_dict[weaponName][1]
		ammo_dict[weaponName][1] = 0
	else:
		ammo_dict[weaponName][1] = ammo_dict[weaponName][1] + ammo_dict[weaponName][0] - mag_size
		ammo_dict[weaponName][0] = mag_size
	get_parent().ammo_changed.emit(ammo_dict[weaponName][0], ammo_dict[weaponName][1])
	
	audioPlayer.pitch_scale = 1
	audioPlayer.stream = reloadSFX
	audioPlayer.play()

func max_ammo_powerup():
	for weapon in loadout:
		ammo_dict[weapon.weaponName] = [weapon.mag_size, weapon.max_ammo - weapon.mag_size]
	get_parent().ammo_changed.emit(ammo_dict[weaponName][0], ammo_dict[weaponName][1])
