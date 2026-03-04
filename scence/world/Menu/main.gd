extends  CanvasLayer
	


func _on_button_focus_entered() -> void:
	get_tree().change_scene_to_file("res://scence/world/game/Game.tscn")


func _on_options_focus_entered() -> void:
	get_tree().change_scene_to_file("res://scence/world/Menu/options.tscn")
