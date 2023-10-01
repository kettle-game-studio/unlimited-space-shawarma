extends CanvasLayer
class_name ComputerUI

@export var ui_recipe_points: Array[ComputerUIPoint]

func set_recipes(recipes: Array[Recipe]):
	for i in ui_recipe_points.size():
		var resipe = null;
		if i < recipes.size():
			resipe = recipes[i]
		ui_recipe_points[i].set_recipe(resipe)
