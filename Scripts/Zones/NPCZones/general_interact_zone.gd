extends BaseZone

func _ready() -> void:
	super._ready()
	
	on_interact.connect(_on_interact)
	
func _on_interact():
	return
