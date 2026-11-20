extends CharacterBody2D
class_name Ennemy

@export var hitbox : Area2D

@export var letter : String = "a"

var pv : int

func _ready() -> void:
	pv = FuncSingleton.get_pascal_triangle(FuncSingleton.get_letter_order(letter))
