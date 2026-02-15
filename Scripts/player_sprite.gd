class_name PlayerSprite extends AnimatedSprite2D

var direction: Vector2
var last_direction: Vector2

var current_animation := "front_idle"
var direction_state = "front"

var is_moving := false

func _physics_process(_delta: float) -> void:
		var move_state = "walk" if is_moving else "idle"
		if direction.x > 0:
			direction_state = "right"
		elif direction.x < 0:
			direction_state = "left"
		
		if direction.y > 0:
			direction_state = "front"
		elif direction.y < 0:
			direction_state = "back"
		
		play(direction_state+"_"+move_state)
