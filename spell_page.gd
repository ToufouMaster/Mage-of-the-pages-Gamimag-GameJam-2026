extends Node2D

@onready var icon := $Icon
var cur_spell : Spell

@onready var stock_label := $StockLabel

func set_spell_page(spell: Spell):
	icon.texture = spell.icon
	cur_spell = spell
	stock_label.text = str(spell.max_stock) + " / " + str(spell.max_stock)

func _process(delta: float) -> void:
	if cur_spell == null: return
	var progress = (cur_spell.cast_timer.wait_time-cur_spell.cast_timer.time_left) / cur_spell.cast_timer.wait_time
	icon.material.set_shader_parameter("progress", progress)
	stock_label.text = str(cur_spell.current_stock) + " / " + str(cur_spell.max_stock)
