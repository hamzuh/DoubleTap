extends CharacterBody2D

#Stat Variables
var health = 100.0
var money = 0
var points = 0

# Movement Variables
@export var speed = 300.0
var rs_deadzone = 0.5
var stickrot = Vector2()
var shotrot = Vector2(1, 0)
var direction = Vector2()

# Shooting Variables
@onready var weapon = $Weapon
#var bulletload = preload("res://Entities/bullet.tscn")

# Buying Variables
var buyDoor: bool = false
var doorNum: int = 0
var cost: int = 0

# Switch Variable
var powerSwitch: bool = false

# Signals
signal money_changed()
signal ammo_changed(current_ammo, reserve_ammo)
signal buy_door(doorNum)
signal powerOn()

# State Machines Variables
@onready var state_machine: Node = $"State Machine"
@onready var movement_animation: Node = $PlayerAnimations

func _ready() -> void:
	state_machine.init(self, movement_animation)

func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)
	
func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)
	rs_look()
	if Input.is_action_pressed("shootaction"):
		speed = 200
		weapon.fire()
	
func _process(delta):
	state_machine.process_frame(delta)

func rs_look():
	stickrot.y = Input.get_joy_axis(0, JOY_AXIS_RIGHT_Y)
	stickrot.x = Input.get_joy_axis(0, JOY_AXIS_RIGHT_X)
	if stickrot.length() >= rs_deadzone:
		shotrot = stickrot.normalized()
		rotation = stickrot.angle()	

#func shoot():
	#var bullet = bulletload.instantiate()
	#bullet.position = self.position
	#bullet.speed = bulletspeed
	#bullet.direction = shotrot
	#bullet.shooter = self
	#owner.add_child(bullet)

func increase_points(inc_points):
	points += inc_points
	money += inc_points
	emit_signal("money_changed", money)
	
func spend_money(expense):
	money -= expense
	money_changed.emit(money)

func _on_level_doorbuymessage(openOrClose: Variant, door: Variant, price) -> void:
	if openOrClose:
		buyDoor = true
		doorNum = door
		cost = price
	else:
		buyDoor = false
		doorNum = 0
		
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("Light Attack"):
		if buyDoor and (money >= cost):
			buy_door.emit(doorNum)
			spend_money(cost)
		if powerSwitch:
			powerOn.emit()
			$AuraLight.visible = false
			$Flashlight.visible = false
	if Input.is_action_just_released("shootaction"):
		weapon.releaseTrigger()
		speed = 300
	if Input.is_action_just_pressed("Swap Weapon"):
		weapon.swap()
	if Input.is_action_just_pressed("Reload"):
		weapon.reload()

func _on_level_powermessage(openOrClose: Variant) -> void:
	if openOrClose:
		powerSwitch = true
	else:
		powerSwitch = false
