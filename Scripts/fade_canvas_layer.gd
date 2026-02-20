class_name FadeCanvasLayer extends CanvasLayer

func fade_in():
	$AnimationPlayer.play("fade_in")
	
func fade_out():
	$AnimationPlayer.play("fade_out")
	await $AnimationPlayer.animation_finished
	SceneManager.change_scene("res://Scenes/menu.tscn")
