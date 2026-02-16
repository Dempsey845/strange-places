class_name Player extends CharacterBody2D

signal on_death
signal on_damage_taken(h: int)

const SPEED := 200.0

var health: int = 3

@onready var player_sprite: PlayerSprite = $PlayerSprite

func _physics_process(_delta: float) -> void:
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
