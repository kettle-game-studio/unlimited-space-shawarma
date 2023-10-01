extends Resource
class_name ItemData

@export var item_name: String
@export var icon: Texture
@export_file("*.tscn")  var prefab: String

func get_prefab() -> PackedScene:
	return load(prefab)
