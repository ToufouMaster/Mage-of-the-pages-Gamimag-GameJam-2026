extends Node2D
class_name Shop

@onready var dice = $RerollStool/Dice

@onready var marker_spell_left : Marker2D = $Markers/SpellLeft
@onready var marker_spell_right : Marker2D = $Markers/SpellRight
@onready var marker_sticker_left : Marker2D = $Markers/StickerLeft
@onready var marker_sticker_right : Marker2D = $Markers/StickerRight
@onready var spell_items : Node2D = $Items/Spells
@onready var sticker_items : Node2D = $Items/Stickers

@export var spells: Array[PackedScene]
@export var stickers: Array[Texture2D]
const SHOP_ITEM_SCENE = preload("res://shop/ShopItem.tscn")
const SHOP_SPELL_SCRIPT = preload("res://shop/shop_item_spell.gd")
const SHOP_STICKER_SCRIPT = preload("res://shop/shop_item_sticker.gd")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	dice.button.mouse_entered.connect(_on_reroll_dice_mouse_entered)
	dice.button.mouse_exited.connect(_on_reroll_dice_mouse_exited)
	dice.button.pressed.connect(_on_reroll_dice_pressed)
	
	var chosenSpells = []
	while chosenSpells.size() < 4:
		var r = randi() % spells.size()
		if not chosenSpells.has(r) :
			chosenSpells.append(r)
	for i in range(4):
		var tmp := SHOP_ITEM_SCENE.instantiate() as ShopItem
		tmp.set_script(SHOP_SPELL_SCRIPT)
		spell_items.add_child(tmp)
		tmp.item_id = chosenSpells[i]
		tmp.position = marker_spell_left.position + (marker_spell_right.position - marker_spell_left.position) * ((i + 0.0)/(chosenSpells.size()-1))
		
	var chosenStickers = []
	while chosenStickers.size() < 3:
		var r = randi() % stickers.size()
		if not chosenStickers.has(r) :
			chosenStickers.append(r)
	for i in range(3):
		var tmp := SHOP_ITEM_SCENE.instantiate() as ShopItem
		tmp.set_script(SHOP_STICKER_SCRIPT)
		sticker_items.add_child(tmp)
		tmp.item_id = chosenStickers[i]
		tmp.position = marker_sticker_left.position + (marker_sticker_right.position - marker_sticker_left.position) * ((i + 0.0)/(chosenStickers.size()-1))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$moneyDisplay.text = "Letters : " + str(MainSingleton.coinLetter)
	pass

func _on_reroll_dice_mouse_entered() -> void:
	dice.modulate = Color(1.825, 1.825, 1.825)
	
func _on_reroll_dice_mouse_exited() -> void:
	dice.modulate = Color.WHITE
	
func _on_reroll_dice_pressed() -> void:
	dice.animate_roll()
