extends Node2D

@onready var button : TextureButton = $TextureButton
@onready var sprite : Sprite2D = $Sprite2D
@onready var audio_stream : AudioStreamPlayer2D = $AudioStreamPlayer2D

func animate_roll():
	button.disabled = true
	sprite.rotation = 0
	sprite.position = Vector2(0, 55)
	var tween = get_tree().create_tween()
	tween.tween_property(sprite, "position", Vector2(0, -100), 0.4).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property(sprite, "position", Vector2(0, 55), 0.4).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
	var right = randi()%2
	var tween2 = get_tree().create_tween()
	tween2.tween_property(sprite, "rotation", PI*(2+randf()*3) if right else -PI*(2+randf()*3), 0.8)
	tween2.tween_callback(button.set_disabled.bind(false))
	audio_stream.play()
