extends Spell

func _init() -> void:
	self.base_price = 35
	self.price_modulation = 20

func get_title():
	return "Circular spikes"

func get_description():
	return "Shoot 8 spells in a circular shape around the player every " +str(self.get_actual_cast_cooldown()).pad_decimals(1)+ " seconds that deal " + str(self.actual_dmg).pad_decimals(1) + " damage each."

func cast_spell(angle_offset : float = 0):
	for i in range(-4,4):
		var new_projectile : Projectile = self.projectile_setup()
		new_projectile.angle = i*PI/4 + angle_offset
		new_projectile.amount_of_target = 3
		MainSingleton.projectile_spawner.spawn_projectile(new_projectile.get_spawn_position(), new_projectile)
