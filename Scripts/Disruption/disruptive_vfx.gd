class_name DisruptiveVFX extends Node2D

@export var particle_effects: Array[CPUParticles2D] = []
@export var start_on_disrupted = true
@export var stop_on_fixed = true

func _ready() -> void:
	stop()
	
	var parent = get_parent()
	if parent.has_method("disrupt"):
		if start_on_disrupted:
			parent.on_disrupted.connect(play)
		if stop_on_fixed:
			parent.on_fixed.connect(stop)

func play():
	for particle_effect in particle_effects:
		particle_effect.emitting = true

func stop():
	for particle_effect in particle_effects:
		particle_effect.emitting = false
