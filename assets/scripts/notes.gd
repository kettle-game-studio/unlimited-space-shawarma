extends Node3D

@export var items: Array[ItemData]
@export var notes: Array[Node3D]

func _ready():
	for i in items.size():
		notes[i].visible = false

func _on_item_placed(item: ItemData):
	for i in items.size():
		if items[i].item_name == item.item_name:
			notes[i].visible = true
