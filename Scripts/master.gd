extends Node

@export var dialogue_manager: DialogueManager

@onready var intro_dialogue: Dialogue = %IntroDialogue
@onready var objective_1_buy_a_coffee: Objective = %Objective1_BuyACoffee

@export var deliver_beans_objective: Objective
@export var cash_dialogue: Dialogue

@export var collect_reward_objective: Objective
@export var police_dialogue: Dialogue

@export var speak_to_sheriff_objective: Objective
@export var return_zombie_to_sheriff: Objective

@export var battery_dialogue: Dialogue
@export var objective_purchase_batteries: Objective

@export var military_dialogue: Dialogue

@onready var objective_12_find_a_solider: Objective = %Objective12_FindASolider

func _ready() -> void:
	intro_dialogue.on_dialogue_complete.connect(func(): objective_1_buy_a_coffee.start_objective())
	
	deliver_beans_objective.on_complete.connect(_on_deliver_beans)
	collect_reward_objective.on_complete.connect(_on_collect_reward)
	
	police_dialogue.on_dialogue_complete.connect(_on_police_dialogue_complete)
	
	return_zombie_to_sheriff.on_complete.connect(_on_police_reward_given)
	
	battery_dialogue.on_dialogue_complete.connect(func(): objective_purchase_batteries.start_objective())
	objective_purchase_batteries.on_complete.connect(_on_purchase_batteries)
	military_dialogue.on_dialogue_complete.connect(_on_military_dialogue_complete)
	
func wait_until_safe():
	if len(NPCInteractField.npcs_chasing_player) > 0:
		await NPCInteractField.Instance.on_no_npcs_chasing_player

func _on_deliver_beans():
	await wait_until_safe()
	await get_tree().create_timer(2.0).timeout
	dialogue_manager.start_dialogue(cash_dialogue)

func _on_collect_reward():
	await wait_until_safe()
	await get_tree().create_timer(2.0).timeout
	dialogue_manager.start_dialogue(police_dialogue)


func _on_police_dialogue_complete():
	await wait_until_safe()
	await get_tree().create_timer(1.0).timeout
	speak_to_sheriff_objective.start_objective()

func _on_police_reward_given():
	await wait_until_safe()
	await get_tree().create_timer(2.0).timeout
	dialogue_manager.start_dialogue(battery_dialogue)

func _on_purchase_batteries():
	await wait_until_safe()
	await get_tree().create_timer(2.0).timeout
	dialogue_manager.start_dialogue(military_dialogue)

func _on_military_dialogue_complete():
	await wait_until_safe()
	objective_12_find_a_solider.start_objective()
