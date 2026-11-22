extends Projectile

@onready var sprite : Sprite2D = $Sprite2D

func get_spawn_position():
	return MainSingleton.player.position

func _process(delta):
	self.sprite.rotation_degrees += delta * 360

func effect_on_ennemy(_ennemy : Ennemy):
	pass
