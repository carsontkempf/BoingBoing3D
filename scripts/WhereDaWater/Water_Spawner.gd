extends Marker2D

@export var spawn_rate: float = 0.2  # Time between spawns
@export var burst_amount: int = 5      # Number of droplets per spawn

# Use a child node as the template (WaterDropletTemplate should be a RigidBody2D node)
@onready var droplet_template = $WaterDroplet

var timer: Timer

func _ready():
	if droplet_template == null:
		push_error("ERROR: WaterDropletTemplate not found!")
	else:
		print("WaterDropletTemplate found. Visible:", droplet_template.visible)
	
	timer = get_node_or_null("Timer")
	if timer == null:
		timer = Timer.new()
		timer.name = "Timer"
		timer.wait_time = spawn_rate
		timer.autostart = true
		timer.one_shot = false
		timer.timeout.connect(_on_Timer_timeout)
		add_child(timer)
		print("Created and started Timer.")
	else:
		timer.wait_time = spawn_rate
		timer.timeout.connect(_on_Timer_timeout)
		timer.start()
		print("Timer started!")

func _on_Timer_timeout():
	print("Spawning droplets...")
	for i in range(burst_amount):
		spawn_droplet()

func spawn_droplet():
	if droplet_template:
		# Duplicate the template deeply, duplicating signals, groups, and scripts.
		# (1 + 2 + 4 + 8 = 15)
		var droplet = droplet_template.duplicate(15)
		if not droplet is RigidBody2D:
			push_error("Template must be a RigidBody2D!")
			return
		# Set the droplet's position to the spawner's global_position
		droplet.position = global_position
		# Force the droplet (and its children) to be visible in case the template is hidden
		droplet.show()
		
		var sprite = droplet.get_node_or_null("Sprite2D")
		if sprite:
			sprite.show()
			print("Sprite2D found, texture:", sprite.texture)
			print("Sprite2D visible:", sprite.visible, " modulate:", sprite.modulate)
		else:
			print("ERROR: Sprite2D missing!")
		
		var collision = droplet.get_node_or_null("CollisionShape2D")
		if collision:
			print("CollisionShape2D found, shape:", collision.shape)
		else:
			print("ERROR: CollisionShape2D missing!")
		
		get_parent().add_child(droplet)
		print("Spawned droplet at:", droplet.position, "Z index:", droplet.z_index)
