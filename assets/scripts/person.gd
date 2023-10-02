extends Node3D
class_name Person

@export var body_parts: Array[RandomPartPicker]
@export var mouth: RandomPartPicker
@export var speech_sounds: Array[AudioStreamPlayer3D]

var talking: bool = false
const MAX_MOUTH_TIME: float = 0.2
var mouth_time: float = 0.5

var current_speech: AudioStreamPlayer3D

func random_person():
	current_speech = speech_sounds.pick_random()
	for body in body_parts:
		body.random_part()
	mouth.set_default()

func _process(delta: float):
	if !talking:
		return
	mouth_time -= delta
	if mouth_time < 0:
		mouth_time += MAX_MOUTH_TIME
		mouth.random_part()

func set_talking(value: bool):
	if value == talking:
		return
	if value:
		start_talking()
	else:
		stop_talking()

func start_talking():
	current_speech.play()
	talking = true

func stop_talking():
	current_speech.stop()
	mouth_time = MAX_MOUTH_TIME
	mouth.set_default()
	talking = false
