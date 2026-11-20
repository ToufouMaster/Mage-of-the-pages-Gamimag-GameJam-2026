extends CharacterBody2D
class_name Ennemy

@export var hitbox : Area2D

@export var letter : String = "a"

var pv : int
var speed : float = 50

func _ready() -> void:
	pv = FuncSingleton.get_pascal_triangle(FuncSingleton.get_letter_order(letter))

func take_damage(amount : int):
	self.pv -= amount
	if (self.pv < 1):
		die()

func die():
	pass

var direction_change_cooldown = 0.5

func _physics_process(delta: float) -> void:
	if (direction_change_cooldown < 0):
		follow_player()
		direction_change_cooldown = randf_range(0, 0.5)
	direction_change_cooldown -= delta
	move_and_slide()

func follow_player():
	var horizontal_movement := Input.get_axis("walk left", "walk right")
	var vertical_movement := Input.get_axis("walk up", "walk down")
	var movement = Vector2(horizontal_movement, vertical_movement).normalized()
	var direction = (MainSingleton.player.position - position + Vector2(randf_range(-50,50), randf_range(-50,50))).normalized()
	velocity = direction * speed
