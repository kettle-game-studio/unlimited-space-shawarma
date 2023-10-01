extends Node3D
class_name ItemInMachine

@export var activator: Activator
@export var hint_postfix: String

var start_position: Vector3
var item: Item

signal picked
signal placed(Item)

func _ready():
	start_position = self.transform.origin

func instantiate_item(res: Resource) -> void:
	desctory_current()
	
	item = res.instantiate() as Item
	self.add_child(item)
	item.global_transform.basis = self.global_transform.basis
	item.global_transform.origin = self.global_transform.origin
	item.connect("picked", self._item_picked)

func desctory_current() -> void:
	item.disconnect("picked", self._item_picked)
	item.queue_free()
	item = null

func _item_picked():
	picked.emit()
	set_activatable(true)
	item.disconnect("picked", self._item_picked)
	item = null

func on_item_swap(new_item: Item):
	place_item(new_item)

func scale_item(sc: float) -> void:
	self.scale = Vector3(sc, sc, sc)

func _activated(player: Player):
	var player_item = player.item_manager.item_in_hand
	if !player_item:
		return
	
	player_item.go_to(self, item)
	
	place_item(player_item)
	
	player.item_manager.item_in_hand = null

func place_item(new_item: Item) -> void:
	new_item.connect("picked", self._item_picked)
	item = new_item
	placed.emit(item)
	set_activatable(false)

func get_hint(player: Player) -> String:
	var item = player.item_manager.item_in_hand
	if item:
		return "Put %s %s" % [item.item_name, hint_postfix]
	return "Put %s" % hint_postfix

func set_activatable(value: bool) -> void:
	if value:
		activator.collision_layer = 1
	else:
		activator.collision_layer = 0

func set_pickable(value: bool) -> void:
	if item:
		item.set_pickable(value)

func move_delta(delta: Vector3) -> void:
	self.transform.origin = self.start_position + delta
