extends Control


func _on_StartgameButton_pressed():
	get_tree().change_scene("res://Level1.tscn")


func _on_QuitgameButton_pressed():
	get_tree().quit()
