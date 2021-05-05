extends Node2D

func _process(delta):
	move_local_x(delta*-400)

func _on_Area2D_body_entered(body):
	body.damage(15)
	queue_free()

