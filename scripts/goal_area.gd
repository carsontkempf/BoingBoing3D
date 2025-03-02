extends Node2D

# --- Goal Area & Win Condition ---
@onready var goal_area: Area2D = $/GoalArea  # This must be an Area2D with a CollisionShape2D
@export var water_needed_to_win: int = 3
var current_water_count: int = 0

func _ready() -> void:
	# Connect the GoalArea's "body_entered" signal to our callback.
	if goal_area:
		goal_area.connect("body_entered", Callable(self, "_on_goal_area_body_entered"))
		print("DEBUG: GoalArea signal connected.")
	else:
		print("DEBUG: GoalArea not found!")

func _on_goal_area_body_entered(body: Node) -> void:
	# Only count bodies that are in the "water" group.
	if body.is_in_group("water"):
		current_water_count += 1
		print("DEBUG: Water droplet entered goal. Current count:", current_water_count)
		# Optionally remove the droplet so it doesn't get counted twice.
		body.queue_free()
		# Check if win condition is met.
		if current_water_count >= water_needed_to_win:
			game_win()

func game_win() -> void:
	print("You Win!")
	# Insert further win logic here, e.g., show a win UI or change scene.
