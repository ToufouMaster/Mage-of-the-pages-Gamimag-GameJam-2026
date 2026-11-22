extends Spell

func _init() -> void:
	self.base_price = 60
	self.price_modulation = 30

func get_title():
	return "Shockwave"

func get_description():
	return "Send a shockwave around the player in a large range that deal no damage but repel the enemies far away."


func cast_spell(_angle_offset : float = 0):
	var new_projectile : Projectile = self.projectile_setup()
	new_projectile.angle = 0
	#Use dmg to determine the strength of the knockback
	new_projectile.shock_wave_strength = new_projectile.dmg
	#reset dmg
	new_projectile.dmg = 0
	MainSingleton.projectile_spawner.spawn_projectile(new_projectile.get_spawn_position(), new_projectile)
