@abstract
extends Node
class_name Spell

@export var max_stock : int = 3
@export var cast_cooldown : float = 0.5
@export var recharge_cooldown : float = 1
@export var dmg : int
@export var duration : float = 5
@export var icon : CompressedTexture2D
@export var projectile : PackedScene

var current_stock = max_stock
var cast_timer : Timer
var recharge_timer : Timer
var switch_timer : Timer
var is_selected : bool = false
var spell_ready : bool = false

var level = 1

enum Sticker {DMG_UP, COOLDOWN_DOWN, STOCKAGE_UP, DOUBLE_SPELL, PASSIF_SPELL, CONSONNE_CRIT, VOYELLE_CRIT, BOOKMARK} 

var sticked_stickers : Dictionary[Sticker, int]

func _ready() -> void:
	for entry in Sticker.values():
		sticked_stickers.set(entry, 1)
	
	cast_timer = Timer.new()
	recharge_timer = Timer.new()
	switch_timer = Timer.new()
	add_child(cast_timer)
	add_child(recharge_timer)
	add_child(switch_timer)
	switch_timer.wait_time = 0.75
	self.cast_timer.timeout.connect(_on_cooldown_end)
	self.cast_timer.wait_time = cast_cooldown
	self.recharge_timer.timeout.connect(_on_recharge)
	self.recharge_timer.wait_time = recharge_cooldown

func start_match():
	current_stock = max_stock
	spell_ready = true
	recharge_timer.start()
	recharge_timer.paused = true
	cast_timer.start()

func end_match():
	recharge_timer.stop()
	cast_timer.stop()

func _on_recharge():
	current_stock = clamp(current_stock + 1, 0, self.max_stock)
	if is_selected:
		self.cast_timer.paused = false

func _on_cooldown_end():
	if is_selected:
		if (self.current_stock > 0):
			current_stock -= 1
			recharge_timer.paused = false
			cast_spell_sticker_wrapper()
			spell_ready = false
			if (self.current_stock == 0):
				cast_timer.paused = true
		else:
			cast_timer.paused = true
	else:
		cast_timer.paused = true
		spell_ready = true

func switch_on():
	is_selected = true
	#wait 1 sec before resuming spell
	switch_timer.start()
	await switch_timer.timeout
	#If is_selected has been switched off in the mean time,
	#will simply not cast spell and keep spell_ready true
	if spell_ready:
		_on_cooldown_end()
	#if is still selected after the one second, we resume the timer
	if is_selected:
		cast_timer.paused = false
	

func switch_off():
	switch_timer.stop()
	is_selected = false

func cast_spell_sticker_wrapper():
	for i in range(0, self.sticked_stickers.get(Sticker.DOUBLE_SPELL)):
		cast_spell()
		await get_tree().create_timer(0.1).timeout

@abstract func cast_spell()

func projectile_setup() -> Projectile:
	var new_projectile : Projectile = self.projectile.instantiate() as Projectile
	new_projectile.dmg = self.dmg
	new_projectile.duration = self.duration
	return new_projectile
