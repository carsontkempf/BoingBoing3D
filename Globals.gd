extends Node


var total_water_particles = 0


var game_over: bool = false
var game_won = false
var reloading = false

func _process(_delta: float) -> void:
	if game_over and not reloading:
		reloading = true
		reload_after_delay()

func reload_after_delay() -> void:
	await get_tree().create_timer(5).timeout
	get_tree().reload_current_scene()
	game_over = false
	game_won = false
	reloading = false
