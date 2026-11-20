extends Node2D
class_name SpellBook

@export var spell_list : Array[Spell]
var current_spell_index : int = 0

func _ready() -> void:
	start_match()

func start_match():
	self.current_spell_index = 0
	for spell in spell_list:
		spell.start_match()
	spell_list[0].switch_on()

func end_match():
	for spell in spell_list:
		spell.end_match()


func go_to_page(index : int):
	print("went to " + str(index))
	spell_list[current_spell_index].switch_off()
	self.current_spell_index = index
	spell_list[current_spell_index].switch_on()

func turn_page_down():
	if (self.current_spell_index + 1 < spell_list.size()):
		go_to_page(self.current_spell_index + 1)
		return true
	return false

func turn_page_up():
	if (self.current_spell_index - 1 >= 0):
		go_to_page(self.current_spell_index - 1)
		return true
	return false
