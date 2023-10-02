extends Node3D

@export var trading_machine: TradingMachine
@export var ui_controller: UIController

func _ready():
	story_routine()

func story_routine():
	ui_controller.add_dialog("Hint", "Use <Mouse> to look around", Color.BLUE)
	await get_tree().create_timer(5.0).timeout
	ui_controller.add_dialog("You", "My ship crashed a week ago and now I am stuck in this tiny rescue capsule.")
	await get_tree().create_timer(5.0).timeout
	ui_controller.add_dialog("You", "I think, i have an apple in the space-storage, I should eat it now.")
	ui_controller.add_dialog("Hint", "Use <E> or <LMB> to pick an item. Use <Space> to eat it.", Color.BLUE)
