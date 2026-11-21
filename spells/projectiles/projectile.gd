@abstract
extends Area2D
class_name Projectile

var angle : float ## Angle in radians
var speed : float = 100 ## The speed of a projectile
var duration : float = 2
var amount_of_target : int = 1
var dmg : int


func _physics_process(delta: float) -> void:
	duration -= delta
	if (duration <= 0):
		end_life_handling()
	var direction = Vector2.from_angle(angle).normalized()
	self.position += direction * speed * delta
	self.rotation = angle
	var overlapping_areas : Array[Area2D] = self.get_overlapping_areas()
	if (!overlapping_areas.is_empty()):
		for ennemy_hitbox in overlapping_areas:
			var ennemy : Ennemy = ennemy_hitbox.get_parent() as Ennemy
			ennemy.take_damage(dmg)
			effect_on_ennemy(ennemy)
		amount_of_target -= overlapping_areas.size()
		if amount_of_target <= 0:
			end_life_handling()

func end_life_handling():
	self.queue_free()

@abstract
func get_spawn_position()

@abstract
func effect_on_ennemy(ennemy : Ennemy)
