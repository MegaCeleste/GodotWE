class_name BeachKoopaMovingState
extends BeachKoopaState


func start() -> Script:
	super()
	slide_comp.process_mode = Node.PROCESS_MODE_INHERIT
	slide_comp.started = true
	sprite.speed_scale = 1
	sprite.play(&"moving")
	koopa.velocity.y = -120
	return


func physics_process(_delta: float) -> Script:
	var query = PhysicsShapeQueryParameters2D.new()
	query.collision_mask = 1 << 3
	query.shape = RectangleShape2D.new()
	query.shape.size = Vector2(3, 14)
	query.transform.origin = koopa.global_position + Vector2(
			5.5 * slide_comp.direction, -7)
	await get_tree().physics_frame
	var result = get_viewport().world_2d.direct_space_state.intersect_shape(
			query, 1)
	if result.size() != 0:
		var shell = result[0].collider
		if shell is KoopaShell:
			return BeachKoopaJumpingState
	return


func entered(player: Player) -> void:
	player.damage()
