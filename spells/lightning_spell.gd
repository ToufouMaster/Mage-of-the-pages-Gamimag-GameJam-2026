extends Spell

func cast_spell(_angle_offset : float = 0):
	var every_ennemies : Array[Node] = MainSingleton.ennemy_spawner.get_children().filter(func(x) : return x is Ennemy)
	if (every_ennemies.is_empty()):
		return
	var chosen_letter : int = every_ennemies.pick_random().letter
	for selected_ennemy in every_ennemies.filter(func (x) : return x.letter == chosen_letter):
		selected_ennemy.take_damage(self.dmg)
