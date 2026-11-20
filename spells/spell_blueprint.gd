@abstract
extends Node2D
class_name Spell

@export var timer : Timer
@export var cooldown : float = 10
@export var dmg : int
@export var duration : float
@export var icon : CompressedTexture2D

var is_selected : bool = false
var spell_ready : bool = false

func _ready() -> void:
	self.timer.timeout.connect(_on_cooldown_end)
	self.timer.wait_time = cooldown

func start_match():
	spell_ready = true
	timer.start()

func end_match():
	timer.stop()

func _on_cooldown_end():
	if (is_selected):
		cast_spell()
	else:
		timer.paused = true
		spell_ready = true

func switch_on():
	is_selected = true
	#wait 1 sec before resuming spell
	await get_tree().create_timer(1).timeout
	#If is_selected has been switched off in the mean time,
	#will simply not cast spell and keep spell_ready true
	if spell_ready:
		_on_cooldown_end()
	#if is still selected after the one second, we resume the timer
	if is_selected:
		timer.paused = false
	

func switch_off():
	is_selected = false

@abstract func cast_spell()
