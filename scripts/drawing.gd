extends Node2D

func _ready() -> void:
	update()

func _draw() -> void:
	draw_line(Vector2.ZERO, Vector2.RIGHT * 300, Color.CHOCOLATE, 8.0)
	draw_primitive()
	
