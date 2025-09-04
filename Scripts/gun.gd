extends Node2D
@export var rotation_speed = 20
@export var bullet_scene: PackedScene
@onready var crosshair = get_tree().root.get_node("Main/Crosshair") 
@onready var muzzle = $Muzzle   # Marker2D

@export var damage = 100
@export var bullet_speed = 2000

var target_angle = null
var cooldown := 0.5
var timer := 0.0
func _process(delta):
	timer = max(timer - delta, 0.0)
	
	if crosshair.target_enemy and crosshair.state == crosshair.CrosshairState.FULL_LOCK:
		target_angle = (crosshair.target_enemy.global_position - global_position).normalized().angle()
		var target_pos = crosshair.target_enemy.global_position
		var target_vel = crosshair.target_enemy.velocity  # Make sure your enemy has a velocity property
		var predicted_pos = predict_intercept(global_position, target_pos, target_vel, bullet_speed)
		var target_angle = (predicted_pos - global_position).angle()
		global_rotation = lerp_angle(global_rotation, target_angle, delta * rotation_speed)
	elif crosshair.target_enemy and crosshair.state == crosshair.CrosshairState.SOFT_LOCK:
		target_angle = (crosshair.global_position - global_position).normalized().angle()
		global_rotation = lerp_angle(global_rotation, target_angle, delta * rotation_speed)
	else:
		target_angle = (crosshair.global_position - global_position).angle()
		global_rotation = lerp_angle(global_rotation, target_angle, delta * rotation_speed)

func shoot():
	if timer > 0.0:
		return
	timer = cooldown
	var bullet = bullet_scene.instantiate()
	bullet.global_position = muzzle.global_position
	bullet.rotation = global_rotation
	bullet.damage = damage  # pass damage to bullet
	bullet.speed = bullet_speed  # pass damage to bullet
	get_tree().current_scene.add_child(bullet)

# Predict where to shoot to hit a moving target
func predict_intercept(shooter_pos: Vector2, target_pos: Vector2, target_vel: Vector2, projectile_speed: float) -> Vector2:
	var to_target = target_pos - shooter_pos
	var a = target_vel.length_squared() - projectile_speed * projectile_speed
	var b = 2 * to_target.dot(target_vel)
	var c = to_target.length_squared()
	
	var discriminant = b*b - 4*a*c
	
	if discriminant < 0 or abs(a) < 0.001:
		# No solution, just aim at current position
		return target_pos
	
	var t1 = (-b + sqrt(discriminant)) / (2*a)
	var t2 = (-b - sqrt(discriminant)) / (2*a)
	var t = min(t1, t2)
	if t < 0:
		t = max(t1, t2)
	if t < 0:
		return target_pos  # target is moving away too fast
	
	return target_pos + target_vel * t
