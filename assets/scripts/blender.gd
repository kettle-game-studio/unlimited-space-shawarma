extends Node

enum State { EMPTY, HAS_INGREDIENT, WORKING, SWITCHING }

@export var time_to_finish: float = 10
@export var recipes: Array[Recipe]

@export var animation_tree: AnimationTree
@export var item_in_machine: ItemInMachine
@export var hide_position: Vector3 = Vector3(0, -0.3, 0)
@export var progress_bar: TextureProgressBar

var state: State = State.EMPTY
var time_left: float

func _ready():
	animation_tree["parameters/conditions/is_open"] = true
	animation_tree["parameters/conditions/not_working"] = false
	progress_bar.value = 0

func _process(delta):
	if state == State.WORKING:
		time_left -= delta
		if time_left < 0:
			time_left = 0
			state = State.SWITCHING
			animation_tree["parameters/conditions/is_working"] = false
			animation_tree["parameters/conditions/not_working"] = true
			show_item()
		var scale = 1 - time_left / time_to_finish
		progress_bar.value = scale * 100

func _item_placed(_item: Item):
	state = State.HAS_INGREDIENT

func _item_picked():
	state = State.EMPTY
	progress_bar.value = 0

func get_hint(_player: Player) -> String:
	match state:
		State.EMPTY:
			return "Blender"
		State.HAS_INGREDIENT:
			return "Start Blending"
		State.WORKING:
			return "Blender Blending"
	return ""

func _activated(_player: Player):
	match state:
		State.HAS_INGREDIENT:
			var res = get_result_item(item_in_machine.item)
			if res == null:
				return
			animation_tree["parameters/conditions/not_working"] = false
			animation_tree["parameters/conditions/is_open"] = false
			animation_tree["parameters/conditions/is_working"] = true
			time_left = time_to_finish
			state = State.SWITCHING
			item_in_machine.set_pickable(false)
			hide_item(res)

func get_result_item(item: Item) -> Resource:
	for recipe in recipes:
		if recipe.input.size() > 0 && recipe.input[0].item_name == item.item_name:
			if recipe.output.size() == 0:
				return null
			return recipe.output[0].get_prefab()
	return null

func hide_item(new_item: Resource):
	const steps = 20
	for i in range(1, steps):
		await get_tree().create_timer(0.01).timeout
		item_in_machine.move_delta(hide_position * (1.0 * i / steps))
		item_in_machine.scale_item(1 - 1.0 * i / steps)
	state = State.WORKING
	item_in_machine.instantiate_item(new_item)

func show_item():
	const steps = 20
	for i in range(1, steps):
		await get_tree().create_timer(0.01).timeout
		item_in_machine.move_delta(hide_position * (1 - 1.0 * i / steps))
		item_in_machine.scale_item(1.0 * i / steps)
	item_in_machine.set_pickable(true)
	state = State.HAS_INGREDIENT
