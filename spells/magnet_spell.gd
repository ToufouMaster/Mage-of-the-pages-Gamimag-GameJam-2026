extends Spell

func _init() -> void:
	self.base_price = 40
	self.price_modulation = 20

func get_title():
	return "Magnet"

func get_description():
	return "Picks up all the coins around the player "+str(get_range())+"x the original scale during " +str(self.actual_duration).pad_decimals(1)+ " seconds."

func get_range():
	return 3 + self.level

func cast_spell(_angle_offset : float = 0):
	MainSingleton.player.coin_picker_area.scale = Vector2.ONE * get_range()
	MainSingleton.player.sprite.self_modulate = Color.BLUE
	await get_tree().create_timer(self.duration).timeout
	MainSingleton.player.sprite.self_modulate = Color.WHITE
	MainSingleton.player.coin_picker_area.scale = Vector2(1,1)
