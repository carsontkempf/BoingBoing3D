extends Node2D

var _click_positions: Array[Vector2] = []  # Stores drawn points
var _is_drawing: bool = false  # Track if the mouse is held

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			_is_drawing = true  # Start drawing
		elif not event.pressed:
			_is_drawing = false  # Stop drawing when released

func _process(_delta: float) -> void:
	if _is_drawing:
		var mouse_pos = get_global_mouse_position()
		_click_positions.append(mouse_pos)  # Add current mouse position
		queue_redraw()  # Update drawing every frame

func _draw() -> void:
	for pos in _click_positions:
		draw_circle(pos, 5, Color.RED)  # Draw circles while dragging
