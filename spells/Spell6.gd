extends Spell

func cast_spell():
	MainSingleton.player.speed += self.dmg
	await get_tree().create_timer(self.duration).timeout
	MainSingleton.player.speed -= self.dmg
