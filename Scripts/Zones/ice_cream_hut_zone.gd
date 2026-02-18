extends BaseZone

@export var collect_beans_objective: Objective
@export var dialogue_manager: DialogueManager
@export var dialogue_player1: Dialogue

func _ready() -> void:
	super._ready()
	on_interact.connect(_on_interact)

func _on_interact():
	print("Interact")
	if not collect_beans_objective.in_progress:
		return
		
	await dialogue_manager.start_dialogue(dialogue_player1)
	collect_beans_objective.complete_objective()
