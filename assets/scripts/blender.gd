extends Node

enum State { EMPTY, HAS_INGREDIENT, WORKING, SWITCHING }

@export var time_to_finish: float = 10
@export var item_animation_target_size: float = 0
@export var recipes: Array[Recipe]

@export var noun: String = "Blender"
@export var verb: String = "Blending"

@export var animation_tree: AnimationTree
@export var item_in_machine: Array[ItemInMachine]
@export var hide_position: Vector3 = Vector3(0, -0.3, 0)
@export var progress_bar: ProgressSprite

@export var blending_sound: AudioStreamPlayer3D
@export var opening_sound: AudioStreamPlayer3D
@export var closing_sound: AudioStreamPlayer3D

var state: State = State.EMPTY
var time_left: float

func _ready():
	animation_tree["parameters/conditions/not_working"] = false
	progress_bar.set_progress(0)
	opening_sound.play()

func _process(delta):
	if state == State.WORKING:
		time_left -= delta
		if time_left < 0:
			time_left = 0
			state = State.SWITCHING
			blending_sound.stop()
			animation_tree["parameters/conditions/is_working"] = false
			animation_tree["parameters/conditions/not_working"] = true
			show_item()
		var scale = 1 - time_left / time_to_finish
		progress_bar.set_progress(scale)

func _item_placed(_item: Item):
	state = State.HAS_INGREDIENT

func _item_picked():
	var flag = false
	for i in self.item_in_machine:
		if i.item != null:
			flag = true
	if !flag:
		state = State.EMPTY
		progress_bar.set_progress(0)

func get_hint(_player: Player) -> String:
	match state:
		State.EMPTY:
			return noun
		State.HAS_INGREDIENT:
			return "Start %s" % verb
		State.WORKING:
			return "%s %s" % [noun, verb]
	return ""

func _activated(_player: Player):
	match state:
		State.HAS_INGREDIENT:
			var res = Recipe.find_recipe(item_in_machine, recipes)
			if res == null:
				return
			animation_tree["parameters/conditions/not_working"] = false
			animation_tree["parameters/conditions/is_working"] = true
			time_left = time_to_finish
			aet_items_pickable(false)
			state = State.SWITCHING
			blending_sound.play()
			hide_item(res.output[0].get_prefab())

func aet_items_pickable(value: bool):
	for item in item_in_machine:
		item.set_pickable(value)

func hide_item(new_item: Resource):
	const steps = 20
	closing_sound.play(0.1)
	for i in range(1, steps):
		await get_tree().create_timer(0.01).timeout
		for item in item_in_machine:
			item.move_delta(hide_position * (1.0 * i / steps))
			item.scale_item(lerp(1.0, item_animation_target_size, 1.0 * i / steps))
	state = State.WORKING
	for item in item_in_machine:
		item.desctory_current()
	item_in_machine[0].instantiate_item(new_item)

func show_item():
	const steps = 20
	opening_sound.play()
	for i in range(1, steps):
		await get_tree().create_timer(0.01).timeout
		for item in item_in_machine:
			item.move_delta(hide_position * (1 - 1.0 * i / steps))
			item.scale_item(lerp(item_animation_target_size, 1.0, 1.0 * i / steps))
	state = State.HAS_INGREDIENT
	aet_items_pickable(true)
