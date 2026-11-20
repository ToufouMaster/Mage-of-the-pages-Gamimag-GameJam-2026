extends CharacterBody2D
class_name Ennemy

@export var hitbox : Area2D
@export var ennemy_sprite : Sprite2D 

var letter : int = 0
var pv : int
var speed : float = 50

func set_up_letter(letter_nb : int, letter_sprite : Texture):
	self.letter = letter_nb
	self.ennemy_sprite.texture = letter_sprite

func _ready() -> void:
	pv = FuncSingleton.get_pascal_triangle(letter)

func take_damage(amount : int):
	self.pv -= amount
	if (self.pv < 1):
		die()

func die():
	pass

var direction_change_cooldown = 0.5

var max_attack_cooldown : float = 0.2
var attack_cooldown : float = max_attack_cooldown
func _physics_process(delta: float) -> void:
	if (direction_change_cooldown < 0):
		follow_player()
		direction_change_cooldown = randf_range(0, 0.5)
	direction_change_cooldown -= delta
	move_and_slide()
	if (!hitbox.get_overlapping_bodies().is_empty() and attack_cooldown <= 0):
		var player = hitbox.get_overlapping_bodies()[0]
		if (player is Player):
			player.take_damage(letter)
			attack_cooldown = max_attack_cooldown
		else:
			push_error("multiples entity in layer player")
	else:
		attack_cooldown -= delta

func follow_player():
	var direction = (MainSingleton.player.position - position + Vector2(randf_range(-50,50), randf_range(-50,50))).normalized()
	velocity = direction * speed
