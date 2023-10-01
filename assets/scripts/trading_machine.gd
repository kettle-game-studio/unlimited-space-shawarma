extends Node3D
class_name TradingMachine

enum State { DISABLED, CAN_TRADE, SWITCHING }

@export var slots: Array[ItemInMachine]
@export var computer_ui: ComputerUI
@export var door: DoorScript
@export var recipes: Array[Recipe]
@export var hide_offset: Vector3
@export var seconds_to_trade: float = 2.0

var state = State.DISABLED

func _ready():
	door.connect("is_open", _is_open)
	door.connect("is_closed", _is_closed)
	set_activatable(false)
	start_trading()

func start_trading():
	door.open()
	computer_ui.set_recipes(recipes)

func stop_trading():
	door.close()
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
	var recipe = find_recipe(recipes)
	if !recipe:
		return
	
	for i in slots.size():
		var out = null;
		if i < recipe.output.size():
			out = recipe.output[i].get_prefab();
		replace_item(slots[i], out)
	
func find_recipe(r: Array[Recipe]) -> Recipe:
	var longest_recipe = null
	var length = -1
	for recipe in r:
		if check_recipe(recipe) && recipe.input.size() > length:
			longest_recipe = recipe
	return longest_recipe

func check_recipe(recipe: Recipe) -> bool:
	for item in recipe.input:
		if !has_enough(recipe.input, item):
			return false
	return true

func has_enough(recipe: Array[ItemData], item: ItemData) -> bool:
	var count_in_recipe = 0
	for i in recipe:
		if i.item_name == item.item_name:
			count_in_recipe += 1
			
	var count_on_table = 0
	for s in slots:
		if s.item && s.item.item_name == item.item_name:
			count_on_table += 1
	
	return count_in_recipe == count_on_table

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

