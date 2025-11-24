class_name ActionBarData

var slots: Array[ItemData] = [null, null, null, null, null, null, null, null, null, null]
var selected_slot_index: int = 0


func to_dict() -> Dictionary:
	var slot_dicts = slots.map(func(item: ItemData): return item.to_dict() if item else {})

	return {"slots": slot_dicts, "selected": selected_slot_index}


static func from_dict(dict: Dictionary) -> ActionBarData:
	var data = ActionBarData.new()

	var slot_dicts = dict.get("slots", [null, null, null, null, null, null, null, null, null, null])
	var slot_items = (
		slot_dicts.map(func(item_dict): return ItemData.from_dict(item_dict) if item_dict else null)
		as Array[ItemData]
	)

	var typed_slots: Array[ItemData] = []

	typed_slots.append_array(slot_items)

	data.slots = typed_slots
	data.selected_slot_index = dict.get("selected", 1)

	return data
