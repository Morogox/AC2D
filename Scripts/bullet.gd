extends Area2D

@export var lifetime: float = 2.0   # seconds before auto-destroy

var life_timer := 0.0
var damage: int = 0          # placeholder, will be set by gun
var speed: float = 2000.0    # placeholder, will be set by gun
func _process(delta):
	# Move forward in the bullet's rotation direction
	position += Vector2.RIGHT.rotated(rotation) * speed * delta
	
	# Auto-destroy after lifetime
	life_timer += delta
	if life_timer >= lifetime:
		queue_free()
	
	# Detect collision
func _on_Bullet_body_entered(body):
	if body.is_in_group("enemies"):
		# Handle hit logic (damage, effects, etc.)
		queue_free()
