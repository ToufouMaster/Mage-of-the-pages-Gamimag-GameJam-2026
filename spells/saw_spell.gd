extends Spell

var first_saw : Projectile

func cast_spell(_angle_offset : float = 0):
	var new_projectile : Projectile = self.projectile_setup()
	new_projectile.angle = 0
	if _angle_offset == 0:
		first_saw = new_projectile
		new_projectile.position = Vector2.ZERO
		MainSingleton.player.add_child(new_projectile)
	else: 
		new_projectile.position = Vector2(randf_range(-600,600), randf_range(-600, 600))
		new_projectile.scale = Vector2.ONE * 3
		first_saw.sprite.add_child(new_projectile)
