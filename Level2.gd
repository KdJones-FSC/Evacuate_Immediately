extends Node2D



func _on_Area2D_body_entered(body):
	get_tree().change_scene("res://TitleScreen.tscn")


func _on_Pits_body_entered(body):
	body.damage(1000)
