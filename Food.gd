extends Node2D

func _on_Area2D_body_entered(body):
	body._set_health(body.health+50)
	queue_free()
