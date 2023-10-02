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
	# await part_1()
	# await part_2()
	await part_3()

# Eating our first apple
func part_1():
	ui_controller.add_dialog("Hint", "Use <Mouse> to look around", Color.BLUE)
	await get_tree().create_timer(5.0).timeout
	ui_controller.add_dialog("You", "My ship crashed a week ago and now I am stuck in this tiny rescue capsule.")
	await get_tree().create_timer(5.0).timeout
	
	if !player_have_eaten():
		ui_controller.add_dialog("You", "I think, i have a multifruit in the space-storage, I should eat it now.")
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

func part_3():
	while !trading_machine.items_recieved.has(blender_item_data.item_name):
		await play_encounter(blender_encounters[blender_encounter_idx])
		blender_encounter_idx = (blender_encounter_idx + 1) % blender_encounters.size()
		await wait_for_ship_fly_away()
		await get_tree().create_timer(10.0).timeout

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
	
func wait_for_ship_fly_away():
	while !await wait_for(func(): return trading_machine.state == TradingMachine.State.DISABLED, 10.0):
		pass
	
func play_encounter(encounter: Encounter, can_refuse: bool = true):
	trading_machine.start_encounter(encounter.recipes, can_refuse)
	await wait_for_ship()
	ui_controller.add_dialog("Alien", encounter.alien_says)
	if encounter.player_says != "":
		await get_tree().create_timer(5.0).timeout
		ui_controller.add_dialog("You", encounter.player_says)
		
