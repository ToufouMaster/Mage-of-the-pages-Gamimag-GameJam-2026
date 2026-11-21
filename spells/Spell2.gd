extends Spell

func cast_spell():
	for i in range(-4,4):
		var new_projectile : Projectile = self.projectile_setup()
		new_projectile.angle = i*PI/4
		new_projectile.amount_of_target = 3
		MainSingleton.projectile_spawner.spawn_projectile(new_projectile.get_spawn_position(), new_projectile)
