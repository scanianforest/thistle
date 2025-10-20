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

func _ready() -> void:
	PlayerChannel.action_bar_slot_selected.connect(_on_action_bar_slot_selected)
	PlayerChannel.action_bar_slot_updated.connect(_on_action_bar_slot_updated)

	for i in range(slots.size()):
		var slot = slots[i]
		slot.clicked.connect(func() -> void:
			PlayerChannel.on_action_bar_slot_selection_requested(i)
		)

func get_slot(index: int) -> ActionBarSlotUI:
	return slots[index]

#region Signal Handlers
func _on_action_bar_slot_selected(index: int) -> void:
	for i in range(slots.size()):
		if i == index:
			slots[i].activate()
		else:
			slots[i].deactivate()


func _on_action_bar_slot_updated(index: int, item: Item) -> void:
	slots[index].item = item
#endregion
