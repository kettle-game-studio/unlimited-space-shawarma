extends PathFollow3D
class_name SpaceShip

@export var speed: float = 0.1

var time = 0.0 

func _process(delta: float):
	time += delta * speed
	self.progress_ratio = clamp(1 - time, 0, 1)
