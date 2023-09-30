extends Node
class_name PlayerRaycast

@export var activatorRaycast: RayCast3D
@export var fridgeRaycast: RayCast3D
@export var player: Player

func _process(_delta):
	if process_raycast(activatorRaycast):
		return
	if process_raycast(fridgeRaycast):
		pass

func process_raycast(raycast: RayCast3D) -> bool:
	var flag = false
	
	if raycast.is_colliding():
		var collider = raycast.get_collider()
		if collider is Activator:
			player.ui.set_help_text(collider.get_hint(player))
			flag = true
			if Input.is_action_just_pressed("Activate"):
				collider.activate(player)
	else:
		player.ui.set_help_text("")
		
	return flag
