class_name PlayerJumpingState
extends PlayerState
## Provides jumping behavior to the player.

# The type of jump that should be buffered
enum _JumpBufferType {
	NONE,
	JUMP,
	SPIN_JUMP
}

var _long_jump := false
var _grav_comp: GravityComponent
var _jump_buffer: _JumpBufferType
var _jump_buffer_timer := 0.0
var _was_holding_item := false


func start() -> Script:
	super()
	var running = Input.is_action_pressed("player_run")
	_long_jump = true
	_grav_comp = Utility.find_child_by_class(player, GravityComponent)
	_was_holding_item = player.held_item != null
	
	player.sounds.stream = preload("uid://bhxmp70u556sv")
	player.sounds.play()
	
	# apply jump speed
	if not running and abs(player.velocity.x) < Player.MAX_WALK_SPEED:
		player.velocity.y = -Player.IDLE_JUMP_SPEED
	elif (
			(not running and abs(player.velocity.x) >= Player.MAX_WALK_SPEED)
			or (running and abs(player.velocity.x) < Player.MAX_RUN_SPEED)
	):
		player.velocity.y = -Player.SLOW_JUMP_SPEED
	elif running and abs(player.velocity.x) >= Player.MAX_RUN_SPEED:
		player.velocity.y = -Player.FAST_JUMP_SPEED
	
	return null


func end() -> void:
	super()
	# reset gravity
	var grav = Utility.find_child_by_class(player, GravityComponent)
	grav.gravity = Vector2(0, Player.GRAVITY)


func physics_process(delta: float) -> Script:
	var direction = Input.get_axis("player_left", "player_right")
	var max_speed = Player.MAX_RUN_SPEED \
			if Input.is_action_pressed("player_run") \
			else Player.MAX_WALK_SPEED
	
	# jump buffer stuff
	if _jump_buffer != _JumpBufferType.NONE:
		_jump_buffer_timer += delta
		# time's up!
		if _jump_buffer_timer > Player.JUMP_BUFFER_TIME:
			_jump_buffer = _JumpBufferType.NONE
	if Input.is_action_just_pressed("player_jump"):
		_jump_buffer = _JumpBufferType.JUMP
		_jump_buffer_timer = 0
	elif Input.is_action_just_pressed("player_spin_jump"):
		_jump_buffer = _JumpBufferType.SPIN_JUMP
		_jump_buffer_timer = 0
	
	if (not Input.is_action_pressed("player_jump")
			and (not Input.is_action_pressed("player_spin_jump")
			or not _was_holding_item)) \
			or player.velocity.y >= -Player.LONG_JUMP_STOP_SPEED:
		_long_jump = false
	
	if player.is_on_floor():
		# jump if the player jumped close enough
		if _jump_buffer == _JumpBufferType.JUMP:
			return PlayerJumpingState
		elif _jump_buffer == _JumpBufferType.SPIN_JUMP:
			return PlayerSpinJumpingState
		elif direction == 0:
			return PlayerIdleState
		else:
			return PlayerMovingState
	
	# change gravity for variable jump height
	if _long_jump:
		_grav_comp.gravity = Vector2(0, Player.LONG_JUMP_GRAVITY)
	else:
		_grav_comp.gravity = Vector2(0, Player.GRAVITY)
	
	position_held_item(direction)
	
	# accelerate
	if direction != 0:
		player.direction = int(direction)
		player.velocity.x = move_toward(
				player.velocity.x,
				max_speed * direction,
				Player.ACCEL
		)
	
	if player.can_change_sprite():
		# animations
		if player.held_item != null:
			player.sprite.play("hold_airborne")
		elif player.velocity.y < 0:
			player.sprite.play("jump")
		else:
			player.sprite.play("fall")
	if direction < 0:
		player.sprite.flip_h = true
	elif direction > 0:
		player.sprite.flip_h = false
	
	return null


func input(event: InputEvent) -> Script:
	super(event)
	
	if player.is_on_floor():
		return move_check(event)
	
	return null
