extends Node

var ERROR_INVENTORY_NOT_FOUND: String = "InventoryComponent not found at path: %s"

@rpc("any_peer", "call_local", "reliable")
func give_item(inventory_path: NodePath, item_data_dict: Dictionary, count: int) -> void:
	var rid = multiplayer.get_remote_sender_id()

	if not is_multiplayer_authority():
		return

	var inventory: InventoryComponent = get_tree().root.get_node(inventory_path)
	if inventory == null:
		Log.err(ERROR_INVENTORY_NOT_FOUND % inventory_path)
		return

	inventory.rpc_add_item.rpc_id(rid, item_data_dict, count)


func remove_item(inventory_path: NodePath, item_data_dict: Dictionary, count: int) -> void:
	var rid = multiplayer.get_remote_sender_id()

	if not is_multiplayer_authority():
		return

	var inventory: InventoryComponent = get_tree().root.get_node(inventory_path)
	if inventory == null:
		Log.err(ERROR_INVENTORY_NOT_FOUND % inventory_path)
		return

	inventory.rpc_remove_item.rpc_id(rid, item_data_dict, count)


@rpc("any_peer", "call_local", "reliable")
func transfer_item(
	from_inventory_path: NodePath,
	to_inventory_path: NodePath,
	item_data_dict: Dictionary,
	count: int
) -> void:
	if not is_multiplayer_authority():
		return

	var from_inventory: InventoryComponent = get_tree().root.get_node(from_inventory_path)
	if from_inventory == null:
		Log.err(ERROR_INVENTORY_NOT_FOUND % from_inventory_path)
		return

	var to_inventory: InventoryComponent = get_tree().root.get_node(to_inventory_path)
	if to_inventory == null:
		Log.err(ERROR_INVENTORY_NOT_FOUND % to_inventory_path)
		return

	var to_owner = to_inventory.get_multiplayer_authority()
	var from_owner = from_inventory.get_multiplayer_authority()

	to_inventory.rpc_add_item.rpc_id(to_owner, item_data_dict, count)
	from_inventory.rpc_remove_item.rpc_id(from_owner, item_data_dict, count)
