@abstract
extends Node
class_name Spell

@export var max_stock : int = 3

@export var cast_cooldown : float = 0.5

@export var recharge_cooldown : float = 1


@export var dmg : int

var actual_dmg = dmg

@export var duration : float = 5
@export var speed : float = 100
@export var icon : CompressedTexture2D
@export var projectile : PackedScene

var current_stock = max_stock
var cast_timer : Timer
var recharge_timer : Timer
var switch_timer : Timer
var passif_timer : Timer

var is_selected : bool = false
var spell_ready : bool = false
var level = 1



enum Sticker {DMG_UP, COOLDOWN_DOWN, STOCKAGE_UP, DOUBLE_SPELL, PASSIF_SPELL, CONSONNE_CRIT, VOYELLE_CRIT, BOOKMARK} 

@export var debug_stickers : Dictionary[Sticker, int]
var sticked_stickers : Dictionary[Sticker, int]

func _ready() -> void:
	
	cast_timer = Timer.new()
	recharge_timer = Timer.new()
	passif_timer = Timer.new()
	switch_timer = Timer.new()
	add_child(cast_timer)
	add_child(recharge_timer)
	add_child(passif_timer)
	add_child(switch_timer)
	switch_timer.wait_time = 0.75
	self.cast_timer.timeout.connect(_on_cooldown_end)
	self.recharge_timer.timeout.connect(_on_recharge)
	self.passif_timer.timeout.connect(_on_passif_launch)
	
	for entry in Sticker.values():
		sticked_stickers.set(entry, 0)
	for entry in debug_stickers.keys():
		for i in range(0, debug_stickers.get(entry)):
			self.add_sticker(entry)
	
	update_dmg()
	update_stock()
	update_cooldowns()

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

func _on_passif_launch():
	if (!is_selected):
		cast_spell_sticker_wrapper()

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
	for i in range(0, self.sticked_stickers.get(Sticker.DOUBLE_SPELL) + 1):
		cast_spell(i*PI/16*(1 if randi_range(0,1) == 0 else -1))

@abstract func cast_spell(angle_offset : float = 0)

func projectile_setup() -> Projectile:
	var new_projectile : Projectile = self.projectile.instantiate() as Projectile
	new_projectile.dmg = self.actual_dmg
	new_projectile.duration = self.duration
	new_projectile.speed = self.speed
	return new_projectile

func update_cooldowns():
	self.cast_timer.wait_time = cast_cooldown * (0.75 ** (sticked_stickers[Sticker.COOLDOWN_DOWN]))
	self.recharge_timer.wait_time =  recharge_cooldown * (0.80 ** (sticked_stickers[Sticker.COOLDOWN_DOWN]))
	self.passif_timer.wait_time = self.recharge_timer.wait_time * (5 * (0.8 **sticked_stickers[Sticker.PASSIF_SPELL]))

func update_dmg():
	self.actual_dmg = self.dmg * (1.5 ** (sticked_stickers[Sticker.DMG_UP]))

func update_stock():
	if (sticked_stickers[Sticker.STOCKAGE_UP] == 0):
		return
	self.max_stock = (self.max_stock / sticked_stickers[Sticker.STOCKAGE_UP]) * (sticked_stickers[Sticker.STOCKAGE_UP]+1)

func add_sticker(sticker_type : Sticker):
	self.sticked_stickers[sticker_type] += 1
	match sticker_type:
		Sticker.DMG_UP:
			update_dmg()
		Sticker.COOLDOWN_DOWN:
			update_cooldowns()
		Sticker.PASSIF_SPELL:
			passif_timer.start()
		Sticker.STOCKAGE_UP:
			update_stock()
