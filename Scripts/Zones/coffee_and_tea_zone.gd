extends BaseZone

@export var buy_a_coffee_objective: Objective
@export var dialogue_manager: DialogueManager
@export var dialogue_jimmy_1: Dialogue


func _ready() -> void:
	super._ready()
	on_interact.connect(_on_interact)

func _on_interact():
	if not buy_a_coffee_objective.in_progress:
		return
	await dialogue_manager.start_dialogue(dialogue_jimmy_1)
	buy_a_coffee_objective.complete_objective()
