extends Node2D
class_name ProjectileSpawner

static var projectile_scene : PackedScene = preload("res://projectile.tscn")

func spawn_projectile(pos: Vector2, projectile: Projectile):
	projectile.global_position = pos
	self.add_child(projectile)
