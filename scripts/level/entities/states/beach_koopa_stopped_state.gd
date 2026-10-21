class_name BeachKoopaStoppedState
extends BeachKoopaState

var time := 0.0


func start() -> Script:
	super()
	slide_comp.process_mode = PROCESS_MODE_DISABLED
	sprite.speed_scale = 1
	sprite.play(&"sliding")
	return


func physics_process(delta: float) -> Script:
	if koopa.is_on_floor():
		koopa.velocity.x = move_toward(koopa.velocity.x, 0, 3)
	time += delta
	if time >= 1.5:
		return BeachKoopaMovingState
	return
