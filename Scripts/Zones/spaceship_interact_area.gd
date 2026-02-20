extends BaseZone

@onready var objective_19_enter_the_ship: Objective = %Objective19_EnterTheShip

var interacted = false

@onready var fade_canvas_layer: FadeCanvasLayer = %FadeCanvasLayer

func _ready() -> void:
	super._ready()
	
	on_interact.connect(_on_interact)

func _on_interact():
	if objective_19_enter_the_ship.in_progress and not interacted:
		interacted = true
		fade_canvas_layer.fade_out()
