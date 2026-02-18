class_name Objective extends Node

signal on_complete
signal on_started

@export_multiline var objective_text := "Go to X"
@export var next_objective: Objective

var completed := false
var in_progress := false

@onready var objective_manager: ObjectiveManager = get_parent()

func start_objective():
	if in_progress or completed:
		return
	
	in_progress = true
	objective_manager.current_objective = self
	objective_manager.start_current_objective()
	on_started.emit()

func complete_objective():
	if completed:
		return
	
	completed = true
	in_progress = false
	objective_manager.complete_current_objective()
	if next_objective:
		next_objective.start_objective()
	else:
		objective_manager.current_objective = null
		print("All objectives complete!")
	on_complete.emit()
