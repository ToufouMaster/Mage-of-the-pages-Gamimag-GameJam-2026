extends Node2D
class_name ShopItem

@onready var bought_sticker = $Bought/boughtSticker

@export var item_id : int : set = set_item_id
@export var price: int
var bought:bool


func _ready() -> void:
	bought_sticker.visible = false

func set_item_id(value):
	item_id = value

func buy():
	$itemAppearance.hide()

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.button_mask == 1 && bought == false:
		if MainSingleton.coinLetter >= price:
			buy()
			bought_sticker.visible = true
			var tween := create_tween()
			bought_sticker.scale = Vector2(0.6,0.6)
			bought_sticker.self_modulate.a = 0
			$StompAudioPlayer.play()
			var angle = randf()
			tween.tween_property(bought_sticker, "self_modulate", Color.WHITE, 0.1)
			tween.parallel().tween_property(bought_sticker, "scale", Vector2(0.15, 0.15), 0.2)
			tween.parallel().tween_property(bought_sticker, "rotation_degrees", (-20 if angle < 0.5 else +20)*(1+randf()), 0.2)
			tween.tween_callback($CoinTossAudioPlayer.play)
			MainSingleton.coinLetter -= price
			bought = true
		else:
			print("you poor dumbass")
