extends Area2D

func _on_body_entered(body: Node2D) -> void:
	var npc: NPC = body
	
	if npc.state == npc.AI_STATE.Wander:
		npc.chase_target = get_parent()
		npc.state = npc.AI_STATE.Chase
