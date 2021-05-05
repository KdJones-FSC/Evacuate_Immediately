extends Node2D

onready var sound = $AudioStreamPlayer2D

func _process(delta):
	move_local_x(delta*400)

func left_process(delta):
	move_local_x(delta*-400)



func _on_Area2D_body_entered(body):
	body.damage(20)
	queue_free()
