extends CharacterBody2D
var input_vector = Vector2.ZERO
@export var cursor: Node2D
enum PlayerState { IDLE, MOVING, QBOOSTING }
var state = PlayerState.IDLE
# Movement speed in pixels per second
@export var speed = 1000
@export var acceleration = 3000
@export var max_speed = 1500     
@export var friction = 3000     
@export var rotation_speed = 10

@export var qBoost_speed = 1000       # The speed added during boost
@export var qBoost_time = 0.25        # Duration of the boost in seconds
var qBoost_timer = 0.0                # Tracks remaining boost time
@export var qBoost_cd_time = 0.20     # Duration of boost cd in seconds
var qBoost_cd_timer = 0.0             # Tracks remaining boost cd time
var is_qBoosting = false
var qBoost_cd = false
var qBoost_direction = Vector2.ZERO
func _physics_process(delta):
	#Rotation
	var cursor_pos = cursor.global_position
	var target_dir = (cursor_pos - global_position).normalized()
	var target_angle = target_dir.angle()
	rotation = lerp_angle(rotation, target_angle, rotation_speed * delta)
	
	#Movement
	input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()


	#if input_vector != Vector2.ZERO:
		#state = PlayerState.MOVING
		#velocity += input_vector * acceleration * delta
		#velocity = velocity.limit_length(max_speed)
	#else:
		#state = PlayerState.IDLE
		#velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
		
	if input_vector != Vector2.ZERO:
		state = PlayerState.MOVING
		var target_velocity = input_vector * max_speed
		var accel_step = acceleration * delta
		# Clamp to prevent overshooting
		accel_step = min(accel_step, target_velocity.distance_to(velocity))
		velocity = velocity.move_toward(target_velocity, accel_step)
	else:
		# Apply friction if no input
		state = PlayerState.IDLE
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	
	if is_qBoosting:
		state = PlayerState.QBOOSTING
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
		if input_vector != Vector2.ZERO:
			is_qBoosting = true
			qBoost_cd_timer = qBoost_cd_time
			qBoost_timer = qBoost_time
			qBoost_direction = input_vector
		
			# Normal case: boost in movement direction
			qBoost_direction = input_vector.normalized()
	
			# Call camera effect function here
			get_node("/root/Main/Camera2D").start_dodge_effect(qBoost_direction)
		
	
