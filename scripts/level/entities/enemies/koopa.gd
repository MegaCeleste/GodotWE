class_name Koopa
extends Entity


func _physics_process(_delta: float) -> void:
	move_and_slide()


func _turned(direction: Vector2) -> void:
	if direction == Vector2.RIGHT:
		%Sprite.flip_h = false
	elif direction == Vector2.LEFT:
		%Sprite.flip_h = true


func _entered(player: Player) -> void:
	player.damage()
