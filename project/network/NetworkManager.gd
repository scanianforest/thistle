extends Node

const DEFAULT_PORT: int = 7923
const MAX_CLIENTS: int = 32

var _peer: ENetMultiplayerPeer = ENetMultiplayerPeer.new()


func _ready() -> void:
	_peer.peer_connected.connect(_on_peer_connected)
	_peer.peer_disconnected.connect(_on_peer_disconnected)


func host(port: int = 7890, max_clients = 32) -> void:
	_peer.create_server(port, max_clients)
	multiplayer.multiplayer_peer = _peer
	Log.pr("Server started on port %d" % port)


func join(address: String, port: int) -> void:
	_peer.create_client(address, port)
	multiplayer.multiplayer_peer = _peer


func _on_peer_connected(id: int) -> void:
	Log.pr("Peer connected with ID: %d" % id)


func _on_peer_disconnected(id: int) -> void:
	Log.pr("Peer disconnected with ID: %d" % id)
