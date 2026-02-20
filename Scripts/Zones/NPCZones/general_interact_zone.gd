extends BaseZone

@export var section_seven: SectionSeven
@export var dialogue_manager: DialogueManager

func _ready() -> void:
	super._ready()
	
	on_interact.connect(_on_interact)
	
func _on_interact():
	if section_seven.objective_16_find_general.in_progress and not section_seven.general_to_player_1.has_started:
		dialogue_manager.start_dialogue(section_seven.general_to_player_1)
	elif section_seven.objective_18_speak_to_general.in_progress and not section_seven.general_to_player_3.has_started:
		dialogue_manager.start_dialogue(section_seven.general_to_player_3)
	
