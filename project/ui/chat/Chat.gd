class_name Chat extends Control


class ChatMessage:
	var sender: String
	var message: String


@onready var _log: Control = %Log
@onready var _input: LineEdit = %Input

var _history: Array[ChatMessage] = []


func _ready() -> void:
	Lobby.player_connected.connect(_on_player_connected)
	Lobby.player_disconnected.connect(_on_player_disconnected)
	Lobby.server_disconnected.connect(_on_lobby_disconnected)
	Lobby.connected.connect(_on_lobby_connected)
	Lobby.disconnected.connect(_on_lobby_disconnected)

	_input.text_submitted.connect(_on_input_text_submitted)


@rpc("any_peer", "call_local")
func send_message(message: String) -> void:
	#var id = multiplayer.get_remote_sender_id()
	#var player_info = Lobby.get_player_info(id)

	#if player_info == null:
	#	_add_local_message("Unknown player (ID: %d) tried to send a message." % id)
	#	return

	var msg = ChatMessage.new()
	msg.sender = "Player_%d" % multiplayer.get_remote_sender_id()
	msg.message = message

	_add_message(msg)
	_history.push_back(msg)


func _add_message(msg: ChatMessage) -> void:
	var label = RichTextLabel.new()
	label.push_font_size(8)
	label.push_color(Color.YELLOW)
	label.add_text("[%s]: " % msg.sender)
	label.pop()
	label.add_text("%s" % msg.message)
	label.pop_all()
	label.fit_content = true
	_log.add_child(label)


func _add_local_message(message: String) -> void:
	var label = RichTextLabel.new()
	label.push_font_size(8)
	label.push_color(Color.DARK_GRAY)
	label.add_text(message)
	label.pop_all()
	label.fit_content = true
	_log.add_child(label)


func _clear_log() -> void:
	for c in _log.get_children():
		c.queue_free()


func _on_player_connected(id: int, info: Lobby.PlayerInfo) -> void:
	Log.debug("%s connected. Sending chat history..." % id)
	_add_local_message("%s connected." % info.name)

	if multiplayer.is_server():
		for msg in _history:
			send_message.rpc_id(id, msg.message)


func _on_player_disconnected(id: int, info: Lobby.PlayerInfo) -> void:
	Log.debug("%s disconnected with ID: %d" % [info.name, id])
	_add_local_message("%s disconnected." % info.name)


func _on_lobby_connected() -> void:
	_add_local_message("Connected to lobby.")


func _on_lobby_disconnected() -> void:
	_history.clear()
	_clear_log()


func _on_input_text_submitted(new_text: String) -> void:
	if new_text.strip_edges() == "":
		return
	send_message.rpc(new_text)
	_input.text = ""
