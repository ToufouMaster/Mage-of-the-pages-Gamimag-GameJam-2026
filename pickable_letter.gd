extends Area2D
class_name PickableLetter

var value : int = 1

func _ready() -> void:
	self.area_entered.connect(_on_area_entered)


func _on_area_entered(_area):
	MainSingleton.gain_money(value)
	self.queue_free()
