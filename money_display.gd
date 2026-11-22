extends Node2D

var money : int = 0 : set = set_money
@export var centered = true

func set_money(value):
	money = value
	$moneyDisplay.text = str(money)

func _ready() -> void:
	$moneyDisplay.horizontal_alignment = HorizontalAlignment.HORIZONTAL_ALIGNMENT_CENTER if centered else HorizontalAlignment.HORIZONTAL_ALIGNMENT_LEFT
