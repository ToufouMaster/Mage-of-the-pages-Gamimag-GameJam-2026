extends Projectile


func get_spawn_position():
	return MainSingleton.player.position

@warning_ignore("unused_parameter")
func effect_on_ennemy(ennemy : Ennemy):
	pass
