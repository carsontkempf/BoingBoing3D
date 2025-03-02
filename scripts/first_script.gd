extends CharacterBody2D

var speed = 150

func _physics_process(_delta):
	var input_dir = Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	)

	velocity = input_dir.normalized() * speed  # Assign velocity
	move_and_slide()  # Now works correctly
