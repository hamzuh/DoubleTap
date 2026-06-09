extends Camera2D

@onready var noise = FastNoiseLite.new()
var shake_intensity: float
var active_shake_time: float

var shake_decay: float = 5

var shake_time: float
var shake_time_speed: float = 20

func _ready() -> void:
	randomize()
	noise.seed = randi()
	noise.frequency = 2

func _physics_process(delta: float) -> void:
	if active_shake_time > 0:
		shake_time += delta * shake_time_speed
		active_shake_time -= delta
		
		offset = Vector2(
			noise.get_noise_2d(shake_time, 0) * shake_intensity,
			noise.get_noise_2d(0, shake_time) * shake_intensity
		)
		
		shake_intensity = max(shake_intensity - shake_decay * delta, 0)
		
	else:
		offset = lerp(offset, Vector2.ZERO, 10.5 * delta)

func shake(intensity, time):
	shake_intensity = intensity
	active_shake_time = time
	shake_time = 0
