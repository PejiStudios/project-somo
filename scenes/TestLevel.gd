extends Node2D

var worldstate
var worldspeed
signal die

func _ready() -> void:
	worldstate = "menu"
	MusicPlayer.stream = load("res://assets/mus/title.wav")
	MusicPlayer.play()

func _process(delta):
#	print(worldstate)
	match worldstate:
		"menu":
			waitfor_start()
		"heating":
			game_process()
		"calm":
			pass

func waitfor_start():
	if $Player.position.y >= 180:
		worldstate = "heating"
	worldspeed = 0

func game_process():
	if worldspeed >= 45:
		worldspeed = 45
	worldspeed = 15


func touched_sun(area):
	worldstate = "menu"
	emit_signal("die")
