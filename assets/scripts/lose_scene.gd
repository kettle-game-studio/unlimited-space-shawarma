extends CanvasLayer

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_button_pressed():
	get_tree().change_scene_to_file("res://assets/scenes/main_scene.tscn")
