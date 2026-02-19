extends Node2D

func _ready() -> void:
	await $AnimationPlayer.animation_finished
	SceneManager.change_scene("res://Scenes/game.tscn")
