extends Node3D
class_name Notes

@export var items: Array[ItemData]
@export var notes: Array[Node3D]

func _ready():
	for i in items.size():
		notes[i].visible = false

func _item_placed(item: ItemData) -> bool:
	for i in items.size():
		if notes[i].visible:
			return true
	return false

func _on_item_placed(item: ItemData):
	for i in items.size():
		if items[i].item_name == item.item_name:
			notes[i].visible = true
