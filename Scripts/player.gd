extends CharacterBody2D
# Movement speed in pixels per second
var speed = 1000
var acceleration = 5000  
var max_speed = 1500     
var friction = 8000      
func _physics_process(delta):
	var input_vector = Vector2.ZERO

	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()

	input_vector = input_vector.normalized()	
	if input_vector != Vector2.ZERO:
		velocity = velocity.move_toward(input_vector * max_speed, acceleration * delta)
	else:
		# Apply friction if no input
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	move_and_slide() 

#Changes done within this function are visual only
func _process(delta):
	look_at(get_global_mouse_position())
	
