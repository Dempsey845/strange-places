extends Node

@export var dialogue_manager: DialogueManager

@export var deliver_beans_objective: Objective
@export var cash_dialogue: Dialogue

@export var collect_reward_objective: Objective
@export var police_dialogue: Dialogue

func _ready() -> void:
	deliver_beans_objective.on_complete.connect(_on_deliver_beans)
	collect_reward_objective.on_complete.connect(_on_collect_reward)
	
	police_dialogue.on_dialogue_complete.connect(_on_police_dialogue_complete)
	
func _on_deliver_beans():
	await get_tree().create_timer(2.0).timeout
	dialogue_manager.start_dialogue(cash_dialogue)

func _on_collect_reward():
	await get_tree().create_timer(2.0).timeout
	dialogue_manager.start_dialogue(police_dialogue)

func _on_police_dialogue_complete():
	# TODO: Start an objective to go speak with the police officer
	pass
