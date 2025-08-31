extends Camera2D
@export var player: CharacterBody2D
var base_camera_spd = 15.0
var world_min = Vector2(-5120, -5120)
var world_max = Vector2(5120, 5120)

var camera_max_speed = 1500  

func _process(delta):
	var player_pos = player.global_position 
	var player_speed = player.velocity.length()
	var mouse_pos = get_global_mouse_position()
	
	# 30% toward cursor 
	var offset = (mouse_pos - player_pos) * 0.3
	var target_pos = player_pos + offset
	#var speed_factor = clamp(player_speed / 500.0, 1.0, 3.0)  # tweak 200 and max factor as needed
	var adjusted_camera_spd = base_camera_spd #* speed_factor
	
	# Smoothly move camera toward target 
	global_position = global_position.lerp(target_pos, adjusted_camera_spd * delta)
	
	var screen_size = get_viewport_rect().size
	var half_screen = screen_size / 2
	
	# Clamp camera to stay within world bounds
	global_position.x = clamp(global_position.x, world_min.x + half_screen.x, world_max.x - half_screen.x)
	global_position.y = clamp(global_position.y, world_min.y + half_screen.y, world_max.y - half_screen.y)
