class_name BeachKoopa
extends Entity

enum Status {
	SLIDING,
	STOPPED,
	MOVING,
	JUMPING,
}

var status: Status = Status.SLIDING


func _ready() -> void:
	%Sprite.flip_h = %SlideComponent.direction < 0
	velocity.x = 180 * %SlideComponent.direction


func kill() -> void:
	queue_free()


func _physics_process(delta: float) -> void:
	move_and_slide()
	super(delta)
	if status == Status.SLIDING or status == Status.STOPPED:
		velocity.x = move_toward(velocity.x, 0, 3)
		if status == Status.SLIDING and absf(velocity.x) < 3:
			status = Status.STOPPED
			%Sprite.speed_scale = 1
			get_tree().create_timer(1.5).timeout.connect(stand)
	elif status == Status.MOVING:
		var query = PhysicsShapeQueryParameters2D.new()
		query.collision_mask = 1 << 3
		query.shape = RectangleShape2D.new()
		query.shape.size = Vector2(3, 14)
		query.transform.origin = global_position + Vector2(
				5.5 * %SlideComponent.direction, -7)
		await get_tree().physics_frame
		var result = get_viewport().world_2d.direct_space_state.intersect_shape(
				query, 1)
		if result.size() != 0:
			var shell = result[0].collider
			if shell is KoopaShell:
				velocity.y = -156
				status = Status.JUMPING
	elif status == Status.JUMPING and velocity.y > 0:
		var query = PhysicsShapeQueryParameters2D.new()
		query.collision_mask = 1 << 3
		query.shape = %CollShape.shape
		query.transform = %CollShape.global_transform
		await get_tree().physics_frame
		var result = get_viewport().world_2d.direct_space_state.intersect_shape(
				query, 1)
		if result.size() != 0:
			var shell = result[0].collider
			if shell is KoopaShell:
				if shell.get_node(^"%PickupComponent").get_holder() != null or \
						shell.koopa_inside:
					%SlideComponent.direction = -%SlideComponent.direction
					if %SlideComponent.direction == -1:
						%SlideComponent.turned.emit(Vector2.LEFT)
					else:
						%SlideComponent.turned.emit(Vector2.RIGHT)
					return
				shell.koopa_inside = true
				shell.respawn = true
				shell.get_node(^"%RespawnTimer").start(1)
				shell.shake()
				queue_free()


func stand() -> void:
	status = Status.MOVING
	%SlideComponent.process_mode = PROCESS_MODE_INHERIT
	%SlideComponent.started = true
	velocity.y = -120
	%Sprite.speed_scale = 1
	%Sprite.play(&"moving")


func _turned(direction: Vector2) -> void:
	%Sprite.flip_h = direction.x < 0


func _stomped(_player: Player) -> void:
	var sprite = %Sprite
	sprite.play(&"dead")
	sprite.reparent(get_parent())
	get_tree().create_timer(0.5).timeout.connect(sprite.queue_free)
	queue_free()


func _entered(player: Player) -> void:
	if status == Status.SLIDING or status == Status.STOPPED:
		player.sprite.play(&"kick")
		player.spawn_spin_thump(player.global_position.lerp(global_position,
				0.5))
		player.sounds.stream = preload("uid://dcf1ixvckgpwp")
		player.sounds.play()
		kill()
	else:
		player.damage()
