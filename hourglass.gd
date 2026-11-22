extends Node2D
class_name Hourglass

@export var progress : float = 0 : set = set_progress
@onready var sand_bottom = $BottomPolygon/SandBottom
@onready var sand_top = $TopPolygon/SandTop
@onready var gpu_particles = $GPUParticles2D
@onready var red_halo = $RedHalo
@onready var timer = $Timer

var alarm_tick = 0

func _ready() -> void:
	FuncSingleton.game_over.connect(on_game_over)

func set_progress(value: float):
	progress = clamp(value, 0, 1)
	if not is_node_ready(): return
	sand_bottom.position.y = 245-progress*93
	sand_top.position.y = 150+progress*24
	gpu_particles.amount_ratio = 1-progress
	gpu_particles.lifetime = max(0.001, 1-progress)
	var progressing = (progress != 0 && progress != 1)
	gpu_particles.emitting = progressing
	if progressing:
		# Alarm
		if progress > 0.8:
			alarm_tick += get_process_delta_time()
			var speed = 1 + ((progress-0.8)*5)*(PI*5)
			red_halo.self_modulate.a = 1-(sin(alarm_tick*speed)+1)/2
		else:
			alarm_tick = 0
			red_halo.self_modulate.a = 0
	else:
		alarm_tick = 0
		red_halo.self_modulate.a = 0

func start_round_timer(cooldown: float = 5):
	timer.start(cooldown)

func on_game_over():
	timer.stop()

func _process(_delta: float) -> void:
	progress = 1 - (timer.time_left / timer.wait_time)
