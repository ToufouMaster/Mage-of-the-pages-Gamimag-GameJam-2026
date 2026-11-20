extends Node2D

func get_pascal_triangle(n : int) -> int:
	@warning_ignore("integer_division")
	return n*(n+1)/2
