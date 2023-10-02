extends Node3D

signal item_placed(ItemData)

@export var spawn_point: Node3D
@export var allowed_machine_type: MachineItem.MachineType 
@export var progress_bar: ProgressSprite

var machine: Node3D

func _ready():
	if !progress_bar:
		return
	progress_bar.set_progress(0)

func _process(float):
	if !progress_bar || !machine:
		return
	if machine.has_method("get_progress"):
		progress_bar.set_progress(machine.get_progress())

func get_hint(player: Player) -> String:
	if machine:
		return ""
	var item = player.item_manager.item_in_hand
	if item && item is MachineItem && item.machine_type == allowed_machine_type:
		return "%s %s" % [MachineItem.get_machine_verb(item.machine_type), item.item_name] 
	return MachineItem.get_spawner_name(allowed_machine_type)
	
func blocked(player: Player) -> bool:
	var item = player.item_manager.item_in_hand
	return machine != null || !(item && item is MachineItem && item.machine_type == allowed_machine_type)

func _activated(player):
	if machine:
		return 
	var item = player.item_manager.item_in_hand
	if item && item is MachineItem && item.machine_type == allowed_machine_type:
		machine = item.machine.instantiate()
		spawn_point.add_child(machine)
		item_placed.emit(item.item_data)
		player.item_manager.destroy_current_item()
		
