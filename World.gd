extends Node2D

const BatSpawn = preload("res://Enemies/Bat.tscn")
const PlayerSpawn = preload("res://Player/Player.tscn")

onready var enemy_spawn = $EnemySpawn
onready var spawn_timer = $SpawnTimer
onready var wave_timer = $WaveTimer
onready var player_spawn = $PlayerSpawn
onready var main_ui = $MainUI
onready var base = $Base


func _ready():
	spawn_timer.start()
	wave_timer.start()


func _process(delta):
	spawn_condition()
	on_base_destroyed()

func enemy_spawn():
	var batspawn = BatSpawn.instance()
	self.add_child(batspawn)
	batspawn.global_position = enemy_spawn.global_position

func player_spawn():
	var playerspawn = PlayerSpawn.instance()
	self.add_child(playerspawn)
	playerspawn.global_position = player_spawn.global_position

func _on_SpawnTimer_timeout():
	enemy_spawn()

func _on_WaveTimer_timeout():
	spawn_timer.stop()

func spawn_condition():
	if main_ui.time <= 5:
		$MainUI/CanvasLayer/SpawnButton.disabled = true
	else:
		$MainUI/CanvasLayer/SpawnButton.disabled = false

func _on_SpawnButton_pressed():
		player_spawn()
		main_ui.time -= 5
		PlayerStats.health = 5

func on_base_destroyed():
	if BossStats.health <= 0:
		spawn_timer.stop()
		self.queue_free()
		
