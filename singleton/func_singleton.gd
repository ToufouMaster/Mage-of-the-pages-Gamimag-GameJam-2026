extends Node2D

func get_pascal_triangle(n : int) -> int:
	@warning_ignore("integer_division")
	return n*(n+1)/2

func get_pascal_triangle_float(n : float) -> float:
	return n*(n+1)/2.0

const voyelles_array = [0,4,8,14,20,24]

func is_voyelle(letter : int):
	return voyelles_array.has(letter)

func is_consomn(letter : int):
	return not is_voyelle(letter)


signal start_match
signal end_match
