extends Sprite2D

@export var sensitivity: float = 20.0 

@onready var initial_position: Vector2 = global_position

func _process(delta: float) -> void:
	var viewport_size = get_viewport().get_visible_rect().size
	var mouse_pos = get_viewport().get_mouse_position()
	
	var center = viewport_size / 2.0
	var Newoffset = (mouse_pos - center) / center
	
	var target_pos = initial_position - (Newoffset * sensitivity)
	
	global_position = global_position.lerp(target_pos, delta * 10.0)
