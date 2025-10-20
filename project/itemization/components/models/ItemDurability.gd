class_name ItemDurability

var durability: float
var max_durability: float

func _init(component: ItemDurabilityComponent):
	durability = component.durability
	max_durability = component.max_durability