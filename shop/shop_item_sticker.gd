extends ShopItem
class_name ShopItemSticker

func set_item_id(value):
	super(value)
	$Background.visible = false
	$itemAppearance.texture = MainSingleton.shop.stickers[item_id] if item_id < 8 else MainSingleton.shop.bookmarks[MainSingleton.spell_book.next_bookmark -1]
	bought_sticker.get_parent().scale = Vector2.ONE*0.6
	$itemAppearance.scale = Vector2.ONE*0.8

func buy():
	super()
	MainSingleton.spell_book.add_sticker_current_index(item_id)
	MainSingleton.spell_book.update_stickers()
