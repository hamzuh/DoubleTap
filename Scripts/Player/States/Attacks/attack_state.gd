class_name attack_State extends State

@export var wooshSFX: AudioStream

func enter() -> void:
	super()
	parent.melee_audio.stream = wooshSFX
	parent.melee_audio.play()
