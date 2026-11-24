extends Spell

func _init() -> void:
	self.base_price = 25
	self.price_modulation = 15

func get_title():
	return "Shockwave"

func get_description():
	return "Send a shockwave around the player in a large range that deals"+ str(self.dmg)+ " damages and repels the enemies far away ("+ str(self.get_actual_cast_cooldown()).pad_decimals(1) +")."


func cast_spell(_angle_offset : float = 0):
	var new_projectile : Projectile = self.projectile_setup()
	new_projectile.angle = 0
	#Use dmg to determine the strength of the knockback
	new_projectile.shock_wave_strength = new_projectile.dmg
	MainSingleton.projectile_spawner.spawn_projectile(new_projectile.get_spawn_position(), new_projectile)
