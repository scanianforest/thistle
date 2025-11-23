extends Control

var item: ItemData:
	set(value):
		_on_item_set(value)


func _on_item_set(new_item: ItemData) -> void:
	%ItemNameLabel.text = new_item.resource.item_name
	%ItemDescriptionLabel.text = new_item.resource.description
