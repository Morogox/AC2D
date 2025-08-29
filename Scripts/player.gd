extends CharacterBody2D
var input_vector = Vector2.ZERO

# Movement speed in pixels per second
var speed = 1000
var acceleration = 3000  
var max_speed = 1500     
var friction = 8000     
var rotation_speed = 10

var qBoost_speed = 1000       # The speed added during boost
var qBoost_time = 0.15        # Duration of the boost in seconds
var qBoost_timer = 0.0        # Tracks remaining boost time
var qBoost_cd_time = 0.20     # Duration of boost cd in seconds
var qBoost_cd_timer = 0.0     # Tracks remaining boost cd time
var is_qBoosting = false
var qBoost_cd = false
var qBoost_direction = Vector2.ZERO
func _physics_process(delta):
	#Rotation
	var mouse_pos = get_global_mouse_position()
	var mouse_dir = (mouse_pos - global_position).normalized()
	var target_angle = mouse_dir.angle()
	rotation = lerp_angle(rotation, target_angle, rotation_speed * delta)
	
	#Movement
	input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()

	input_vector = input_vector.normalized()	
	if input_vector != Vector2.ZERO:
		velocity = velocity.move_toward(input_vector * max_speed, acceleration * delta)
	else:
		# Apply friction if no input
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	
	if is_qBoosting:
		velocity = (max_speed + qBoost_speed) * qBoost_direction
		qBoost_timer -= delta
		if qBoost_timer <= 0:
			is_qBoosting = false
			qBoost_cd = true
	if qBoost_cd:
		qBoost_cd_timer -= delta
		if qBoost_cd_timer <= 0:
			qBoost_cd = false
	move_and_slide() 

func _input(event):
	if event.is_action_pressed("ui_shift") and qBoost_cd == false:  # make sure "ui_shift" is mapped to Shift in InputMap
		is_qBoosting = true
		qBoost_cd_timer = qBoost_cd_time
		qBoost_timer = qBoost_time
		qBoost_direction = input_vector
		if input_vector != Vector2.ZERO:
			# Normal case: boost in movement direction
			qBoost_direction = input_vector.normalized()
		else:
			# Edge case: no movement input, boost toward cursor
			qBoost_direction = Vector2(cos(rotation), sin(rotation))
		
#Changes done within this function are visual only
#func _process(delta):
	#look_at(get_global_mouse_position())
	
