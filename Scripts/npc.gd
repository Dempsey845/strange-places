class_name NPC extends CharacterBody2D

@onready var nav_agent: NavigationAgent2D = %NavAgent
@onready var wander_wait_timer: Timer = %WanderWaitTimer
@onready var chase_update_timer: Timer = %ChaseUpdateTimer
@onready var npc_sprite: NPCSprite = %NPCSprite

@export var speed: float = 150.0
@export var game_manager: GameManager
@export var chase_target: Node2D = null
@export var max_chase_distance: float = 300.0
@onready var max_chase_distance_sq = max_chase_distance * max_chase_distance

enum AI_STATE {
	Wander,
	Chase
}

var is_navigating = false
var state := AI_STATE.Chase


func _ready():
	nav_agent.velocity_computed.connect(_on_velocity_computed)

func _process(_delta: float) -> void:
	match (state):
		AI_STATE.Wander:
			_wander()
		AI_STATE.Chase:
			_chase()
			
			
	is_navigating = _handle_navigation()
	npc_sprite.is_moving = is_navigating

func _chase():
	if chase_target == null:
		state = AI_STATE.Wander
		return
	
	if chase_update_timer.is_stopped():
		nav_agent.target_position = chase_target.global_position
		var distance_to_target = global_position.distance_squared_to(chase_target.global_position)
		if distance_to_target > max_chase_distance_sq:
			state = AI_STATE.Wander
			return
			
		chase_update_timer.start()

func _wander():
	if nav_agent.target_position == Vector2.ZERO:
		nav_agent.target_position = game_manager.get_random_nav_point(nav_agent)
	elif not is_navigating and wander_wait_timer.is_stopped():
		wander_wait_timer.start()
		await wander_wait_timer.timeout
		nav_agent.target_position = game_manager.get_random_nav_point(nav_agent)

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
