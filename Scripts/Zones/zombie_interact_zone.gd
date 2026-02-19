extends BaseZone

const RUN_AWAY_DURATION = 5.0
const RUN_AWAY_SPEED_MULTIPLIER = 1.25

var has_run_away := false
var is_running_away := false

var section_three: SectionThree
var dialogue_manager: DialogueManager

func _ready() -> void:
	super._ready()
	
	on_interact.connect(_on_interact)
	
	section_three = get_tree().current_scene.get_node("%Section3")
	dialogue_manager = get_tree().current_scene.get_node("%DialogueManager")
	
	await get_tree().create_timer(5.0).timeout
	
	section_three.zombie_to_player_1.on_dialogue_complete.connect(_on_zombie_to_player_dialogue_complete)
	section_three.sheriff_to_player_2.on_dialogue_complete.connect(_on_sheriff_to_player_dialogue_complete)

func _on_interact():
	var parent: NPC = get_parent()
	if not has_run_away and section_three.objective_find_the_zombie.in_progress:
		parent.run_away(RUN_AWAY_DURATION, NPC.AI_STATE.Idle, RUN_AWAY_SPEED_MULTIPLIER)
		section_three.objective_find_the_zombie.complete_objective()
		
		has_run_away = true
		is_running_away = true
		
		get_tree().create_timer(RUN_AWAY_DURATION).timeout.connect(_on_run_away_finished)
	elif not is_running_away and section_three.objective_9_catch_the_zombie.in_progress and not section_three.player_to_zombie_1.has_started and parent.nav_agent.is_navigation_finished():
		dialogue_manager.start_dialogue(section_three.player_to_zombie_1)
		
func _on_run_away_finished():
	is_running_away = false

func _on_zombie_to_player_dialogue_complete():
	var parent: NPC = get_parent()
	parent.follow_until_reached_destination(section_three.sheriff_marker)
	section_three.objective_9_catch_the_zombie.complete_objective()

func _on_sheriff_to_player_dialogue_complete():
	var parent: NPC = get_parent()
	parent.state = NPC.AI_STATE.Idle
	section_three.objective_10_return_the_zombie_to_the_sheriff.complete_objective()
