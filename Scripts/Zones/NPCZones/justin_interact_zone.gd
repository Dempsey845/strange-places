extends BaseZone

@export var poach_justin_objective: Objective
@export var player_justin_dialogue_1: Dialogue
@export var dialogue_manager: DialogueManager
@export var justin_dialogue_2: Dialogue

@onready var justin_animated_sprite: AnimatedSprite2D = %JustinAnimatedSprite

func _ready() -> void:
	super._ready()
	on_interact.connect(_on_interact)
	
	justin_dialogue_2.on_dialogue_complete.connect(_on_justin_dialogue_complete)
	
func _on_interact():
	print("Interact")
	if not poach_justin_objective.in_progress or poach_justin_objective.completed or player_justin_dialogue_1.has_started:
		return
	
	justin_animated_sprite.play("idle")
	
	dialogue_manager.start_dialogue(player_justin_dialogue_1)

func _on_justin_dialogue_complete():
	justin_animated_sprite.play("idle_phone")
	poach_justin_objective.complete_objective()
