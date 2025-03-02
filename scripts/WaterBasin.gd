extends Area2D

@export var fluid_sprite: Node2D  # Drag your Sprite here in the Inspector.
var fluid_level: float = 0.0

func _ready() -> void:
	connect("body_entered", Callable(self, "_on_body_entered"))
	print("DEBUG: WaterBasin ready.")

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("water_droplet"):
		fluid_level += 1.0  # Increase fluid level (adjust per droplet)
		if fluid_sprite:
			fluid_sprite.scale.y = 1.0 + fluid_level * 0.05  # Visual update
		print("DEBUG: Droplet merged in basin. Fluid level:", fluid_level)
		body.queue_free()
