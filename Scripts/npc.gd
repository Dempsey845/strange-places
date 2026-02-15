class_name NPC extends CharacterBody2D

@onready var nav_agent: NavigationAgent2D = %NavAgent

@export var speed: float = 100.0

func _ready():
	nav_agent.velocity_computed.connect(_on_velocity_computed)
	await get_tree().process_frame
	print("Agent map:", nav_agent.get_navigation_map())

func _process(_delta: float) -> void:
	if nav_agent.is_navigation_finished():
		velocity = Vector2.ZERO
		return

	var next_path_position = nav_agent.get_next_path_position()
	var direction = (next_path_position - global_position).normalized()
	velocity = direction * speed
	
	move_and_slide()

func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed:
		nav_agent.target_position = get_global_mouse_position()

func _on_velocity_computed(safe_velocity: Vector2):
	velocity = safe_velocity
	move_and_slide()
