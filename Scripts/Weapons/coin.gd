extends Area2D

@onready var tracer: Line2D = $Tracer
@onready var flash: PointLight2D = $Flash
@onready var audioPlayer = $AudioStreamPlayer2D
@onready var sprite = $AnimatedSprite2D
@onready var particles = $GPUParticles2D
@onready var trail = $Trail
@onready var whistle = $Whistle

var hitter: Node
var speed: float = 6
var direction: Vector2
var range: float = 10000
var tracerCooldown: float = 0
var active: float = 0
var active_max: float = 2.5
var shot = false
var hitted: bool = false
var traversed: bool = false

func _ready() -> void:
	Globals.hitstop.connect(_on_hitstop)
	sprite.rotation = direction.angle()
	audioPlayer.stream = load("res://Audio/Weapons/Coin/Coinflip.ogg")
	audioPlayer.play()
	whistle.play()

func _physics_process(delta: float) -> void:
	whistle.pitch_scale += delta * 0.1
	var new_scale = 1.5 * (2 * sin((2 * PI) / (2*active_max) * active))
	sprite.scale = Vector2(new_scale, new_scale)
	sprite.speed_scale = (3-(2.7*sin((2 * PI) / (2*active_max) * active))) * Globals.speed_scale
	speed = 7 - (6*sin((2 * PI) / (2*active_max) * active))
	if active <= active_max:
		position += direction * speed * Globals.speed_scale
		active += delta * Globals.speed_scale
	else:
		if not audioPlayer.playing and not particles.emitting:
			queue_free()
	if tracerCooldown >= 0:
		tracerCooldown -= delta
		if tracerCooldown < 0.2:
			# Probably a better way to do this
			if audioPlayer.stream == load("res://Audio/Weapons/Coin/coinhit.wav"):
				audioPlayer.stop()
	else:
		if shot:
			#hitter.camera.shake(25, 0.3)
			shot = false
			sprite.visible = false
			trail.visible = false
			$CollisionShape2D.disabled = true
			#speed = 0
			audioPlayer.stream = load("res://Audio/Weapons/Coin/superhit.wav")
			audioPlayer.play()
			particles.emitting = true
		tracer.visible = false
		flash.visible = false
	
func hit(killer, weapon, damage, knockback, instakill):
	traversed = true
	whistle.stop()
	if not hitted:
		# Doesn't work need to flip hitted earlier
		# Syntax for filter is right though
		var next_coin = get_tree().get_nodes_in_group("Coin").filter(func(check_coin): return not check_coin.traversed).pick_random()
		if next_coin:
			next_coin.hit(killer, weapon, damage, knockback, true)
			tracer.set_point_position(1, to_local(next_coin.position))
			tracer.visible = true
			flash.visible = true
			shot = true
			tracerCooldown = 0.35
			Globals.hitstop_activate(0.35, 0, true, 10, 0.3)
			hitted = true
			return
		# Called when bullet hits this
		# Kertwang into nearest enemy
		# Also remember to shoot a ray to the enemy to see if it's valid
		var nearest_enemy_distance = range
		var nearest_enemy
		for enemy in get_tree().get_nodes_in_group("Enemy"):
			if position.distance_to(enemy.position) <= nearest_enemy_distance:
				nearest_enemy = enemy
				nearest_enemy_distance = position.distance_to(enemy.position)
		if nearest_enemy:
			nearest_enemy.hit(killer, damage, knockback, true)
			tracer.set_point_position(1, to_local(nearest_enemy.position))
			tracer.visible = true
			flash.visible = true
			shot = true
			tracerCooldown = 0.35
			Globals.hitstop_activate(0.35, 0, true, 10, 0.3)
			hitted = true
		audioPlayer.stream = load("res://Audio/Weapons/Coin/coinhit.wav")
		audioPlayer.play()
		
func _on_hitstop(start, timescale, camera_shake, intensity, time):
	#sprite.speed_scale = timescale
	# Maybe don't need this?
	if start:
		trail.paused = true
	else: trail.paused = false
