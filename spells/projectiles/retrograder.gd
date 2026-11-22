extends Projectile


var affected_ennemy : Array[Node] = []

func get_spawn_position():
	return MainSingleton.player.position

func effect_on_ennemy(_ennemy : Ennemy):
	if (_ennemy not in affected_ennemy):
		var new_letter : int = clamp(_ennemy.letter - 1, 0, 25)
		affected_ennemy.append(_ennemy)
		_ennemy.set_up_letter(new_letter, _ennemy.get_parent().letter_sprites[new_letter], true)
