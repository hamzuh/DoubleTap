extends Area2D

@onready var tracer: Line2D = $Tracer
@onready var flash: PointLight2D = $Flash
@onready var audioPlayer = $AudioStreamPlayer2D

var hitter: Node
var speed: float = 7
var direction: Vector2
var range: float = 10000
var tracerCooldown: float = 0
var active: float = 4
var shot = false

func _physics_process(delta: float) -> void:
	if active >= 0:
		position += direction * speed
		active -= delta
	else:
		queue_free()
	if tracerCooldown > 0:
		speed = 0
		tracerCooldown -= delta
		if tracerCooldown < 0.15:
			audioPlayer.stop()
	else:
		if shot:
			hitter.camera.shake(25, 0.3)
			shot = false
			audioPlayer.stream = load("res://Audio/Weapons/Coin/superhit.wav")
			audioPlayer.play()
		speed = 7
		tracer.visible = false
		flash.visible = false
	
func hit(killer, weapon, damage, knockback, instakill):
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
		tracerCooldown = 0.3
	audioPlayer.stream = load("res://Audio/Weapons/Coin/coinhit.wav")
	audioPlayer.play()
		
