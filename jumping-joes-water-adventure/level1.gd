extends Node2D

@onready var dirt_tilemap = $DirtTileMap
@onready var water_particles = $WaterParticles
@onready var goal_area = $GoalArea
@export var dig_radius = 1
@export var water_needed_to_win = 50

var is_digging = false # Variable to track if the mouse button is held down

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			is_digging = event.pressed # Set is_digging based on button press/release

func _process(delta): # Use _process for continuous updates
	if is_digging: # If left mouse button is held down
		var mouse_pos = get_global_mouse_position()
		dig_at_position(mouse_pos)

func dig_at_position(pos):
	var cell_size = dirt_tilemap.tile_set.tile_size
	var tile_coords = dirt_tilemap.local_to_map(dirt_tilemap.to_local(pos))

	for x in range(tile_coords.x - dig_radius, tile_coords.x + dig_radius + 1):
		for y in range(tile_coords.y - dig_radius, tile_coords.y + dig_radius + 1):
			var dist_sq = (tile_coords.x - x)**2 + (tile_coords.y - y)**2
			if dist_sq <= dig_radius**2:
				dirt_tilemap.set_cell(Vector2i(x, y), -1)

func _physics_process(delta):
	check_goal_condition()

func check_goal_condition():
	var particles_in_goal = 0
	if goal_area.has_overlapping_bodies():
		for body in goal_area.get_overlapping_bodies():
			if body == water_particles:
				particles_in_goal += water_particles.get_particle_count()

	if particles_in_goal >= water_needed_to_win:
		game_win()

func game_win():
	print("You Win!")
	# Add game win logic here (scene change, UI display, etc.)
