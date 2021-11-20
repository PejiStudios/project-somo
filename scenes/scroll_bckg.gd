extends Camera2D

onready var worldspeed = $"/root/Level".worldspeed
var pos_before_reset

func _ready():
	$"/root/Level".connect("die", self, "reset")

func _process(delta):
	position.y += $"/root/Level".worldspeed*delta
	$background_texture.rect_position -= Vector2(0,7.5*delta)
	if $background_texture.rect_position <= Vector2(0,-330):
		$background_texture.rect_position = Vector2 (0,0)

func reset():
	pos_before_reset = int(position.y)
	position.y = 0
