extends CharacterBody2D

var speed = 14
var vel

func _ready() -> void:
	if global_position.x < 80:
		vel = Vector2(speed, 0)
		velocity = vel
	else:
		scale.x = -1
		vel = Vector2(-speed, 0)
		velocity = vel
	
	collision_mask = 0

func _physics_process(delta: float) -> void:
	if Global.game_over:
		return
	
	var original_y = global_position.y
	
	move_and_slide()
	
	global_position.y = original_y
	
	if velocity.x > 0:
		if global_position.x > 184:
			global_position.x = -22
	else:
		if global_position.x < -22:
			global_position.x = 184
	
	if velocity.x > 0:
		vel.x = speed
		velocity.x = vel.x
	else:
		vel.x = -speed
		velocity.x = vel.x

func _on_area_2d_body_entered(body: Node2D) -> void:
	body.active_log_count += 1
	body.current_log_velocity = vel

func _on_area_2d_body_exited(body: Node2D) -> void:
	body.active_log_count -= 1
