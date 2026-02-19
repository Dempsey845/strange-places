extends BaseZone

@export var buy_a_coffee_objective: Objective
@export var dialogue_manager: DialogueManager
@export var dialogue_jimmy_1: Dialogue

@export var deliver_beans_objective: Objective
@export var dialogue_player_2: Dialogue
@export var inventory_manager: InventoryManager

func _ready() -> void:
	super._ready()
	on_interact.connect(_on_interact)
	
	dialogue_player_2.on_next_dialogue_complete.connect(_on_dialogue_player_2_next_dialogue_complete)

func _on_interact():
	if buy_a_coffee_objective.in_progress and not dialogue_jimmy_1.has_started:
		await dialogue_manager.start_dialogue(dialogue_jimmy_1)
		buy_a_coffee_objective.complete_objective()
	elif deliver_beans_objective.in_progress and not dialogue_player_2.has_started:
		dialogue_manager.start_dialogue(dialogue_player_2)
		

func _on_dialogue_player_2_next_dialogue_complete():
	deliver_beans_objective.complete_objective()
	inventory_manager.remove_item_from_inventory(Items.ItemName.CoffeeBeans)
