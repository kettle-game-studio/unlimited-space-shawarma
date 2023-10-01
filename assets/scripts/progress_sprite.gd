extends Sprite3D
class_name ProgressSprite

@export var progress_bar: TextureProgressBar

func _ready():
	texture = $SubViewport.get_texture()

func set_progress(progress: float) -> void:
	progress_bar.value = progress * 100
