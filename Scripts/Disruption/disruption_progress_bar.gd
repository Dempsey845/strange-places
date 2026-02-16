extends ProgressBar

@onready var disruption_manager: DisruptionManager = %DisruptionManager

func _process(delta: float) -> void:
	value = disruption_manager.disruption_level
