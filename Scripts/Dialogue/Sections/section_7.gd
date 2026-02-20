class_name SectionSeven extends Node

@onready var general_to_player_1: Dialogue = %GeneralToPlayer1
@onready var player_to_general_1: Dialogue = %PlayerToGeneral1
@onready var general_to_player_2: Dialogue = %GeneralToPlayer2
@onready var general_to_player_3: Dialogue = %GeneralToPlayer3

@onready var objective_16_find_general: Objective = %Objective16_FindGeneral
@onready var objective_17_fight: Objective = %Objective17_Fight
@onready var objective_18_speak_to_general: Objective = %Objective18_SpeakToGeneral
@onready var objective_19_enter_the_ship: Objective = %Objective19_EnterTheShip

@onready var soldier_manager: SoldierManager = %SoldierManager

@onready var player: Player = %Player

var completed_fight := false

func _ready() -> void:
	general_to_player_2.on_dialogue_complete.connect(_start_fight)
	general_to_player_3.on_dialogue_complete.connect(func(): objective_18_speak_to_general.complete_objective())

func _start_fight():
	soldier_manager.start_chase_and_shoot()
	objective_17_fight.start_objective()
	player.unlock_shoot()
	$SoldierCountCheckTimer.start()

func _on_soldier_count_check_timer_timeout() -> void:
	if not completed_fight and soldier_manager.get_soldier_count() <= 0 :
		objective_18_speak_to_general.start_objective()
		completed_fight = true
