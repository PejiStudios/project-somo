extends Control

onready var label: Label = get_node("Label")


func _ready() -> void:
	label.text = label.text % [PlayerData.score, PlayerData.deaths]
	MusicPlayer.stop()
	$Menu/PlayButton.grab_focus()
