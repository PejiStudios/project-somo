extends Button



func _on_button_up() -> void:
	PlayerData.score = 0
	PlayerData.life = 100
	MusicPlayer.stop()
	MusicPlayer.play()
	get_tree().paused = false
	get_tree().reload_current_scene()
