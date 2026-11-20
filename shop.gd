extends Node2D

@export var items: Array[Texture2D]
const SHOP_ITEM_SCENE = preload("res://ShopItem.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(items.size()):
		var tmp := SHOP_ITEM_SCENE.instantiate() as ShopItem
		tmp.texture = items[i]
		add_child(tmp)

		tmp.position = $Left.position + ($Right.position - $Left.position) * ((i + 0.0)/(items.size()-1))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$moneyDisplay.text = "you have " + str(MainSingleton.coinLetter) + " moni"
	pass
