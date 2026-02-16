class_name DisruptionManager extends Node

@export var disruption_increment: float = 1
var disruption_level: float = 0.0 # 0 - 100

func _process(delta: float) -> void:
	disruption_level += delta * disruption_increment
	disruption_level = min(disruption_level, 100.0)
