extends Node

@export var animation_tree: AnimationTree

func _ready():
	animation_tree["parameters/conditions/is_open"] = true
