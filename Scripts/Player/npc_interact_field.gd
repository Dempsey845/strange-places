class_name NPCInteractField extends Area2D

@onready var disruption_manager: DisruptionManager = get_tree().current_scene.get_disruption_manager()

static var npcs_chasing_player: Array[int]

func _on_body_entered(body: Node2D) -> void:
	var npc = body
	
	if disruption_manager.disruption_level > 20 and not DialogueManager.in_dialogue and npc.state == npc.AI_STATE.Wander and npc.can_agro:
		npc.chase_target = get_parent()
		npc.state = npc.AI_STATE.Chase
		npcs_chasing_player.append(npc.get_instance_id())
