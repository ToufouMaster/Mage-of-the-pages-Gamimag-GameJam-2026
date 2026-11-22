extends Node2D
class_name SpellBook

var spell_list : Array[Node]
var current_spell_index : int = 0

@onready var notepad : Node2D = $NotePad
@onready var healthbar : Node2D = $HealthBar
@onready var hourglass : Hourglass = $Hourglass


func _ready() -> void:
	FuncSingleton.start_run.connect(_on_run_start)

func _on_run_start():
	start_match()
	spell_list = $Spells.get_children()


func _input(event: InputEvent) -> void:
	if (event.is_action_pressed("switch up")):
		self.turn_page_up()
	if (event.is_action_pressed("switch down")):
		self.turn_page_down()
	for i in range(1, 6):
		if (event.is_action_pressed(str(i))):
			if bookmark_dico.has(str(i)):
				go_to_page(bookmark_dico.get(str(i)))

func start_match():
	FuncSingleton.start_match.emit()
	self.go_to_page(0)
	hourglass.start_round_timer()
	hourglass.timer.timeout.connect(end_match)

func end_match():
	$"../GameAnimationPlayer".play("TurnPageToShop")
	FuncSingleton.end_match.emit()

func add_spell(spell_scene : PackedScene, spell_position : int):
	var new_spell : Spell = spell_scene.instantiate() as Spell
	$Spells.add_child(new_spell)
	self.spell_list.insert(spell_position, new_spell)

func add_spell_current_index(spell_scene : PackedScene):
	add_spell(spell_scene,current_spell_index)
	current_spell_index +=1
	
func add_sticker_current_index(sticker:Spell.Sticker):
	var spell = spell_list[current_spell_index] as Spell
	spell.add_sticker(sticker)

func update_stickers():
	$NotePad/Page/SpellPage.set_stickers(spell_list[current_spell_index])
	$NotePad/Background/SpellPage.set_stickers(spell_list[current_spell_index])
	

func go_to_page(index : int):
	var turn_down = index > current_spell_index
	var old_spell = spell_list[current_spell_index]
	var new_spell = spell_list[index]
	old_spell.switch_off()
	self.current_spell_index = index
	if turn_down:
		$NotePad/NotepadAnimationPlayer.play("PageDown", -1, 5.0)
		$NotePad/Page/SpellPage.remove_stickers()
		$NotePad/Page/SpellPage.set_stickers(spell_list[current_spell_index])
		$NotePad/Page/SpellPage.set_spell_page(new_spell)
		await $NotePad/NotepadAnimationPlayer.animation_finished
		$NotePad/Background/SpellPage.remove_stickers()
		
	else:
		$NotePad/NotepadAnimationPlayer.play("PageDown", -1, -5.0, true)
		$NotePad/Background/SpellPage.remove_stickers()
		$NotePad/Background/SpellPage.set_stickers(spell_list[current_spell_index])
		$NotePad/Background/SpellPage.set_spell_page(new_spell)
		await $NotePad/NotepadAnimationPlayer.animation_finished
		$NotePad/Page/SpellPage.remove_stickers()
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


func _on_sign_button_pressed() -> void:
	$"../GameAnimationPlayer".play("TurnPageToWorld")
	start_match()

func _on_game_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "TurnPageToWorld":
		MainSingleton.round += 1

var next_bookmark : int = 1
var bookmark_dico : Dictionary[String, int]
var bookmark_available : bool = true

func add_bookmark(related_spell_index : int):
	if bookmark_available:
		bookmark_dico.set(str(next_bookmark), related_spell_index) 
		next_bookmark += 1
		bookmark_available = next_bookmark < 5
	else:
		push_error("too much bookmark in sells")
