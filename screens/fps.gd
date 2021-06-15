extends Label

func _process(delta):
	var fps = str(Engine.get_frames_per_second())
	$".".text = "FPS " + fps
