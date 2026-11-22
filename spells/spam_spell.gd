extends Spell

func cast_spell(angle_offset : float = 0):
	var new_projectile : Projectile = self.projectile_setup()
	new_projectile.angle = randf()*PI*2 + angle_offset
	MainSingleton.projectile_spawner.spawn_projectile(new_projectile.get_spawn_position(), new_projectile)
