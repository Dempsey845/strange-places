extends BaseZone

@export var collect_beans_objective: Objective
@export var dialogue_manager: DialogueManager
@export var dialogue_player1: Dialogue
@export var inventory_manager: InventoryManager

@export var talk_to_bob_objective: Objective
@export var bob_job_dialogue: Dialogue
@export var collect_reward_objective: Objective
@export var dialogue_player5: Dialogue

const COFFEE_BEANS_ITEM = preload("res://Scenes/Inventory/coffee_beans_item.tscn")
const TWENTY_DOLLAR_BILL_ITEM = preload("res://Scenes/Inventory/twenty_dollar_bill_item.tscn")

func _ready() -> void:
	super._ready()
	on_interact.connect(_on_interact)
	
	dialogue_player1.on_next_dialogue_complete.connect(_on_dialogue_player1_fully_complete)
	dialogue_player5.on_next_dialogue_complete.connect(_on_dialogue_player5_fully_complete)

func _on_interact():
	if collect_beans_objective.in_progress and not dialogue_player1.has_started:
		dialogue_manager.start_dialogue(dialogue_player1)
	elif talk_to_bob_objective.in_progress and not bob_job_dialogue.has_started:
		await dialogue_manager.start_dialogue(bob_job_dialogue)
		talk_to_bob_objective.complete_objective()
	elif collect_reward_objective.in_progress and not dialogue_player5.has_started:
		dialogue_manager.start_dialogue(dialogue_player5)
		
func _on_dialogue_player1_fully_complete():
	collect_beans_objective.complete_objective()
	await get_tree().create_timer(1.0).timeout
	inventory_manager.add_item_to_inventory(COFFEE_BEANS_ITEM)

func _on_dialogue_player5_fully_complete():
	collect_reward_objective.complete_objective()
	await get_tree().create_timer(1.0).timeout
	inventory_manager.add_item_to_inventory(TWENTY_DOLLAR_BILL_ITEM)
