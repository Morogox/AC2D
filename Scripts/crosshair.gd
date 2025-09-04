extends Node2D
@export var player: CharacterBody2D
@export var free_sprite: Texture2D
@export var soft_lock_sprite: Texture2D
@export var full_lock_sprite: Texture2D
enum CrosshairState {
	FREE,       # Following the cursor normally
	SOFT_LOCK,  # Slowly lerping toward an enemy
	FULL_LOCK   # Snapped onto enemy
}

var state: CrosshairState = CrosshairState.FREE
var target_enemy: Node = null
var nearby = target_enemy

var cursor_pos = get_global_mouse_position()

@export var soft_lock_radius = 400.0  # in pixels
@export var soft_lock_speed = 10.0    # lerp factor
@export var full_lock_time = 0.1      # base time to switch to full lock
@export var free_radius = 1000.0      # pixels; how far mouse can go from target before releasing lock

var soft_lock_timer = 0.0

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN) # hide system cursor


func get_nearest_enemy(cursor_position: Vector2) -> Node:
	var enemies = get_tree().get_nodes_in_group("enemies")
	var closest: Node = null
	var min_dist = soft_lock_radius
	for e in enemies:
		var dist = e.global_position.distance_to(cursor_pos)
		#print(dist)
		if dist < min_dist:
			min_dist = dist
			closest = e
	return closest

#func is_enemy_on_screen(enemy: Node2D) -> bool:
	#var visibility_notifier = enemy.get_node("VisibleOnScreenNotifier2D")
	#if visibility_notifier:
		#return visibility_notifier.is_on_screen()
	#return false

func attempt_lock_on():
	nearby = get_nearest_enemy(cursor_pos)
	if nearby and nearby != target_enemy:
		state = CrosshairState.SOFT_LOCK
		target_enemy = nearby
		soft_lock_timer = 0.0


func _process(delta):
	#position = get_viewport().get_mouse_position()
	cursor_pos = get_global_mouse_position()
	
	match state:
		CrosshairState.FREE:
			# Normal cursor follow
			global_position = cursor_pos
			attempt_lock_on()
		CrosshairState.SOFT_LOCK:
			
			if not target_enemy or not is_instance_valid(target_enemy) or cursor_pos.distance_to(target_enemy.global_position) > free_radius:
				print("dislocated: " + str(cursor_pos.distance_to(target_enemy.global_position)))
				print(str(target_enemy))
				state = CrosshairState.FREE
				target_enemy = null
			else:
				# Lerp towards enemy
				global_position = global_position.lerp(target_enemy.global_position, soft_lock_speed * delta)
				# Increment timer scaled by enemy distance
				var dist = target_enemy.global_position.distance_to(player.global_position)
				var scaled_time = full_lock_time * (dist / soft_lock_radius)  # farther = longer
				soft_lock_timer += delta
				if soft_lock_timer >= scaled_time:
					state = CrosshairState.FULL_LOCK
					
		CrosshairState.FULL_LOCK:
			
			if not target_enemy or not is_instance_valid(target_enemy) or cursor_pos.distance_to(target_enemy.global_position) > free_radius:
				print("dislocated: " + str(cursor_pos.distance_to(target_enemy.global_position)))
				print(str(target_enemy))
				state = CrosshairState.FREE
				target_enemy = null
			else:
				global_position = target_enemy.global_position
				
				

	match state:
		CrosshairState.FREE:
			get_child(0).texture = free_sprite
			get_child(1).global_position = global_position
		CrosshairState.SOFT_LOCK:
			get_child(0).texture = soft_lock_sprite
			get_child(1).global_position = target_enemy.global_position
		CrosshairState.FULL_LOCK:
			get_child(0).texture = full_lock_sprite
			get_child(1).global_position = target_enemy.global_position

func _input(event):
	if event is InputEventMouseMotion:
		attempt_lock_on()
		
