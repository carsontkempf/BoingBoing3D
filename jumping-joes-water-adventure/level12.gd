#GDScript
extends Node2D

@onready var dirt_tilemap = $DirtTileMap # Replace with your TileMap node name
@onready var water_particles = $WaterParticles # Replace with your GPUParticles2D node name (if you name it differently in the scene)
@onready var goal_area = $GoalArea # Replace with your Goal Area node name (e.g., Area2D)
@export var dig_radius = 4
@export var water_needed_to_win = 50 # Number of particles needed in goal

func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT: # Left mouse button click
		var mouse_pos = get_global_mouse_position()
		dig_at_position(mouse_pos)
func dig_at_position(pos):
	var cell_size = dirt_tilemap.tile_set.tile_size
	var tile_coords = dirt_tilemap.local_to_map(dirt_tilemap.to_local(pos))

	for x in range(tile_coords.x - dig_radius, tile_coords.x + dig_radius + 1):
		for y in range(tile_coords.y - dig_radius, tile_coords.y + dig_radius + 1):
			var dist_sq = (tile_coords.x - x)**2 + (tile_coords.y - y)**2
			if dist_sq <= dig_radius**2: # Dig within a circle
				# Correct set_cell call to use Vector2i
				dirt_tilemap.set_cell(Vector2i(x, y), -1) # -1 clears the tile in TileMap

func _physics_process(delta):
	check_goal_condition()

func check_goal_condition():
	var particles_in_goal = 0
	if goal_area.has_overlapping_bodies():
		for body in goal_area.get_overlapping_bodies():
			if body == water_particles: # Assuming water particles are GPUParticles2D
				particles_in_goal += water_particles.get_particle_count() # Or count relevant particles

	if particles_in_goal >= water_needed_to_win:
		game_win()

func game_win():
	print("You Win!")
	# Add game win logic here (scene change, UI display, etc.)
