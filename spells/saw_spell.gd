extends Spell

func _init() -> void:
	self.base_price = 50
	self.price_modulation = 20

func get_title():
	return "Saw blade"

func get_description():
	return "Deal a small amount of damage (" + str(self.actual_dmg).pad_decimals(1) + ") very fast around the player in a short range."

var first_saw : Projectile

func cast_spell(_angle_offset : float = 0):
	var new_projectile : Projectile = self.projectile_setup()
	new_projectile.angle = 0
	if _angle_offset == 0:
		first_saw = new_projectile
		new_projectile.position = Vector2.ZERO
		MainSingleton.player.add_child(new_projectile)
	else: 
		new_projectile.position = Vector2(randf_range(-500,500), randf_range(-500, 500))
		new_projectile.scale = Vector2.ONE * 3
		first_saw.sprite.add_child(new_projectile)
