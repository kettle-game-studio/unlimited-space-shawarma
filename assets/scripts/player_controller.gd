extends Node

@export var player: Player
@export var camera: Camera3D

@export var camera_speed: float = 0.01

func _input(event: InputEvent):
	if event is InputEventMouseMotion:
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			rotate_camera(event.relative)
	elif event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	if Input.is_action_just_pressed("Escape"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	if Input.is_action_just_pressed("Eat"):
		var item = player.item_manager.item_in_hand
		if item && item.item_data.food > 0:
			player.items_eaten += 1
			player.item_manager.destroy_current_item()

func rotate_camera(vector: Vector2):
	camera.rotation.x = clamp(camera.rotation.x - vector.y * camera_speed, -PI/2, PI/2)
	player.rotate_y(-vector.x * camera_speed)
