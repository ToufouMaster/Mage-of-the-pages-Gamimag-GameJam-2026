extends Node2D


var pentacle_duration : float
var pentacle_speed : float = 1

func add_rotation_time(time : float, speed : float = 1, color : Color = Color.WHITE):
	self.modulate = color
	self.pentacle_duration += time
	self.pentacle_speed = speed



func _process(delta: float) -> void:
	if pentacle_duration > 0:
		self.show()
		$Pentacle.rotation += delta * 3 * pentacle_speed
		pentacle_duration -= delta
	else:
		self.hide()
