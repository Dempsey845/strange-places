extends Label

@export var npc_interact_field: NPCInteractField

func _ready():
	npc_interact_field.on_no_npcs_chasing_player.connect(_on_no_npcs_chasing_player)
	npc_interact_field.on_npc_chase.connect(_on_npc_chase)
	
func _on_no_npcs_chasing_player():
	visible = false
	print("No more NPCs chasing the player.")
	
func _on_npc_chase():
	visible = true
	print("NPC chasing player.")
