class_name Projectile extends Area2D

@export var damage: int = 1
@export var speed: float = 300.0

var direction: Vector2

func _ready() -> void:
	look_at(direction)

func _process(delta: float) -> void:
	global_position += direction * speed * delta

func _on_area_entered(area: Area2D) -> void:
	if area.has_method("take_damage"):
		area.take_damage(damage)
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if not body.has_method("take_damage"):
		queue_free()

func _on_life_timer_timeout() -> void:
	queue_free()
