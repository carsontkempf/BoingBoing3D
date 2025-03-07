extends Node2D

@onready var goal_area: Area2D = $GoalArea       # Ensure this node exists and is an Area2D with a CollisionShape2D.
# --- Win Condition ---
@export var water_needed_to_win: int = 3
var current_water_count: int = 0

# --- Drawing (Deletion) Code ---
var _is_drawing: bool = false  # Tracks if the mouse is held

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		_is_drawing = (event.pressed and event.button_index == MOUSE_BUTTON_LEFT)

func _process(_delta: float) -> void:
	if _is_drawing:
		check_and_delete_dirt(get_global_mouse_position())

func check_and_delete_dirt(mouse_pos: Vector2) -> void:
	var draw_radius = 20.0  # Adjust as needed
	for tile in get_tree().get_nodes_in_group("dirt_tiles"):
		if tile.position.distance_to(mouse_pos) <= draw_radius:
			tile.queue_free()

# --- Background Generation Code ---
var tile_size = Vector2(32, 32)           # Tile dimensions
var grid_offset = Vector2(21, 745)          # Offset from left and bottom of screen
var grid_area = Vector2(1000, 1000)         # Area to cover with the grid
var metal_chance = 0.1                      # Chance for a metal tile

var dirt_scene = preload("res://scenes/WhereDaWater/dirt_sprite.tscn")
var metal_scene = preload("res://scenes/WhereDaWater/stone_sprite.tscn")
var rng: RandomNumberGenerator = RandomNumberGenerator.new()

func generate_background() -> void:
	var viewport_size = get_viewport_rect().size
	# Calculate bottom-left anchor (since origin is top-left)
	var bottom_left = Vector2(grid_offset.x, viewport_size.y - grid_offset.y)
	print("Viewport size: ", viewport_size)
	print("Calculated bottom_left: ", bottom_left)
	
	var cols = ceil(grid_area.x / tile_size.x)
	var rows = ceil(grid_area.y / tile_size.y)
	print("Columns: ", cols, " Rows: ", rows)
	
	for i in range(int(cols)):
		for j in range(int(rows)):
			var tile_x = bottom_left.x + i * tile_size.x
			var tile_y = bottom_left.y - j * tile_size.y  # subtract to move upward
			var tile
			if rng.randf() < metal_chance:
				tile = metal_scene.instantiate()
			else:
				tile = dirt_scene.instantiate()
				tile.add_to_group("dirt_tiles")
			tile.position = Vector2(tile_x, tile_y)
			add_child(tile)
			# Uncomment next line for debugging tile placement
			# print("Tile placed at: ", tile.position)

# --- Goal Area Signal Handling & Win Condition ---
func _ready() -> void:
	rng.seed = 123456789  # or use rng.randomize() for a different seed each run
	generate_background()
	
	# Connect the GoalArea's signal using the new Callable syntax (Godot 4)
	goal_area.connect("body_entered", Callable(self, "_on_goal_area_body_entered"))
	print("DEBUG: GoalArea signal connected.")

func _physics_process(_delta: float) -> void:
	check_goal_condition()

func _on_goal_area_body_entered(body: Node) -> void:
	# When a body enters the goal area, check if it's a water droplet.
	if body.is_in_group("water"):
		current_water_count += 1
		print("DEBUG: Water droplet entered goal. Current count:", current_water_count)
		# Optionally remove the droplet:
		body.queue_free()
		# Trigger win condition if enough water has accumulated.
		if current_water_count >= water_needed_to_win:
			game_win()

func check_goal_condition() -> void:
	# Alternatively, you can count overlapping bodies each frame.
	# This sample uses the signal method so this function can be empty or used for other logic.
	pass

func game_win() -> void:
	print("You Win!")
	# Insert further win logic here (e.g., display a win screen, change scene, etc.)
