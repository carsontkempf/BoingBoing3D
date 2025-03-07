extends Node2D

func _process(delta: float) -> void:
	if Global.game_over:
		if !Global.game_won:
			$Player/idleFaceAway.play("death")
			await get_tree().create_timer(2).timeout
			$GameOverText.text = "You Lost!"
		else:
			$GameOverText.text = "You Won!"
			
		$Player/idleFaceAway.stop()
		$GameOverBg.visible = true
		$GameOverText.visible = true
	else:
		$GameOverBg.visible = false
		$GameOverText.visible = false
