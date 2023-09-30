extends Node3D
class_name GrowableItem

var fruit: Item 
var is_picked: bool = false

func instantiate_fruit(res: Resource) -> void:
	self.scale_fruit(1)
	fruit = res.instantiate() as Item
	self.add_child(fruit)
	fruit.set_pickable(false)
	fruit.global_transform.basis = self.global_transform.basis
	fruit.global_transform.origin = self.global_transform.origin
	fruit.transform.origin = -fruit.top_point.transform.origin
	
	fruit.connect("picked", self.picked)
	is_picked = false
	
	self.scale_fruit(0)

func scale_fruit(sc: float) -> void:
	self.scale = Vector3(sc, sc, sc)

func picked():
	is_picked = true
	fruit.disconnect("picked", self.picked)

func fully_grown():
	fruit.set_pickable(true)
