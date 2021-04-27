extends "res://actors/actor.gd"

export var score: = 100
func _ready() -> void:
	set_physics_process(false)
	_velocity.x =-speed.x * 0.25
	PlayerData.connect("hitstun_update", self, "update_hit")

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
	queue_free()
	PlayerData.score += score

func _on_Timer_timeout() -> void:
	pass # Replace with function body.


func _weapon_connected(_area: Area2D) -> void:
	die()
