extends Control

func _ready() -> void:
	$"/root/PlayerData".life = 100
	$"/root/PlayerData".score = 0
	$Menu/PlayButton.grab_focus()
