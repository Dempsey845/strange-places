class_name SectionSix extends Node

@export var dialogue_manager: DialogueManager 

@onready var izzy_to_player_1: Dialogue = %IzzyToPlayer1
@onready var player_to_izzy_1: Dialogue = %PlayerToIzzy1
@onready var izzy_to_player_2: Dialogue = %IzzyToPlayer2

@onready var objective_enter_base: Objective = %Objective15_EnterBase

@onready var gate: StaticBody2D = %Gate

func _ready() -> void:
	izzy_to_player_2.on_dialogue_complete.connect(_on_dialogue_complete)

func _on_dialogue_complete():
	objective_enter_base.complete_objective()
	gate.queue_free()
