extends Node2D


var player : Player
var projectile_spawner : ProjectileSpawner
var spell_book : SpellBook
var shop : Shop
var ennemy_spawner : Node2D
var coinLetter:int = 0

func _ready() -> void:
	player = get_tree().root.get_node("Node2D/WorldViewport/World/Player")
	projectile_spawner = get_tree().root.get_node("Node2D/WorldViewport/World/ProjectileSpawner")
	spell_book = get_tree().root.get_node("Node2D/SpellBook")
	ennemy_spawner = get_tree().root.get_node("Node2D/WorldViewport/World/EnnemySpawner")
	shop = get_tree().root.get_node("Node2D/Shop")

func gain_money(amount : int):
	self.coinLetter += amount
