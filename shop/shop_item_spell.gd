extends ShopItem
class_name ShopItemSpell

func set_item_id(value):
	super(value)
	var spell : Spell = MainSingleton.shop.spells[item_id].instantiate()
	$itemAppearance.texture = spell.icon
	bought_sticker.get_parent().scale = Vector2.ONE*0.8

func buy():
	super()
	MainSingleton.spell_book.add_spell_current_index(MainSingleton.shop.spells[item_id])
	$Background.hide()
