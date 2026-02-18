class_name DialogueManager extends Node

signal on_dialogue_started(dialogue: Dialogue)
signal on_dialogue_ended(dialogue: Dialogue)

@export var dialogue_icon: TextureRect
@export var dialogue_label: Label
@export var dialogue_animation_player: AnimationPlayer

var typing_speed := 0.04
var untyping_speed := 0.01
var is_typing := false
var skip_requested := false

func start_dialogue(dialogue: Dialogue, _prev_dialogue: Dialogue = null) -> void:
	on_dialogue_started.emit(dialogue)
	dialogue_animation_player.play("open")
	await dialogue_animation_player.animation_finished
	for text in dialogue.dialogue_text:
		await type_text(text)
		await get_tree().create_timer(dialogue.time_between_text).timeout
		await untype_text()
	dialogue_animation_player.play("close")
	
	if dialogue.next_dialogue:
		await get_tree().create_timer(dialogue.time_between_next_dialogue).timeout
		start_dialogue(dialogue.next_dialogue, dialogue)
	else:
		if _prev_dialogue:
			_prev_dialogue.on_next_dialogue_complete.emit()
		on_dialogue_ended.emit(dialogue)

func type_text(full_text: String) -> void:
	is_typing = true
	skip_requested = false
	
	dialogue_label.text = full_text
	dialogue_label.visible_characters = 0
	
	for i in full_text.length():
		if skip_requested:
			dialogue_label.visible_characters = full_text.length()
			break
		
		dialogue_label.visible_characters += 1
		await get_tree().create_timer(typing_speed).timeout
	
	is_typing = false


func untype_text() -> void:
	for i in dialogue_label.visible_characters:
		dialogue_label.visible_characters -= 1
		await get_tree().create_timer(untyping_speed).timeout
	
	dialogue_label.text = ""

func _input(event):
	if event.is_action_pressed("skip") and is_typing:
		skip_requested = true
