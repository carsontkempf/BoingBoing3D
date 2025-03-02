extends GPUParticles2D

@export var gravity = Vector2(0, 200)
@export var drag = 0.1
@export var particle_color = Color("lightblue")

@onready var dirt_tilemap = get_node("../DirtTileMap") # Assuming DirtTileMap is a sibling node

func _ready():
	one_shot = true # Stop emitting particles after initial burst
