extends Node3D

@export var trading_machine: TradingMachine
@export var ui_controller: UIController
@export var player: Player
@export var notes: Notes

func player_have_eaten() -> bool:
	return player.items_eaten > 0

func _ready():
	story_routine()

func story_routine():
	await part_1()
	await part_2()
	await part_3()
	await part_4()
	await part_5()
	await part_6()
	await free_play()

# Eating our first apple
func part_1():
	ui_controller.add_dialog("Hint", "Use <Mouse> to look around", Color.BLUE)
	await get_tree().create_timer(5.0).timeout
	ui_controller.add_dialog("You", "My ship crashed a week ago and now I am stuck in this tiny rescue capsule.")
	await get_tree().create_timer(5.0).timeout
	
	if !player_have_eaten():
		ui_controller.add_dialog("You", "I think, i have a shawarma in the space-storage, I should eat it now.")
		ui_controller.add_dialog("Hint", "Use <E> or <LMB> to pick an item. Use <Space> to eat it.", Color.BLUE)
		
		while !await wait_for(player_have_eaten , 6.0):
			ui_controller.add_dialog("Hint", "Use <E> or <LMB> to pick an item. Use <Space> to eat it.", Color.BLUE)	
	
	ui_controller.add_dialog("You", "Mmm, delicios")

@export var free_fruit_tree: Encounter

# Meeting ourfirst ship
func part_2():
	await get_tree().create_timer(5.0).timeout
	ui_controller.add_dialog("You", "I think I hear a spaceship passing by. I wish they notice my S.O.S")
	await play_encounter(free_fruit_tree, false)
	await get_tree().create_timer(1.0).timeout
	ui_controller.add_dialog("Hint", "Use <E> or <LMB> on a green button to recieve this offer", Color.BLUE)
	
	while !await wait_for(func (): return player.trees_taken > 0, 20):
		ui_controller.add_dialog("Hint", "Use <E> or <LMB> to pick the tree", Color.BLUE)
	
	ui_controller.add_dialog("Hint", "Plant the tree in the pot on the right wall", Color.BLUE)
	
	await wait_for_ship_fly_away()
	ui_controller.add_dialog("You", "And the ship is gone")
	await get_tree().create_timer(3.0).timeout
	ui_controller.add_dialog("You", "The next one will save me for sure")

@export var blender_encounters: Array[Encounter]
var blender_encounter_idx = 0
var blender_item_data = preload("res://assets/prefabs/items/data/blender.tres")

# BLENDER
func part_3():
	while !trading_machine.items_recieved.has(blender_item_data.item_name):
		await get_tree().create_timer(10.0).timeout
		await play_encounter(blender_encounters[blender_encounter_idx])
		blender_encounter_idx = (blender_encounter_idx + 1) % blender_encounters.size()
		await wait_for_ship_fly_away()

@export var sandbox_encounters: Array[Encounter] 
@export var sandbox_random_encounters: Array[Encounter] 
var sandbox_encounte_idx = 0

var microwave_item_data = preload("res://assets/prefabs/items/data/microwave.tres")
var mixer_item_data = preload("res://assets/prefabs/items/data/mixer.tres")
var fruit_tree_item_data = preload("res://assets/prefabs/items/data/baked_multifruit.tres")
var vegetable_item_data = preload("res://assets/prefabs/items/data/multivegetable_tree.tres")

# sandboxing
func part_4():
	while sandbox_encounters.size() != 0:
		sandbox_encounte_idx = sandbox_encounte_idx % sandbox_encounters.size()
		# await get_tree().create_timer(10.0).timeout
		await play_encounter(sandbox_encounters[sandbox_encounte_idx])
		await wait_for_ship_fly_away()
		
		if trading_machine.last_encounter_result:
			sandbox_encounters.remove_at(sandbox_encounte_idx)
			print("sandbox_encounters.size() = ", sandbox_encounters.size())
		else:
			sandbox_encounte_idx += 1
	
		await get_tree().create_timer(10.0).timeout
		await play_encounter(sandbox_random_encounters.pick_random())
		await wait_for_ship_fly_away()

@export var freeplay_encounters: Array[Encounter]
@export var ships_to_win: int = 15

func part_5():
	freeplay_encounters.append_array(sandbox_random_encounters)
	while trading_machine.positive_ships < ships_to_win:
		await get_tree().create_timer(7.0).timeout
		await play_encounter(freeplay_encounters.pick_random())
		await wait_for_ship_fly_away()
		
		await get_tree().create_timer(10.0).timeout
		await play_encounter(freeplay_encounters.pick_random())
		await wait_for_ship_fly_away()

@export var save_encounter: Encounter

func part_6():
	await get_tree().create_timer(15.0).timeout
	await play_encounter(save_encounter)
	await wait_for_trade_to_stop()
	if trading_machine.last_encounter_result:
		get_tree().change_scene_to_file("res://assets/scenes/YouWin.tscn")
	else:
		await wait_for_ship_fly_away()
		

func free_play():
	while true:
		await get_tree().create_timer(7.0).timeout
		await play_encounter(freeplay_encounters.pick_random())
		await wait_for_ship_fly_away()
		
		await get_tree().create_timer(10.0).timeout
		await play_encounter(freeplay_encounters.pick_random())
		await wait_for_ship_fly_away()

func wait_for(f: Callable, time_limit: float) -> bool:
	const time_step = 1.0 / 24.0 
	var t = 0;
	while t < time_limit:
		await get_tree().create_timer(time_step).timeout
		var r = f.call()
		if r:
			return true
		t += time_step
	return false

func wait_for_ship():
	while !await wait_for(func(): return trading_machine.state == TradingMachine.State.CAN_TRADE, 10.0):
		pass
	
func wait_for_trade_to_stop():
	while !await wait_for(func(): return trading_machine.state == TradingMachine.State.SWITCHING, 10.0):
		pass

func wait_for_ship_fly_away():
	while !await wait_for(func(): return trading_machine.state == TradingMachine.State.DISABLED, 10.0):
		pass
	
func play_encounter(encounter: Encounter, can_refuse: bool = true):
	trading_machine.start_encounter(encounter.recipes, can_refuse)
	await wait_for_ship()
	if encounter.alien_says == "":
		ui_controller.add_dialog("Alien", make_dummy_alien_text(encounter))
	else:
		ui_controller.add_dialog("Alien", encounter.alien_says)
		
	if encounter.player_says != "":
		await get_tree().create_timer(5.0).timeout
		ui_controller.add_dialog("You", encounter.player_says)
		
func make_dummy_alien_text(encounter: Encounter) -> String:
	var res = "Hello! I propse an exchange: "
	for idx in encounter.recipes.size():
		res += make_dummy_for_recipe(encounter.recipes[idx], idx)
	return res

const STARTS = ["You give me ", "Or you give me ", "Lastly you can give me "]
const FOR_EMPTY = ["Get ", "Or you can get", "Lastly you can get "]
const ENDS = [" and get ", " and i return ", " and recieve "]

func make_dummy_for_recipe(recipe: Recipe, idx: int) -> String:
	if recipe.input.size() == 0:
		return FOR_EMPTY[idx] + make_dummy_for_ingr_list(recipe.output) + " for free! "
	return STARTS[idx] + make_dummy_for_ingr_list(recipe.input) + ENDS[idx] + make_dummy_for_ingr_list(recipe.output) + ". "
	
func make_dummy_for_ingr_list(list: Array[ItemData]) -> String:
	if list.size() == 0:
		return "absolutely nothing"
	if list.size() == 1:
		return list[0].item_name.to_lower()
	var res = ""
	
	for idx in list.size():
		if idx == list.size() - 1:
			res += " and " + list[idx].item_name.to_lower()
		else:
			res += " " + list[idx].item_name.to_lower()
	
	return res
	
