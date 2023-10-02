extends Node3D
class_name ShipsCount

@export var line_counts: Array[LineCount]
@export var header: Node3D

var lines: int = 0 

func _ready():
	set_count(0)

func inc_count():
	lines += 1
	set_count(lines)

func set_count(count: int) -> void:
	header.visible = count > 0
	
	var c = count
	for lc in line_counts:
		lc.set_lines(c)
		c -= 5
