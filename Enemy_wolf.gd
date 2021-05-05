extends KinematicBody2D


var run_speed = 150
var velocity = Vector2.ZERO
var player = null
export (int) var gravity = 100000
onready var _animated_sprite = $AnimatedSprite
onready var effects = $AnimationPlayer
export (float) var max_health = 50
onready var health = max_health setget _set_health

func _physics_process(delta):
	velocity = Vector2.ZERO
	velocity.y += delta * gravity
	if player:
		if position.direction_to(player.position).x > 0:
			_animated_sprite.play("wolf_walk_right")
		else:
			_animated_sprite.play("wolf_walk_left")
		velocity.x = position.direction_to(player.position).x * run_speed
	velocity = move_and_slide(velocity)
	
func _set_health(value):
	var prev_health = health
	health = clamp(value, 0, max_health)
	if health != prev_health:
		emit_signal("health_updated",health)
		if health == 0:
			kill()
			emit_signal("killed")
			

func damage(amount):
	_set_health(health - amount)
	effects.play("damage")

func kill():
	_animated_sprite.play("death")
	queue_free()

func _on_search_area_body_entered(body):
	player = body


func _on_search_area_body_exited(body):
	player = null
	_animated_sprite.stop()


func _on_damage_area_body_entered(body):
	body.damage(25)
