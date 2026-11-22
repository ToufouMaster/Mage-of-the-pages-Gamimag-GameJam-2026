extends Spell

var regen_timer : Timer

func _init() -> void:
	self.base_price = 50
	self.price_modulation = 30

func get_title():
	return "Rod of Asclepius"

func get_description():
	return "Heal a small amount ("+str(self.actual_dmg).pad_decimals(1)+") of hp every " + str(100/self.actual_speed).pad_decimals(1) + " seconds during the next 5 seconds following its activation."

func cast_spell(_angle_offset : float = 0):
	if regen_timer == null: 
		regen_timer = Timer.new()
		self.add_child(regen_timer)
	regen_timer.wait_time = 100/self.speed
	regen_timer.start(-1)
	regen_timer.timeout.connect(_on_heal)
	await get_tree().create_timer(self.duration).timeout
	regen_timer.stop()
	regen_timer.timeout.disconnect(_on_heal)

func _on_heal():
	MainSingleton.player.heal_damage(self.dmg)
	print("healed")
