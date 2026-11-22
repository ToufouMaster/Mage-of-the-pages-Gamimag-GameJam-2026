extends Node2D

@onready var icon := $Icon
var cur_spell : Spell

@onready var stock_label := $StockLabel
@onready var reload_bar := $ReloadBar

func set_spell_page(spell: Spell):
	icon.texture = spell.icon
	cur_spell = spell
	stock_label.text = str(spell.actual_max_stock) + " / " + str(spell.actual_max_stock)

func _process(_delta: float) -> void:
	if cur_spell == null: return
	if (cur_spell.current_stock < cur_spell.actual_max_stock):
		reload_bar.show()
		reload_bar.max_value = cur_spell.recharge_timer.wait_time
		reload_bar.value = cur_spell.recharge_timer.time_left
	else:
		reload_bar.hide()
	var progress = (cur_spell.cast_timer.wait_time-cur_spell.cast_timer.time_left) / cur_spell.cast_timer.wait_time
	icon.material.set_shader_parameter("progress", 1 if cur_spell.spell_ready else progress)
	stock_label.text = str(cur_spell.current_stock) + " / " + str(cur_spell.actual_max_stock)
