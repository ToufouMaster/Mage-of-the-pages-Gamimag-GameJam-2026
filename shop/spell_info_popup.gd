extends Control

func set_popup_info(spell_id, is_sticker):
	$Stats.hide()
	if !is_sticker:
		var spell_instance : Spell = MainSingleton.shop.spells.get(spell_id).instantiate()
		var found_spell : Spell = null
		for i in MainSingleton.spell_book.spell_list:
			if spell_instance.get_title() != i.get_title(): continue
			found_spell = i
			break
		$Stats.show()
		var damage
		var reload_cd
		var cast_cd
		var duration
		var speed
		
		$SpellStatus/Sticker.hide()
		$SpellStatus/NewSpell.hide()
		$SpellStatus/LevelUp.hide()
		if found_spell:
			$SpellStatus/LevelUp.show()
			$SpellStatus/LevelUp/ProgressBar.value = found_spell.item_amount
			$SpellStatus/LevelUp/ProgressBar.max_value = found_spell.level+1
			$SpellStatus/LevelUp/ProgressBar/Label.text = "Level: "+str(found_spell.level+1) + " | " + str(found_spell.item_amount) + " / " + str(found_spell.level+2)
			damage = found_spell.actual_dmg
			reload_cd = found_spell.get_actual_reload_cooldown()
			cast_cd = found_spell.get_actual_cast_cooldown()
			duration = found_spell.actual_duration
			speed = found_spell.actual_speed
		else:
			$SpellStatus/NewSpell.show()
			damage = spell_instance.dmg
			reload_cd = spell_instance.recharge_cooldown
			cast_cd = spell_instance.cast_cooldown
			duration = spell_instance.duration
			speed = spell_instance.speed
		
		$Title.text = spell_instance.get_title()
		$Description.text = spell_instance.get_description()
		$Stats/Damage.visible = damage != 0
		$Stats/Damage/Value.text = ": " + str(damage).pad_decimals(1)
		$Stats/ReloadCD.visible = reload_cd != 0
		$Stats/ReloadCD/Value.text = ": " + str(reload_cd).pad_decimals(1)
		$Stats/CastCD.visible = cast_cd != 0
		$Stats/CastCD/Value.text = ": " + str(cast_cd).pad_decimals(1)
		$Stats/Duration.visible = duration != 0
		$Stats/Duration/Value.text = ": " + str(duration).pad_decimals(1)
		$Stats/Speed.visible = speed != 0
		$Stats/Speed/Value.text = ": " + str(speed).pad_decimals(1)
	else:
		$SpellStatus/Sticker.show()
	
	print($"../VisibleOnScreenNotifier2D".is_on_screen())
	if !$"../VisibleOnScreenNotifier2D".is_on_screen():
		position.x = -925
	else:
		position.x = 200
