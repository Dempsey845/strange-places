class_name SectionFive extends Node

@export var dialogue_manager: DialogueManager

@onready var player_to_soldier_1: Dialogue = %PlayerToSoldier1
@onready var soldier_to_player_1: Dialogue = %SoldierToPlayer1
@onready var objective_find_a_solider: Objective = %Objective12_FindASolider
@onready var objective_lure_soldier: Objective = %Objective13_LureSoldier
@onready var objective_shapeshift: Objective = %Objective14_Shapeshift

@onready var alleyway_marker: Marker2D = %AlleywayMarker

func has_reached_alleyway(npc_pos: Vector2):
	return npc_pos.distance_to(alleyway_marker.global_position) < 50
