extends PanelContainer

@onready var slots: Array[ActionBarSlotUI] = [
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

var actionbar: ActionBarComponent = null


func _ready() -> void:
	UIChannel.actionbar_set.connect(_on_actionbar_set)

	for i in range(slots.size()):
		var slot = slots[i]
		slot.dropped_on.connect(func(item: ItemData): _on_slot_dropped_on(i, item))
		slot.clicked.connect(func(): actionbar.select_slot(i))
		slot.secondary.connect(func(): actionbar.set_slot(i, null))


func get_slot(index: int) -> ActionBarSlotUI:
	return slots[index]


#region Signal Handlers
func _on_actionbar_set(action_bar: ActionBarComponent) -> void:
	actionbar = action_bar
	actionbar.slot_set.connect(_on_action_bar_slot_updated)
	actionbar.slot_selected.connect(_on_action_bar_slot_selected)


func _on_action_bar_slot_selected(index: int) -> void:
	print("Action bar slot %d selected" % index)
	for i in range(slots.size()):
		if i == index:
			slots[i].activate()
		else:
			slots[i].deactivate()


func _on_action_bar_slot_updated(index: int, item: ItemData) -> void:
	slots[index].item = item


func _on_slot_dropped_on(index: int, item: ItemData) -> void:
	print("Item dropped on action bar slot %d" % index)
	actionbar.set_slot(index, item)
#endregion
