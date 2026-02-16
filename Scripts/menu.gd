extends Node2D

func play():
	call_deferred("_go_to_game")

func _go_to_game():
	SceneManager.change_scene("res://Scenes/game.tscn")
