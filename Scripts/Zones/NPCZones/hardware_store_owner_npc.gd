extends BaseZone

@export var dialogue_manager: DialogueManager
@export var section_four: SectionFour
@export var inventory_manager: InventoryManager

var interacted := false

const BATTERY_ITEM = preload("uid://b3fqitrebj3ri")

func _ready() -> void:
	super._ready()
	
	on_interact.connect(_on_interact)
	
func _on_interact():
	if interacted:
		return
	
	if not section_four.objective_purchase_batteries.in_progress or section_four.objective_purchase_batteries.completed:
		return
	
	dialogue_manager.start_dialogue(section_four.sarah_to_player_1)
	inventory_manager.remove_item_from_inventory(Items.ItemName.TwentyDollarBill)
	inventory_manager.remove_item_from_inventory(Items.ItemName.FiftyDollarBill)
	
	section_four.player_to_sarah_2.on_dialogue_complete.connect(_on_dialogue_complete)
	
	
	interacted = true

func _on_dialogue_complete():
	inventory_manager.add_item_to_inventory(BATTERY_ITEM)
	await get_tree().create_timer(1.5).timeout
	section_four.objective_purchase_batteries.complete_objective()
	
