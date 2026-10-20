class_name StunnedEnemy
extends Grabbable
## A [Grabbable] that an enemy either turns into or releases.
## 
## A [StunnedEnemy] is a [Grabbable] which can interact with other enemies and
## [StunnedEnemy]s. Usually, this type of entity represents some sort of
## "stunned" version of an enemy: a [StompedGaloomba], [Shell], etc. It kills
## enemies if in motion or held, in the latter case the [StunnedEnemy] will
## also die.

## The area to check for enemies and [StunnedEnemy]s. This should be equal to
## to [member PickupComponent.check_rect].
@export var check_rect: Rect2

var _prev: Vector2


func _physics_process(delta: float) -> void:
	_prev = position
	super(delta)
	if position - _prev == Vector2.ZERO:
		return
	
	var query = PhysicsShapeQueryParameters2D.new()
	query.collision_mask = 1 << 1
	query.exclude = [get_rid()]
	query.shape = RectangleShape2D.new()
	query.shape.size = check_rect.size
	query.transform.origin = to_global(check_rect.get_center())
	var results = get_viewport().world_2d.direct_space_state.intersect_shape(
			query, 1)
	for i in results:
		var body: CollisionObject2D = i.collider
		if body.has_method(&"kill") and body is not Player:
			body.kill()
			if %PickupComponent.get_holder() != null:
				kill()


func kill() -> void:
	var graphics = $Graphics.duplicate() as Node2D
	graphics.global_position = $Graphics.global_position
	graphics.name = "Dead" + name
	graphics.z_index = GameConstants.Layers.Z_DEAD
	graphics.set_script(DeadEntity)
	graphics.velocity = Vector2(60 * -sign(Utility.id("player").velocity.x), -240)
	add_sibling(graphics)
	queue_free()
