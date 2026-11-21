extends Node2D
class_name SpellBook

var spell_list : Array[Node]
var current_spell_index : int = 0




func _ready() -> void:
	spell_list = $Spells.get_children()
	start_match()

func _input(event: InputEvent) -> void:
	if (event.is_action_pressed("switch up")):
		self.turn_page_up()
	if (event.is_action_pressed("switch down")):
		self.turn_page_down()

func start_match():
	self.current_spell_index = 0
	for spell in spell_list:
		spell.start_match()
	spell_list[0].switch_on()

func end_match():
	for spell in spell_list:
		spell.end_match()

func add_spell(spell_scene : PackedScene, position : int):
	var new_spell : Spell = spell_scene.instantiate() as Spell
	$Spells.add_child(new_spell)
	self.spell_list.insert(position, new_spell)
	
func add_spell_current_index(spell_scene : PackedScene):
	add_spell(spell_scene,current_spell_index)
	current_spell_index +=1

func go_to_page(index : int):
	print("went to " + str(index))
	var turn_down = index > current_spell_index
	var old_spell = spell_list[current_spell_index]
	var new_spell = spell_list[index]
	old_spell.switch_off()
	self.current_spell_index = index
	if turn_down:
		$NotePad/NotepadAnimationPlayer.play("PageDown", -1, 5.0)
		$NotePad/Page/SpellPage.set_spell_page(new_spell)
	else:
		$NotePad/NotepadAnimationPlayer.play("PageDown", -1, -5.0, true)
		$NotePad/Background/SpellPage.set_spell_page(new_spell)
	new_spell.switch_on()

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
