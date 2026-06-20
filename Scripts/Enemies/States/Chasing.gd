extends State

@export var idle_state: State
@export var swiping_state: State

@onready var navigation_agent = $"../../NavigationAgent2D"
@onready var variation: Vector2 = Vector2(randf_range(0, 22), 0).rotated(randf_range(0, 2*PI))

@onready var legAnim = $"../../Legs"

func _ready() -> void:
	navigation_agent.velocity_computed.connect(Callable(_on_velocity_computed))
	
func enter() -> void:
	super()
	set_movement_target(parent.Player.position + variation)
	legAnim.play("walk")
	
func set_movement_target(movement_target: Vector2):
	navigation_agent.set_target_position(movement_target)

func process_physics(delta: float) -> State:
	#if knock:
		#velocity = knockdirect * knockforce * Globals.speed_scale
		#move_and_slide()
		#knockforce -= 1000 * delta * Globals.speed_scale
		#if knockforce <= 0:
			#knock = false
		#return
	##sprite.rotation = velocity.angle()
	#if dead:
		#return
	if Globals.speed_scale:
		legAnim.rotation = parent.velocity.angle() - parent.rotation
		parent.rotation = lerp_angle(parent.rotation, parent.velocity.angle(), 0.08)
		#parent.sprite.rotation = lerp_angle(parent.sprite.rotation, parent.velocity.angle(), 0.08)
		#parent.occluder.rotation = parent.sprite.rotation
	legAnim.speed_scale = (0.1 + (0.9 * (parent.speed / parent.velocity.length()))) * Globals.speed_scale
	
	# Could probably just change this into a match
	if parent.position.distance_to(parent.Player.position) >= 1000:
		parent.navtimer.wait_time = 0.5
	elif parent.position.distance_to(parent.Player.position) >= 500:
		parent.navtimer.wait_time = 0.25
	elif parent.position.distance_to(parent.Player.position) >= 150:
		parent.navtimer.wait_time = 0.15
	# If the enemy is closer than 200 units to the player...
	elif parent.position.distance_to(parent.Player.position) >= 100:
		# Shoot a ray from the enemy to the player...
		var space_state = parent.get_world_2d().direct_space_state
		var query = PhysicsRayQueryParameters2D.create(parent.global_position, parent.Player.position)
		# Might be self instead of parent
		query.exclude = [parent, parent.Player]
		var result = space_state.intersect_ray(query)
		# If the ray detects no wall in the way...
		if !(result.get("collider") == parent.Level):
			# Move straight towards the player
			parent.velocity = parent.position.direction_to(parent.Player.position) * parent.speed * Globals.speed_scale
			parent.move_and_slide()
			return
	# If the enemy is super close / in swiping range they should attempt an attack
	else:
		return idle_state
	# Do not query when the map has never synchronized and is empty.
	if NavigationServer2D.map_get_iteration_id(navigation_agent.get_navigation_map()) == 0:
		return
	if navigation_agent.is_navigation_finished():
		return

	var next_path_position: Vector2 = navigation_agent.get_next_path_position()
	var new_velocity: Vector2 = parent.global_position.direction_to(next_path_position) * parent.speed * Globals.speed_scale
	if navigation_agent.avoidance_enabled:
		navigation_agent.set_velocity(new_velocity)
	else:
		_on_velocity_computed(new_velocity)
		
	return null

func _on_velocity_computed(safe_velocity: Vector2):
	parent.velocity = safe_velocity
	parent.move_and_slide()
	
# Remove other timeout signal from main script
func _on_timer_timeout() -> void:
	set_movement_target(parent.Player.position + variation)

func exit() -> void:
	legAnim.speed_scale = 1 * Globals.speed_scale
	legAnim.stop()
	super()
