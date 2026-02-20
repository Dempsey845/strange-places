class_name NPC extends CharacterBody2D

@onready var nav_agent: NavigationAgent2D = %NavAgent
@onready var wander_wait_timer: Timer = %WanderWaitTimer
@onready var chase_update_timer: Timer = %ChaseUpdateTimer
@onready var chase_throw_cooldown_timer: Timer = %ChaseThrowCooldownTimer
@onready var npc_sprite: NPCSprite = %NPCSprite
@onready var melee_attack_area: Area2D = %MeleeAttackArea

@export var speed: float = 150.0
var initial_speed: float

@export_category("Chase")
@export var can_agro := true
@export var chase_target: Node2D = null

@export var melee_attack_distance: float = 45.0
@onready var melee_attack_distance_sq = melee_attack_distance * melee_attack_distance

@export var max_chase_distance: float = 300.0
@onready var max_chase_distance_sq = max_chase_distance * max_chase_distance

@export var projectile_packed_scene: PackedScene

@export_category("Wander")
@export var mixed_wander := true # random + hot spots
@export var fixed_wander := false
@export var fixed_wander_points: Node2D
@onready var hot_spots: HotSpots = get_tree().current_scene.hot_spots
var last_hot_spot = null
var last_fixed_wander_point = null

enum AI_STATE {
	Wander,
	Chase,
	RunAway,
	Follow,
	Idle
}

enum ATTACK_STATE
{
	Melee,
	Throw
}

var is_navigating = false
var state := AI_STATE.Wander
var attack_state := ATTACK_STATE.Melee
var run_away_return_state := AI_STATE.Wander

var follow_destination: Marker2D = null

var game_manager: GameManager

func _ready():
	nav_agent.velocity_computed.connect(_on_velocity_computed)
	
	initial_speed = speed
	
	if not game_manager:
		game_manager = get_tree().current_scene

func _process(_delta: float) -> void:
	match (state):
		AI_STATE.Wander:
			_wander()
		AI_STATE.Chase:
			_chase()
			_handle_attack_state()
		AI_STATE.RunAway:
			_run_away()
		AI_STATE.Follow:
			_follow()
		AI_STATE.Idle:
			velocity = Vector2.ZERO
	
	is_navigating = _handle_navigation()
	npc_sprite.is_moving = is_navigating

func run_away(duration: float, return_state: AI_STATE, speed_multiplier: float = 1.0):
	run_away_return_state = return_state
	state = AI_STATE.RunAway
	
	speed *= speed_multiplier
	
	if chase_target != null:
		var direction = (global_position - chase_target.global_position).normalized()
		nav_agent.target_position = global_position + direction * max_chase_distance
	
	await get_tree().create_timer(duration).timeout
	
	if state == AI_STATE.RunAway:
		state = run_away_return_state
		speed = initial_speed

func follow_until_reached_destination(destination: Marker2D):
	if chase_target == null:
		return
		
	state = AI_STATE.Follow
	follow_destination = destination

func _run_away():
	if chase_target == null:
		state = run_away_return_state
		return
	
	if nav_agent.is_navigation_finished():
		var direction = (global_position - chase_target.global_position).normalized()
		nav_agent.target_position = global_position + direction * max_chase_distance

func _handle_attack_state():
	if chase_target == null:
		return
	
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

func _follow():
	if chase_target == null:
		state = AI_STATE.Idle
		return
	
	if chase_update_timer.is_stopped():
		nav_agent.target_position = chase_target.global_position
		
		if follow_destination:
			var distance_to_destination = global_position.distance_to(follow_destination.global_position)
			if distance_to_destination < 50:
				state = AI_STATE.Idle
				follow_destination = null
		
		chase_update_timer.start()

func _wander():
	if nav_agent.target_position == Vector2.ZERO:
		_next_wander_point()
	elif not is_navigating and wander_wait_timer.is_stopped():
		wander_wait_timer.start()
		await wander_wait_timer.timeout
		_next_wander_point()

func _next_wander_point():
	if state != AI_STATE.Wander:
		return
	
	if fixed_wander:
		var rand_wander_point = fixed_wander_points.get_children().pick_random()
		while  rand_wander_point == last_fixed_wander_point:
			rand_wander_point = fixed_wander_points.get_children().pick_random()
		nav_agent.target_position = rand_wander_point.global_position
		last_fixed_wander_point = rand_wander_point
		return
	
	var random_wander = not mixed_wander or randi() % 2 == 1
	
	if random_wander:
			nav_agent.target_position = game_manager.get_random_nav_point(nav_agent)
	else:
		if last_hot_spot == null:
			nav_agent.target_position = hot_spots.get_random_hot_spot(nav_agent)
		else:
			var next_hot_spot = hot_spots.get_random_hot_spot(nav_agent)
			while last_hot_spot != next_hot_spot:
				next_hot_spot = hot_spots.get_random_hot_spot(nav_agent)

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
