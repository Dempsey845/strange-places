class_name Dialogue extends Node

@warning_ignore("unused_signal")
signal on_next_dialogue_complete
@warning_ignore("unused_signal")
signal on_dialogue_complete

@export var dialogue_text: Array[String]
@export var time_between_text := 1.0
@export var next_dialogue: Dialogue
@export var time_between_next_dialogue := 1.5
@export var freeze_player := true
@export var auto_continue := true

var has_started := false
