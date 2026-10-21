class_name BeachKoopaJumpingState
extends BeachKoopaState


func start() -> Script:
	super()
	slide_comp.process_mode = Node.PROCESS_MODE_INHERIT
	slide_comp.started = true
	sprite.speed_scale = 1
	sprite.play(&"moving")
	koopa.velocity.y = -180
	return


func physics_process(_delta: float) -> Script:
	if koopa.velocity.y < 0:
		return
	var query = PhysicsShapeQueryParameters2D.new()
	query.collision_mask = 1 << 3
	query.shape = coll_shape.shape
	query.transform = coll_shape.global_transform
	await get_tree().physics_frame
	var result = get_viewport().world_2d.direct_space_state.intersect_shape(
			query, 1)
	if result.size() != 0:
		var shell = result[0].collider
		if shell is KoopaShell:
			if shell.get_node(^"%PickupComponent").get_holder() != null or \
					shell.koopa_inside:
				slide_comp.direction = -slide_comp.direction
				if slide_comp.direction == -1:
					slide_comp.turned.emit(Vector2.LEFT)
				else:
					slide_comp.turned.emit(Vector2.RIGHT)
				return
			shell.koopa_inside = true
			shell.respawn = true
			shell.get_node(^"%RespawnTimer").start(1)
			shell.shake()
			koopa.queue_free()
	return


func entered(player: Player) -> void:
	player.damage()
