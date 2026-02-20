extends Label

@export var npc_interact_field: NPCInteractField

func _ready():
	npc_interact_field.on_no_npcs_chasing_player.connect(func(): visible = false)
	npc_interact_field.on_npc_chase.connect(func(): visible = true)
