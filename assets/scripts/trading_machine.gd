extends Node3D
class_name TradingMachine

enum State { DISABLED, CAN_TRADE, SWITCHING }

@export var slots: Array[ItemInMachine]
@export var computer_ui: ComputerUI
@export var door: DoorScript
@export var recipes: Array[Recipe]
@export var hide_offset: Vector3
@export var seconds_to_trade: float = 2.0
@export var ship: SpaceShip

var state = State.DISABLED

func _ready():
	door.connect("is_open", _is_open)
	door.connect("is_closed", _is_closed)
	set_activatable(false)
	
	ship.connect("arrived", _on_ship_arrived)
	ship.random_ship()
	ship.fly()

func _on_ship_arrived():
	start_trading()

func start_trading():
	door.open()
	computer_ui.set_recipes(recipes)

func stop_trading():
	door.close()
	ship.fly_away()
	state = State.DISABLED
	set_activatable(false)
	
func _is_open():
	state = State.CAN_TRADE
	set_activatable(true)

func _is_closed():
	print("is closed")
	
func set_activatable(value: bool) -> void:
	for slot in slots:
		slot.set_activatable(value)

func _cancel_button_activated(player):
	if state != State.CAN_TRADE:
		return
	stop_trading()
	
func _ok_button_activated(player):
	if state != State.CAN_TRADE:
		return
	var recipe = Recipe.find_recipe(slots, recipes)
	if !recipe:
		return
	
	for i in slots.size():
		var out = null;
		if i < recipe.output.size():
			out = recipe.output[i].get_prefab();
		replace_item(slots[i], out)

func replace_item(item: ItemInMachine, res: Resource):
	const delta_time = 1.0 / 60.0
	var total_time = seconds_to_trade / 2.0
	var time = 0;
	while time < total_time:
		time += delta_time
		await get_tree().create_timer(delta_time).timeout
		var moved = time / total_time
		item.move_delta(hide_offset * moved)
		item.scale_item(1 - moved)
	item.instantiate_item(res)
	time = 0;
	while time < total_time:
		time += delta_time
		await get_tree().create_timer(delta_time).timeout
		var moved = 1 - time / total_time
		
		item.move_delta(hide_offset * moved)
		item.scale_item(1 - moved)

