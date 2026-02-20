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
var waiting_for_input := false

static var in_dialogue := false

func _ready() -> void:
	#start_dialogue($MasterDialogues/IntroDialogue)
	pass

func start_dialogue(dialogue: Dialogue, _prev_dialogue: Dialogue = null) -> void:
	on_dialogue_started.emit(dialogue)
	dialogue_animation_player.play("open")
	dialogue.has_started = true
	in_dialogue = true
	await dialogue_animation_player.animation_finished
	
	for text in dialogue.dialogue_text:
		await type_text(text)
		
		if dialogue.auto_continue:
			await get_tree().create_timer(dialogue.time_between_text).timeout
		else:
			waiting_for_input = true
			await wait_for_continue_input()
			waiting_for_input = false
		
		await untype_text()
	
	dialogue_animation_player.play("close")
	
	if dialogue.next_dialogue:
		await get_tree().create_timer(dialogue.time_between_next_dialogue).timeout
		start_dialogue(dialogue.next_dialogue, dialogue)
	else:
		if _prev_dialogue:
			_prev_dialogue.on_next_dialogue_complete.emit()
		dialogue.on_dialogue_complete.emit()
		on_dialogue_ended.emit(dialogue)
		in_dialogue = false


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


func wait_for_continue_input() -> void:
	await get_tree().process_frame
	while waiting_for_input:
		await get_tree().process_frame


func _input(event):
	# Skip typing
	#if event.is_action_pressed("skip") and is_typing:
		#skip_requested = true
	
	# Manual continue (per dialogue)
	if waiting_for_input and event.is_action_pressed("skip"):
		waiting_for_input = false
