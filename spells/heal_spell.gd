extends Spell

var regen_timer : Timer

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
