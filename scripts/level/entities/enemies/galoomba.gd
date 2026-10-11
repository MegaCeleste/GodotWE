class_name Galoomba
extends Enemy


func _stomped(player: Player) -> void:
	super(player)
	if is_queued_for_deletion():
		return
	var stomp: StompedGaloomba = preload("uid://x314ug2d52hj").instantiate()
	stomp.global_position = global_position
	stomp.level = level
	stomp.sub_area = sub_area
	add_sibling.call_deferred(stomp)
	queue_free()


func _turned(direction: Vector2) -> void:
	if direction == Vector2.RIGHT:
		%Sprite.flip_h = false
	elif direction == Vector2.LEFT:
		%Sprite.flip_h = true
