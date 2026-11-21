extends Node2D
class_name ProjectileSpawner

func spawn_projectile(pos: Vector2, projectile: Projectile):
	projectile.global_position = pos
	self.add_child(projectile)
