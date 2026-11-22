extends CharacterBody2D
class_name Player

var speed = 100.0

@export var ennemy_detect_area : Area2D
@onready var coin_picker_area : Area2D = $CoinPicker

func _ready() -> void:
	self.process_mode = Node.PROCESS_MODE_DISABLED
	FuncSingleton.start_match.connect(start_match)
	FuncSingleton.end_match.connect(end_match)

func start_match():
	self.self_modulate.a = 1
	self.show()
	self.health = self.max_health
	self.process_mode = Node.PROCESS_MODE_ALWAYS
	self.show()

func end_match():
	self.process_mode = Node.PROCESS_MODE_DISABLED
	self.hide()

func get_closer_ennemy_direction():
	var current_closer_ennemy : Ennemy = null
	var current_closest_distance : float = 1000
	var all_near_ennemies := ennemy_detect_area.get_overlapping_bodies()
	for ennemy_body : Ennemy in all_near_ennemies:
		var dist_to_player : float = self.global_position.distance_to(ennemy_body.global_position)
		if dist_to_player < current_closest_distance:
			current_closest_distance = dist_to_player
			current_closer_ennemy = ennemy_body
	if (current_closer_ennemy == null):
		return null
	
	return self.global_position.direction_to(current_closer_ennemy.global_position).normalized()

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
	$GameOver.show()
	self.self_modulate.a = 0
	FuncSingleton.game_over.emit()
	self.process_mode = Node.PROCESS_MODE_DISABLED

func add_pentacle(duration : float, speed: float = 1, color: Color = Color.WHITE):
	$PentacleFlat.add_rotation_time(duration, speed, color)


func _physics_process(_delta: float) -> void:
	var horizontal_movement := Input.get_axis("walk left", "walk right")
	var vertical_movement := Input.get_axis("walk up", "walk down")
	if (horizontal_movement > 0):
		$Sprite2D.flip_h = false
	else :
		$Sprite2D.flip_h = true
		
	var movement = Vector2(horizontal_movement, vertical_movement).normalized()
	if movement:
		velocity = movement * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.y = move_toward(velocity.y, 0, speed)

	move_and_slide()
