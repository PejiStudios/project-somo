extends Camera2D

onready var worldspeed = $"/root/Level".worldspeed

func _process(delta):
	position.y += $"/root/Level".worldspeed*delta
	$TextureRect.rect_position -= Vector2(0,7.5*delta)
	if $TextureRect.rect_position <= Vector2(0,-330):
		$TextureRect.rect_position = Vector2 (0,0)
