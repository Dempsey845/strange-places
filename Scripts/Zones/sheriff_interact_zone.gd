extends BaseZone

@export var dialogue_manager: DialogueManager
@export var speak_to_sheriff_objective: Objective
@export var player_to_sheriff_1_dialogue: Dialogue
@export var sheriff_to_player_1_dialogue: Dialogue

@export var return_zombie_to_sheriff_objective: Objective
@export var sheriff_to_player_2_dialogue: Dialogue

func _ready() -> void:
	super._ready()
	on_interact.connect(_on_interact)
	
	sheriff_to_player_1_dialogue.on_dialogue_complete.connect(_on_sheriff_first_spoken_to)
	sheriff_to_player_2_dialogue.on_dialogue_complete.connect(_on_bounty_complete)

func _on_interact():
	if speak_to_sheriff_objective.in_progress and not speak_to_sheriff_objective.completed and not player_to_sheriff_1_dialogue.has_started:
		dialogue_manager.start_dialogue(player_to_sheriff_1_dialogue)
	elif return_zombie_to_sheriff_objective.in_progress and not sheriff_to_player_2_dialogue.has_started and not return_zombie_to_sheriff_objective.completed:
		dialogue_manager.start_dialogue(sheriff_to_player_2_dialogue)

func _on_sheriff_first_spoken_to():
	speak_to_sheriff_objective.complete_objective()

func _on_bounty_complete():
	print("TODO: Give reward")
