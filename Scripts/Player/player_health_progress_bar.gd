extends ProgressBar

@onready var player: Player = %Player

func _ready() -> void:
	player.on_damage_taken.connect(_update_progress_bar)
	max_value = player.health
	value = player.health
	
func _update_progress_bar(h: int):
	value = h
