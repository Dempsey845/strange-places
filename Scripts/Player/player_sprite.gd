class_name PlayerSprite extends AnimatedSprite2D

var direction: Vector2
var last_direction: Vector2

var current_animation := "front_idle"
var direction_state = "front"

var is_moving := false

var state = "idle"

const HURT_ANIM_COUNT = 3
const HURT_ANIM_FPS = 10.0

var shape_shifted := false
@onready var player_soldier_sprite: AnimatedSprite2D = %PlayerSoldierSprite


func _physics_process(_delta: float) -> void:
		state = ("walk" if is_moving else "idle") if state!="hurt" else "hurt"
		
		if (abs(direction.x) > abs(direction.y)):
			if direction.x > 0:
				direction_state = "right"
			elif direction.x < 0:
				direction_state = "left"
		else:
			if direction.y > 0:
				direction_state = "front"
			elif direction.y < 0:
				direction_state = "back"
		
		if shape_shifted:
			player_soldier_sprite.play(direction_state+"_"+state)
		else:
			play(direction_state+"_"+state)

func play_hurt_animation():
	state = "hurt"
	await get_tree().create_timer(HURT_ANIM_COUNT/HURT_ANIM_FPS).timeout
	state = "idle"
