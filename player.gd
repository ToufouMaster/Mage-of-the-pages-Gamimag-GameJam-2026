extends CharacterBody2D

const SPEED = 100.0

func _physics_process(delta: float) -> void:
	var horizontal_movement := Input.get_axis("ui_left", "ui_right")
	var vertical_movement := Input.get_axis("ui_up", "ui_down")
	var movement = Vector2(horizontal_movement, vertical_movement).normalized()
	if movement:
		velocity = movement * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)

	move_and_slide()
