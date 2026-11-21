extends Spell

func cast_spell(angle_offset : float = 0):
	var target_direction = MainSingleton.player.get_closer_ennemy_direction()
	for offset in [-PI/16, 0, PI/16]:
		var new_projectile : Projectile = self.projectile_setup()
		new_projectile.angle = (randf()*PI*2 if target_direction == null else target_direction.angle()) + offset + angle_offset
		MainSingleton.projectile_spawner.spawn_projectile(new_projectile.get_spawn_position(), new_projectile)
	await get_tree().create_timer(0.3).timeout
	for offset in [-PI/16, 0, PI/16]:
		var new_projectile : Projectile = self.projectile_setup()
		new_projectile.angle = (randf()*PI*2 if target_direction == null else target_direction.angle()) + offset + angle_offset
		MainSingleton.projectile_spawner.spawn_projectile(new_projectile.get_spawn_position(), new_projectile)
