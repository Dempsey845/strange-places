class_name ObjectiveManager extends Node

@export var objective_label: Label

var current_objective: Objective

@onready var first_objective: Objective = get_child(6)

func _ready() -> void:
	first_objective.start_objective()

func start_current_objective():
	# Update objective UI
	objective_label.text = current_objective.objective_text

func complete_current_objective():
	# Update objective UI
	objective_label.text = ""
