extends Label

func _process(_delta):
	var fps = str(Engine.get_frames_per_second())
	$".".text = "FPS " + fps
