class_name Player extends CharacterBody2D

const SPEED = 500.0

@onready var player_sprite: PlayerSprite = $PlayerSprite

func _physics_process(_delta: float) -> void:
	var direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * SPEED
	player_sprite.direction = direction
	player_sprite.is_moving = velocity != Vector2.ZERO
	move_and_slide()
