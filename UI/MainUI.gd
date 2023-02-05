extends Control

var time = 0

onready var timer = $CanvasLayer/Timer
onready var label = $CanvasLayer/Label

func _ready():
	timer.start()

func _on_Timer_timeout():
	time += 1
	label.text = str(time)


