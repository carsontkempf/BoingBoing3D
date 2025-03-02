extends Node2D
# Water Generation using PhysicsServer2D & RenderingServer

@export var particle_texture: Texture2D
@export var max_water_particles: int = 100
var current_particle_count: int = 0
var spawn_timer: float = 2.0
@export var spawn_time: float = 1.0
var water_particles = []  # Array to hold droplet Node2D instances

# --- Create a water droplet as a Node2D ---
func create_particle() -> void:
	# Create a container node for the droplet
	var droplet = Node2D.new()
	# Set its position relative to this node (with some randomness)
	droplet.position = global_position + Vector2(randf_range(-10, 10), randf_range(-10, 10))
	add_child(droplet)
	# Add to the "water" group so the GoalArea can detect it
	droplet.add_to_group("water")
	
	# --- Create a Physics Body for the droplet ---
	var ps = PhysicsServer2D
	var water_body = ps.body_create()
	ps.body_set_mode(water_body, PhysicsServer2D.BODY_MODE_RIGID)
	ps.body_set_space(water_body, get_world_2d().space)
	var shape = ps.circle_shape_create()
	ps.shape_set_data(shape, 8)  # 8-pixel radius
	ps.body_add_shape(water_body, shape, Transform2D.IDENTITY)
	ps.body_set_collision_layer(water_body, 1)
	ps.body_set_collision_mask(water_body, 1)
	ps.body_set_param(water_body, PhysicsServer2D.BODY_PARAM_FRICTION, 0.0)
	ps.body_set_param(water_body, PhysicsServer2D.BODY_PARAM_MASS, 0.05)
	ps.body_set_param(water_body, PhysicsServer2D.BODY_PARAM_GRAVITY_SCALE, 0.8)
	var trans = Transform2D.IDENTITY
	trans.origin = droplet.position
	ps.body_set_state(water_body, PhysicsServer2D.BODY_STATE_TRANSFORM, trans)
	# Store the physics body RID as metadata on the droplet node
	droplet.set_meta("physics_body", water_body)
	
	# --- Create the Visual for the droplet ---
	var vs = RenderingServer
	var canvas_item = vs.canvas_item_create()
	vs.canvas_item_set_parent(canvas_item, droplet.get_canvas_item())
	vs.canvas_item_set_transform(canvas_item, trans)
	var rect = Rect2(Vector2(-8, -8), particle_texture.get_size() / 4)
	vs.canvas_item_add_texture_rect(canvas_item, rect, particle_texture)
	vs.canvas_item_set_self_modulate(canvas_item, Color("ff00ff"))
	droplet.set_meta("canvas_item", canvas_item)
	
	# Save the droplet in our array for later updating and removal
	water_particles.append(droplet)

func _physics_process(delta: float) -> void:
	# Spawn a new droplet if the timer is below zero and we haven't reached the max count
	if spawn_timer < 0 and current_particle_count < max_water_particles:
		create_particle()
		current_particle_count += 1
		spawn_timer = spawn_time
	spawn_timer -= 1
	#update particle texture position to be at Rigid body position
	for col in water_particles:
		var trans = PhysicsServer2D.body_get_state(col[0],PhysicsServer2D.BODY_STATE_TRANSFORM)
		trans.origin = trans.origin - global_position
		RenderingServer.canvas_item_set_transform(col[1],trans)
		#Delete particles if Y position > than 1500. 2D y down is positive
		if trans.origin.y > 2000:
			#remove RIDs
			PhysicsServer2D.free_rid(col[0])
			RenderingServer.free_rid(col[1])
			#remove reference
			water_particles.erase(col)
			Globals.total_water_particles -=1

