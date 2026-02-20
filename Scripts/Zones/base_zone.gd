class_name BaseZone extends Area2D

signal on_interact

var in_area := false


func _ready() -> void:
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)

func _on_area_entered(_area: Area2D) -> void:
	in_area = true

func _on_area_exited(_area: Area2D) -> void:
	in_area = false
	
func _process(_delta: float) -> void:
	if in_area and len(NPCInteractField.npcs_chasing_player)==0 and Input.is_action_just_pressed("interact"):
		on_interact.emit()
