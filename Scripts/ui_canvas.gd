extends CanvasLayer
var prev_velocity = Vector2.ZERO
var player_node: CharacterBody2D
func _process(delta):
	# Get player velocity
	player_node = get_parent().get_node("Player")
	var vel = player_node.velocity
	var speed = vel.length()
	 
	# Approximate acceleration
	var accel = (vel - prev_velocity).length() / delta
	prev_velocity = vel
		
	# Get FPS
	var fps = Engine.get_frames_per_second()
	
	# Convert player state enum to string
	var state_names = ["IDLE", "MOVING", "QBOOSTING"]
	var state_str = state_names[player_node.state]
	
	# Update Label text
	$Label.text = "Velocity: " + str(round(speed)) + "
	" + "Acceleration: " + str(round(accel)) + "
	" +"FPS: " + str(round(fps)) + "
	" +"Player State: " + state_str
