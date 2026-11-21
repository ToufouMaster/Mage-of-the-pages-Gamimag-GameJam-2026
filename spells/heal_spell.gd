extends Spell

func cast_spell(_angle_offset : float = 0):
	MainSingleton.player.heal_damage(self.dmg)
