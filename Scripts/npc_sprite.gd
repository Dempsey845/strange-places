class_name NPCSprite extends AnimatedSprite2D

var direction: Vector2
var last_direction: Vector2

var current_animation := "front_idle"
var direction_state = "front"

var is_moving := false

func _physics_process(_delta: float) -> void:
		var move_state = "walk" if is_moving else "idle"
		
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
		
		play(direction_state+"_"+move_state)
