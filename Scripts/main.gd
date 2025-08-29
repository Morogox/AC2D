extends Node2D
var camera_spd = 5.0

func _ready():
	Engine.max_fps = 60

func _process(delta):
	var player_pos = $Player.global_position
	var mouse_pos = get_global_mouse_position()
	
	var offset = (mouse_pos - player_pos) * 0.3  # 30% toward cursor
	var target_pos = player_pos + offset
	
	# Smoothly move camera toward target
	$Camera2D.global_position = $Camera2D.global_position.lerp(target_pos, camera_spd * delta)
