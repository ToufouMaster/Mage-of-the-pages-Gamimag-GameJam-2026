extends Node2D

@onready var icon := $Icon
var cur_spell : Spell

func set_spell_page(spell: Spell):
	icon.texture = spell.icon
	cur_spell = spell

func _process(delta: float) -> void:
	if cur_spell == null: return
	var progress = (cur_spell.timer.wait_time-cur_spell.timer.time_left) / cur_spell.timer.wait_time
	icon.material.set_shader_parameter("progress", progress)
