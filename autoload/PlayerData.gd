extends Node2D

signal score_updated
signal player_died
signal life_update
signal hitstun_update
signal boss_life_update

var score = 0 setget set_score
var deaths = 0 setget set_deaths
var life = 100 setget set_life
var boss_life = 100 setget set_boss_life
var hitstun = 0
var indoor = false
var teleporting = false
var floored = false
var boss_battle = false
func reset() -> void:
	score = 0
	deaths = 0 

func set_score(value: int) -> void:
	score = value
	emit_signal("score_updated")

func set_deaths(value: int) -> void:
	deaths = value
	emit_signal("player_died")

func set_life(value: int) -> void:
	life = value
	emit_signal("life_update")

func set_boss_battle(value: bool) -> void:
	boss_life = value
	emit_signal("boss_battle_state")

func set_boss_life(value: int) -> void:
	boss_life = value
	emit_signal("boss_life_update")
