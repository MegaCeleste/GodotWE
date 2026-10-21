class_name StompedGaloomba
extends StunnedEnemy

const KICK = preload("uid://dp6qqkjyxu0cu")
const RESPAWN_TIME = 10.0
const SHAKE_TIME = 9.0

var shake_tween: Tween


func _ready() -> void:
	%RespawnTimer.start(RESPAWN_TIME)
	%ShakeTimer.start(SHAKE_TIME)


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
	
	player.sounds.stream = KICK
	player.sounds.play()
	
	p.just_thrown = true
	p.just_thrown_timer.start()


func _respawn_timeout() -> void:
	var galoomba: Galoomba = load("uid://d2p4v7v1baic6").instantiate()
	
	galoomba.global_position = global_position
	var direction = -1 if %Sprite.flip_h else 1
	galoomba.get_node(^"%SlideComponent").direction = direction
	galoomba.get_node(^"%Sprite").flip_h = %Sprite.flip_h
	if is_on_floor():
		galoomba.velocity.y = -60
	
	sub_area.add(galoomba)
	queue_free()


func _shake_timeout() -> void:
	if %PickupComponent.get_holder() == null:
		shake_tween = create_tween()
		shake_tween.set_loops()
		shake_tween.tween_property(%Sprite, ^"position:x", 1, 0.025)
		shake_tween.tween_property(%Sprite, ^"position:x", -1, 0.05)
		shake_tween.tween_property(%Sprite, ^"position:x", 0, 0.025)
	else:
		if shake_tween != null and shake_tween.is_valid():
			shake_tween.kill()
		%RespawnTimer.start()
		%ShakeTimer.start()
