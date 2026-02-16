extends ProgressBar

@onready var disruption_manager: DisruptionManager = %DisruptionManager

func _process(_delta: float) -> void:
	value = disruption_manager.disruption_level
