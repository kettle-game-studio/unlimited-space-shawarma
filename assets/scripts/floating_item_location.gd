extends Node3D
class_name FloatingItemLocation

var speed: float;
var start_position: Vector3
var start_rotation: Vector3
var time: float = 0;
var salt: float

func _ready():
	var rng = RandomNumberGenerator.new()
	salt = rng.randf_range(-PI, PI)
	speed = rng.randf_range(0.1, 0.3)

func set_origin():
	start_position = self.transform.origin - make_position()
	start_rotation = self.rotation - make_rotation()

func _process(delta):
	time += delta
	self.transform.origin = self.start_position + self.make_position()
	self.rotation = self.start_rotation + self.make_rotation()

func make_position() -> Vector3:
	var t = self.time * self.speed
	return Vector3(sin(t), sin(t), 0)

func make_rotation() -> Vector3:
	var t = self.time * self.speed
	return Vector3(sin(t), salt, cos(t))
