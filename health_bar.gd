extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var hp : float = MainSingleton.player.health
	var max_hp : float = MainSingleton.player.max_health
	var hp_ratio : float = clampf(hp/max_hp, 0.0, 1.0)
	$HealthProgress.value = hp_ratio*100
	$PointLight2D.offset.x = -180*(1-hp_ratio)
	$PointLight2D.energy = hp_ratio*1.5
	
