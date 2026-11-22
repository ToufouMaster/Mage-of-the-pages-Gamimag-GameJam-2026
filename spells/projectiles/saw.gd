extends Projectile

func _ready() -> void:
	MainSingleton.play_audioplayer_at_pos($ProjectileHitPlayer, global_position)

func get_spawn_position():
	return MainSingleton.player.position

func _process(delta):
	self.sprite.rotation_degrees += delta * 360

func effect_on_ennemy(_ennemy : Ennemy):
	pass
