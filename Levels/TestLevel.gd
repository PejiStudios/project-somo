extends Node2D

func _ready() -> void:
	MusicPlayer.stream = load("res://assets/mus/bckgndTest.ogg")
	MusicPlayer.play()
