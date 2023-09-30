extends Node

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
	
func _process(delta):
	if opening:
		if open(delta):
			opening = !opening
	else:
		if close(delta):
			opening = !opening
	pass

func open(delta: float) -> bool:
	if moved == 1:
		return true;
	if moved > 1:
		moved = 1
		set_doors_positions()
		return true;
		
	moved += (1 / seconsToOpen) * delta
	set_doors_positions()
	return false
	
func close(delta: float) -> bool:
	if moved == 0:
		return true;
	if moved < 0:
		moved = 0
		set_doors_positions()
		return true;
	
	moved -= (1 / seconsToOpen)  * delta
	set_doors_positions()
	return false

func set_doors_positions():
	leftDoor.transform.origin = leftDoorStartPosition + targetPosition * moved
	rightDoor.transform.origin = rightDoorStartPosition - targetPosition * moved
	
