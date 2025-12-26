extends Node

signal player_connected(id: int, info: PlayerInfo)
signal player_disconnected(id: int, info: PlayerInfo)
signal server_disconnected
signal connected
signal disconnected


class PlayerInfo:
	var name: String

	func _init(dict: Dictionary) -> void:
		self.name = dict.get("name", "Stranger")

	func to_dict() -> Dictionary:
		return {
			"name": name,
		}


var _info: PlayerInfo = PlayerInfo.new({"name": "Player_%d" % randi_range(1000, 9999)})
var _players: Dictionary[int, PlayerInfo] = {}


func _ready() -> void:
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)
	multiplayer.server_disconnected.connect(_on_server_disconnected)
	multiplayer.connected_to_server.connect(_on_connected_to_server)
	multiplayer.connection_failed.connect(_on_connection_failed)

	_setup_console_commands()


#region Public
func host(port: int = 7890, max_clients = 32) -> void:
	var peer: ENetMultiplayerPeer = ENetMultiplayerPeer.new()
	if peer.create_server(port, max_clients) != OK:
		Log.err("Failed to create server on port %d" % port)
		return

	Log.pr("Server started on port %d" % port)
	multiplayer.multiplayer_peer = peer

	_players[1] = _info
	player_connected.emit(1, _info)


func join(address: String = "127.0.0.1", port: int = 7890) -> void:
	var peer := ENetMultiplayerPeer.new()
	var client_err = peer.create_client(address, port)
	if client_err != OK:
		Log.err("Failed to create client: %s" % client_err)
		return

	multiplayer.multiplayer_peer = peer
	_players[multiplayer.get_unique_id()] = _info


func leave() -> void:
	if multiplayer.multiplayer_peer is OfflineMultiplayerPeer:
		Log.warn("Not connected to any server")
		return

	multiplayer.multiplayer_peer = OfflineMultiplayerPeer.new()
	disconnected.emit()


func get_player_info(id: int) -> PlayerInfo:
	return _players.get(id, null)


#endregion Public

#region Private

@rpc("any_peer", "call_remote")
func _register_player(info_dict: Dictionary) -> void:
	var lid = multiplayer.get_unique_id()
	var rid = multiplayer.get_remote_sender_id()
	var info = PlayerInfo.new(info_dict)

	_players[rid] = info

	player_connected.emit(rid, info)
	Log.pr("Player %d registered player %d with info %s" % [lid, rid, info_dict])


func _remove_player(id: int) -> void:
	var info = _players.get(id, null)
	if _players.erase(id):
		Log.pr("Player %s with ID %d has left the lobby" % [info.name, id])
		player_disconnected.emit(id, info)
	else:
		Log.warn("Tried to remove non-existent player with ID %d" % id)


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


#region Signals


func _on_peer_connected(id: int) -> void:
	Log.debug("[%d] Peer connected with ID: %d" % [multiplayer.get_unique_id(), id])
	_register_player.rpc_id(id, _info.to_dict())


func _on_peer_disconnected(id: int) -> void:
	Log.debug("[%d] Peer disconnected with ID: %d" % [multiplayer.get_unique_id(), id])
	_remove_player(id)


func _on_server_disconnected() -> void:
	Log.pr("[%d] Disconnected from server" % multiplayer.get_unique_id())
	multiplayer.multiplayer_peer = OfflineMultiplayerPeer.new()
	server_disconnected.emit()


func _on_connected_to_server() -> void:
	Log.pr("Connected with ID %d to server" % multiplayer.get_unique_id())
	connected.emit()


func _on_connection_failed() -> void:
	Log.pr("Connection to server failed")

#endregion Signals
