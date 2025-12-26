class_name ActionBarComponent extends Node

signal slot_selected(index: int)
signal slot_set(index: int, item: ItemData)

var slots: Array[ItemData] = []
var selected_slot_index: int


func _ready() -> void:
	if is_multiplayer_authority():
		UIChannel.set_actionbar(self)

	slots.resize(10)


func save() -> ActionBarData:
	var data = ActionBarData.new()
	data.slots = slots.duplicate()
	data.selected_slot_index = selected_slot_index
	return data


func load(data: ActionBarData) -> void:
	for i in len(data.slots):
		set_slot.call_deferred(i, data.slots[i])
	select_slot.call_deferred(data.selected_slot_index)


func set_slot(index: int, item: ItemData) -> void:
	slots[index] = item
	slot_set.emit(index, item)


func select_slot(index: int) -> void:
	selected_slot_index = index
	slot_selected.emit(index)


func find_item(item: ItemData) -> int:
	for i in len(slots):
		if slots[i] == item:
			return i
	return -1


func _get_first_empty_slot() -> int:
	for i in [1, 2, 3, 4, 5, 6, 7, 8, 9, 0]:
		if slots[i] == null:
			return i
	return -1


#region Signal Handlers
func _on_action_bar_slot_update_requested(index: int, item: ItemData) -> void:
	set_slot(index, item)


func _on_action_bar_slot_selection_requested(index: int) -> void:
	if selected_slot_index == index:
		return
	select_slot(index)


func _on_inventory_item_added(item: ItemData) -> void:
	var empty_slot_index = _get_first_empty_slot()
	if empty_slot_index != -1:
		set_slot(empty_slot_index, item)


func _on_inventory_item_removed(item: ItemData) -> void:
	for i in len(slots):
		if slots[i] == item:
			set_slot(i, null)
#endregion
