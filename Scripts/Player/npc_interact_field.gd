extends Area2D

@onready var disruption_manager: DisruptionManager = get_tree().current_scene.get_disruption_manager()

func _on_body_entered(body: Node2D) -> void:
	var npc: NPC = body
	
	if disruption_manager.disruption_level > 20 and npc.state == npc.AI_STATE.Wander and npc.can_agro:
		npc.chase_target = get_parent()
		npc.state = npc.AI_STATE.Chase
