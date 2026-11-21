extends CharacterBody2D
class_name Player

const SPEED = 50.0

@export var health_bar : ProgressBar
var health : int = 100 : 
	set(val):
		health = val
		health_bar.value = val

const max_health : int = 100
var regen_active : bool = false

func take_damage(amount : int):
	health -= amount
	if (health <= 0):
		die()
	else:
		regen_health()

func regen_health():
	if !regen_active:
		regen_active = true
		await get_tree().create_timer(1).timeout
		heal_damage(1)
		regen_active = false
		if (health != max_health):
			regen_health()

func heal_damage(amount : int):
	health = clamp(health + amount, 0, max_health)


func die():
	print("rip in rip")

func _physics_process(delta: float) -> void:
	var horizontal_movement := Input.get_axis("walk left", "walk right")
	var vertical_movement := Input.get_axis("walk up", "walk down")
	var movement = Vector2(horizontal_movement, vertical_movement).normalized()
	if movement:
		velocity = movement * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)

	move_and_slide()
