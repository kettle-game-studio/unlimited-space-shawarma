extends Node3D
class_name RandomPartPicker

@export var number: int = 1

var children: Array[Node]

func _ready():
	children = self.get_children()

func random_part():
	randomize()
	children.shuffle()
	for i in children.size():
		children[i].visible = i < number
	
