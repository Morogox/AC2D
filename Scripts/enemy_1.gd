extends CharacterBody2D
var direction = 1  # 1 = down, -1 = up
func _ready():
	# Placeholder setup
	print("Enemy spawned at ", global_position)
	add_to_group("enemies")


func _process(delta):
	global_position.x += 1000 * delta * direction  
	# reverse when reaching limits
	if global_position.x > 3000:
		direction = -1
	elif global_position.x < 1000:
		direction = 1
	pass
	
