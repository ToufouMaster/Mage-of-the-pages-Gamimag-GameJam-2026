extends Node2D



var player : Player
var money_displayer : Node 
var projectile_spawner : ProjectileSpawner
var spell_book : SpellBook
var shop : Shop
var ennemy_spawner : Node2D
var game_animation_player : AnimationPlayer
var coinLetter:int = 0 : 
	set(val):
		coinLetter = val
		money_displayer.set_money(val)
var round = 1

func _ready() -> void:
	player = get_tree().root.get_node("Node2D/WorldViewport/World/Player")
	money_displayer = get_tree().root.get_node("Node2D/Shop/Money Display")
	projectile_spawner = get_tree().root.get_node("Node2D/WorldViewport/World/ProjectileSpawner")
	spell_book = get_tree().root.get_node("Node2D/SpellBook")
	ennemy_spawner = get_tree().root.get_node("Node2D/WorldViewport/World/EnnemySpawner")
	shop = get_tree().root.get_node("Node2D/Shop")
	game_animation_player = get_tree().root.get_node("Node2D/GameAnimationPlayer")
	FuncSingleton.start_run.connect(_on_run_start)
	
func _on_run_start():
	coinLetter = 0
	round = 1

func gain_money(amount : int):
	self.coinLetter += amount
