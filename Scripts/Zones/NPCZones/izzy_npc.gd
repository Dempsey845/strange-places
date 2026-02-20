extends BaseZone

@export var section_six: SectionSix

func _ready() -> void:
	super._ready()
	
	on_interact.connect(_on_interact)
	
func _on_interact():
	if not section_six.objective_enter_base.in_progress or section_six.izzy_to_player_1.has_started:
		return
	
	section_six.dialogue_manager.start_dialogue(section_six.izzy_to_player_1)
