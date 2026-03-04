extends Node2D

var player_scene = preload("res://scence/entity/player.tscn")
var current_player = player_scene.instantiate()
var spawn_point = Vector2(-1021,270)

func _ready() -> void:
	spawn_player()


func spawn_player() -> void:
	if current_player != null and is_instance_valid(current_player):
		current_player.queue_free()
		
		var new_player = player_scene.instantiate()
		new_player.position = spawn_point
		if new_player.has_signal("is_dead"):
			new_player.is_dead.connect(_dead_player)
		add_child(new_player)
		current_player = new_player

func _dead_player(dead) -> void:
	get_tree().change_scene_to_file("res://scence/world/Menu/main.tscn")
