extends Label

var playerstate
var temptext
func _ready():
	$"/root/Level/Player".connect("player_state", self, "_on_ps")

func _process(_delta):
	var fps = str(Engine.get_frames_per_second())
	temptext = "FPS " + fps
	temptext += "\n PS: " + str(playerstate)
	temptext += "\nFlipped: " + str($"/root/Level/Player".flipped)
	temptext += "\nd timer: " + str($"/root/Level/Player/Dtimer".time_left)
	temptext += "\nis timer off?: " + str($"/root/Level/Player/Dtimer".is_stopped())
	text = temptext
func _on_ps(ps):
	playerstate = ps
