extends Area2D

var enemy = null

func can_see_enemy():
	return enemy != null

func _on_EnemyDetectionZone_body_entered(body):
	enemy = body

func _on_EnemyDetectionZone_body_exited(body):
	enemy = null
