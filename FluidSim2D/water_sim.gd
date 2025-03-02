extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_goal_area_body_entered(body: Node2D) -> void:
	if body != Sprite2D:
		Globals.particles_in_goal += 1
	pass # Replace with function body.




func _on_goal_area_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:

	if body_shape_index == 0:
		Globals.particles_in_goal += 1
	
	pass # Replace with function body.


func _on_goal_area_body_shape_exited(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body_shape_index == 0:
		Globals.particles_in_goal -= 1
		
	pass # Replace with function body.
