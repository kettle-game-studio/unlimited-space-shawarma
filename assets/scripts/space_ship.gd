extends PathFollow3D
class_name SpaceShip

signal arrived

@export var door: DoorScript
@export var random_parts: Array[RandomPartPicker]
@export var paths: Array[Path3D]

@export var seconds_to_fly: float = 0.1
@export var material: StandardMaterial3D
@export var color_material: StandardMaterial3D
@export var textures: Array[Texture]
@export var colors: Array[Color]

var time = 0.0 
var rng = RandomNumberGenerator.new()

func _ready():
	random_ship()
	fly()
	door.connect("is_closed", _on_door_is_closed)

func random_ship():
	for part in random_parts:
		part.random_part()
	
	self.position = Vector3()
	var path_idx = rng.randi_range(0, textures.size() - 1)
	self.reparent(self.paths[path_idx])
	
	var idx = rng.randi_range(0, textures.size() - 1)
	material.set_texture(BaseMaterial3D.TEXTURE_ALBEDO, textures[idx])
	color_material.albedo_color = colors[idx]
	print("set material idx = ", idx, ", total textures = ", textures.size(), ", total colors = ", colors.size())

func fly():
	self.visible = true
	const delta_time = 1.0 / 60.0
	var progress = 0
	while progress < 1:
		time += delta_time
		await get_tree().create_timer(delta_time).timeout
		progress += delta_time / seconds_to_fly
		self.progress_ratio = 1 - progress
	self.progress_ratio = 0
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
	var progress = 0
	while progress < 1:
		time += delta_time
		await get_tree().create_timer(delta_time).timeout
		self.position += Vector3(-speed * delta_time, 0, -speed * delta_time)
