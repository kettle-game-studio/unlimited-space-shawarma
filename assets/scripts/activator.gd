extends Node3D
class_name Activator

@export var hint: String
@export var hint_source: Node
@export var activation_sound: AudioStreamPlayer3D

signal activated(player: Player)

func blocked(player: Player) -> bool:
	return hint_source.has_method("blocked") && hint_source.blocked(player)

func get_hint(player: Player) -> String:
	return hint_source.get_hint(player)

func activate(player: Player) -> void:
	if blocked(player):
		return
	activated.emit(player)
	if activation_sound != null:
		activation_sound.play()
