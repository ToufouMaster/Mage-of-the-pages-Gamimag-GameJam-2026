@abstract
extends Area2D
class_name Projectile

@export var sprite : Sprite2D
@export var texture : Texture2D
@export var hit_sfx : AudioStream
var angle : float ## Angle in radians
var speed : float = 100 ## The speed of a projectile
var duration : float = 2
var amount_of_target : int = 1
var dmg : int

func _ready() -> void:
	$Sprite2D.texture = texture


var weak_letter : Dictionary


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
			if (ennemy_hitbox.get_parent().current_damage_cooldown > 0):
				continue
			var ennemy : Ennemy = ennemy_hitbox.get_parent() as Ennemy
			var actual_dmg = dmg if not weak_letter.has(ennemy.letter) else dmg * weak_letter.get(ennemy.letter)
			ennemy.take_damage(dmg)
			if hit_sfx:
				MainSingleton.play_audioplayer_at_pos($ProjectileHitPlayer, global_position)
			effect_on_ennemy(ennemy)
			amount_of_target -= 1
			if amount_of_target <= 0:
				end_life_handling()

func end_life_handling():
	self.queue_free()

@abstract
func get_spawn_position()

@abstract
func effect_on_ennemy(ennemy : Ennemy)
