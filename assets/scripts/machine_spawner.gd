extends Node3D

@export var spawn_point: Node3D

var machine: Node3D

func get_hint(player: Player) -> String:
	if machine:
		return ""
	var item = player.item_manager.item_in_hand
	if item && item is MachineItem:
		return "Plant %s" % item.item_name 
	return "Tree Pot"

func _activated(player):
	if machine:
		return 
	var item = player.item_manager.item_in_hand
	if item && item is MachineItem:
		machine = item.machine.instantiate()
		spawn_point.add_child(machine)
		player.item_manager.destroy_current_item()
		
