tool
extends Area2D

func _ready() -> void:
	set_process(true)

onready var anim_player: AnimationPlayer = $AnimationPlayer
export var next_scene: PackedScene

func _process(_delta: float) -> void:
	if PlayerData.indoor == true: 
		if Input.is_action_just_pressed("ui_up"): 
			if PlayerData.floored == true: teleport()
	if PlayerData.boss_battle == true:
		$hitbox.disabled = true
		visible = false
	else:
		$hitbox.disabled = false
		visible = true


func _on_body_entered(_body: Node) -> void:
	PlayerData.indoor = true

func _on_body_exited(_body: Node) -> void:
	PlayerData.indoor = false

func _get_configuration_warning() -> String:
	return "The next scene property can't be empty" if not next_scene else ""


func teleport() -> void:
	PlayerData.teleporting = true
	anim_player.play("fade_in")
	yield(anim_player, "animation_finished")
	get_tree().change_scene_to(next_scene)
