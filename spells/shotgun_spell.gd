extends Spell

func _init() -> void:
	self.base_price = 50
	self.price_modulation = 20

func get_title():
	return "Shotgun"

func get_description():
	return "Shoot 3 projectiles in the direction of the nearest enemy in a circular formation and deals ("+str(self.get_actual_cast_cooldown()).pad_decimals(1)+") moderately high damage."

func cast_spell(angle_offset : float = 0):
	var target_direction = MainSingleton.player.get_closer_ennemy_direction()
	for offset in [-PI/16, 0, PI/16]:
		var new_projectile : Projectile = self.projectile_setup()
		new_projectile.angle = (randf()*PI*2 if target_direction == null else target_direction.angle()) + offset + angle_offset
		MainSingleton.projectile_spawner.spawn_projectile(new_projectile.get_spawn_position(), new_projectile)
