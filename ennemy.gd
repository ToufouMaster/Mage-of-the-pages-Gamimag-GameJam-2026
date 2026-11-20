extends CharacterBody2D
class_name Ennemy

@export var hitbox : Area2D

@export var letter : String = "a"

var pv : int
var speed : float

func _ready() -> void:
	pv = FuncSingleton.get_pascal_triangle(FuncSingleton.get_letter_order(letter))

func take_damage(amount : int):
	self.pv -= amount
	if (self.pv < 1):
		die()

func die():
	pass
