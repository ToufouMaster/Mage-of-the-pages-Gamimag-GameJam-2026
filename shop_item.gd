extends Node2D
class_name ShopItem

@export var texture:Texture2D
@export var price: int
var bought:bool
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$itemAppearance.texture = texture
	$boughtSticker.visible = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.button_mask == 1 && bought == false:
		if MainSingleton.coinLetter >= price:
			print("bought")
			$boughtSticker.visible = true
			var tween := create_tween()
			$boughtSticker.scale = Vector2(0.6,0.6)
			$boughtSticker.self_modulate.a = 0
			$StompAudioPlayer.play()
			var angle = randf()
			tween.tween_property($boughtSticker, "self_modulate", Color.WHITE, 0.1)
			tween.parallel().tween_property($boughtSticker, "scale", Vector2(0.15, 0.15), 0.2)
			tween.parallel().tween_property($boughtSticker, "rotation_degrees", (-20 if angle < 0.5 else +20)*(1+randf()), 0.2)
			tween.tween_callback($CoinTossAudioPlayer.play)
			MainSingleton.coinLetter -= price
			bought = true
		else:
			print("you poor dumbass")
	pass # Replace with function body.
