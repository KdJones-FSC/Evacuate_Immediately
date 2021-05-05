extends KinematicBody2D

var bulletObj = null
var leftBullet = null
var fire_speed = 3.0
var player = null
export (float) var max_health = 70
onready var health = max_health setget _set_health
onready var effects = $AnimationPlayer
onready var shot_timer = $ShotTimer
onready var _animated_sprite = $AnimatedSprite


func _ready():
	bulletObj = load("res://Enemy bullet.tscn")
	leftBullet = load("res://Enemy bullet left.tscn")
	shot_timer.wait_time = 3.0/fire_speed
	shot_timer.one_shot = true

func _physics_process(delta): # get's called every physics step
	if $Area2D.overlaps_body(player): # returns bool true/false
		if shot_timer.time_left == 0:
			shoot()

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
	queue_free()
	

func shoot():
	
	if position.direction_to(player.position).x > 0:
		_animated_sprite.flip_h = false
		var bullet = bulletObj.instance()
		bullet.position = self.get_position()
		bullet.position.y = bullet.position.y
		get_node("/root").add_child(bullet)
		shot_timer.start()
	else:
		_animated_sprite.flip_h = true
		var bullet = leftBullet.instance()
		bullet.position = self.get_position()
		bullet.position.y = bullet.position.y
		get_node("/root").add_child(bullet)
		shot_timer.start()


func _on_Area2D_body_entered(body):
	player = body
	shoot()


func _on_Area2D_body_exited(body):
	player = null
