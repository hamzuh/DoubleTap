extends Area2D

var speed
var direction
var shooter
var rotatespeed = 30

# Variables for boomerang shuriken
#var accel = 900
#var returning = false

func _ready():
	print("pew")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	# Code for boomerang shuriken
	#speed -= accel * delta
	#if speed <= 0 and not returning:
		#print("returning")
		#returning = true
		
	self.position += speed * direction * delta
	$Sprite2D.rotation += rotatespeed * delta

func _on_body_entered(body):
	if body.is_in_group("World"):
		queue_free()
	if body.is_in_group("Enemy"):
		body.hit(shooter)
		queue_free()
