extends Node3D

@export var player: Node3D
@export var camera: Camera3D

@export var camera_speed: float = 0.01

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event: InputEvent):
	if event is InputEventMouseMotion:
		rotate_camera(event.relative)	

func rotate_camera(vector: Vector2):
	camera.rotation.x = clamp(camera.rotation.x - vector.y * camera_speed, -PI/2, PI/2)
	player.rotate_y(-vector.x * camera_speed)
