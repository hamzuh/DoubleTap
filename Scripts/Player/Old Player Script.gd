extends CharacterBody2D

#Stat Variables
var health = 100.0
var money = 0
var points = 0

# Movement Variables
var speed = 300.0
var rs_deadzone = 0.5
var stickrot = Vector2()
var shotrot = Vector2(1, 0)
var direction = Vector2()

# Shooting Variables
var firerate = 0.096
var timer = 0

# Signals
signal money_changed

func _process(delta):
	# Semi auto
	#if Input.is_action_just_pressed("shootaction"):
		#shoot()
		
	if Input.is_action_pressed("shootaction"):
		timer -= delta
		if timer <= 0:
			timer = firerate
			shoot()
	else:
		timer = 0

func _physics_process(delta):

	direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if direction:
		$legsanimated.play()
	else:
		$legsanimated.stop()
	# ACCELERATION CODE
	# "acceleration * delta"
	# Acceleration is 300 in this example, I would increase.
	# I'm not sure this is a good addition, just fun to play around with
	#if direction != Vector2.ZERO:
		#velocity = velocity.move_toward(direction * 300, 1200 * delta)
	#else:
		#velocity = velocity.move_toward(Vector2.ZERO, 900 * delta)
	
	# Bog standard movement
	velocity = direction * speed
	#print(velocity)
	#else:
	#	velocity = move_toward(velocity, 0, speed)

	move_and_slide()
	
	rs_look()
	
func rs_look():
	stickrot.y = Input.get_joy_axis(0, JOY_AXIS_RIGHT_Y)
	stickrot.x = Input.get_joy_axis(0, JOY_AXIS_RIGHT_X)
	if stickrot.length() >= rs_deadzone:
		shotrot = stickrot.normalized()
		rotation = stickrot.angle()	

var bulletload = preload("res://Entities/bullet.tscn")
var bulletspeed = 500.0

func shoot():
	var bullet = bulletload.instantiate()
	bullet.position = self.position
	bullet.speed = bulletspeed
	bullet.direction = shotrot
	bullet.shooter = self
	owner.add_child(bullet)

func increase_points(inc_points):
	points += inc_points
	money += inc_points
	emit_signal("money_changed", money)
