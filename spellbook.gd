extends Node2D
class_name SpellBook

@export var spell_list : Array[Spell]
var current_spell_index : int = 0

func go_to_page(index : int):
	spell_list[current_spell_index].switch_off()
	self.current_spell_index = index
	spell_list[current_spell_index].switch_on()

func turn_page_down():
	pass
	
