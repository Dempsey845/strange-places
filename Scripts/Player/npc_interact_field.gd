class_name NPCInteractField extends Area2D

@onready var disruption_manager: DisruptionManager = get_tree().current_scene.get_disruption_manager()

@warning_ignore("unused_signal")
signal on_no_npcs_chasing_player

@warning_ignore("unused_signal")
signal on_npc_chase

static var npcs_chasing_player: Array[int]

static var Instance: NPCInteractField

func _ready() -> void:
	Instance = self
	
func _exit_tree() -> void:
	Instance = null
	npcs_chasing_player.clear()

func _on_body_entered(body: Node2D) -> void:
	var npc = body
	
	if disruption_manager.disruption_level > 20 and not DialogueManager.in_dialogue and npc.state == npc.AI_STATE.Wander and npc.can_agro:
		npc.chase_target = get_parent()
		npc.state = npc.AI_STATE.Chase
		if len(npcs_chasing_player) == 0:
			on_npc_chase.emit()
		
		npcs_chasing_player.append(npc.get_instance_id())
