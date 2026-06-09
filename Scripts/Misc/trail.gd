extends Line2D

var pos_queue: Array
var max_length: int = 20
var paused: bool = false
var normal_width = 10

func _physics_process(delta: float) -> void:
	#width = normal_width * 0.8 * get_parent().sprite.scale[0]
	#max_length = normal_length * round(cos((2 * PI) / (4*get_parent().active_max) * get_parent().active))
	if not paused:
		var pos = get_parent().position
		
		pos_queue.push_front(pos)
		if pos_queue.size() > max_length:
			pos_queue.pop_back()
			
		clear_points()
		
		for point in pos_queue:
			add_point(point)
