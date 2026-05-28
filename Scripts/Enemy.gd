extends CharacterBody2D

@onready var Player = get_parent().get_Player()
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D

# Base stats
var speed: int = 80
var health: int = 100

# Knockback variables
var knock: bool = false
var knockforce: float
var knockdirect: Vector2

func _physics_process(delta):
	if knock:
		velocity = knockdirect * knockforce
		move_and_slide()
		knockforce -= 1000 * delta
		if knockforce <= 0:
			knock = false
		return
	look_at(Player.position)
	velocity = transform.x * speed
	move_and_slide()

func hit(killer, damage, knockback):
	health -= damage
	print(health)
	killer.increase_points(50)
	if health <= 0:
		die(killer)
	if knockback:
		knockdirect = killer.position.direction_to(self.position)
		knockforce = knockback
		knock = true

func die(killer):
	killer.increase_points(100)
	# print("I died!")
	# Add blood spurting effect
	# Play death noise
	queue_free()
