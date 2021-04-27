extends "res://actors/actor.gd"

export var score: = 100
var audio = "res://assets/mus/Boss_Test.ogg"
func _ready() -> void:
	get_parent().get_node("Door/hitbox").disabled = true
	MusicPlayer.stream = load(audio)
	MusicPlayer.play()
	PlayerData.boss_battle = true
	PlayerData.boss_life = 100
	set_physics_process(false)
	_velocity.x = -speed.x * 0.25
	PlayerData.connect("hitstun_update", self, "update_hit")

#func _on_VisionL_body_entered(body: Node) -> void:
#	if body.global_position.x < get_node("VisionL").global_position.x:
#	_velocity.x = -speed.x * 0.25
#func _on_VisionR_body_entered(body: Node) -> void:
#	if body.global_position.x > get_node("VisionR").global_position.x:
#	_velocity.x = -speed.x * -0.25
#func _on_BlindSpot_body_exited(body: Node) -> void:
#		_velocity.x *= 0

func _physics_process(delta: float) -> void:
	_velocity.y += gravity * delta
	if is_on_wall():
		_velocity.x *= -1.0
		if _velocity.x == -speed.x * 0.25:
			$Animation.flip_h = false
		else:
			$Animation.flip_h = true
	_velocity.y = move_and_slide(_velocity, FLOOR_NORMAL).y

func die() -> void:
	PlayerData.score += score
	PlayerData.boss_battle = false
	queue_free()
func _on_Timer_timeout() -> void:
	pass # Replace with function body.


func _weapon_connected(_area: Area2D) -> void:
	PlayerData.boss_life -= 10
	if PlayerData.boss_life < 1:
		die()
