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
@export var ui_controller: UIController
@export var ships_count: ShipsCount

var state = State.DISABLED
var can_decline: bool = true

var items_recieved: Dictionary = {}

var last_encounter_result: bool
var positive_ships: int = 0

func _ready():
	door.connect("is_open", _is_open)
	door.connect("is_closed", _is_closed)
	set_activatable(true)
	
	ship.connect("arrived", _on_ship_arrived)
	ship.connect("disappeared", _on_ship_disappeared)

func start_encounter(recipes: Array[Recipe], can_decline: bool = true):
	self.recipes = recipes
	self.can_decline = can_decline
	ship.fly()

func _on_ship_arrived():
	start_trading()

func _on_ship_disappeared():
	state = State.DISABLED

func _process(float):
	if state == State.CAN_TRADE:
		ship.person.set_talking(ui_controller.is_npc_talking())

func start_trading():
	door.open()
	computer_ui.set_recipes(recipes)

func stop_trading():
	ships_count.inc_count()
	door.close()
	ship.fly_away()
	state = State.SWITCHING
	#set_activatable(false)
	computer_ui.disable()
	ship.person.set_talking(false)
	
func _is_open():
	state = State.CAN_TRADE
	#set_activatable(true)

func _is_closed():
	print("is closed")
	
func set_activatable(value: bool) -> void:
	for slot in slots:
		slot.set_activatable(value)

func _cancel_button_activated(player):
	if state != State.CAN_TRADE:
		return
	if !can_decline:
		self.ui_controller.add_dialog("You", "I don't think I can decline such an offer")
		return
	
	last_encounter_result = false
	state = State.SWITCHING
	stop_trading()

func _ok_button_activated(player):
	if state != State.CAN_TRADE:
		return
	var recipe = Recipe.find_recipe(slots, recipes)
	if !recipe:
		self.ui_controller.add_dialog("You", "I don't think this is a valid trade")
		return
		
	positive_ships += 1
	last_encounter_result = true
	state = State.SWITCHING
	for i in slots.size():
		var out = null;
		if i < recipe.output.size():
			out = recipe.output[i];
		replace_item(slots[i], out, i == 0)

func replace_item(item: ItemInMachine, res: ItemData, must_stop_trading: bool):
	if res:
		if !items_recieved.has(res.item_name):
			items_recieved[res.item_name] = 0
		items_recieved[res.item_name] += 1
	
	const delta_time = 1.0 / 60.0
	var total_time = seconds_to_trade / 2.0
	var time = 0;
	while time < total_time:
		time += delta_time
		await get_tree().create_timer(delta_time).timeout
		var moved = time / total_time
		item.move_delta(hide_offset * moved)
		item.scale_item(1 - moved)
	if res:
		item.instantiate_item(res.get_prefab())
	else:
		item.instantiate_item(null)
	time = 0;
	while time < total_time:
		time += delta_time
		await get_tree().create_timer(delta_time).timeout
		var moved = 1 - time / total_time
		
		item.move_delta(hide_offset * moved)
		item.scale_item(1 - moved)
	
	if must_stop_trading:
		stop_trading()
		

