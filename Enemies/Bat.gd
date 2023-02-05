extends KinematicBody2D

export var ACCELERATION = 20
export var MAX_SPEED = 80
export var FRICTION = 200

const EnemyDeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")
const DamageIndicator = preload("res://UI/DamageIndicator.tscn")

enum {
	IDLE,
	MARCH,
	CHASE
}

var velocity = Vector2.ZERO

var knockback = Vector2.ZERO
var state = CHASE
var num_hit = 0

onready var animated_sprite = $AnimatedSprite
onready var stats = $Stats
onready var detection_zone = $DetectionZone
onready var hurt_box = $HurtBox
onready var animation_player = $AnimationPlayer


func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, 200 * delta)
	knockback = move_and_slide(knockback)
	
	match state:
		IDLE:
			velocity = Vector2(-1, 0)
			move_and_slide(velocity * MAX_SPEED * ACCELERATION * delta)
			animated_sprite.flip_h = velocity.x < 0
			seek_player()
		MARCH:
			 pass
		CHASE:
			var player = detection_zone.player
			if player != null:
				var direction = position.direction_to(player.global_position)
				velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
				
			else:
				state = IDLE
			animated_sprite.flip_h = velocity.x < 0
			
	velocity = move_and_slide(velocity)

func seek_player():
	if detection_zone.can_see_player():
		state = CHASE

func _on_HurtBox_area_entered(area):
	stats.health -= area.damage
	num_hit += 1
	
	if num_hit == 2:
		knockback = area.knockback_vector * 180
	hurt_box.start_invincibility(0.6)
	hurt_box._create_hit_effect()
	
	var damage_indicator = DamageIndicator.instance()
	get_parent().add_child(damage_indicator)
	damage_indicator.label.text = str(area.damage)
	damage_indicator.global_position = global_position

	 
func _on_Stats_no_health(): 
	queue_free()
	var enemyDeathEffect = EnemyDeathEffect.instance()
	enemyDeathEffect.global_position = global_position
	get_parent().add_child(enemyDeathEffect)

func _on_HurtBox_invincibility_ended():
	animation_player.play("stop")


func _on_HurtBox_invincibility_started():
	animation_player.play("start")
