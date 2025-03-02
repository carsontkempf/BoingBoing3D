@tool
extends StaticBody2D

@onready var col = $CollisionPolygon2D


func _draw():
	draw_colored_polygon(col.polygon,Color.BLACK)
