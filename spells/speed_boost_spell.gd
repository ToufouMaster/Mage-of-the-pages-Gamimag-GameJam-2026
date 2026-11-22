extends Spell

func _init() -> void:
	self.base_price = 50
	self.price_modulation = 100

func get_title():
	return "Speedforce"

func get_description():
	return "Accelerate the player's movement speed by a LOT ("+ str(self.get_actual_cast_cooldown()).pad_decimals(1) +")."


func cast_spell(_angle_offset : float = 0):
	MainSingleton.player.speed += self.dmg
	await get_tree().create_timer(self.duration).timeout
	MainSingleton.player.speed -= self.dmg
