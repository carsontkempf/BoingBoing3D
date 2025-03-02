extends Control

func _ready():
	$StartButton.connect("pressed", _on_start_button_pressed)
	print("Button Ready!")  # Debugging

func _on_start_button_pressed():
	print("Button Pressed!")  # Debugging
	get_tree().change_scene_to_file("res://Game.tscn")
