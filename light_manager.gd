extends Node2D

@export var noise : Noise

@onready var light1 = $PointLight2D
@onready var light2 = $PointLight2D2

@onready var light1pos = $PointLight2D.position
@onready var light2pos = $PointLight2D2.position

func _process(delta: float) -> void:
	var x = noise.get_noise_1d(Time.get_ticks_msec()/10)
	var y = noise.get_noise_1d(Time.get_ticks_msec()/8)
	var z = noise.get_noise_1d(Time.get_ticks_msec()/5)
	var direction1 = Vector2.from_angle(atan(x)).normalized()*y*25
	var direction2 = Vector2.from_angle(atan(y)).normalized()*x*25
	light1.position = light1pos+direction1
	light2.position = light2pos+direction2
	light1.texture_scale = 6 + (z)
	light2.texture_scale = 10 + (z)
