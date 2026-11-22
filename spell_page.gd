extends Node2D

@onready var icon := $Icon
var cur_spell : Spell

@onready var stock_label := $StockLabel
@onready var reload_bar := $ReloadBar
@export var Stickers : Array[Texture2D]
var stickersNodes : Array[Node]

func remove_stickers():
	for elt in stickersNodes:
		elt.queue_free()
	stickersNodes.clear()

func set_stickers(spell :Spell):
	remove_stickers()
	for key in spell.sticked_stickers.keys():
		for sticker in spell.sticker_positions:
			var tmp = Sprite2D.new()
			tmp.texture = Stickers[sticker.x]
			tmp.position = Vector2(sticker.y,sticker.z)
			tmp.scale = Vector2(0.5,0.5)
			stickersNodes.append(tmp)
			self.add_child(tmp)

func set_spell_page(spell: Spell):
	icon.texture = spell.icon
	cur_spell = spell
	stock_label.text = str(spell.actual_max_stock) + " / " + str(spell.actual_max_stock)
	#add_sticker(1)
		

func _process(_delta: float) -> void:
	if cur_spell == null: return
	if (cur_spell.current_stock < cur_spell.actual_max_stock):
		reload_bar.show()
		reload_bar.max_value = cur_spell.recharge_timer.wait_time
		reload_bar.value = cur_spell.recharge_timer.wait_time-cur_spell.recharge_timer.time_left
	else:
		reload_bar.hide()
	var progress = (cur_spell.cast_timer.wait_time-cur_spell.cast_timer.time_left) / cur_spell.cast_timer.wait_time
	icon.material.set_shader_parameter("progress", 1 if cur_spell.spell_ready else progress)
	stock_label.text = str(cur_spell.current_stock) + " / " + str(cur_spell.actual_max_stock)
