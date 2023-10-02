extends Node3D

@export var hint: String
@export var shiftDir: Vector3 = Vector3(0, 0, 1)

func get_hint(_player: Player) -> String:
	return "Press '%s'" % hint

var pressed = false

func blocked(_player) -> bool:
	return pressed

func _on_area_activated(_player):
	if pressed:
		return
	pressed = true
	const delta_move = 0.008
	const delta_time = 1.0 / 60.0
	const total_time = 0.1
	var time = 0;
	while time < total_time:
		time += delta_time
		var moved = time / total_time
		self.translate(shiftDir*(-moved*delta_move))
		await get_tree().create_timer(delta_time).timeout
	time = 0;
	while time < total_time:
		time += delta_time
		var moved = time / total_time
		self.translate(shiftDir*moved*delta_move)
		await get_tree().create_timer(delta_time).timeout
	pressed = false
