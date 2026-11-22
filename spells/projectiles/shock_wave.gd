extends Projectile

func get_spawn_position():
	return MainSingleton.player.position

@export var shock_wave_strength : float = 1

func effect_on_ennemy(ennemy : Ennemy):
	ennemy.apply_knockback(ennemy.global_position - self.global_position, shock_wave_strength, 2)
