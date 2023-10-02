extends CanvasLayer
class_name ComputerUI

@export var ui_recipe_points: Array[ComputerUIPoint]
@export var color_front: ColorRect
@export var color_back: ColorRect

func _ready():
	disable()

func set_recipes(recipes: Array[Recipe]):
	enable_routine()
	for i in ui_recipe_points.size():
		var resipe = null
		if i < recipes.size():
			resipe = recipes[i]
		ui_recipe_points[i].set_recipe(resipe)

func disable():
	disable_routine()

func enable_routine():
	const delta_time = 1.0 / 24.0
	const total_t = delta_time * 12;
	var t = 0;
	while t < total_t:
		await get_tree().create_timer(delta_time).timeout
		color_front.visible = true
		color_front.scale = Vector2(1, t / total_t)
		t += delta_time
	
	color_front.scale = Vector2(1, 1)

func disable_routine():
	const delta_time = 1.0 / 24.0
	const total_t = delta_time * 12;
	var t = 0;
	while t < total_t:
		await get_tree().create_timer(delta_time).timeout
		color_front.scale = Vector2(1, 1 - t / total_t)
		t += delta_time
	
	color_front.scale = Vector2(1, 1)
	color_front.visible = false
	for i in ui_recipe_points:
		i.set_recipe(null)
