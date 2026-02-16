class_name PlayerHitbox extends Area2D

@onready var player: Player = get_parent()

func take_damage(damage: int):
	player.take_damage(damage)
