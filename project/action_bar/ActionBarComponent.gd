class_name ActionBarComponent extends Node

var slots: Array[Item] = []
var selected_slot_index: int

func _ready() -> void:
	slots.resize(10)
	for i in slots.size():
		slots[i] = null
	
	PlayerChannel.action_bar_slot_update_requested.connect(_on_action_bar_slot_update_requested)
	PlayerChannel.action_bar_slot_selection_requested.connect(_on_action_bar_slot_selection_requested)
	PlayerChannel.inventory_item_added.connect(_on_inventory_item_added)

	select_slot.call_deferred(1)

func set_slot(index: int, item: Item) -> void:
	slots[index] = item
	PlayerChannel.on_action_bar_slot_updated(index, item)

func select_slot(index: int) -> void:
	selected_slot_index = index
	PlayerChannel.on_action_bar_slot_selected(index)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("action_bar"):
		var slot = int(event.as_text())
		select_slot(slot)
	elif event.is_action_pressed("action_bar_next"):
		var next_index = (selected_slot_index + 1) % slots.size()
		select_slot(next_index)
	elif event.is_action_pressed("action_bar_previous"):
		var previous_index = (selected_slot_index - 1 + slots.size()) % slots.size()
		select_slot(previous_index)


func _get_first_empty_slot() -> int:
	for i in [1, 2, 3, 4, 5, 6, 7, 8, 9, 0]:
		if slots[i] == null: return i
	return -1

#region Signal Handlers
func _on_action_bar_slot_update_requested(index: int, item: Item) -> void:
	set_slot(index, item)

func _on_action_bar_slot_selection_requested(index: int) -> void:
	if selected_slot_index == index: return
	select_slot(index)

func _on_inventory_item_added(item: Item) -> void:
	var empty_slot_index = _get_first_empty_slot()
	if empty_slot_index != -1:
		set_slot(empty_slot_index, item)

#endregion
