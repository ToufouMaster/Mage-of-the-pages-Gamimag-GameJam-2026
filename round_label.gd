extends Label


func _ready() -> void:
	FuncSingleton.start_match.connect(start_match)


func start_match():
	self.text = "Round" + str(MainSingleton.round)
	self.show()
	await get_tree().create_timer(1.5).timeout
	self.hide()
