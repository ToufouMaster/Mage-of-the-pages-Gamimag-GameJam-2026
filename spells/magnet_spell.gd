extends Spell

func cast_spell(angle_offset : float = 0):
	MainSingleton.player.coin_picker_area.scale = Vector2(4,4)
	await get_tree().create_timer(self.duration).timeout
	MainSingleton.player.coin_picker_area.scale = Vector2(1,1)
