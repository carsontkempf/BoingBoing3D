extends CharacterBody2D

var tile_size = 8

var inputs = {
	"ui_right": Vector2.RIGHT,
	"ui_left": Vector2.LEFT,
	"ui_up": Vector2.UP,
	"ui_down": Vector2.DOWN
}

var is_moving = false
var vertical_offset = 2

var active_log_count = 0
var current_log_velocity

func _process(delta: float) -> void:
	if global_position.x < 0 or global_position.x > 160:
		Global.game_over = true
	if Global.game_over:
		pass
	else:
		$idleFaceAway.play("idle")

func _unhandled_input(event):
	if is_moving or Global.game_over:
		return
		
	for dir in inputs.keys():
		if event.is_action_pressed(dir):
			move(inputs[dir])
			break

var grid_width = 20  # Number of 8px tiles horizontally
var grid_height = 26  # Number of 8px tiles vertically

func can_move_to(target_position):
	return target_position.x != -76 && target_position.x != 76 && target_position.y != -97 && target_position.y != 111

func move(direction):
	var target_position = position + direction * tile_size
	
	if !can_move_to(target_position):
		return
	
	is_moving = true
	
	var tween = create_tween()
	
	tween.tween_property(self, "scale", Vector2(0.525, 0.50), 0.02)
	
	tween.tween_property(self, "scale", Vector2(0.525, 0.58), 0.03)
	
	tween.parallel().tween_property(self, "position", target_position, 0.05)
	
	var jump_height = 2
	var original_y = position.y
	tween.parallel().tween_property(self, "position:y", original_y - jump_height, 0.025)
	tween.parallel().tween_property(self, "position:y", target_position.y, 0.025).set_delay(0.025)
	
	tween.tween_property(self, "scale", Vector2(.525, .548), 0.02).set_delay(0.03)
	
	await tween.finished
	
	is_moving = false
	
	check_drowning()

func _physics_process(delta: float) -> void:
	if active_log_count > 0:
		velocity = current_log_velocity
		move_and_slide()
	else:
		velocity = Vector2(0, 0)

func check_drowning():
	if global_position.y <= -17 and global_position.y >= -73 and !is_moving and active_log_count == 0:
		Global.game_over = true

func _on_ending_area_body_entered(body: Node2D) -> void:
	Global.game_won = true
	Global.game_over = true
