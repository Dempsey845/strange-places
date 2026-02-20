class_name Item extends Control

@export var item_name: Items.ItemName
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var item_texture: TextureRect = %ItemTexture

func _ready() -> void:
	item_texture.texture = load(Items.ItemIcons[item_name])

func play_exit_animation():
	animation_player.play_backwards("entry")
	await animation_player.animation_finished
	call_deferred("queue_free")
