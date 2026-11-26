extends Spell

func _init() -> void:
	self.base_price = 10
	self.price_modulation = 5

func get_title():
	return "Chronopost"

func get_description():
	return "Shoots projectiles with a very low cooldown and a big ammo capacity in random direction around the player and deal " +  str(self.get_actual_damage()).pad_decimals(1) + " damage."

func cast_spell(angle_offset : float = 0):
	var new_projectile : Projectile = self.projectile_setup()
	new_projectile.angle = randf()*PI*2 + angle_offset
	MainSingleton.projectile_spawner.spawn_projectile(new_projectile.get_spawn_position(), new_projectile)
