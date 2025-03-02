extends Node2D

@export var water_needed_to_win = 30

# --- Deletion (Drawing) Code ---
var _is_drawing: bool = false  # Track if the mouse is held

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			_is_drawing = true
		else:
			_is_drawing = false

func _process(_delta: float) -> void:
	check_goal_condition()
	if _is_drawing:
		check_and_delete_dirt(get_global_mouse_position())

func check_and_delete_dirt(mouse_pos: Vector2) -> void:
	var draw_radius = 20.0  # Adjust as needed
	for tile in get_tree().get_nodes_in_group("dirt_tiles"):
		if tile.position.distance_to(mouse_pos) <= draw_radius:
			tile.queue_free()

# --- Background Generation Code ---
var tile_size = Vector2(32, 32)           # Set your tile dimensions (16 or 32 as needed)
var grid_offset = Vector2(21, 745)           # Offset from left and bottom of screen
var grid_area = Vector2(1000, 1000)         # Area to cover with the grid
var metal_chance = 0.1                    # 8% chance for a metal tile in any cell

var dirt_scene = preload("res://scenes/dirt_sprite.tscn")
var metal_scene = preload("res://scenes/stone_sprite.tscn")
var rng: RandomNumberGenerator = RandomNumberGenerator.new()

func generate_background() -> void:
	var viewport_size = get_viewport_rect().size
	# Calculate the bottom left anchor.
	# Since Godot's origin is top-left, the bottom left is:
	var bottom_left = Vector2(grid_offset.x, viewport_size.y - grid_offset.y)
	print("Viewport size: ", viewport_size)
	print("Calculated bottom_left: ", bottom_left)
	
	# Calculate number of columns and rows needed to cover grid_area
	var cols = ceil(grid_area.x / tile_size.x)
	var rows = ceil(grid_area.y / tile_size.y)
	print("Columns: ", cols, " Rows: ", rows)
	
	# Loop over each cell in the grid
	for i in range(int(cols)):
		for j in range(int(rows)):
			var tile_x = bottom_left.x + i * tile_size.x
			var tile_y = bottom_left.y - j * tile_size.y  # subtract to move upward
			var tile
			# Randomly choose between a metal tile or a dirt tile.
			if rng.randf() < metal_chance:
				tile = metal_scene.instantiate()
			else:
				tile = dirt_scene.instantiate()
				tile.add_to_group("dirt_tiles")
			tile.position = Vector2(tile_x, tile_y)
			add_child(tile)
			#print("Tile placed at: ", tile.position)  # Uncomment for debugging

func _ready() -> void:
	# Seed the RNG. Use rng.randomize() if you want a different seed each run.
	rng.seed = 123456789
	generate_background()
	
func check_goal_condition():
	if Globals.particles_in_goal >= water_needed_to_win:
		game_win()

func game_win():
	print("You Win!!")
