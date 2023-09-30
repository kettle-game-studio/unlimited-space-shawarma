extends Node
class_name ItemManager

@export var hand: Node3D

var item_in_hand: Item

func item_is(name: String) -> bool:
	return item_in_hand && item_in_hand.item_name == name

func destroy_current_item() -> void:
	if !item_in_hand:
		return
	item_in_hand.queue_free()
	item_in_hand = null
