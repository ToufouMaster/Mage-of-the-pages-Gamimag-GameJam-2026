extends Spell

func cast_spell():
	MainSingleton.player.heal_damage(self.dmg)
