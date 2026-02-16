class_name NPCSprite extends AnimatedSprite2D

@export var melee_animation_frame_count: int = 5
@export var melee_animation_fps: float = 10.0
@export var melee_animation_attack_check_frame: int = 3

@onready var melee_animation_duration: float = melee_animation_frame_count / melee_animation_fps
@onready var melee_attack_check_timer: Timer = %MeleeAttackCheckTimer

var direction: Vector2

var current_animation := "front_idle"
var direction_state = "front"

var is_moving := false

var state = "idle"

func _physics_process(_delta: float) -> void:
	state = ("walk" if is_moving else "idle") if state!="melee_attack" else "melee_attack"
	_update_direction()
	
	play(direction_state+"_"+state)

func _update_direction():
	if (abs(direction.y) > abs(direction.x)):
		if direction.y > 0:
			direction_state = "front"
		elif direction.y < 0:
			direction_state = "back"
	else:
		if direction.x > 0:
			direction_state = "right"
		elif direction.x < 0:
			direction_state = "left"

func play_melee_attack():
	state = "melee_attack"
	melee_attack_check_timer.start(melee_animation_attack_check_frame/melee_animation_fps)
	await get_tree().create_timer(melee_animation_duration).timeout
	state = "idle"
