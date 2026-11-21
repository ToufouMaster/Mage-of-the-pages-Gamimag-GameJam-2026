extends Node2D


var player : Player
var projectile_spawner : ProjectileSpawner
var coinLetter:int = 0

func _ready() -> void:
	player = get_tree().root.get_node("Node2D/WorldViewport/World/Player")
	projectile_spawner = get_tree().root.get_node("Node2D/WorldViewport/World/ProjectileSpawner")


func gain_money(amount : int):
	self.coinLetter += amount
