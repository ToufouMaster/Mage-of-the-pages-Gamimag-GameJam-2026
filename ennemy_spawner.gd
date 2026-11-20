extends Node2D

var budget : int = 20
var ennemy_scene : PackedScene = preload("res://ennemy.tscn")

@export var letter_sprites : Array[Texture]
@export var spawn_timer : Timer

func _ready() -> void:
	start_match()
	spawn_timer.start()

func start_match():
	spawn_timer.timeout.connect(spawn_batch_of_ennemies)

func end_match():
	spawn_timer.timeout.disconnect(spawn_batch_of_ennemies)

func spawn_batch_of_ennemies():
	var letter_choices : Array[int] = self.choose_every_letter()
	for letter in letter_choices:
		var new_ennemy : Ennemy = ennemy_scene.instantiate() as Ennemy
		new_ennemy.set_up_letter(letter, letter_sprites[0] if letter-1 >= letter_sprites.size() else letter_sprites[letter-1])
		var horizontal_movement := Input.get_axis("walk left", "walk right")
		var vertical_movement := Input.get_axis("walk up", "walk down")
		var movement = Vector2(horizontal_movement, vertical_movement).normalized()
		var spawn_position : Vector2 = MainSingleton.player.global_position + movement * 20 + Vector2(randf_range(-1,1), randf_range(-1,1)).normalized()*200
		new_ennemy.global_position = spawn_position
		self.add_child(new_ennemy)

func choose_letter(current_budget : int):
	return randi_range(0, min(current_budget/2, 25)) + 1

func choose_every_letter() -> Array[int]:
	var letter_list : Array[int] = []
	var current_budget = budget
	while (current_budget > 0):
		var next_letter_chosen : int = choose_letter(current_budget)
		current_budget -= next_letter_chosen
		letter_list.append(next_letter_chosen)
	return letter_list
