extends Camera2D

@export var player: Node2D
@export var smooth_speed: float = 5.0
@export var peek_intensity: float = 100.0 # How many pixels the camera can shift near edges

# Define your map boundaries (In pixels)
@export var map_left: float = 0
@export var map_top: float = 0
@export var map_right: float = 1920
@export var map_bottom: float = 1080

var screen_size: Vector2
var base_center: Vector2

func _ready() -> void:
	screen_size = get_viewport_rect().size
	# Center the camera on the map initially
	base_center = Vector2((map_left + map_right) / 2, (map_top + map_bottom) / 2)
	global_position = base_center

func _process(delta: float) -> void:
	if not player:
		return

	# 1. Find how far the player is from the center of the screen/map
	var player_offset = player.global_position - base_center
	
	# 2. Normalize that distance to calculate a slight camera "peek"
	var target_peek = player_offset.normalized() * peek_intensity
	
	# 3. Combine base position with the edge-peek shift
	var target_position = base_center + target_peek
	
	# 4. STRICTLY CLAMP to ensure the camera viewport never leaves the map boundaries
	var half_screen = screen_size / 2
	target_position.x = clamp(target_position.x, map_left + half_screen.x, map_right - half_screen.x)
	target_position.y = clamp(target_position.y, map_top + half_screen.y, map_bottom - half_screen.y)
	
	# 5. Smoothly glide to the position
	global_position = global_position.lerp(target_position, smooth_speed * delta)
