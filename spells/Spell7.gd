extends Spell

func cast_spell():
	var new_projectile : Projectile = self.projectile_setup()
	new_projectile.amount_of_target = 1000000
	new_projectile.angle = 0
	new_projectile.speed = 0
	MainSingleton.projectile_spawner.spawn_projectile(new_projectile.get_spawn_position(), new_projectile)
