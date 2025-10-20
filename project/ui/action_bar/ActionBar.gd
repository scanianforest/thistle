extends PanelContainer

@onready var slots: Array[ActionBarSlot] = [
	%Slot0,
	%Slot1,
	%Slot2,
	%Slot3,
	%Slot4,
	%Slot5,
	%Slot6,
	%Slot7,
	%Slot8,
	%Slot9,
]

func _ready() -> void:
	PlayerChannel.inventory_item_added.connect(_on_inventory_item_added)

func get_first_empty_slot() -> ActionBarSlot:
	var rs = slots.slice(1)
	print(rs)
	rs.push_back(slots[0])
	
	for slot in rs:
		if slot.item == null:
			print(slot)
			return slot
	return null

func get_slot(index: int) -> ActionBarSlot:
	return slots[index]

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("action_bar"):
		var slot = int(event.as_text())
		for i in range(10):
			if i == slot: slots[i].activate()
			else: slots[i].deactivate()

#region Signal Handlers
func _on_inventory_item_added(item: ItemResource) -> void:
	var slot = get_first_empty_slot()
	if slot: 
		print(slot)
		slot.item = item
#endregion
