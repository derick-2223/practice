extends StaticBody2D

export var defense = 0.5

const EnemyDeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")
const DamageIndicator = preload("res://UI/DamageIndicator.tscn")

var stats = BossStats

onready var hurt_box = $HurtBox
onready var boss_health = $BossHealth


func _ready():
	stats.connect("no_boss_health", self, "queue_free")

func _on_HurtBox_area_entered(area):
	stats.health -= area.damage - defense
	hurt_box._create_hit_effect()
	
	var damage_indicator = DamageIndicator.instance()
	get_parent().add_child(damage_indicator)
	damage_indicator.label.text = str(area.damage - defense)
	damage_indicator.global_position = global_position
	

