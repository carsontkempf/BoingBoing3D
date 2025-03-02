extends Area2D

func _ready() -> void:
	connect("body_entered", Callable(self, "_on_body_entered"))
	add_to_group("water_droplet")
	print("DEBUG: WaterCollisionSensor ready and added to group 'water_droplet'.")

func _on_body_entered(body: Node) -> void:
	print("Body entered:", body.name)
	queue_free()
