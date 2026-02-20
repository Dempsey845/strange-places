class_name SoldierOneInteractZone extends BaseZone

signal on_knock_out_solider

@onready var section_five: SectionFive = get_tree().current_scene.get_node("%Section5")

enum SOLDIER_INTERACT_STATE 
{
	NotInteractedWith,
	InteractingWith,
	FollowingPlayer,
	WaitingForNextInteract,
	KnockedOut
}

var state := SOLDIER_INTERACT_STATE.NotInteractedWith

func _ready() -> void:
	super._ready()
	on_interact.connect(_on_interact)

func _on_interact():
	var parent: NPC = get_parent()
	match state:
		SOLDIER_INTERACT_STATE.NotInteractedWith:
			if section_five.player_to_soldier_1.has_started or not section_five.objective_find_a_solider.in_progress:
				return
			
			section_five.soldier_to_player_1.on_dialogue_complete.connect(_on_lure_soldier)
			_stop_moving(parent)
			section_five.dialogue_manager.start_dialogue(section_five.player_to_soldier_1)
			state = SOLDIER_INTERACT_STATE.InteractingWith
		SOLDIER_INTERACT_STATE.InteractingWith:
			pass
		SOLDIER_INTERACT_STATE.FollowingPlayer:
			pass
		SOLDIER_INTERACT_STATE.WaitingForNextInteract:
			_knock_out(parent)
		SOLDIER_INTERACT_STATE.KnockedOut:
			pass
	
func _on_lure_soldier():
	section_five.objective_find_a_solider.complete_objective()
	_start_follow_player(get_parent())
	
func _start_follow_player(parent: NPC):
	if not parent.chase_target:
		push_error("Soldier1NPC has not been assigned a chase_target (the player)")
	
	parent.state = NPC.AI_STATE.Follow
	state = SOLDIER_INTERACT_STATE.FollowingPlayer
	
func _stop_moving(parent: NPC):
	parent.state = NPC.AI_STATE.Idle
	parent.nav_agent.target_position = global_position
	parent.npc_sprite.is_moving = false
	parent.npc_sprite.direction = Vector2(0, 1)
	
func _knock_out(parent: NPC):
	parent.npc_sprite.enabled = false
	parent.npc_sprite.play("knocked_out")
	section_five.objective_shapeshift.complete_objective()
	on_knock_out_solider.emit()

func _on_check_position_timer_timeout() -> void:
	if state == SOLDIER_INTERACT_STATE.FollowingPlayer and section_five.has_reached_alleyway(global_position):
		_stop_moving(get_parent())
		state = SOLDIER_INTERACT_STATE.WaitingForNextInteract
		section_five.objective_lure_soldier.complete_objective()
