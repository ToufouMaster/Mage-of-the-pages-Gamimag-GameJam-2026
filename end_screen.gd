extends Node2D


func _ready() -> void:
	FuncSingleton.game_over.connect(func (): $RoundLabel.text = "Round "+ str(MainSingleton.round) + " Reached")

func _on_button_pressed() -> void:
	self.get_parent().hide()
	FuncSingleton.start_run.emit()
