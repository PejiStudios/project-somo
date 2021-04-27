extends Area2D

export var score = 100

func _on_Area2D_body_entered(_body: Node) -> void:
	picked()


func picked() -> void:
	PlayerData.score += score
	queue_free()
