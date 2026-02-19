extends Node

@export var dialogue_manager: DialogueManager
@export var deliver_beans_objective: Objective
@export var cash_dialogue: Dialogue


func _ready() -> void:
	deliver_beans_objective.on_complete.connect(_on_deliver_beans)
	
func _on_deliver_beans():
	await get_tree().create_timer(2.0).timeout
	dialogue_manager.start_dialogue(cash_dialogue)
