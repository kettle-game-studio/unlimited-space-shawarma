extends Node3D
class_name DoorScript

signal is_open
signal is_closed

@export var leftDoor: Node3D
@export var rightDoor: Node3D
@export var targetPosition: Vector3
@export var seconsToOpen: float

var leftDoorStartPosition: Vector3
var rightDoorStartPosition: Vector3 

var opening = true
var moved = 0

func _ready():
	leftDoorStartPosition = leftDoor.transform.origin
	rightDoorStartPosition = rightDoor.transform.origin

func open():
	const delta_time = 1.0 / 60.0 
	var time = 0;
	while time < seconsToOpen:
		time += delta_time
		await get_tree().create_timer(delta_time).timeout
		moved = time / seconsToOpen
		set_doors_positions()
	is_open.emit()
	
func close():
	const delta_time = 1.0 / 60.0 
	var time = 0;
	while time < seconsToOpen:
		time += delta_time
		await get_tree().create_timer(delta_time).timeout
		moved = 1 - time / seconsToOpen
		set_doors_positions()
	is_closed.emit()

func set_doors_positions():
	leftDoor.transform.origin = leftDoorStartPosition + targetPosition * moved
	rightDoor.transform.origin = rightDoorStartPosition - targetPosition * moved
	
