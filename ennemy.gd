extends CharacterBody2D
class_name Ennemy

var coin_drop : PackedScene = preload("res://pickable_letter.tscn")

@export var hitbox : Area2D
@export var ennemy_sprite : Sprite2D 

var knockback: Vector2 = Vector2.ZERO
var knockback_timer: float = 0

func apply_knockback(direction: Vector2, force: float, knockback_duration: float):
	knockback = direction*force
	knockback_timer = knockback_duration

var letter : int = 0
var max_pv : float
var pv : float : 
	set(val):
		pv = val
		self.modulate.a = 0.75*pv/max_pv + 0.25
var speed : float = 50

func set_up_letter(letter_nb : int, letter_sprite : Texture, no_reset : bool = false):
	self.letter = letter_nb
	self.ennemy_sprite.texture = letter_sprite
	self.max_pv = FuncSingleton.get_letter_scale(letter)
	if !no_reset:
		self.pv = max_pv
	else:
		self.pv = clamp(self.pv, 0, self.max_pv)

func _ready() -> void:
	$AnimationPlayer.play("waving")

const DAMAGE_TAKING_COOLDOWN : float = 0.1
var current_damage_cooldown : float = 0

func take_damage(amount : int):
	if current_damage_cooldown < 0:
		current_damage_cooldown = DAMAGE_TAKING_COOLDOWN
		self.pv -= amount
		if (self.pv < 1 and not is_dying):
			die()

var is_dying : bool = false

func die():
	if !is_dying:
		is_dying = true
		var new_drop : PickableLetter = coin_drop.instantiate() as PickableLetter
		new_drop.value = (self.letter + 1) 
		new_drop.position = self.position
		new_drop.scale = new_drop.scale + Vector2.ONE * float(self.letter/26)
		self.get_parent().add_child(new_drop)
		self.queue_free()

var direction_change_cooldown = 0.5

var max_attack_cooldown : float = 0.1
var attack_cooldown : float = max_attack_cooldown
func _physics_process(delta: float) -> void:
	if knockback_timer > 0:
		velocity = knockback
		knockback_timer -= delta
		if knockback_timer <= 0:
			knockback = Vector2.ZERO
	else:
		if (direction_change_cooldown < 0):
			follow_player()
			direction_change_cooldown = randf_range(0, 0.5)
		direction_change_cooldown -= delta
		if (!hitbox.get_overlapping_bodies().is_empty() and attack_cooldown <= 0):
			var player = hitbox.get_overlapping_bodies()[0]
			if (player is Player):
				player.take_damage(5)
				attack_cooldown = max_attack_cooldown
			else:
				push_error("multiples entity in layer player")
		else:
			attack_cooldown -= delta
	current_damage_cooldown -= delta
	move_and_slide()

func follow_player():
	var direction = (MainSingleton.player.position - position + Vector2(randf_range(-50,50), randf_range(-50,50))).normalized()
	velocity = direction * speed
