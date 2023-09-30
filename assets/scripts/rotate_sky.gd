extends Node

@export var sky: WorldEnvironment
@export var rotation_speed: Vector3

func _process(delta):
	sky.environment.sky_rotation += delta * rotation_speed
