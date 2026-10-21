class_name BeachKoopaSlidingState
extends BeachKoopaState


func start() -> Script:
	super()
	slide_comp.process_mode = PROCESS_MODE_DISABLED
	sprite.speed_scale = 0
	sprite.play(&"sliding")
	koopa.velocity.x = 180 * slide_comp.direction
	return


func physics_process(_delta: float) -> Script:
	if koopa.is_on_floor():
		koopa.velocity.x = move_toward(koopa.velocity.x, 0, 3)
	if koopa.velocity.x < 3:
		return BeachKoopaStoppedState
	return
