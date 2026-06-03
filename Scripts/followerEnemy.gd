extends CharacterBody2D

@onready var Player = get_parent().get_Player()
@onready var Level = get_parent().get_Level()
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@onready var sprite = $Sprite2D
@onready var occluder = $LightOccluder2D
@onready var navtimer = $Timer

# Base stats
var speed: int = 100
#var speed: float = randf_range(97, 100)
var health: int = 100
var variation: Vector2 = Vector2(randf_range(0, 100), 0).rotated(randf_range(0, 2*PI))

# Knockback variables
var knock: bool = false
var knockforce: float
var knockdirect: Vector2

# Signals
signal enemy_dead()

func hit(killer, damage, knockback):
	health -= damage
	print(health)
	killer.increase_points(10)
	if health <= 0:
		die(killer)
	if knockback:
		knockdirect = killer.position.direction_to(self.position)
		knockforce = knockback
		knock = true

func die(killer):
	killer.increase_points(50)
	enemy_dead.emit()
	# print("I died!")
	# Add blood spurting effect
	# Play death noise
	queue_free()
	
###

func _ready() -> void:
	navigation_agent.velocity_computed.connect(Callable(_on_velocity_computed))
	set_movement_target(Player.position + variation)

func set_movement_target(movement_target: Vector2):
	navigation_agent.set_target_position(movement_target)

func _physics_process(delta):
	if knock:
		velocity = knockdirect * knockforce
		move_and_slide()
		knockforce -= 1000 * delta
		if knockforce <= 0:
			knock = false
		return
	#sprite.rotation = velocity.angle()
	sprite.rotation = lerp_angle(sprite.rotation, velocity.angle(), 0.08)
	occluder.rotation = sprite.rotation
	
	if position.distance_to(Player.position) >= 1000:
		navtimer.wait_time = 0.5
	elif position.distance_to(Player.position) >= 500:
		navtimer.wait_time = 0.25
	elif position.distance_to(Player.position) >= 150:
		navtimer.wait_time = 0.15
	# If the enemy is closer than 200 units to the player...
	else:
		# Shoot a ray from the enemy to the player...
		var space_state = get_world_2d().direct_space_state
		var query = PhysicsRayQueryParameters2D.create(global_position, Player.position)
		query.exclude = [self, Player]
		var result = space_state.intersect_ray(query)
		# If the ray detects no wall in the way...
		if !(result.get("collider") == Level):
			# Move straight towards the player
			velocity = position.direction_to(Player.position) * speed
			move_and_slide()
			return
	# If the enemy is super close / in swiping range they should attempt an attack
	
	# Do not query when the map has never synchronized and is empty.
	if NavigationServer2D.map_get_iteration_id(navigation_agent.get_navigation_map()) == 0:
		return
	if navigation_agent.is_navigation_finished():
		return

	var next_path_position: Vector2 = navigation_agent.get_next_path_position()
	var new_velocity: Vector2 = global_position.direction_to(next_path_position) * speed
	if navigation_agent.avoidance_enabled:
		navigation_agent.set_velocity(new_velocity)
	else:
		_on_velocity_computed(new_velocity)

func _on_velocity_computed(safe_velocity: Vector2):
	velocity = safe_velocity
	move_and_slide()
	
func _on_timer_timeout() -> void:
	set_movement_target(Player.position + variation)
