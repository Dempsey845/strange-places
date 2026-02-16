class_name DisruptiveProp extends Area2D

signal on_disrupted
signal on_fixed

@onready var fix_timer: Timer = %FixTimer
@onready var disruption_manager: DisruptionManager = get_tree().current_scene.get_disruption_manager()

@export var min_disruption_level := 10 # Minimum level of disruption for this item to be 'disrupted'
@export var automatic_fix := true
@export var fix_time := 10.0

var is_disrupted := false

func disrupt():
	if is_disrupted:
		return
	
	is_disrupted = true
	on_disrupted.emit()
	
	if automatic_fix:
		fix_timer.start(fix_time)

func fix():
	if not is_disrupted:
		return
	
	is_disrupted = false
	on_fixed.emit()

func _on_fix_timer_timeout() -> void:
	fix()

func _on_area_entered(_area: Area2D) -> void:
	if disruption_manager.disruption_level >= min_disruption_level:
		disrupt()
