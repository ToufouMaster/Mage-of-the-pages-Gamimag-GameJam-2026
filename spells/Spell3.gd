extends Spell

func cast_spell():
	var new_projectile : Projectile = self.projectile_setup()
	var target_direction = MainSingleton.player.get_closer_ennemy_direction()
	new_projectile.angle = randf()*PI*2 if target_direction == null else target_direction.angle()
	new_projectile.speed = 200
	MainSingleton.projectile_spawner.spawn_projectile(new_projectile.get_spawn_position(), new_projectile)
