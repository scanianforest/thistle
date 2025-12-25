class_name NetworkManager extends Node

const DEFAULT_PORT: int = 7923
const MAX_CLIENTS: int = 32

var _peer: ENetMultiplayerPeer = ENetMultiplayerPeer.new()


func _ready() -> void:
	_peer.peer_connected.connect(_on_peer_connected)
	_peer.peer_disconnected.connect(_on_peer_disconnected)

	_setup_console_commands()
	_setup_client_connection_signals()


func host(port: int = 7890, max_clients = 32) -> void:
	_peer.create_server(port, max_clients)
	multiplayer.multiplayer_peer = _peer
	Log.pr("Server started on port %d" % port)


func join(address: String = "127.0.0.1", port: int = 7890) -> void:
	var client_err = _peer.create_client(address, port)
	if client_err != OK:
		Log.err("Failed to create client: %s" % client_err)
		return

	multiplayer.multiplayer_peer = _peer


func leave() -> void:
	if multiplayer.multiplayer_peer == null:
		Log.warn("No multiplayer peer to disconnect")
		return

	if multiplayer.is_server():
		Log.pr("Shutting down server")
		for id in multiplayer.get_peers():
			Log.pr("Disconnecting peer ID: %d" % id)
			multiplayer.multiplayer_peer.disconnect_peer(id)
	else:
		Log.pr("Disconnecting from server")

	multiplayer.multiplayer_peer.close()


func _setup_client_connection_signals() -> void:
	multiplayer.server_disconnected.connect(_on_server_disconnected)


func _on_peer_connected(id: int) -> void:
	Log.pr("Peer connected with ID: %d" % id)


func _on_peer_disconnected(id: int) -> void:
	Log.pr("Peer disconnected with ID: %d" % id)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action("ui_up"):
		_send_message.rpc()


func _on_server_disconnected() -> void:
	Log.pr("Disconnected from server")
	multiplayer.multiplayer_peer = null


@rpc("any_peer", "call_remote")
func _send_message() -> void:
	print(
		(
			"Message [%s] received on peer [%s], from peer [%s]"
			% [
				"Test Message",
				str(multiplayer.get_unique_id()),
				str(multiplayer.get_remote_sender_id())
			]
		)
	)


func _setup_console_commands() -> void:
	(
		LimboConsole
		. register_command(
			host,
			"host",
			"Starts a server on the specified port.",
		)
	)

	(
		LimboConsole
		. register_command(
			join,
			"join",
			"Joins a server at the specified address and port.",
		)
	)

	(
		LimboConsole
		. register_command(
			leave,
			"leave",
			"Leaves the current server or disconnects the client.",
		)
	)
