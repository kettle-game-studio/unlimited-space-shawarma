extends Node

@export var activatorRaycast: RayCast3D
@export var player: Player

func _process(delta):
	if activatorRaycast.is_colliding():
		player.ui.set_help_text("Collidion")
	else:
		player.ui.set_help_text("")
