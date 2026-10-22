class_name Shell
extends Entity

const KICK1 = preload("uid://dp6qqkjyxu0cu")
const KICK2 = preload("uid://dcf1ixvckgpwp")
const BUMP = preload("uid://7ec5u6l30bgt")

var max_speed: float
var speed: float
var moving := false:
	set = _set_moving
var direction: int


func _ready() -> void:
	%PickupComponent.just_thrown = true
	%PickupComponent.just_thrown_timer.start()


func _physics_process(delta: float) -> void:
	if %PickupComponent.get_holder() != null:
		return
	move_and_slide()
	super(delta)
	if moving:
		if is_on_wall():
			direction = -direction
			%Sounds.stream = BUMP
			%Sounds.play()
		if speed < max_speed:
			speed = move_toward(speed, max_speed, 3)
		velocity.x = speed * direction
	elif is_on_floor():
		velocity.x = 0


func stomp(player: Player) -> void:
	if not moving or %PickupComponent.just_thrown:
		return
	player.bounce()
	player.spawn_spin_thump()
	%Sounds.stream = KICK2
	%Sounds.play()
	moving = false


func start_moving(player: Player) -> void:
	direction = 1 if global_position.x > player.global_position.x else -1
	speed = (120 + absf(player.velocity.x / 2))
	max_speed = speed + (30 if player.velocity.x == 0 else 12)
	moving = true


func block_hit(block: Node2D, _hitter: Entity) -> void:
	var flip = block.global_position.x < global_position.x
	direction = -1 if flip else 1
	velocity.x = 30 * direction
	velocity.y = -180


func _entered(player: Player) -> void:
	if moving and not %PickupComponent.just_thrown:
		player.damage()


func _body_entered(body: Node2D) -> void:
	if body is Player:
		if %PickupComponent.get_holder() == body:
			return
		if %PickupComponent.just_thrown or moving:
			return
		%Sounds.stream = KICK1
		%Sounds.play()
		body.sprite.speed_scale = 1
		body.sprite.play(&"kick")
		start_moving(body)
		
	elif moving and body is Entity and body.has_method(&"kill"):
		body.kill(self)
		if body is Shell or %PickupComponent.get_holder() != null:
			kill(body)


func _dropped(player: Player, release_type: PickupComponent.ReleaseType) -> void:
	if release_type == PickupComponent.ReleaseType.KICKED:
		velocity = Vector2.ZERO
		start_moving(player)


func _set_moving(v: bool) -> void:
	%PickupComponent.can_be_held = not v
	%PickupComponent.just_thrown = true
	%PickupComponent.just_thrown_timer.start()
	if not v:
		velocity.x = 0
	moving = v
