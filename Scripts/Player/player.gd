class_name Player extends CharacterBody2D

signal on_death
signal on_damage_taken(h: int)

const SPEED := 200.0

var health: int = 10
var freezed := false

var shoot_locked := true

@export var dialogue_manager: DialogueManager
@onready var player_sprite: PlayerSprite = $PlayerSprite
@onready var crosshair: Control = %Crosshair


const PLAYER_PROJECTILE = preload("res://Scenes/Projectiles/player_projectile.tscn")

func _ready() -> void:
	if not dialogue_manager:
		push_warning("Player not assigned dialogue manager! This will cause issues with freezing the player on dialogues.")
		return
		
	dialogue_manager.on_dialogue_started.connect(func(d: Dialogue): freezed = d.freeze_player)
	dialogue_manager.on_dialogue_ended.connect(func(_d: Dialogue): freezed = false)

func _physics_process(_delta: float) -> void:
	if freezed:
		velocity = Vector2.ZERO
		player_sprite.is_moving = false
		return
	
	var direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * SPEED
	player_sprite.direction = direction
	player_sprite.is_moving = velocity != Vector2.ZERO
	move_and_slide()
	
func _process(_delta: float) -> void:
	if shoot_locked or not %ShootRateTimer.is_stopped():
		return
	
	if Input.is_action_just_pressed("shoot"):
		var projectile = PLAYER_PROJECTILE.instantiate()
		projectile.global_position = global_position
		projectile.shot_from = Projectile.SHOT_FROM.Player
		projectile.direction = global_position.direction_to(get_global_mouse_position())
		get_tree().current_scene.add_child(projectile)
		%ShootRateTimer.start()

func take_damage(damage: int):
	player_sprite.play_hurt_animation()
	health -= damage
	
	on_damage_taken.emit(health)
	
	if health <= 0:
		on_death.emit()
		queue_free()

func shape_shift_into_soldier():
	player_sprite.visible = false
	player_sprite.shape_shifted = true
	%PlayerSoldierSprite.visible = true

func unlock_shoot():
	shoot_locked = false
	crosshair.visible = true
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and not shoot_locked:
		crosshair.position = event.position

func _exit_tree() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
