extends Node2D

func get_letter_scale(n : int) -> int:
	@warning_ignore("integer_division")
	return (n+1) * 2

func get_pascal_triangle_float(n : float) -> float:
	return n*(n+1)/2.0

const voyelles_array = [0,4,8,14,20,24]

const consone_array = [1,2,3,5,6,7,9,10,11,12,13,15,16,17,18,19,21,22,23,25]


signal start_run
signal game_over
signal start_match
signal end_match
