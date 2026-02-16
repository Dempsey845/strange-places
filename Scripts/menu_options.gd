extends VBoxContainer

@onready var menu: Node2D = $"../.."

func _on_play_button_pressed() -> void:
	menu.play()
