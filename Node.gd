extends Node

export(int) var max_health = 1 setget set_max_health
var health = max_health setget set_health

signal no_boss_health
signal boss_health_changed(value)
signal boss_max_health_changed(value)


func set_max_health(value):
	max_health = value
	self.health = min(health, max_health)
	emit_signal("boss_max_health_changed", max_health)

func set_health(new_health):
	health = new_health
	emit_signal("boss_health_changed", health)
	if health <= 0:
		emit_signal("no_boss_health")

func _ready():
	self.health = max_health
