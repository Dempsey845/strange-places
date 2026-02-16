class_name NPC extends CharacterBody2D

@onready var nav_agent: NavigationAgent2D = %NavAgent
@onready var wander_wait_timer: Timer = %WanderWaitTimer
@onready var npc_sprite: NPCSprite = %NPCSprite

@export var speed: float = 100.0
@export var game_manager: GameManager

enum AI_STATE {
	Wander,
	Chase
}

var is_navigating = false
var state := AI_STATE.Wander

func _ready():
	nav_agent.velocity_computed.connect(_on_velocity_computed)

func _process(_delta: float) -> void:
	match (state):
		AI_STATE.Wander:
			if nav_agent.target_position == Vector2.ZERO:
				nav_agent.target_position = game_manager.get_random_nav_point(nav_agent)
			elif not is_navigating and wander_wait_timer.is_stopped():
				wander_wait_timer.start()
				await wander_wait_timer.timeout
				nav_agent.target_position = game_manager.get_random_nav_point(nav_agent)
			
	is_navigating = _handle_navigation()
	npc_sprite.is_moving = is_navigating

func _handle_navigation():
	if nav_agent.is_navigation_finished():
		velocity = Vector2.ZERO
		return false

	var next_path_position = nav_agent.get_next_path_position()
	var direction = (next_path_position - global_position).normalized()
	npc_sprite.direction = direction
	velocity = direction * speed
	
	move_and_slide()
	return true


func _on_velocity_computed(safe_velocity: Vector2):
	velocity = safe_velocity
	move_and_slide()
