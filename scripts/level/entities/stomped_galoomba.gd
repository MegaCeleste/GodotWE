class_name StompedGaloomba
extends StunnedEnemy


func _entered(player: Player) -> void:
	var p = %PickupComponent
	if p.just_thrown:
		return
	
	var pos = global_position.lerp(player.global_position, 0.5)
	var particle = player.spawn_spin_thump(pos)
	particle.scale = Vector2(0.5, 0.5)
	
	%Sprite.flip_h = player.position.x > position.x
	var direction = -1 if %Sprite.flip_h else 1
	velocity.x = (absf(player.velocity.x) + 60) * direction
	velocity.y = -30
	
	p.just_thrown = true
	p.just_thrown_timer.start(PickupComponent.JUST_THROWN_TIME)
