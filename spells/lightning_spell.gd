extends Spell

func _init() -> void:
	self.base_price = 40
	self.price_modulation = 20

func get_title():
	return "Selective lighting strike"

func get_description():
	return "Strike all the enemies that share a randomly selected letter and deal " + str(self.actual_dmg).pad_decimals(1) + " damage."


func cast_spell(_angle_offset : float = 0):
	var every_ennemies : Array[Node] = MainSingleton.ennemy_spawner.get_children().filter(func(x) : return x is Ennemy)
	if (every_ennemies.is_empty()):
		return
	var chosen_letter : int = every_ennemies.pick_random().letter
	for selected_ennemy in every_ennemies.filter(func (x) : return x.letter == chosen_letter):
		selected_ennemy.take_damage(self.dmg)
