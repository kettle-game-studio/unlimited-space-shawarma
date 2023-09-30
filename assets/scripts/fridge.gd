extends Node
class_name Fridge

var floating_item_prefab = preload("res://assets/prefabs/floating_item_location.tscn")

func _activated(player: Player):
	var item = player.item_manager.item_in_hand;
	if item == null:
		return;
	
	var collision = player.player_raycast.fridgeRaycast.get_collision_point()
	var player_pos = player.global_transform.origin
	
	var vec = collision - player_pos
	
	var node = floating_item_prefab.instantiate()
	add_child(node)
	node.global_transform.origin = player_pos + vec * 1.3
	
	item.go_to(node)
	player.item_manager.item_in_hand = null;

func get_hint(player: Player) -> String:
	if player.item_manager.item_in_hand == null:
		return "Item storage"
	return "Store %s" % player.item_manager.item_in_hand.item_name
