extends Node2D

@export var spells: Array[PackedScene]
@export var stickers: Array[Texture2D]
const SHOP_ITEM_STICKER_SCENE = preload("res://shop/ShopItemSticker.tscn")
const SHOP_ITEM_SPELL_SCENE = preload("res://shop/ShopItemSpell.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var chosenSpells = []
	while chosenSpells.size() < 4:
		var r = randi() % spells.size()
		if not chosenSpells.has(r) :
			chosenSpells.append(r)
	for i in range(4):
		var tmp := SHOP_ITEM_SPELL_SCENE.instantiate() as ShopItemSpell
		var spell = spells[chosenSpells[i]].instantiate()
		tmp.texture = spell.icon
		tmp.item = spells[chosenSpells[i]]
		add_child(tmp)
		tmp.position = $Left.position + ($Right.position - $Left.position) * ((i + 0.0)/(chosenSpells.size()-1))
		
	var chosenStickers = []
	while chosenStickers.size() < 3:
		var r = randi() % stickers.size()
		if not chosenStickers.has(r) :
			chosenStickers.append(r)
	for i in range(3):
		var tmp := SHOP_ITEM_STICKER_SCENE.instantiate() as ShopItemSticker
		tmp.texture = stickers[chosenStickers[i]]
		tmp.stickerType = chosenStickers[i]
		add_child(tmp)
		tmp.position = $Left2.position + ($Right2.position - $Left2.position) * ((i + 0.0)/(chosenStickers.size()-1))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$moneyDisplay.text = "Letters : " + str(MainSingleton.coinLetter)
	pass

var previouslyClicked = 0
func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.button_mask == 1 and event.button_mask != previouslyClicked:
		print("reroll not implemented")
	previouslyClicked = event.button_mask
