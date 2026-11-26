extends Spell

func _init() -> void:
	self.base_price = 35
	self.price_modulation = 40

func get_title():
	return "RetroGrader"

func get_description():
	return "Shoot a Roulleau Comprésseur that decrease the level of damaged letters by one when hit and deals " + str(self.get_actual_damage()).pad_decimals(1) + " damage."

func cast_spell(angle_offset : float = 0):
	var new_projectile : Projectile = self.projectile_setup()
	var target_direction = MainSingleton.player.get_closer_ennemy_direction()
	new_projectile.angle = (randf()*PI*2 if target_direction == null else target_direction.angle()) + angle_offset
	MainSingleton.projectile_spawner.spawn_projectile(new_projectile.get_spawn_position(), new_projectile)
