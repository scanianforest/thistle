class_name EquipmentComponent extends Node

signal item_equipped(item: ItemData)

var equipped_item: ItemData = null


func equip_item(item: ItemData) -> void:
	equipped_item = item
	item_equipped.emit(item)

	if item:
		Log.todo("Equipped item: %s" % item.resource.item_name)
