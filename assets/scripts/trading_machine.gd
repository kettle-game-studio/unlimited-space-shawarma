extends Node3D
class_name TradingMachine

enum State { DISABLED, CAN_TRADE, SWITCHING }

@export var slots: Array[ItemInMachine]
@export var door: DoorScript

var state = State.DISABLED

func _ready():
	door.connect("is_open", _is_open)
	set_activatable(false)
	start()

func start():
	door.open()

func _is_open():
	print("is open")
	state = State.CAN_TRADE
	set_activatable(true)

func set_activatable(value: bool) -> void:
	for slot in slots:
		slot.set_activatable(value)
