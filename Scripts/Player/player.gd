class_name Player extends CharacterBody2D

signal on_death
signal on_damage_taken(h: int)

const SPEED := 200.0

var health: int = 5
var freezed := false

@export var dialogue_manager: DialogueManager
@onready var player_sprite: PlayerSprite = $PlayerSprite

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
