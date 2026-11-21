@abstract
extends Node
class_name Spell

@export var max_stock : int = 3
@export var cast_cooldown : float = 0.5
@export var recharge_cooldown : float = 1
@export var dmg : int
@export var duration : float
@export var icon : CompressedTexture2D
@export var projectile : PackedScene

var current_stock = max_stock
var cast_timer : Timer
var recharge_timer : Timer
var is_selected : bool = false
var spell_ready : bool = false



func _ready() -> void:
	cast_timer = Timer.new()
	recharge_timer = Timer.new()
	add_child(cast_timer)
	add_child(recharge_timer)
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
	current_stock += 1
	if current_stock >= max_stock:
		self.recharge_timer.paused = true


func _on_cooldown_end():
	if is_selected:
		if (self.current_stock > 0):
			current_stock -= 1
			recharge_timer.paused = false
			cast_spell()
			spell_ready = false
	else:
		cast_timer.paused = true
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
		cast_timer.paused = false
	

func switch_off():
	is_selected = false

@abstract func cast_spell()

func projectile_setup() -> Projectile:
	var new_projectile : Projectile = self.projectile.instantiate() as Projectile
	new_projectile.dmg = self.dmg
	new_projectile.duration = self.duration
	return new_projectile
