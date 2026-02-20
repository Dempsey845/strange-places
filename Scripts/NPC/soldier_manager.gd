extends Node

@export var soldiers: Node2D

func start_chase_and_shoot():
	for soldier in soldiers.get_children():
		soldier.start_chase_and_shoot()
