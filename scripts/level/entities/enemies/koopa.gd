class_name Koopa
extends Entity


func _physics_process(delta: float) -> void:
	super(delta)
	move_and_slide()


func block_hit(block: Node2D, hitter: Entity) -> void:
	var shell = preload("uid://u8qe0i0cacce").instantiate()
	shell.koopa_inside = true
	shell.global_position = global_position
	sub_area.add(shell)
	shell.block_hit(block, hitter)
	shell.get_node(^"%Sprite").flip_v = true
	queue_free()


func _turned(direction: Vector2) -> void:
	if direction == Vector2.RIGHT:
		%Sprite.flip_h = false
	elif direction == Vector2.LEFT:
		%Sprite.flip_h = true


func _entered(player: Player) -> void:
	player.damage()


func _stomped(player: Player) -> void:
	var beach_koopa = preload("uid://cefvya51l3c0q").instantiate()
	beach_koopa.global_position = global_position
	var direction
	if player.global_position < global_position:
		direction = 1
	elif player.global_position > global_position:
		direction = -1
	else:
		direction = player.direction
	beach_koopa.get_node(^"%SlideComponent").direction = direction
	sub_area.add(beach_koopa)
	var shell = preload("uid://u8qe0i0cacce").instantiate()
	shell.global_position = global_position
	sub_area.add(shell)
	queue_free()
