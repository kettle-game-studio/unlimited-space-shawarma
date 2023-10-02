extends Node3D
class_name LineCount

@export var lines: Array[Node3D]

func set_lines(count: int) -> void:
	for i in lines.size():
		lines[i].visible = i < count
