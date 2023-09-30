extends Node3D
class_name Item

@export var item_name: String
@export var top_point: Node3D
@export var activator: Area3D

signal picked

func go_to(node: Node3D, other: Item = null) -> void:
	var parent = self.get_parent()
	var tr = self.transform
	
	self.global_transform.origin = node.global_transform.origin
	self.reparent(node, true)
	
	if other != null:
		other.go_to(parent)
		other.transform = tr
	elif parent is FloatingItemLocation:
		parent.queue_free()

func _activated(player: Player):
	var hand = player.item_manager.hand
	go_to(hand, player.item_manager.item_in_hand)
	self.transform = Transform3D()
	player.item_manager.item_in_hand = self
	picked.emit()

func get_hint(_player: Player) -> String:
	return "Take %s" % item_name

func set_pickable(value: bool) -> void:
	if value:
		activator.collision_layer = 1
	else:
		activator.collision_layer = 0
