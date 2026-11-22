extends Node2D
class_name Shop

@onready var dice = $RerollStool/Dice

@onready var marker_spell_left : Marker2D = $Markers/SpellLeft
@onready var marker_spell_right : Marker2D = $Markers/SpellRight
@onready var marker_sticker_left : Marker2D = $Markers/StickerLeft
@onready var marker_sticker_right : Marker2D = $Markers/StickerRight
@onready var spell_items : Node2D = $Market/Items/Spells
@onready var sticker_items : Node2D = $Market/Items/Stickers
@onready var money_display : Node2D = $"Money Display"

@export var spells: Array[PackedScene]
@export var stickers: Array[Texture2D]
@export var bookmarks: Array[Texture2D]
@export var sticker_prices: Dictionary[Spell.Sticker, Vector2]
const SHOP_ITEM_SCENE = preload("res://shop/ShopItem.tscn")
const SHOP_SPELL_SCRIPT = preload("res://shop/shop_item_spell.gd")
const SHOP_STICKER_SCRIPT = preload("res://shop/shop_item_sticker.gd")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	dice.button.mouse_entered.connect(_on_reroll_dice_mouse_entered)
	dice.button.mouse_exited.connect(_on_reroll_dice_mouse_exited)
	dice.button.pressed.connect(_on_reroll_dice_pressed)
	generate_items()
	reroll_items()

func clear_items():
	for i in spell_items.get_children():
		i.queue_free()
	for i in sticker_items.get_children():
		i.queue_free()

func generate_items():
	clear_items()
	for i in range(4):
		var tmp := SHOP_ITEM_SCENE.instantiate() as ShopItem
		tmp.set_script(SHOP_SPELL_SCRIPT)
		spell_items.add_child(tmp)
		tmp.position = marker_spell_left.position + (marker_spell_right.position - marker_spell_left.position) * ((i + 0.0)/(3))
		
	for i in range(3):
		var tmp := SHOP_ITEM_SCENE.instantiate() as ShopItem
		tmp.set_script(SHOP_STICKER_SCRIPT)
		tmp.is_sticker = true
		sticker_items.add_child(tmp)
		tmp.position = marker_sticker_left.position + (marker_sticker_right.position - marker_sticker_left.position) * ((i + 0.0)/(2))
	
	reroll_items()

func reroll_items():
	var price_multiplier = 1+FuncSingleton.get_pascal_triangle_float((1+float(MainSingleton.round))/5.0)
	print("price_multiplier: "+ str(price_multiplier))
	for i : ShopItem in spell_items.get_children():
		if i.bought: continue
		i.item_id = randi() % spells.size()
		var instance : Spell = MainSingleton.shop.spells[i.item_id].instantiate()
		i.price = (instance.base_price+randi()%max(1, instance.price_modulation)) * price_multiplier*3
		if instance.base_price == 0: push_warning(instance.get_title() + "Spell shop price statistics are missing")
	for i : ShopItem in sticker_items.get_children():
		if i.bought: continue
		i.item_id = randi() % stickers.size()
		var instance = sticker_prices.get(i.item_id) if sticker_prices.size() > i.item_id else Vector2.ONE
		if sticker_prices.size() <= i.item_id: push_warning(Spell.Sticker.keys().get(i.item_id)+" sticker shop price statistics are missing")
		i.price = (instance.x+randi()%max(1, instance.y)) * price_multiplier*5
	dice.money_display.money = (50*((1+dice.rolls)**1.5))*price_multiplier if dice.rolls > 0 else 50*price_multiplier

func _on_reroll_dice_mouse_entered() -> void:
	dice.modulate = Color(1.825, 1.825, 1.825)
	
func _on_reroll_dice_mouse_exited() -> void:
	dice.modulate = Color.WHITE
	
func _on_reroll_dice_pressed() -> void:
	if MainSingleton.coinLetter >= dice.money_display.money:
		dice.animate_roll()
		dice.rolls += 1
		reroll_items()
