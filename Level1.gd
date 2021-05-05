extends Node2D



func _on_next_level_body_entered(body):
	if($Player):
		get_tree().change_scene("res://Level2.tscn")
