extends GdUnitTestSuite

@warning_ignore_start("redundant_await")

@onready var runner: GdUnitSceneRunner
var sut: Game


func before_test() -> void:
	runner = scene_runner("res://game/game.tscn")
	sut = runner.scene() as Game


func test_game_lifecycle() -> void:
	var monitor = monitor_signals(sut)

	sut.start()

	await assert_signal(monitor).is_emitted("started")
