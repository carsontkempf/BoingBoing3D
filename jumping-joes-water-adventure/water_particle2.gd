extends GPUParticles2D

@export var gravity = Vector2(0, 200)
@export var drag = 0.1
@export var particle_color = Color("lightblue")

@onready var dirt_tilemap = get_node("../DirtTileMap") # Assuming DirtTileMap is a sibling node

func _ready():
	if not dirt_tilemap:
		printerr("Error: DirtTileMap node not found! Make sure DirtTileMap is a sibling of WaterParticles.")
	emitting = false # Stop emitting particles after initial burst


func _physics_process(delta):
	if not dirt_tilemap: # Exit if DirtTileMap is not found
		return

	var particles_data = get_particles_data() # Get particle data array
	var particle_count = get_particle_count()

	for i in range(particle_count):
		var particle_velocity = get_particle_attribute(i, PARTICLE_ATTRIBUTE_VELOCITY)
		var particle_position = get_particle_attribute(i, PARTICLE_ATTRIBUTE_POSITION)

		particle_velocity += gravity * delta
		particle_velocity *= (1.0 - drag) # Apply drag

		# Check for dirt collision
		var tile_coords = dirt_tilemap.local_to_map(particle_position)
		var tile_id = dirt_tilemap.get_cell_tile_data(tile_coords)

		if tile_id: # If tile_id is not null (meaning there's a tile)
			particle_velocity = Vector2.ZERO # Stop the particle

		set_particle_attribute(i, PARTICLE_ATTRIBUTE_VELOCITY, particle_velocity)

func _init():
	color = particle_color
	lifetime = 1.0
	amount = 100 # Initial number of particles - now also the total limit
	emission_shape = PARTICLE_EMISSION_SHAPE_POINT
	direction = Vector2(0, 1)
	spread = 360 # Emit in all directions initially
	initial_velocity_min = 50
	initial_velocity_max = 100
	gravity_point_unit = false
	radial_accel_min = 0
	radial_accel_max = 0
	tangential_accel_min = 0
	tangential_accel_max = 0
	damping_min = 0.1
	damping_max = 0.2
	angle_min = 0
	angle_max = 360
	scale_amount_min = 0.5
	scale_amount_max = 0.8
	color_initial_variant = 0.2
