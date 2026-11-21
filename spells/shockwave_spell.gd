extends Spell

func cast_spell(_angle_offset : float = 0):
	var new_projectile : Projectile = self.projectile_setup()
	new_projectile.angle = 0
	#Use dmg to determine the strength of the knockback
	new_projectile.shock_wave_strength = new_projectile.dmg
	#reset dmg
	new_projectile.dmg = 0
	MainSingleton.projectile_spawner.spawn_projectile(new_projectile.get_spawn_position(), new_projectile)
