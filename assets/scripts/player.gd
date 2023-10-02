extends Node3D
class_name Player

@export var ui: UIController
@export var item_manager: ItemManager
@export var player_raycast: PlayerRaycast

var items_eaten: int = 0
var trees_taken: int = 0

var items_taken: Dictionary = Dictionary()
