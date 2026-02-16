class_name NPC extends CharacterBody2D

@onready var nav_agent: NavigationAgent2D = %NavAgent
@onready var wander_wait_timer: Timer = %WanderWaitTimer
@onready var chase_update_timer: Timer = %ChaseUpdateTimer
@onready var chase_throw_cooldown_timer: Timer = %ChaseThrowCooldownTimer
@onready var npc_sprite: NPCSprite = %NPCSprite
@onready var melee_attack_area: Area2D = %MeleeAttackArea

@export var speed: float = 150.0

@export_category("Chase")
@export var chase_target: Node2D = null

@export var melee_attack_distance: float = 45.0
@onready var melee_attack_distance_sq = melee_attack_distance * melee_attack_distance

@export var max_chase_distance: float = 300.0
@onready var max_chase_distance_sq = max_chase_distance * max_chase_distance

@export var projectile_packed_scene: PackedScene

enum AI_STATE {
	Wander,
	Chase
}

enum ATTACK_STATE
{
	Melee,
	Throw
}

var is_navigating = false
var state := AI_STATE.Wander
var attack_state := ATTACK_STATE.Melee

var game_manager: GameManager

func _ready():
	nav_agent.velocity_computed.connect(_on_velocity_computed)
	
	if not game_manager:
		game_manager = get_tree().current_scene

func _process(_delta: float) -> void:
	match (state):
		AI_STATE.Wander:
			_wander()
		AI_STATE.Chase:
			_chase()
			_handle_attack_state()
	
	is_navigating = _handle_navigation()
	npc_sprite.is_moving = is_navigating

func _handle_attack_state():
	match (attack_state):
		ATTACK_STATE.Melee:	
			nav_agent.target_position = global_position
			npc_sprite.direction = global_position.direction_to(chase_target.global_position)
			npc_sprite.play_melee_attack()
		ATTACK_STATE.Throw:
			if chase_throw_cooldown_timer.is_stopped():
				var projectile: Projectile = projectile_packed_scene.instantiate()
				projectile.global_position = global_position
				projectile.direction = global_position.direction_to(chase_target.global_position)
				get_tree().current_scene.add_child(projectile)
				chase_throw_cooldown_timer.start()

func _change_attack_state(new_state: ATTACK_STATE):
	if new_state == attack_state:
		return
	
	match new_state:
		ATTACK_STATE.Throw:
			chase_throw_cooldown_timer.start()
	
	attack_state = new_state

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
		elif distance_to_target < melee_attack_distance_sq:
			_change_attack_state(ATTACK_STATE.Melee)
		else:
			_change_attack_state(ATTACK_STATE.Throw)
			
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

func _on_melee_attack_check_timer_timeout() -> void:
	var overlapping_areas = melee_attack_area.get_overlapping_areas()
	if overlapping_areas.size() > 0:
		var player_hitbox: PlayerHitbox = overlapping_areas[0]
		player_hitbox.take_damage(1)
