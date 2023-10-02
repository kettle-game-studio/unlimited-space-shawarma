extends Label
class_name ComputerUIPoint

@export var in_plus: Array[Control]
@export var in_textures: Array[TextureRect]

@export var out_plus: Array[Control]
@export var out_textures: Array[TextureRect]

func set_recipe(recipe: Recipe) -> void:
	self.visible = recipe != null && (recipe.input.size() != 0 || recipe.output.size() != 0)
	if recipe == null:
		return
	
	for i in in_plus.size():
		in_plus[i].visible = i + 1 < recipe.input.size()
	for i in out_plus.size():
		out_plus[i].visible = i + 1 < recipe.output.size()
		
	for i in in_textures.size():
		in_textures[i].visible = i < recipe.input.size()
	for i in out_textures.size():
		out_textures[i].visible = i < recipe.output.size()
	
	for i in recipe.input.size():
		in_textures[i].texture = recipe.input[i].icon
	for i in recipe.output.size():
		out_textures[i].texture = recipe.output[i].icon
