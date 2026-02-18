extends BaseZone

@export var collect_beans_objective: Objective
@export var dialogue_manager: DialogueManager
@export var dialogue_player1: Dialogue
@export var inventory_manager: InventoryManager

const COFFEE_BEANS_ITEM = preload("res://Scenes/Inventory/coffee_beans_item.tscn")

func _ready() -> void:
	super._ready()
	on_interact.connect(_on_interact)
	
	dialogue_player1.on_next_dialogue_complete.connect(_on_dialgoue_player1_fully_complete)

func _on_interact():
	if not collect_beans_objective.in_progress:
		return
		
	dialogue_manager.start_dialogue(dialogue_player1)
	
func _on_dialgoue_player1_fully_complete():
	collect_beans_objective.complete_objective()
	await get_tree().create_timer(1.5).timeout
	inventory_manager.add_item_to_inventory(COFFEE_BEANS_ITEM)
