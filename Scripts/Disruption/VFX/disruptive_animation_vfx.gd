class_name DisruptiveAnimationVFX extends Node2D

@export var disruptive_animated_sprites: Array[DisruptiveAnimatedSprite] = []
@export var start_on_disrupted = true
@export var stop_on_fixed = false

func _ready() -> void:
	stop()

	var parent = get_parent()
	if parent.has_method("disrupt"):
		if start_on_disrupted:
			parent.on_disrupted.connect(play)
		if stop_on_fixed:
			parent.on_fixed.connect(stop)

func play():
	for sprite in disruptive_animated_sprites:
		sprite.play_anim("default")

func stop():
	for sprite in disruptive_animated_sprites:
		sprite.stop_anim()
