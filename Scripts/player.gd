extends CharacterBody2D
# Movement speed in pixels per second
var speed = 1000

func _physics_process(delta):
	var input_vector = Vector2.ZERO

	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()

	input_vector = input_vector.normalized() * speed
	velocity = input_vector
	move_and_slide() 

#Changes done within this function are visual only
func _process(delta):
	look_at(get_global_mouse_position())
	
func _ready():
	# Get the current window size dynamically
	var screen_size = get_viewport_rect().size
	# Place player in the center
	position = screen_size / 2
