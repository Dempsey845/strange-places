class_name SequencedDisruptiveAnimationVFX extends Node2D

@export var start_animated_sprite: AnimatedSprite2D
@export var loop_animated_sprite: AnimatedSprite2D
@export var end_animated_sprite: AnimatedSprite2D

@export var start_on_disrupted = true
@export var stop_on_fixed = true

@export var delay = 0.0

func _ready() -> void:
	_hide_all()

	var parent = get_parent()
	if parent.has_method("disrupt"):
		if start_on_disrupted:
			parent.on_disrupted.connect(play)
		if stop_on_fixed:
			parent.on_fixed.connect(stop)
	
	start_animated_sprite.animation_finished.connect(_loop)
	end_animated_sprite.animation_finished.connect(_finish)
	
func play():
	_hide_all()
	
	await get_tree().create_timer(delay).timeout
	
	start_animated_sprite.visible = true
	start_animated_sprite.play("default")
	
func stop():
	loop_animated_sprite.visible = false
	end_animated_sprite.visible = true
	end_animated_sprite.play("default")

func _hide_all():
	start_animated_sprite.visible = false
	loop_animated_sprite.visible = false
	end_animated_sprite.visible = false

func _loop():
	start_animated_sprite.visible = false
	loop_animated_sprite.visible = true
	
	loop_animated_sprite.play("default")

func _finish():
	end_animated_sprite.visible = false
