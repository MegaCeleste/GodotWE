class_name BeachKoopa
extends Entity


func _ready() -> void:
	%Sprite.flip_h = %SlideComponent.direction < 0


func _physics_process(delta: float) -> void:
	move_and_slide()
	super(delta)


func stand() -> void:
	%StateMachine.switch(BeachKoopaMovingState)


func _turned(direction: Vector2) -> void:
	%Sprite.flip_h = direction.x < 0


func _stomped(_player: Player) -> void:
	var sprite = %Sprite
	sprite.play(&"dead")
	sprite.reparent(get_parent())
	get_tree().create_timer(0.5).timeout.connect(sprite.queue_free)
	queue_free()


func _entered(player: Player) -> void:
	%StateMachine.current_state.entered(player)
