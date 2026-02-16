class_name DisruptiveAnimatedSprite extends AnimatedSprite2D

signal finished

@export var hide_on_ready = true
@export var unhide_on_play = true
@export var hide_on_finished = true
@export var hide_on_stop = false

func _ready() -> void:
	animation_finished.connect(_on_animation_finished)
	
	if hide_on_ready:
		visible = false

func _on_animation_finished() -> void:
	if hide_on_finished:
		visible = false
	finished.emit()

func play_anim(anim_name: String):
	if unhide_on_play:
		visible = true
	play(anim_name)
	
func stop_anim():
	stop()
	
	if hide_on_stop:
		visible = false
