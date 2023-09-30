extends Node3D
class_name Item

@export var item_name: String

func go_to(node: Node3D) -> void:
	var parent = self.get_parent()
	self.global_transform.origin = node.global_transform.origin
	self.reparent(node, true)
	if parent is FloatingItemLocation:
		parent.queue_free()

func _activated(player: Player):
	var hand = player.item_manager.hand
	player.item_manager.item_in_hand = self
	go_to(hand)

func get_hint(_player: Player) -> String:
	return "Take %s" % item_name
