class_name ObjectiveManager extends Node

@export var objective_label: Label

var current_objective: Objective

@onready var first_objective: Objective = get_child(14)

func _ready() -> void:
	first_objective.start_objective()
	pass

func start_current_objective():
	# Update objective UI
	objective_label.text = current_objective.objective_text

func complete_current_objective():
	# Update objective UI
	objective_label.text = ""
