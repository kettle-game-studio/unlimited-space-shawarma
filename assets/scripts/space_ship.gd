extends PathFollow3D
class_name SpaceShip

signal arrived
signal disappeared

@export var door: DoorScript
@export var random_parts: Array[RandomPartPicker]
@export var paths: Array[Path3D]

@export var seconds_to_fly: float = 0.1
@export var material: StandardMaterial3D
@export var color_material: StandardMaterial3D
@export var textures: Array[Texture]
@export var colors: Array[Color]

@export var fly_sound: AudioStreamPlayer3D
@export var speech_sounds: Array[AudioStreamPlayer3D]

var time = 0.0 
var rng = RandomNumberGenerator.new()

var current_speech: AudioStreamPlayer3D

func _ready():
	door.connect("is_closed", _on_door_is_closed)

func start_speech():
	current_speech.play()

func stop_speech():
	current_speech.stop()

func random_ship():
	print("Random ship")
	for part in random_parts:
		part.random_part()
	
	current_speech = speech_sounds.pick_random()
	
	self.position = Vector3()
	var path_idx = rng.randi_range(0, self.paths.size() - 1)
	self.reparent(self.paths[path_idx])
	
	var idx = rng.randi_range(0, textures.size() - 1)
	material.set_texture(BaseMaterial3D.TEXTURE_ALBEDO, textures[idx])
	color_material.albedo_color = colors[idx]

func fly():
	const delta_time = 1.0 / 60.0
	
	await get_tree().create_timer(delta_time).timeout
	self.random_ship()
	var progress = 0
	
	self.visible = true
	fly_sound.play()
	while progress < 1:
		time += delta_time
		await get_tree().create_timer(delta_time).timeout
		progress += delta_time / seconds_to_fly
		self.progress_ratio = 1 - progress
	self.progress_ratio = 0
	fly_sound.stop()
	await get_tree().create_timer(1.0).timeout
	arrived.emit()
	door.open()

func fly_away():
	door.close()
	
func _on_door_is_closed():
	fly_away_routine()

func fly_away_routine():
	const delta_time = 1.0 / 60.0
	var time = 0;
	var speed = 20
	
	fly_sound.play()
	
	while time < 3:
		time += delta_time
		await get_tree().create_timer(delta_time).timeout
		self.position += Vector3(-speed * delta_time, 0, -speed * delta_time)
	
	fly_sound.stop()
	disappeared.emit()
