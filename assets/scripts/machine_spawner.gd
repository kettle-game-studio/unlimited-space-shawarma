extends Node3D

@export var spawn_point: Node3D
@export var allowed_machine_type: MachineItem.MachineType 

var machine: Node3D

func get_hint(player: Player) -> String:
	if machine:
		return ""
	var item = player.item_manager.item_in_hand
	if item && item is MachineItem && item.machine_type == allowed_machine_type:
		return "%s %s" % [MachineItem.get_machine_verb(item.machine_type), item.item_name] 
	return MachineItem.get_spawner_name(allowed_machine_type)

func _activated(player):
	if machine:
		return 
	var item = player.item_manager.item_in_hand
	if item && item is MachineItem && item.machine_type == allowed_machine_type:
		machine = item.machine.instantiate()
		spawn_point.add_child(machine)
		player.item_manager.destroy_current_item()
		
