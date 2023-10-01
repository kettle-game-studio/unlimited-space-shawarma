extends Node3D
class_name Item

signal picked

@export var item_data: ItemData
@export var top_point: Node3D
@export var activator: Area3D

@export var get_sound: AudioStreamPlayer3D

var item_name: String : get = _get_item_name

func _get_item_name() -> String:
	return item_data.item_name

func go_to(node: Node3D, other: Item = null) -> void:
	# print("go_to node = ", node, "item_name = ", item_name)
	# if other:
	# 	print("other = ", other.item_name)
		
	var parent = self.get_parent()
	var global_origin = self.global_transform.origin
	
	#self.global_transform.origin = node.global_transform.origin
	self.reparent(node, true)
	self.transform = Transform3D()
	
	if other != null:
		other.go_to(parent)
		other.global_transform.origin = global_origin
		if parent.has_method("on_item_swap"):
			parent.on_item_swap(other)
	elif parent is FloatingItemLocation:
		parent.queue_free()
	if other == null && !(node is FloatingItemLocation):
		get_sound.play()	
	
func _activated(player: Player):
	var parent = self.get_parent()
	if parent.has_method("can_take_item") and !parent.can_take_item(player):
		return
		
	picked.emit()
	
	var hand = player.item_manager.hand
	go_to(hand, player.item_manager.item_in_hand)
	self.transform = Transform3D()
	player.item_manager.item_in_hand = self

func get_hint(_player: Player) -> String:
	return "Take %s" % item_name

func set_pickable(value: bool) -> void:
	if value:
		activator.collision_layer = 1
	else:
		activator.collision_layer = 0
