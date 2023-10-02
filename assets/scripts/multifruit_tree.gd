extends Node
class_name MultifruitTree

enum State { UNWATERED, GROWING, FULLY_GROWN }

@export var fruit_positions: Array[GrowableItem]
@export var time_to_grow: float = 1
@export var fruit_item: ItemData

@export var drink_sound: AudioStreamPlayer3D

var state: State = State.UNWATERED
var rnd = RandomNumberGenerator.new()
var time_left: float
var growing_fruit: GrowableItem;

func _ready():
	time_left = time_to_grow

func get_progress() -> float:
	return 1 - time_left / time_to_grow

func _process(delta):
	if state == State.GROWING:
		time_left -= delta;
		if time_left <= 0:
			time_left = 0;
			state = State.FULLY_GROWN
			growing_fruit.fully_grown()
		var scale = get_progress()
		growing_fruit.scale_fruit(scale)
	elif state == State.FULLY_GROWN:
		if growing_fruit.is_picked:
			time_left = time_to_grow
			growing_fruit = null;
			state = State.UNWATERED;

func get_hint(player: Player) -> String:
	match state:
		State.UNWATERED:
			if player.item_manager.item_is("Water"):
				return "Water the %s" % fruit_item.item_name
			return "Unwatered %s" % fruit_item.item_name
		State.GROWING:
			return "Growing %s" % fruit_item.item_name
		State.FULLY_GROWN:
			return "Fully Grown %s" % fruit_item.item_name
	return ""

func _activated(player: Player):
	if state == State.UNWATERED && player.item_manager.item_is("Water"):
		drink_sound.play()
		state = State.GROWING
		time_left = time_to_grow
		player.item_manager.destroy_current_item()
		
		var idx = rnd.randi_range(0, fruit_positions.size() - 1)
		growing_fruit = fruit_positions[idx]
		growing_fruit.instantiate_fruit(fruit_item.get_prefab())
		

