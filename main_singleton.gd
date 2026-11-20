extends Node2D


var player : CharacterBody2D
var projectile_spawner : ProjectileSpawner

func _ready() -> void:
	player = get_tree().root.get_node("Node2D/WorldViewport/World/Player")
	projectile_spawner = get_tree().root.get_node("Node2D/WorldViewport/World/ProjectileSpawner")
