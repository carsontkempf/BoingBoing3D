extends CharacterBody2D

var speed = 16

func _ready() -> void:
	if global_position.x < 80:
		set_velocity(Vector2(speed, 0))
	else:
		scale.x = -1
		set_velocity(Vector2(-speed, 0))
	
	collision_mask = 0

func _physics_process(delta: float) -> void:
	if Global.game_over:
		return
	
	var original_y = global_position.y
	move_and_slide()
	
	if get_velocity().x > 0:
		if global_position.x > 170:
			global_position.x = -11
	else:
		if global_position.x < -11:
			global_position.x = 170


func _on_area_2d_body_entered(body: Node2D) -> void:
	Global.game_over = true
