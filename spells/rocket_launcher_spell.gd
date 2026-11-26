extends Spell

func _init() -> void:
	self.base_price = 35
	self.price_modulation = 15

func get_title():
	return "Rocket Launcher"

func get_description():
	return "Shoot in the direction of the nearest enemy, deal " + str(self.get_actual_damage()).pad_decimals(1) + " damage and repel nearby enemies on impact."

func cast_spell(angle_offset : float = 0):
	var new_projectile : Projectile = self.projectile_setup()
	var target_direction = MainSingleton.player.get_closer_ennemy_direction()
	new_projectile.angle = (randf()*PI*2 if target_direction == null else target_direction.angle()) + angle_offset
	MainSingleton.projectile_spawner.spawn_projectile(new_projectile.get_spawn_position(), new_projectile)
