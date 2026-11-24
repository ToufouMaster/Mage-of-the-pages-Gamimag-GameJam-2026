@abstract
extends Node
class_name Spell

@export var max_stock : int = 1
var actual_max_stock : int
@export var dmg : int
var actual_dmg = dmg

@export var duration : float = 5
var actual_duration : float = duration

@export var speed : float = 100
var actual_speed : float = speed

@export var target_amount : int = 1
var actual_target_amount : int = target_amount

@export var cast_cooldown : float = 0.5
@export var recharge_cooldown : float = 1

@export var icon : CompressedTexture2D
@export var projectile : PackedScene
@export var pentacle_color : Color
@export var pentacle_duration : float = 0.5


var base_price = 0
var price_modulation = 0

var current_stock = 0
var cast_timer : Timer
var recharge_timer : Timer
var passif_timer : Timer

var is_selected : bool = false
var spell_ready : bool = false

var level = 0
var item_amount : int = 0 : 
	set(val):
		item_amount = val
		if (item_amount >= level+2):
			level_up()

func level_up():
	self.item_amount = 0
	self.level += 1
	update_everything()

enum Sticker {DMG_UP, COOLDOWN_DOWN, STOCKAGE_UP, SWIFT_SPELL_UP, DOUBLE_SPELL, PASSIF_SPELL, CONSONNE_CRIT, VOYELLE_CRIT, BOOKMARK} 


var weak_letter : Dictionary[int, float]

@export var debug_stickers : Dictionary[Sticker, int]
var sticked_stickers : Dictionary[Sticker, int]
var sticker_positions : Array[Vector3]

func _ready() -> void:
	FuncSingleton.start_match.connect(start_match)
	FuncSingleton.end_match.connect(end_match)
	
	cast_timer = Timer.new()
	recharge_timer = Timer.new()
	passif_timer = Timer.new()
	add_child(cast_timer)
	add_child(recharge_timer)
	add_child(passif_timer)
	self.cast_timer.timeout.connect(_on_cooldown_end)
	self.recharge_timer.timeout.connect(_on_recharge)
	self.passif_timer.timeout.connect(_on_passif_launch)
	for entry in Sticker.values():
		sticked_stickers.set(entry, 0)

func start_match():
	if MainSingleton.round == 0:
		for entry in debug_stickers.keys():
			for i in range(0, debug_stickers.get(entry)):
				self.add_sticker(entry)
	update_everything()
	current_stock = actual_max_stock
	is_selected = false
	spell_ready = false
	await get_tree().create_timer(2).timeout
	recharge_timer.start()
	cast_timer.start()
	recharge_timer.paused = false
	cast_timer.paused = false

func end_match():
	recharge_timer.paused = true
	recharge_timer.stop()
	cast_timer.paused = true
	cast_timer.stop()

func _on_recharge():
	current_stock = clamp(current_stock + 1, 0, self.actual_max_stock)
	if (cast_timer.paused):
		_on_cooldown_end()

func _on_cooldown_end():
	if is_selected:
		if (self.current_stock > 0):
			recharge_timer.paused = false
			cast_spell_sticker_wrapper()
			spell_ready = false
			if (self.current_stock == 0):
				cast_timer.paused = true
		else:
			cast_timer.paused = true
			spell_ready = true
	else:
		cast_timer.paused = true
		spell_ready = true


func _on_passif_launch():
	if (!is_selected):
		cast_spell_sticker_wrapper()


func switch_on():
	is_selected = true
	cast_timer.paused = false
	cast_timer.start()

func switch_off():
	is_selected = false
	cast_timer.paused = true

func cast_spell_sticker_wrapper():
	MainSingleton.player.add_pentacle(self.pentacle_duration,  self.sticked_stickers.get(Sticker.DOUBLE_SPELL) + 1, self.pentacle_color)
	for i in range(0, self.sticked_stickers.get(Sticker.DOUBLE_SPELL) + 1):
		if (self.current_stock >= 1):
			cast_spell(i*PI/16*(1 if randi_range(0,1) == 0 else -1))
			self.current_stock -= 1

@abstract func cast_spell(angle_offset : float = 0)

func projectile_setup() -> Projectile:
	var new_projectile : Projectile = self.projectile.instantiate() as Projectile
	new_projectile.dmg = self.actual_dmg
	new_projectile.duration = self.actual_duration
	new_projectile.speed = self.actual_speed
	new_projectile.amount_of_target = self.actual_target_amount
	new_projectile.weak_letter = self.weak_letter
	return new_projectile

func update_everything():
	update_cooldowns()
	update_dmg()
	update_stock()
	update_duration()
	update_speed()
	update_target_amount()

func get_actual_cast_cooldown():
	if !sticked_stickers.has(Sticker.COOLDOWN_DOWN): return cast_cooldown
	return cast_cooldown * (0.80 ** (sticked_stickers[Sticker.COOLDOWN_DOWN]))
	
func get_actual_reload_cooldown():
	if !sticked_stickers.has(Sticker.COOLDOWN_DOWN): return recharge_cooldown
	return recharge_cooldown * (0.90 ** (sticked_stickers[Sticker.COOLDOWN_DOWN]))
	
func get_actual_passive_cooldown():
	if !sticked_stickers.has(Sticker.PASSIF_SPELL): return self.recharge_timer.wait_time
	return self.recharge_timer.wait_time * (4 * (0.85 **sticked_stickers[Sticker.PASSIF_SPELL]))

func update_cooldowns():
	self.cast_timer.wait_time = get_actual_cast_cooldown()
	self.recharge_timer.wait_time =  get_actual_reload_cooldown()
	self.passif_timer.wait_time = get_actual_passive_cooldown()

func update_dmg():
	self.actual_dmg = self.dmg * (1.4 ** (sticked_stickers[Sticker.DMG_UP] + float(level)/2))

func update_stock():
	self.actual_max_stock = roundi(self.max_stock * (sticked_stickers[Sticker.STOCKAGE_UP]+1 + float(level)/2))

func update_duration():
	self.actual_duration = self.duration * 1.5 ** ((float(sticked_stickers[Sticker.SWIFT_SPELL_UP]) + float(level))/3)

func update_speed():
	self.actual_speed = self.speed * 1.5 ** ((float(sticked_stickers[Sticker.SWIFT_SPELL_UP]) + float(level))/3)

func update_target_amount():
	self.actual_target_amount = self.target_amount + FuncSingleton.get_letter_scale(sticked_stickers[Sticker.SWIFT_SPELL_UP])

func add_weak_letters(letter_list : Array, coef : float):
	for letter : int in letter_list:
		if weak_letter.has(letter):
			weak_letter[letter] * coef
		else:
			weak_letter.set(letter, coef)


var sticker_amount : int = 0
const MAX_STICKER : int = 5

func can_get_new_sticker() -> bool:
	return sticker_amount < MAX_STICKER

func add_sticker(sticker_type : Sticker):
	self.sticked_stickers[sticker_type] += 1 if sticker_type < 8 else 8 + MainSingleton.spell_book.next_bookmark
	self.sticker_positions.append(Vector3(sticker_type,randi()%250 +50,randi()%300 + 50))
	self.sticker_amount += 1
	match sticker_type:
		Sticker.DMG_UP:
			update_dmg()
		Sticker.COOLDOWN_DOWN:
			update_cooldowns()
		Sticker.PASSIF_SPELL:
			passif_timer.start()
		Sticker.STOCKAGE_UP:
			update_stock()
		Sticker.SWIFT_SPELL_UP:
			update_duration()
			update_speed()
			update_target_amount()
		Sticker.VOYELLE_CRIT:
			add_weak_letters(FuncSingleton.voyelles_array, 1.9)
		Sticker.CONSONNE_CRIT:
			add_weak_letters(FuncSingleton.consone_array, 1.5)
		Sticker.BOOKMARK:
			MainSingleton.spell_book.add_bookmark(self.get_index())

func get_title():
	push_warning(get_name() + " spell name is not implemented")
	return "EMPTY TITLE"

func get_description():
	push_warning(get_name() + " spell description is not implemented")
	return "EMPTY DESCRIPTION"
