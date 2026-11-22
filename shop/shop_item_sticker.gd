extends ShopItem
class_name ShopItemSticker

func set_item_id(value):
	super(value)
	$Background.visible = false
	$itemAppearance.texture = MainSingleton.shop.stickers[item_id]
	bought_sticker.get_parent().scale = Vector2.ONE*0.6

func buy():
	super()
	MainSingleton.spell_book.add_sticker_current_index(item_id)
