extends AnimatedSprite
onready var player = $".."

func _process(_delta):
	if player._velocity.x > 0:
		flip(true)
	elif player._velocity.x < 0:
		flip(false)
		
	match player.playerstate:
		0:
			floored()

func flip(value):
	match value:
		true:
			flip_h = true
		false:
			flip_h = false

func floored():
	if player._velocity.x == 0:
		play("idle")
	else: play("walk")
