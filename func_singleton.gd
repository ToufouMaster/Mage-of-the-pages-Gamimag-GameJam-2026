extends Node2D

func get_letter_order(letter : String) -> int:
	return ord(letter.to_upper()) - ord("A")

func get_pascal_triangle(n : int) -> int:
	return n*(n+1)/2
