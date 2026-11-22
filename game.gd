extends Node2D

func _ready() -> void:
	$StartButton.pressed.connect(start_game)

func start_game():
	$WorldViewport/World.show()
	$Shop.show()
	$SpellBook.show()
	$StartButton.hide()
	FuncSingleton.start_run.emit()
