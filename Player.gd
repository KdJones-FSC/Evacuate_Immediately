extends KinematicBody2D


signal health_updated(health)
signal killed()

# Declare member variables here. Examples:
var fire_speed = 3.0
var bulletObj = null
var leftBullet = null
export (float) var max_health = 100
onready var health = max_health setget _set_health
onready var _animated_sprite = $AnimatedSprite
onready var invulnerability_timer = $InvulnerabilityTimer
onready var effects = $AnimationPlayer
onready var shot_timer = $ShotTimer
onready var health_bar = $HealthBar/HealthBar

export (int) var run_speed = 200
export (int) var jump_speed = -500
export (int) var gravity = 800

var velocity = Vector2()
var jumping = false

func _ready():
	bulletObj = load("res://Player Bullet.tscn")
	leftBullet = load("res://Player left bullet.tscn")
	shot_timer.wait_time = 3.0/fire_speed
	shot_timer.one_shot = true

func get_input():
	velocity.x = 0

	if Input.is_action_just_pressed('ui_up') and is_on_floor():
		jumping = true
		velocity.y = jump_speed
		
	if Input.is_action_pressed("ui_left"):
		velocity.x -= run_speed
		_animated_sprite.play("run")
		_animated_sprite.flip_h = true
	elif Input.is_action_pressed("ui_right"):
		velocity.x += run_speed
		_animated_sprite.play("run")
		_animated_sprite.flip_h = false
		
	if Input.is_action_pressed("ui_select"):
		if shot_timer.time_left == 0:
			if (_animated_sprite.flip_h == false):
				var bullet = bulletObj.instance()
				bullet.position = self.get_position()
				bullet.position.y = bullet.position.y
				get_node("/root").add_child(bullet)
				shot_timer.start()
			else:
				var bullet = leftBullet.instance()
				bullet.position = self.get_position()
				bullet.position.y = bullet.position.y
				get_node("/root").add_child(bullet)
				shot_timer.start()
	if Input.is_action_just_released("ui_left"):
		_animated_sprite.stop()
	elif Input.is_action_just_released("ui_right"):
		_animated_sprite.stop()

func _physics_process(delta):
	get_input()
	velocity.y += delta * gravity

	if jumping and is_on_floor():
		jumping = false

	velocity = move_and_slide(velocity, Vector2(0, -1))
	
	
func kill():
	print("You died")
	_animated_sprite.play("die")
	queue_free()
	get_tree().change_scene("res://TitleScreen.tscn")
	
func damage(amount):
	if invulnerability_timer.is_stopped():
		invulnerability_timer.start()
		_set_health(health - amount)
		effects.play("damage")
		effects.queue("invulnerability")

func _set_health(value):
	var prev_health = health
	health = clamp(value, 0, max_health)
	health_bar.value = health
	print(health)
	if health != prev_health:
		emit_signal("health_updated",health)
		if health == 0:
			kill()
			emit_signal("killed")


func _on_InvulnerabilityTimer_timeout():
	effects.play("rest") # Replace with function body.
