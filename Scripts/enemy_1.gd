extends CharacterBody2D
var direction = 1  
var speed = 1000  # pixels per second
@export var on = true
func _ready():
	add_to_group("enemies")

func _process(delta):
	if on:
		# Update position
		global_position.x += speed * delta * direction
	
		# Update velocity vector
		velocity = Vector2(speed * direction, 0)
	
		# Reverse direction at limits
		if global_position.x > 3000:
			direction = -1
		elif global_position.x < -3000:
			direction = 1
	
