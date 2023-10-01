extends Node3D

@export var number: int = 1

func _ready():
	var children = self.get_children()
	randomize()
	children.shuffle()
	for i in children.size():
		children[i].visible = i < number
