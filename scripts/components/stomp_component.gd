class_name StompComponent
extends Component

signal stomped(player: Player)
signal spin_stomped(player: Player)
signal entered(player: Player)

const KICK = preload("uid://dcf1ixvckgpwp")
const RECOIL = preload("uid://e8157k7h45xi")

@export var hitbox: Rect2
@export var margin := 5.0

## The [PickupComponent] this body has, if any. Used for skipping stomp
## detection when the body is held.
var pickup_comp: PickupComponent


func _ready() -> void:
	pickup_comp = Utility.find_child_by_class(get_parent(), PickupComponent)


func _physics_process(_delta: float) -> void:
	# Godot processes physics space right after all physics process functions
	# are done, so we wait until right after it gets processed for accurate
	# timing
	await get_tree().physics_frame
	
	if pickup_comp != null and pickup_comp.get_holder() != null:
		return
	
	var query = PhysicsShapeQueryParameters2D.new()
	query.collision_mask = 1 << 2
	query.shape = RectangleShape2D.new()
	query.shape.size = hitbox.size
	query.transform.origin = get_parent().to_global(hitbox.get_center())
	var result = get_viewport().world_2d.direct_space_state.intersect_shape(
			query, 1)
	if result.size() == 0:
		return
	var player: Player = result[0].collider
	var box = Utility.get_bounding_box(player)
	if box.end.y < get_parent().to_global(hitbox.position).y + margin:
		if player.state_machine.current_state is PlayerSpinJumpingState:
			spin_stomped.emit(player)
		else:
			stomped.emit(player)
	else:
		entered.emit(player)


func stomp(player: Player) -> void:
	player.bounce()
	player.sounds.stream = KICK
	player.sounds.play()
	player.spawn_spin_thump()


func recoil(player: Player) -> void:
	player.bounce()
	player.sounds.stream = RECOIL
	player.sounds.play()
	player.spawn_spin_thump()


func spin_stomp(player: Player) -> void:
	player.bounce()
	var spin_smoke = SpinSmoke.create()
	get_parent().add_sibling(spin_smoke)
	spin_smoke.global_position = get_parent().global_position - Vector2(0, 8)
	get_parent().queue_free()
