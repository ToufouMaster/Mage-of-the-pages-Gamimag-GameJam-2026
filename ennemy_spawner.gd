extends Node2D

var budget : int = 500

var ennemy_scene : PackedScene = preload("res://ennemy.tscn")

@export var letter_sprites : Array[Texture]
@export var spawn_cooldown : float = 2

var spawn_timer : Timer

func _ready() -> void:
	FuncSingleton.start_match.connect(start_match)
	FuncSingleton.end_match.connect(end_match)

func start_match():
	budget = MainSingleton.round * 50
	spawn_timer = Timer.new()
	spawn_timer.wait_time = spawn_cooldown
	self.add_child(spawn_timer)
	spawn_timer.start()
	spawn_timer.timeout.connect(spawn_batch_of_ennemies)

func end_match():
	spawn_timer.timeout.disconnect(spawn_batch_of_ennemies)
	for child in self.get_children():
		child.queue_free()

const SPAWN_OFFSET = 150

func spawn_batch_of_ennemies():
	var letter_choices : Array[int] = self.choose_every_letter()
	for letter in letter_choices:
		var new_ennemy : Ennemy = ennemy_scene.instantiate() as Ennemy
		new_ennemy.set_up_letter(letter, letter_sprites[0] if letter >= letter_sprites.size() else letter_sprites[letter])
		var horizontal_movement := Input.get_axis("walk left", "walk right")
		var vertical_movement := Input.get_axis("walk up", "walk down")
		var movement = Vector2(horizontal_movement, vertical_movement).normalized()
		var random_spawn = Vector2(randf_range(-SPAWN_OFFSET,SPAWN_OFFSET), randf_range(-SPAWN_OFFSET, SPAWN_OFFSET))
		#horriblement opti
		while (abs(random_spawn.y - MainSingleton.player.global_position.y)) < 20:
			random_spawn.y += randf_range(-SPAWN_OFFSET, SPAWN_OFFSET)
		while(abs(random_spawn.x - MainSingleton.player.global_position.x)) < 20:
			random_spawn.x += randf_range(-SPAWN_OFFSET, SPAWN_OFFSET)
		new_ennemy.global_position = random_spawn
		self.add_child(new_ennemy)

func choose_letter(current_budget : int):
	var max_afforable_letter : int
	var sum = 0
	for i in range(1,27):
		sum += i
		if current_budget/sum < 3:
			break
		else:
			max_afforable_letter = i
	return randi_range(1, max_afforable_letter)

func choose_every_letter() -> Array[int]:
	var letter_list : Array[int] = []
	var current_budget = budget
	while (current_budget > 5):
		var next_letter_chosen : int = choose_letter(current_budget)
		var affordable_letter : int = clamp(current_budget/(2*(1+next_letter_chosen)), 0, 25)
		current_budget -= FuncSingleton.get_letter_scale(next_letter_chosen)*affordable_letter
		for i in range (0, affordable_letter):
			letter_list.append(next_letter_chosen-1)
	return letter_list
