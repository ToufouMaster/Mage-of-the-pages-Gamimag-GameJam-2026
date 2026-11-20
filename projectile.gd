extends Area2D
class_name Projectile

var angle : float ## Angle in radians
var speed : float = 100 ## The speed of a projectile

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var direction = Vector2.from_angle(angle).normalized()
	self.position += direction * speed * delta
	self.rotation = angle
