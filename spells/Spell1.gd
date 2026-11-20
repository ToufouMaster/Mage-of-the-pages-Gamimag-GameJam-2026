extends Spell

func cast_spell():
	var projectile : Projectile = MainSingleton.projectile_spawner.projectile_scene.instantiate()
	projectile.angle = randf()*PI*2
	MainSingleton.projectile_spawner.spawn_projectile(projectile.get_spawn_position(), projectile)
