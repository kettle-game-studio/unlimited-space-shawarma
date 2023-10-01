extends Item
class_name MachineItem

enum MachineType { TREE, FOOD_PROCESSOR }

@export var machine: PackedScene
@export var machine_type: MachineType

static func get_spawner_name(_machine_type: MachineType) -> String:
	match _machine_type:
		MachineType.TREE:
			return "Tree Pot"
		MachineType.FOOD_PROCESSOR:
			return "Power Outlet"
	return "Spawner"

static func get_machine_verb(_machine_type: MachineType) -> String:
	match _machine_type:
		MachineType.TREE:
			return "Plant"
		MachineType.FOOD_PROCESSOR:
			return "Connect"
	return "Put"
