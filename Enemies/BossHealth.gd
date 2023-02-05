extends Control

var hearts = 5 setget set_hearts
var max_hearts = 5 setget set_max_hearts

onready var heart_ui_full = $HeartUIFull
onready var heart_ui_empty = $HeartUIEmpty
onready var label = $Label

	

func set_hearts(value):
	hearts = clamp(value, 0, max_hearts)
	if heart_ui_full != null:
		heart_ui_full.rect_size.x = hearts * 15
		label.text = str(hearts) + "/" + str(max_hearts)
	
func set_max_hearts(value):
	max_hearts = max(value, 1)
	self.hearts = min(hearts, max_hearts)
	if heart_ui_empty != null:
		heart_ui_empty.rect_size.x = max_hearts * 15

func _ready():
	self.max_hearts = BossStats.max_health
	self.hearts = BossStats.health
	BossStats.connect("boss_health_changed",  self, "set_hearts")
	BossStats.connect("boss_max_health_changed", self, "set_max_hearts")
	
