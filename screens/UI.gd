extends Control

onready var scene_tree: = get_tree()
onready var paused_overlay: ColorRect= get_node("PauseOverlay")
onready var score: Label = get_node("Score")
onready var pause_title: Label = get_node("PauseOverlay/Title")
var paused = false setget set_paused

func _ready() -> void:
	PlayerData.connect("score_updated", self, "update_score")
	PlayerData.connect("player_died", self, "_on_PlayerData_player_died")
	PlayerData.connect("life_update", self, "update_life")
	PlayerData.connect("boss_life_update", self, "update_boss_life")
	update_score()
	update_life()
	update_boss_life()

func _process(_delta: float) -> void:
	if PlayerData.boss_battle == true: $"BossbarLayout/Scaling/Life Bar".visible = true
	else: $"BossbarLayout/Scaling/Life Bar".visible = false
	if PlayerData.indoor == true: $TouchScreen/up.visible = true
	else: $TouchScreen/up.visible = false

func _on_PlayerData_player_died() -> void:
	self.paused = true
	pause_title.text = "You died"

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") and pause_title.text != "You died":
		self.paused =  not paused
		scene_tree.set_input_as_handled()

func update_score() -> void:
	score.text = "Score: %s" % PlayerData.score

func update_life() -> void:
	$"LifeBarLayout/Scaling/Life Bar".value = PlayerData.life

func update_boss_life() -> void:
	$"BossbarLayout/Scaling/Life Bar".value = PlayerData.boss_life

func set_paused(value: bool) -> void:
	paused = value
	scene_tree.paused = value
	paused_overlay.visible = value
	$PauseOverlay/PauseMenu/RetryButton.grab_focus()
