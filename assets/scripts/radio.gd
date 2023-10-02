extends Node3D

@export var music: AudioStreamPlayer3D

@export var progress_sprite: ProgressSprite
@export var min_volume = -40
@export var max_volume = 10
@export var default_volume = -10
@export var step = 5

func volume_as_progress() -> float:
	return (music.volume_db-min_volume)/(max_volume-min_volume)

func _ready():
	progress_sprite.set_progress(volume_as_progress())
	music.play()

func _on_play_area_activated(player):
	if music.playing:
		music.stop()
	else:
		music.play()

func _on_change_volume(player: Player, delta: int):
	music.volume_db+=delta*step
	if music.volume_db < min_volume:
		music.volume_db = min_volume
	elif music.volume_db > max_volume:
		music.volume_db = max_volume
	progress_sprite.set_progress(volume_as_progress())
