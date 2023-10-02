extends Node
class_name ItemManager

@export var hand: Node3D
@export var player: Player
@export var tree_data: ItemData

var item_in_hand: Item : set = _set_item_in_hand

func _set_item_in_hand(item: Item):
	item_in_hand = item
	if item && item.item_data.item_name == tree_data.item_name:
		player.trees_taken += 1

func item_is(item_name: String) -> bool:
	return item_in_hand && item_in_hand.item_name == item_name

func destroy_current_item() -> void:
	if !item_in_hand:
		return
	item_in_hand.queue_free()
	item_in_hand = null
