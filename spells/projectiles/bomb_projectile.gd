extends Projectile

func get_spawn_position():
	return MainSingleton.player.position


var bomb : PackedScene = preload("res://spells/projectiles/shock_wave.tscn")

func end_life_handling():
	var new_bomb : Projectile = bomb.instantiate()
	new_bomb.dmg = self.dmg
	new_bomb.shock_wave_strength = 0.5
	new_bomb.amount_of_target = 10000
	new_bomb.scale = Vector2(0.3, 0.3)
	new_bomb.duration = 0.2
	new_bomb.speed = 0
	new_bomb.position = Vector2.ZERO
	MainSingleton.projectile_spawner.spawn_projectile(self.global_position, new_bomb)
	super.end_life_handling()

func effect_on_ennemy(_ennemy : Ennemy):
	pass
