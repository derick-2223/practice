extends KinematicBody2D

const PlayerHurtSound = preload("res://Player/PLayerHurtSound.tscn")


export var ACCELERATION = 50
export var MAX_SPEED = 50
export var ROLL_SPEED = 80
export var FRICTION = 500

enum {
	MOVE,
	ATTACK,
	IDLE
}

var state = MOVE
var velocity = Vector2.ZERO
var knockback = Vector2.RIGHT
var stats = PlayerStats

onready var animation_player = $AnimationPlayer
onready var animation_tree = $AnimationTree
onready var animation_state = animation_tree.get("parameters/playback")
onready var sword_hit_box = $HitboxPivot/SwordHitBox
onready var hurt_box = $HurtBox
onready var blink_animation = $BlinkAnimation
onready var sprite = $Sprite
onready var enemy_detection_zone = $EnemyDetectionZone


func _ready():
	stats.connect("no_health", self, "queue_free")
	animation_tree.active = true
	sword_hit_box.knockback_vector = knockback
	

func _physics_process(delta):
	match state:
		MOVE:
			move(delta)
			seek_enemy()
			
		ATTACK:
			var enemy = enemy_detection_zone.enemy
			if enemy != null:
				attack_state(delta)
			else:
				state = MOVE
	
func seek_enemy():
	if enemy_detection_zone.can_see_enemy():
		state = ATTACK
	
		
func attack_state(delta):
	velocity = Vector2.ZERO
	animation_state.travel("attack")
	
func attack_animation_finisihed():
	state = MOVE
	
func move(delta):
	velocity = Vector2(1,0)
	move_and_slide(velocity * MAX_SPEED * ACCELERATION * delta)
	animation_tree.set("parameters/run/blend_position", velocity.x)
	animation_state.travel("run")

func _on_HurtBox_area_entered(area):
	stats.health -= area.damage
	hurt_box.start_invincibility(0.5)
	hurt_box._create_hit_effect()
	var playerhurtsound = PlayerHurtSound.instance()
	get_tree().current_scene.add_child(playerhurtsound)

func _on_HurtBox_invincibility_started():
	blink_animation.play("start")

func _on_HurtBox_invincibility_ended():
	blink_animation.play("stop")

