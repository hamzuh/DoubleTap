class_name Powerup extends Area2D

@onready var powerup_choices: Array[PowerupStat] = [load("res://Scripts/Powerups/doublepoints.tres"), load("res://Scripts/Powerups/firesale.tres"), load("res://Scripts/Powerups/instakill.tres"), load("res://Scripts/Powerups/maxammo.tres"), load("res://Scripts/Powerups/nuke.tres")]
@onready var powerup_type: PowerupStat

@onready var powerup_name: String
@onready var sprite: Sprite2D = $Sprite2D
# Placeholder FX
@onready var lighting: PointLight2D = $PointLight2D
var lightval: float

signal picked_up(powerup_name, picker)

func _ready() -> void:
	if powerup_type == null:
		powerup_type = powerup_choices.pick_random()
		
	powerup_name = powerup_type.powerup_name
	sprite.texture = powerup_type.icon

func _physics_process(delta: float) -> void:
	# Make light effect bigger and smaller
	lightval += delta * 2
	if lightval >= PI:
		lightval = 0
	lighting.texture_scale = 0.4 + (sin(lightval) * 0.3)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		picked_up.emit(powerup_name, body)
		# Play pickup animation / FX
		queue_free()
