extends Node2D

# --- Node References ---
@onready var goal_area: Area2D = $GoalArea  # Adjust this path if GoalArea is nested differently

# --- Win Condition Variables ---
@export var water_needed_to_win: int = 3
var current_water_count: int = 0

# --- Background Generation Variables ---
var tile_size: Vector2 = Vector2(32, 32)
var grid_offset: Vector2 = Vector2(21, 745)
var grid_area: Vector2 = Vector2(1000, 1000)
var metal_chance: float = 0.1

var dirt_scene = preload("res://scenes/dirt_sprite.tscn")
var metal_scene = preload("res://scenes/stone_sprite.tscn")
var rng: RandomNumberGenerator = RandomNumberGenerator.new()

# --- Background Generation Function ---
func generate_background() -> void:
	var viewport_size: Vector2 = get_viewport_rect().size
	var bottom_left: Vector2 = Vector2(grid_offset.x, viewport_size.y - grid_offset.y)
	print("Viewport size: ", viewport_size)
	print("Calculated bottom_left: ", bottom_left)
	
	var cols: float = ceil(grid_area.x / tile_size.x)
	var rows: float = ceil(grid_area.y / tile_size.y)
	print("Columns: ", cols, " Rows: ", rows)
	
	for i in range(int(cols)):
		for j in range(int(rows)):
			var tile_x: float = bottom_left.x + i * tile_size.x
			var tile_y: float = bottom_left.y - j * tile_size.y
			var tile
			if rng.randf() < metal_chance:
				tile = metal_scene.instantiate()
			else:
				tile = dirt_scene.instantiate()
				tile.add_to_group("dirt_tiles")
			tile.position = Vector2(tile_x, tile_y)
			add_child(tile)

# --- _ready() ---
func _ready() -> void:
	rng.seed = 123456789  # or use rng.randomize() for a different seed
	generate_background()
	
	# Connect the GoalArea's "body_entered" signal
	if goal_area:
		goal_area.connect("body_entered", Callable(self, "_on_goal_area_body_entered"))
		print("DEBUG: GoalArea signal connected.")
	else:
		print("DEBUG: GoalArea not found! Check your scene tree and node path.")

# --- Per-Frame Check (Optional) ---
func _physics_process(_delta: float) -> void:
	check_goal_condition()

# --- Signal Callback for GoalArea ---
func _on_goal_area_body_entered(body: Node) -> void:
	# Only count bodies that are in the "water" group.
	if body.is_in_group("water"):
		current_water_count += 1
		print("DEBUG: Water droplet entered goal. Current count:", current_water_count)
		body.queue_free()  # Remove the droplet so it isn't counted twice.
		if current_water_count >= water_needed_to_win:
			game_win()

# --- Optional Per-Frame Overlap Check ---
func check_goal_condition() -> void:
	if goal_area:
		var droplets = goal_area.get_overlapping_bodies()
		var count = 0
		for body in droplets:
			if body.is_in_group("water"):
				count += 1
		if count > 0:
			print("DEBUG: Overlapping water droplets count:", count)

# --- Win Function ---
func game_win() -> void:
	print("You Win!")
	# Insert further win logic here (e.g., display win UI, change scene, etc.)
